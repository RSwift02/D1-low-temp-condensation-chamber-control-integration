#!/bin/zsh
cd "$(dirname "$0")" || exit 1
echo "plotter: 连接 127.0.0.1:8777（需要另一个终端先跑 run_bridge.command）"
exec ./.venv/bin/python serial_plot.py --window 400
