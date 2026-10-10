#!/usr/bin/env python3
"""Plots the stream produced by serial_bridge.py (live socket or recorded log).

Keys: space 暂停 | c 选择通道 | l 隐藏最大通道 | n 归一化 | g 对数纵轴
      x 切换横轴窗口 | f 冻结纵轴 | r 重置 | s 存图 | q 退出
"""

from __future__ import annotations

import argparse
import json
import os
import re
import signal
import socket
import sys
import time

import matplotlib

if "--headless" in sys.argv:
    matplotlib.use("Agg")
elif not os.environ.get("MPLBACKEND"):
    try:
        import tkinter  # noqa: F401

        matplotlib.use("TkAgg")
    except ImportError:
        pass

import matplotlib.pyplot as plt
from matplotlib.widgets import Button, CheckButtons


def setup_chinese_font() -> None:
    from matplotlib import font_manager

    available = {font.name for font in font_manager.fontManager.ttflist}
    for name in (
        "PingFang SC",
        "Hiragino Sans GB",
        "Heiti SC",
        "Songti SC",
        "STHeiti",
        "Arial Unicode MS",
        "Noto Sans CJK SC",
    ):
        if name in available:
            matplotlib.rcParams["font.sans-serif"] = [name, "Helvetica", "Arial"]
            break
    matplotlib.rcParams["axes.unicode_minus"] = False


def safe_close_all() -> None:
    try:
        plt.close("all")
    except Exception:
        pass


def raise_figure(figure) -> None:
    manager = getattr(figure.canvas, "manager", None)
    window = getattr(manager, "window", None)
    for method in ("deiconify", "lift", "focus_force"):
        action = getattr(window, method, None)
        if callable(action):
            try:
                action()
            except Exception:
                pass


setup_chinese_font()

PALETTE = [
    "#4c9aff", "#ff6b6b", "#4ad991", "#ffd166", "#c77dff",
    "#48cae4", "#f8961e", "#80ed99", "#f28482", "#a1c181",
]
SETTINGS_FILE = "plot_settings.json"

UNIT_GUESS = (
    (r"tcav|temp|temperature|\bamb\b|air|body|cel", "°C"),
    (r"hum|rh\b", "%RH"),
    (r"press|baro", "hPa"),
    (r"volt|vcc|vdd|vbat|mv\b", "V"),
    (r"\bamp|curr", "A"),
    (r"rssi|dbm", "dBm"),
    (r"duty|pwm|percent|load", "%"),
    (r"lux|light", "lx"),
    (r"rpm|speed", "rpm"),
    (r"dist", "cm"),
)


def load_settings(path: str) -> dict:
    try:
        with open(path) as handle:
            data = json.load(handle)
        return data if isinstance(data, dict) else {}
    except (OSError, json.JSONDecodeError):
        return {}


def save_settings(path: str, payload: dict) -> None:
    try:
        with open(path, "w") as handle:
            json.dump(payload, handle, indent=2, sort_keys=True)
    except OSError:
        pass


class Stream:
    def __init__(self, window: int) -> None:
        self.window = window
        self.times: list[float] = []
        self.series: dict[str, list[float]] = {}
        self.order: list[str] = []
        self.unit_overrides: dict[str, str] = {}
        self.count = 0
        self.rate = 0.0
        self._rate_window = time.time()
        self._rate_count = 0

    def push(self, payload: dict) -> None:
        values = payload.get("v") or {}
        if not values:
            return
        timestamp = float(payload.get("t", len(self.times) * 0.01))
        for name, value in values.items():
            if name not in self.series:
                self.series[name] = []
                self.order.append(name)
            try:
                self.series[name].append(float(value))
            except (TypeError, ValueError):
                self.series[name].append(float("nan"))
        self.times.append(timestamp)
        self.count += 1
        self._rate_count += 1
        now = time.time()
        if now - self._rate_window >= 1.0:
            self.rate = self._rate_count / (now - self._rate_window)
            self._rate_window = now
            self._rate_count = 0
        overflow = len(self.times) - self.window
        if overflow > 0:
            del self.times[:overflow]
            for name in self.order:
                del self.series[name][:overflow]

    def unit_for(self, name: str) -> str:
        if name in self.unit_overrides:
            return self.unit_overrides[name]
        column = [value for value in self.series.get(name, []) if value == value]
        if re.fullmatch(r"ch\d+", name) and len(column) > 2:
            rising = all(b >= a for a, b in zip(column, column[1:]))
            if rising and column[-1] > 1000:
                return "ms"
        lowered = name.lower()
        for pattern, unit in UNIT_GUESS:
            if re.search(pattern, lowered):
                return unit
        return ""

    def bounds(self, name: str) -> tuple[float, float] | None:
        column = [value for value in self.series.get(name, []) if value == value]
        if not column:
            return None
        return min(column), max(column)

    def last(self, name: str) -> float | None:
        column = [value for value in reversed(self.series.get(name, [])) if value == value]
        return column[0] if column else None


class SocketSource:
    def __init__(self, host: str, port: int) -> None:
        self.host = host
        self.port = port
        self.connection: socket.socket | None = None
        self.buffer = b""
        self.announced = False

    def poll(self) -> list[tuple[str, object]]:
        events: list[tuple[str, object]] = []
        if self.connection is None:
            try:
                self.connection = socket.create_connection((self.host, self.port), timeout=3)
                self.connection.setblocking(False)
            except OSError:
                self.connection = None
                if not self.announced:
                    print(f"waiting for bridge on {self.host}:{self.port}", file=sys.stderr, flush=True)
                    self.announced = True
                return events
            self.announced = False
            print(f"connected to {self.host}:{self.port}", file=sys.stderr, flush=True)
        try:
            chunk = self.connection.recv(65536)
        except (BlockingIOError, InterruptedError):
            return events
        except OSError:
            chunk = b""
        if not chunk:
            try:
                self.connection.close()
            except OSError:
                pass
            self.connection = None
            print("bridge disconnected, will retry", file=sys.stderr, flush=True)
            return events
        self.buffer += chunk
        while b"\n" in self.buffer:
            raw, self.buffer = self.buffer.split(b"\n", 1)
            if not raw.strip():
                continue
            try:
                events.append(("data", json.loads(raw)))
            except json.JSONDecodeError:
                continue
        return events


class LogSource:
    def __init__(self, path: str, limit: int | None) -> None:
        self.rows: list[dict] = []
        with open(path) as handle:
            for index, line in enumerate(handle):
                if limit is not None and index >= limit:
                    break
                line = line.strip()
                if not line:
                    continue
                try:
                    self.rows.append(json.loads(line))
                except json.JSONDecodeError:
                    continue
        self.index = 0
        self.finished = False

    def poll(self) -> list[tuple[str, object]]:
        events: list[tuple[str, object]] = []
        while self.index < len(self.rows) and len(events) < 400:
            events.append(("data", self.rows[self.index]))
            self.index += 1
        if self.index >= len(self.rows) and not self.finished:
            self.finished = True
            events.append(("done", None))
        return events


class Plotter:
    def __init__(self, stream: Stream, source: str, hidden: set[str], only: set[str], xspan: float | None) -> None:
        self.stream = stream
        self.source = source
        self.hidden = set(hidden)
        self.only = set(only)
        self.xspan = xspan
        self.saved_xspan = xspan
        self.paused = False
        self.freeze_scale = False
        self.hide_largest = False
        self.normalize = False
        self.logy = False
        self.dirty = True
        self.lines: dict[str, object] = {}
        self.link = False
        self.first_sample_logged = False
        self.selector_fig = None
        self.selector_names: list[str] = []
        self.check = None
        self.figure, self.axes = plt.subplots(figsize=(11, 6.5))
        self.figure.canvas.manager.set_window_title("Arduino 实时曲线")
        self.figure.canvas.mpl_connect("close_event", self.on_close)
        self.figure.canvas.mpl_connect("key_press_event", self.on_key)
        self.status = self.figure.text(0.01, 0.965, "", fontsize=9, va="top")
        self.axes.grid(True, alpha=0.3)
        self.figure.tight_layout(rect=(0, 0.07, 1, 0.94))
        self.button_ax = self.figure.add_axes((0.12, 0.015, 0.20, 0.045))
        self.button = Button(self.button_ax, " 选择通道 (c) ", color="#4c9aff", hovercolor="#78b6ff")
        self.button.label.set_fontsize(9)
        self.button.on_clicked(lambda event: self.toggle_selector())

    def on_close(self, event) -> None:
        safe_close_all()

    def on_key(self, event) -> None:
        key = (event.key or "").lower()
        print(f"key received: {event.key!r} on figure {event.canvas.figure.number}", file=sys.stderr, flush=True)
        if key == " ":
            self.paused = not self.paused
        elif key == "c":
            self.toggle_selector()
            return
        elif key == "l":
            self.hide_largest = not self.hide_largest
        elif key == "n":
            self.normalize = not self.normalize
        elif key == "g":
            self.logy = not self.logy
        elif key == "f":
            self.freeze_scale = not self.freeze_scale
        elif key == "x":
            self.xspan = None if self.xspan == self.saved_xspan else self.saved_xspan
        elif key == "r":
            self.reset()
        elif key == "s":
            self.save()
        elif key == "q":
            safe_close_all()
            return
        elif key.isdigit() and key != "0":
            self.toggle_by_index(int(key) - 1)
        self.dirty = True

    def toggle_by_index(self, index: int) -> None:
        names = self.stream.order
        if index < 0 or index >= len(names):
            return
        name = names[index]
        if name in self.hidden:
            self.hidden.discard(name)
        else:
            self.hidden.add(name)
        self.persist()

    def persist(self) -> None:
        save_settings(SETTINGS_FILE, {"hidden": sorted(self.hidden)})

    def reset(self) -> None:
        self.stream.times.clear()
        self.stream.order.clear()
        for column in self.stream.series.values():
            column.clear()
        self.lines.clear()
        self.axes.clear()
        self.axes.grid(True, alpha=0.3)
        self.dirty = True

    def save(self) -> None:
        name = f"plot_{time.strftime('%Y%m%d_%H%M%S')}.png"
        self.figure.savefig(name, dpi=140)
        print(f"saved {name}", file=sys.stderr, flush=True)

    def toggle_selector(self) -> None:
        if self.selector_fig is not None:
            try:
                plt.close(self.selector_fig)
            except Exception:
                pass
            self.selector_fig = None
            return
        names = list(self.stream.order)
        if not names:
            names = ["(暂无数据)"]
        height = max(1.8, 0.32 * len(names) + 1.1)
        self.selector_fig = plt.figure(figsize=(4.6, height))
        self.selector_fig.canvas.manager.set_window_title("选择要显示的通道")
        area = self.selector_fig.add_axes((0.06, 0.06, 0.88, 0.88))
        area.axis("off")
        labels = [f"{index + 1}  {name}" for index, name in enumerate(names)]
        actives = [name not in self.hidden for name in names]
        self.check = CheckButtons(area, labels, actives)
        self.selector_names = list(names)
        self.check.on_clicked(lambda label: self.on_check(names, labels, label))
        self.selector_fig.canvas.mpl_connect(
            "close_event", lambda event: setattr(self, "selector_fig", None)
        )
        self.selector_fig.canvas.mpl_connect("key_press_event", self.on_key)
        raise_figure(self.selector_fig)
        print(f"通道选择面板已打开: {names}（勾掉=不画）", file=sys.stderr, flush=True)

    def refresh_selector(self) -> None:
        if self.selector_fig is None:
            return
        names = list(self.stream.order)
        if not names or names == self.selector_names:
            return
        self.toggle_selector()
        self.toggle_selector()

    def on_check(self, names: list[str], labels: list[str], label: str) -> None:
        try:
            name = names[labels.index(label)]
        except ValueError:
            return
        if name in self.hidden:
            self.hidden.discard(name)
        else:
            self.hidden.add(name)
        self.persist()
        self.dirty = True

    def visible_names(self) -> list[str]:
        names = [name for name in self.stream.order if self.stream.series.get(name)]
        if self.only:
            names = [name for name in names if name in self.only]
        names = [name for name in names if name not in self.hidden]
        if self.hide_largest and len(names) > 1:
            largest = max(names, key=lambda name: abs(self.stream.last(name) or 0.0))
            names = [name for name in names if name != largest]
        return names

    def unit_label(self, names: list[str]) -> str:
        if self.normalize:
            return "归一化值 (每个通道 0–1，真实范围见图例)"
        if self.logy:
            return "value (log)"
        units = {self.stream.unit_for(name) for name in names}
        units.discard("")
        if len(units) == 1:
            return f"value ({units.pop()})"
        if len(units) > 1:
            return "value (" + ", ".join(sorted(units)) + ")"
        return "value"

    def transform(self, name: str, column: list[float]) -> list[float]:
        if not self.normalize:
            return column
        bounds = self.stream.bounds(name)
        if bounds is None:
            return column
        low, high = bounds
        span = high - low
        if span <= 0:
            return [0.5] * len(column)
        return [(value - low) / span for value in column]

    def legend_labels(self, names: list[str]) -> list[str]:
        labels = []
        for index, name in enumerate(self.stream.order):
            if name not in names:
                continue
            unit = self.stream.unit_for(name)
            suffix = f" {unit}" if unit else ""
            value = self.stream.last(name)
            bounds = self.stream.bounds(name)
            if value is None:
                labels.append(f"[{index + 1}] {name}")
            elif self.normalize and bounds:
                labels.append(f"[{index + 1}] {name}: {bounds[0]:g}–{bounds[1]:g}{suffix}")
            else:
                digits = 2 if abs(value) < 100 else 0
                labels.append(f"[{index + 1}] {name} = {value:.{digits}f}{suffix}")
        return labels

    def add_channel(self, name: str, color_index: int) -> None:
        color = PALETTE[color_index % len(PALETTE)]
        (line,) = self.axes.plot([], [], lw=1.4, color=color)
        self.lines[name] = line

    def update(self) -> None:
        if not self.dirty:
            return
        self.dirty = False
        stream = self.stream
        names = self.visible_names()
        for name in list(self.lines):
            if name not in names:
                self.lines.pop(name).remove()
        for name in names:
            if name not in self.lines:
                self.add_channel(name, stream.order.index(name))

        if not stream.times:
            if self.link:
                self.axes.set_title("已连接采集进程，等待第一行数据…", fontsize=10, color="#a60")
            else:
                self.axes.set_title(
                    "没有连接到采集进程：双击桌面“启动曲线.command”，并关掉 Arduino IDE 的 Serial Monitor",
                    fontsize=10,
                    color="#b00",
                )
            self.figure.canvas.draw_idle()
            return
        if not names:
            self.axes.set_title(
                "所有通道都被隐藏了：按 c 打开勾选面板，或按 1-9 打开某个通道",
                fontsize=10,
                color="#a60",
            )
            self.figure.canvas.draw_idle()
            return

        self.axes.set_title("")
        for name, line in self.lines.items():
            column = stream.series.get(name, [])
            if len(column) != len(stream.times):
                column = [
                    value if index < len(column) else float("nan")
                    for index, value in enumerate(stream.times)
                ]
            line.set_data(stream.times, self.transform(name, column))

        self.axes.set_yscale("log" if self.logy and not self.normalize else "linear")
        self.axes.set_ylabel(self.unit_label(names))
        if not self.freeze_scale:
            lowest, highest = self.axis_bounds(names)
            if lowest is not None and highest is not None:
                if self.normalize:
                    self.axes.set_ylim(-0.02, 1.02)
                elif self.logy and lowest > 0:
                    self.axes.set_ylim(lowest * 0.9, highest * 1.1)
                else:
                    padding = max((highest - lowest) * 0.08, 1e-9)
                    self.axes.set_ylim(lowest - padding, highest + padding)
        last_t = stream.times[-1]
        if self.xspan:
            start = max(0.0, last_t - self.xspan)
            self.axes.set_xlim(start, start + self.xspan)
        else:
            self.axes.set_xlim(0.0, max(last_t, 1e-3))
        if self.axes.get_legend() is not None:
            self.axes.get_legend().remove()
        labels = self.legend_labels(names)
        self.axes.legend(
            [self.lines[name] for name in names],
            labels,
            loc="upper left",
            ncols=min(3, max(1, len(names))),
            fontsize=8,
            framealpha=0.85,
        )
        modes = []
        if self.paused:
            modes.append("PAUSED")
        if self.freeze_scale:
            modes.append("y冻结")
        if self.normalize:
            modes.append("归一化")
        if self.logy:
            modes.append("log")
        if self.hide_largest:
            modes.append("隐藏最大")
        self.status.set_text(
            f"{self.source}   样本={stream.count}   {stream.rate:.1f} 行/秒   "
            f"显示 {len(names)}/{len(stream.order)} 通道   "
            f"t={last_t:.1f}s" + (f"   {' '.join(modes)}" if modes else "") + "\n"
            "space 暂停 | c 选择通道 | l 隐藏最大 | n 归一化 | g 对数轴 | "
            "x 切换横轴窗口 | f 冻结纵轴 | r 重置 | s 存图 | q 退出"
        )
        self.figure.canvas.draw_idle()

    def axis_bounds(self, names: list[str]) -> tuple[float | None, float | None]:
        low, high = None, None
        for name in names:
            column = [value for value in self.stream.series.get(name, []) if value == value]
            if not column:
                continue
            tail = self.transform(name, column)[-200:]
            column_low, column_high = min(tail), max(tail)
            low = column_low if low is None else min(low, column_low)
            high = column_high if high is None else max(high, column_high)
        return low, high


def apply_events(plotter: Plotter, events: list[tuple[str, object]]) -> bool:
    finished = False
    for kind, payload in events:
        if kind == "data":
            if not plotter.paused:
                plotter.stream.push(payload)  # type: ignore[arg-type]
                plotter.dirty = True
        elif kind == "status":
            print(payload, file=sys.stderr, flush=True)
        if kind == "data" and not plotter.first_sample_logged:
            plotter.first_sample_logged = True
            print(
                f"first sample received, channels={sorted(payload.get('v') or {})}",
                file=sys.stderr,
                flush=True,
            )
        elif kind == "done":
            finished = True
    return finished


def parse_units(text: str) -> dict[str, str]:
    units: dict[str, str] = {}
    for item in text.split(","):
        if "=" not in item:
            continue
        name, unit = item.split("=", 1)
        name = name.strip()
        if name:
            units[name] = unit.strip()
    return units


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--serve", type=int, default=8777, metavar="PORT")
    parser.add_argument("--log", default=None, help="replay a recorded .jsonl log instead of a socket")
    parser.add_argument("--window", type=int, default=600, help="samples kept in memory")
    parser.add_argument("--xspan", type=float, default=None, help="seconds visible on the x axis")
    parser.add_argument("--only", default="", help="comma separated channels to keep")
    parser.add_argument("--drop", default="", help="comma separated channels to hide")
    parser.add_argument("--units", default="", help='override units, e.g. "tCav=°C,amb=°C"')
    parser.add_argument("--headless", action="store_true", help="render to --save without a window")
    parser.add_argument("--save", default=None, help="output png for --headless")
    parser.add_argument("--limit", type=int, default=None, help="stop after N log rows")
    parser.add_argument("--select", action="store_true", help="start with the channel picker open")
    args = parser.parse_args()

    if args.headless and not args.log:
        sys.exit("--headless needs --log")
    if args.headless and not args.save:
        args.save = "plot_replay.png"

    stream = Stream(args.window)
    only = {name.strip() for name in args.only.split(",") if name.strip()}
    drop = {name.strip() for name in args.drop.split(",") if name.strip()}
    settings = load_settings(SETTINGS_FILE)
    hidden = set(drop)
    if not only and not drop:
        hidden |= {str(name) for name in settings.get("hidden", [])}
    stream.unit_overrides = parse_units(args.units)

    if args.log:
        source = LogSource(args.log, args.limit)
        label = args.log
    else:
        source = SocketSource(args.host, args.serve)
        label = f"{args.host}:{args.serve}"

    plotter = Plotter(stream, label, hidden, only, args.xspan)

    if args.headless:
        while True:
            if apply_events(plotter, source.poll()):
                break
            time.sleep(0.01)
        plotter.freeze_scale = True
        plotter.dirty = True
        plotter.update()
        plotter.figure.savefig(args.save, dpi=140)
        print(f"saved {args.save}", file=sys.stderr)
        return

    print(f"backend: {matplotlib.get_backend()}", file=sys.stderr, flush=True)

    def tick() -> None:
        if not plt.fignum_exists(plotter.figure.number):
            return
        plotter.link = bool(getattr(source, "connection", None)) if not args.log else True
        apply_events(plotter, source.poll())
        plotter.update()
        plotter.refresh_selector()

    def on_signal(signum, frame) -> None:
        safe_close_all()

    signal.signal(signal.SIGINT, on_signal)
    signal.signal(signal.SIGTERM, on_signal)

    timer = None
    try:
        timer = plotter.figure.canvas.new_timer(interval=25)
        timer.add_callback(tick)
        timer.start()
    except (AttributeError, NotImplementedError):
        timer = None

    raise_figure(plotter.figure)
    if args.select:
        plotter.toggle_selector()
    try:
        if timer is not None:
            plt.show()
        else:
            plt.ion()
            plt.show(block=False)
            while plt.fignum_exists(plotter.figure.number):
                tick()
                plt.pause(0.02)
    except KeyboardInterrupt:
        pass
    finally:
        if timer is not None:
            try:
                timer.stop()
            except Exception:
                pass
        plotter.persist()
        safe_close_all()


if __name__ == "__main__":
    main()
