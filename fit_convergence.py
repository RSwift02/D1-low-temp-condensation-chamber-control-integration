#!/usr/bin/env python3
"""Analyse a constant-duty (step) cooling run from run.jsonl.

Reads the bridge JSONL log, isolates the last contiguous segment where duty
was held near its maximum, then:
  * fits the offset -offset(t)=yinf-(yinf-off0)*exp(-t/tau) curve
  * reports the asymptotic offset below ambient, tau, rmse
  * checks whether the tail slope says the run converged
  * gives a verdict against the target setpoint (default 20 C)

Usage:
  python fit_convergence.py [--file run.jsonl] [--duty-min 254]
                            [--target 20.0] [--out convergence_trend.png]
"""

from __future__ import annotations

import argparse
import json

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

REC_KEYS = ("tCav", "amb", "duty")


def load(path: str) -> list[tuple[float, float, float, float]]:
    recs: list[tuple[float, float, float, float]] = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                d = json.loads(line)
            except ValueError:
                continue
            v = d.get("v") or {}
            if not all(k in v for k in REC_KEYS):
                continue
            recs.append((float(d.get("t", 0.0)), float(v["duty"]), float(v["tCav"]), float(v["amb"])))
    return recs


def segment_by_reset(recs: list[tuple[float, float, float, float]]):
    segs: list[np.ndarray] = []
    cur: list[tuple[float, float, float, float]] = []
    prev_t: float | None = None
    for rec in recs:
        if prev_t is not None and rec[0] < prev_t - 60.0:
            if len(cur) >= 3:
                segs.append(np.array(cur, dtype=float))
            cur = []
        cur.append(rec)
        prev_t = rec[0]
    if len(cur) >= 3:
        segs.append(np.array(cur, dtype=float))
    return segs


def fit_exp(ts: np.ndarray, ys: np.ndarray) -> tuple[float, float, float, float] | None:
    """Return (rmse, yinf, off0, tau) via OLS in (a, b*exp(-t/tau)), grid over tau."""
    if len(ts) < 10:
        return None
    t = ts - ts[0]
    span = max(float(t[-1]), 60.0)
    best = None
    for tau in np.logspace(np.log10(span / 100.0), np.log10(span * 2.0), 500):
        tau = max(float(tau), 5.0)
        X = np.exp(-t / tau)
        A = np.column_stack([np.ones_like(t), X])
        c, *_ = np.linalg.lstsq(A, ys, rcond=None)
        pred = A @ c
        rmse = float(np.sqrt(np.mean((pred - ys) ** 2)))
        if best is None or rmse < best[0]:
            best = (rmse, float(c[0]), float(c[0] + c[1]), tau)
    return best


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--file", default="run.jsonl")
    ap.add_argument("--duty-min", type=float, default=254.0, help="select points at/above this duty")
    ap.add_argument("--target", type=float, default=20.0, help="desired cavity setpoint (C)")
    ap.add_argument("--out", default="convergence_trend.png")
    ap.add_argument("--slope-window-min", type=float, default=30.0)
    args = ap.parse_args()

    recs = load(args.file)
    segs = segment_by_reset(recs)
    print(f"log: {len(recs)} lines, {len(segs)} boot session(s)")

    chosen = None
    for seg in reversed(segs):
        hit = np.mean(seg[:, 1] >= args.duty_min)
        if hit >= 0.9:
            chosen = seg
            break
    if chosen is None:
        print(f"no segment held duty >= {args.duty_min:.0f}; analysis the last session anyway")
        chosen = segs[-1] if segs else None
    if chosen is None or len(chosen) < 10:
        raise SystemExit("no usable data")

    t = chosen[:, 0] - chosen[0, 0]
    duty = chosen[:, 1]
    cav = chosen[:, 2]
    amb = chosen[:, 3]
    amb_mean = float(np.mean(amb))
    keep = chosen[:, 1] >= args.duty_min
    if np.count_nonzero(keep) < 30:
        print("too few points above duty-min; using whole segment rows")
        keep = np.ones(len(chosen), dtype=bool)

    ts = t[keep]
    offset = amb_mean - cav[keep]
    fit = fit_exp(ts, offset)

    slope_min = args.slope_window_min * 60.0
    tail = offset[-1] if len(offset) else float("nan")
    tail_slope = float("nan")
    if len(offset) > 2:
        tw, ow = ts[-1] - ts, offset
        tail = ow[-1]
        if ts[-1] - ts[0] >= slope_min:
            m = (ow[-1] - ow[0]) / (tw[0] - tw[-1])  # C/s
            tail_slope = abs(m) * 60.0  # C/min

    needed = amb_mean - args.target
    print(f"segment duration: {t[-1] / 60.0:6.1f} min | samples: {len(chosen)} "
          f"(kept {np.count_nonzero(keep)})")
    print(f"ambient (avg):    {amb_mean:6.2f} C   (min {amb.min():.2f} / max {amb.max():.2f})")
    print(f"cav tail:         {float(tail):6.2f} C below ambient ({amb_mean:.2f} - {float(tail):.2f})")
    print(f"tail drift rate:  {tail_slope:6.3f} C/min (converged < 0.02)")
    if fit is not None:
        rmse, yinf, off0, tau = fit
        print(f"FIT  offset= yinf-(yinf-{off0:.2f})*exp(-t/{tau/60.0:.1f}min)")
        print(f"     yinf = {yinf:6.2f} C below ambient  tau = {tau/60.0:6.1f} min  rmse = {rmse:.3f} C")
        print(f"     -> equilibrium tCav ≈ {amb_mean - yinf:6.2f} C"
              f" (while ambient stays {amb_mean:.1f})")
        verdict = yinf >= needed
        print(f"VERDICT target {args.target:.1f} C: needs offset {needed:.1f} C ; "
              f"endpoint gives {yinf:.1f} C -> "
              f"{'REACHABLE (amb-stable)' if verdict else 'NOT REACHED at this ambient'}")
    else:
        yinf = float(tail)
        print("too few points for reliable fit; treating tail offset as endpoint")

    fig, axes = plt.subplots(3, 1, figsize=(11, 9), sharex=True)
    (ax_c, ax_d, ax_o) = axes
    ax_c.plot(t / 60.0, cav, ".-", ms=3, label="tCav")
    ax_c.plot(t / 60.0, amb, ".", ms=3, alpha=0.6, label="amb")
    ax_c.set_ylabel("C")
    ax_c.legend(loc="best")
    ax_d.plot(t / 60.0, duty, ".-", ms=3)
    ax_d.set_ylabel("duty")
    ax_d.axhline(args.duty_min, color="r", ls=":", lw=1)
    ax_o.plot(ts / 60.0, offset, ".-", ms=3, label="offset=amb-cav")
    if fit is not None:
        tt = np.linspace(ts[0], ts[-1], 600) - ts[0]
        ttx = tt + ts[0]
        y_pred = yinf - (yinf - off0) * np.exp(-(tt) / tau)
        ax_o.plot(ttx / 60.0, y_pred, "r-", lw=2,
                  label=f"fit  yinf={yinf:.2f} tau={tau/60.0:.1f}min")
    ax_o.axhline(needed, color="g", ls="--", lw=1.5, label=f"need {needed:.1f} C for {args.target:.1f}")
    ax_o.set_xlabel("t (min)")
    ax_o.set_ylabel("offset (C)")
    ax_o.legend(loc="best")
    ax_c.set_title(f"constant-duty run  amb~{amb_mean:.1f}  target {args.target:.1f}")
    fig.tight_layout()
    fig.savefig(args.out, dpi=150)
    print(f"plot saved: {args.out}")


if __name__ == "__main__":
    main()