#!/bin/zsh
cd "$(dirname "$0")" || exit 1
echo "bridge: 独占串口 /dev/cu.usbmodemF412FA6F4F3C2 @115200，日志 run.jsonl"
exec ./.venv/bin/python serial_bridge.py --baud 115200 --wait 600 --log run.jsonl
