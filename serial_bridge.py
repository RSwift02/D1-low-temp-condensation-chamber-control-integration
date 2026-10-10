#!/usr/bin/env python3
"""Owns the serial port, normalises Arduino output, fans it out to log + TCP."""

from __future__ import annotations

import argparse
import glob
import json
import os
import re
import select
import socket
import subprocess
import sys
import threading
import time

try:
    import serial
except ImportError:
    sys.exit("missing pyserial:  pip install -r requirements.txt")

TOKEN_SPLIT = re.compile(r"[\s,;|]+")
LABEL = re.compile(r"^([A-Za-z_][A-Za-z0-9_]{0,31})\s*[:=]\s*(.+)$")
BARE_LABEL = re.compile(r"^([A-Za-z_][A-Za-z0-9_]{0,31})\s*[:=]$")
NUMBER = re.compile(r"[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?")
SKIP_PREFIX = ("#", ";", "//", "/*")

PORT_GLOBS = (
    "/dev/cu.usbmodem*",
    "/dev/cu.usbserial*",
    "/dev/cu.usbmodem*",
    "/dev/cu.wchusb*",
    "/dev/cu.SLAB*",
    "/dev/cu.SLAB_USBtoUART*",
    "/dev/ttyUSB*",
    "/dev/ttyACM*",
)
BAUD_CANDIDATES = (115200, 9600, 250000, 500000, 2000000, 57600)


def discover_ports() -> list[str]:
    found: list[str] = []
    for pattern in PORT_GLOBS:
        for path in glob.glob(pattern):
            if "Bluetooth" in path or path in found:
                continue
            found.append(path)
    return found


def first_number(text: str) -> float | None:
    anchored = NUMBER.match(text)
    if anchored:
        return float(anchored.group(0))
    if text and (text[0].isdigit() or text[0] in "+-." ):
        inner = NUMBER.search(text)
        if inner:
            return float(inner.group(0))
    return None


def parse_line(line: str) -> dict[str, float] | None:
    text = line.strip()
    if not text or text.startswith(SKIP_PREFIX):
        return None
    channels: dict[str, float] = {}
    position = 0
    pending: str | None = None
    for token in TOKEN_SPLIT.split(text):
        if not token:
            continue
        if pending is not None:
            value = first_number(token)
            if value is not None:
                channels[pending] = value
            pending = None
            continue
        bare = BARE_LABEL.match(token)
        if bare:
            pending = bare.group(1)
            continue
        labelled = LABEL.match(token)
        if labelled:
            value = first_number(labelled.group(2).strip())
            if value is not None:
                channels[labelled.group(1)] = value
            continue
        value = first_number(token)
        if value is not None:
            channels[f"ch{position}"] = value
        position += 1
    return channels or None


def port_holder(port: str) -> str:
    try:
        out = subprocess.run(["lsof", port], capture_output=True, text=True, timeout=3).stdout
    except (OSError, subprocess.SubprocessError):
        return ""
    lines = [line.split() for line in out.strip().splitlines()[1:] if line.split()]
    if not lines:
        return ""
    return f"{lines[0][0]} (pid {lines[0][1]})"


def open_port(port: str, baud: int | None, probe_seconds: float) -> tuple[serial.Serial, int]:
    def attempt(rate: int) -> tuple[serial.Serial, bool]:
        handle = serial.Serial()
        handle.port = port
        handle.baudrate = rate
        handle.timeout = 0.2
        handle.open()
        deadline = time.time() + probe_seconds
        seen = bytearray()
        while time.time() < deadline:
            chunk = handle.read(256)
            if chunk:
                seen += chunk
                if sum(1 for b in seen if 32 <= b < 127 or b in (10, 13, 9)) > 12:
                    return handle, True
        return handle, False

    if baud is not None:
        handle = serial.Serial()
        handle.port = port
        handle.baudrate = baud
        handle.timeout = 0.2
        handle.dtr = True
        handle.rts = True
        handle.open()
        return handle, baud

    for rate in BAUD_CANDIDATES:
        try:
            handle, got_data = attempt(rate)
        except serial.SerialException as exc:
            print(f"  {rate} baud failed: {exc}", file=sys.stderr)
            continue
        if got_data:
            return handle, rate
        handle.close()
    handle, _ = attempt(BAUD_CANDIDATES[0])
    return handle, BAUD_CANDIDATES[0]


class Fanout:
    def __init__(self, log_path: str | None, host: str, port: int) -> None:
        self.host = host
        self.port = port
        self.lock = threading.Lock()
        self.clients: list[socket.socket] = []
        self.log = open(log_path, "a", buffering=1) if log_path else None
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.bind((host, port))
        self.server.listen(8)
        self.server.settimeout(0.2)
        self._stop = threading.Event()
        threading.Thread(target=self._accept_loop, daemon=True).start()

    def _accept_loop(self) -> None:
        while not self._stop.is_set():
            try:
                client, _ = self.server.accept()
            except socket.timeout:
                continue
            except OSError:
                return
            client.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            with self.lock:
                self.clients.append(client)
            print(f"plotter connected ({len(self.clients)} total)", file=sys.stderr)

    def publish(self, payload: dict) -> None:
        if self.log:
            self.log.write(json.dumps(payload, separators=(",", ":")) + "\n")
        line = (json.dumps(payload, separators=(",", ":")) + "\n").encode()
        with self.lock:
            for client in list(self.clients):
                try:
                    client.sendall(line)
                except OSError:
                    try:
                        client.close()
                    except OSError:
                        pass
                    self.clients.remove(client)

    def _reap(self) -> None:
        dead = []
        for client in self.clients:
            try:
                ready, _, _ = select.select([client], [], [], 0)
                if ready and client.recv(1, socket.MSG_PEEK) == b"":
                    dead.append(client)
            except OSError:
                dead.append(client)
        for client in dead:
            try:
                client.close()
            except OSError:
                pass
            self.clients.remove(client)
            print("plotter disconnected", file=sys.stderr, flush=True)

    def client_count(self) -> int:
        with self.lock:
            self._reap()
            return len(self.clients)

    def close(self) -> None:
        self._stop.set()
        with self.lock:
            for client in self.clients:
                client.close()
            self.clients.clear()
        self.server.close()
        if self.log:
            self.log.close()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("port", nargs="?", help="serial device, default: auto-detect")
    parser.add_argument("--baud", type=int, default=None, help="default: probe common rates")
    parser.add_argument("--list", action="store_true", help="list candidate ports and exit")
    parser.add_argument("--log", default="arduino_log.jsonl", help="JSONL log path")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--serve", type=int, default=8777, metavar="PORT")
    parser.add_argument("--probe", type=float, default=1.5, help="seconds per baud during probing")
    parser.add_argument("--raw", action="store_true", help="also echo raw lines to stdout")
    parser.add_argument(
        "--exit-after",
        type=float,
        default=8.0,
        metavar="SECONDS",
        help="release the serial port this many seconds after the last plotter disconnects (0 = never)",
    )
    parser.add_argument(
        "--wait",
        type=float,
        default=120.0,
        metavar="SECONDS",
        help="keep retrying while the port is busy (0 = fail immediately)",
    )
    args = parser.parse_args()

    if args.list:
        ports = discover_ports()
        print("\n".join(ports) if ports else "no usb serial devices found")
        return

    port = args.port
    if port in (None, "auto"):
        ports = discover_ports()
        if not ports:
            sys.exit("no usb serial device found; plug the board in or pass a port")
        if len(ports) > 1:
            print(f"several ports present {ports}, using {ports[0]}", file=sys.stderr)
        port = ports[0]

    deadline = time.time() + args.wait if args.wait > 0 else time.time()
    while True:
        try:
            handle, rate = open_port(port, args.baud, args.probe)
            break
        except serial.SerialException as exc:
            remaining = deadline - time.time()
            if remaining <= 0:
                sys.exit(
                    f"cannot open {port}: {exc}\n"
                    f"占用者: {port_holder(port) or '未知'}\n"
                    "关闭 Arduino IDE 的 Serial Monitor / Serial Plotter 后重试"
                )
            print(
                f"串口被占用: {port_holder(port) or exc}  等待中…"
                f"（剩 {remaining:.0f}s；关掉 Arduino IDE 的 Serial Monitor 就会自动接上）",
                file=sys.stderr,
                flush=True,
            )
            time.sleep(min(3.0, remaining))

    fanout = Fanout(args.log, args.host, args.serve)
    print(
        f"listening on {args.host}:{args.serve} | logging to {args.log} | "
        f"run:  python serial_plot.py",
        file=sys.stderr,
    )
    print(f"opened {port} at {rate} baud", file=sys.stderr)
    if args.baud is None:
        print(
            f"note: auto-probe discarded up to {args.probe:.1f}s of data, pass --baud <rate> to skip",
            file=sys.stderr,
        )
    if args.exit_after > 0:
        print(
            f"guard: no plotter for {args.exit_after:.0f}s -> release {port} (use --exit-after 0 to disable)",
            file=sys.stderr,
        )

    idle_stop = threading.Event()

    def release_when_idle() -> None:
        ever_connected = False
        silent = 0.0
        while True:
            time.sleep(1.0)
            if fanout.client_count() > 0:
                ever_connected = True
                silent = 0.0
                continue
            if not ever_connected:
                continue
            silent += 1.0
            if silent >= args.exit_after:
                print(
                    f"no plotter for {silent:.0f}s, releasing {port} so Arduino IDE can use it",
                    file=sys.stderr,
                    flush=True,
                )
                idle_stop.set()
                return

    if args.exit_after > 0:
        threading.Thread(target=release_when_idle, daemon=True).start()

    start = time.time()
    counters = {"lines": 0, "parsed": 0, "skipped": 0}
    window = time.time()
    try:
        while True:
            if idle_stop.is_set():
                break
            try:
                raw_line = handle.readline()
            except serial.SerialException as exc:
                print(f"serial error: {exc}", file=sys.stderr)
                break
            if not raw_line:
                if not handle.is_open:
                    break
                continue
            counters["lines"] += 1
            line = raw_line.decode("utf-8", errors="replace").strip()
            if args.raw and line:
                print(line, flush=True)
            channels = parse_line(line)
            if channels is None:
                counters["skipped"] += 1
                continue
            counters["parsed"] += 1
            fanout.publish({"t": round(time.time() - start, 6), "v": channels})
            if time.time() - window >= 1.0:
                if sys.stderr.isatty():
                    print(f"\r{timestamps(counters)}", end="", file=sys.stderr, flush=True)
                else:
                    print(timestamps(counters), file=sys.stderr, flush=True)
                window = time.time()
    except KeyboardInterrupt:
        pass
    finally:
        print(f"\n{timestamps(counters)}", file=sys.stderr)
        handle.close()
        fanout.close()


def timestamps(counters: dict[str, int]) -> str:
    return " | ".join(f"{key}={value}" for key, value in counters.items())


if __name__ == "__main__":
    main()
