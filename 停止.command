#!/bin/zsh
pkill -f serial_plot.py 2>/dev/null
pkill -f serial_bridge.py 2>/dev/null
sleep 1
echo "已停止采集与绘图，串口已释放，可以回 Arduino IDE 用 Serial Monitor 了。"
sleep 3
