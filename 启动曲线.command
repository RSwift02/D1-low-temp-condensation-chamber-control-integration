#!/bin/zsh
cd "$(dirname "$0")" || exit 1

PORT_NAME="/dev/cu.usbmodemF412FA6F4F3C2"

pkill -f serial_plot.py 2>/dev/null

if pgrep -f serial_bridge.py >/dev/null; then
  echo "[采集] 已在运行，复用"
else
  echo "[采集] 启动，占用串口 ${PORT_NAME} @115200，日志 run.jsonl"
  nohup ./.venv/bin/python serial_bridge.py --baud 115200 --wait 600 --log run.jsonl > bridge.log 2>&1 &
  sleep 2
fi

echo "[绘图] 打开曲线窗口（关掉本窗口就停止绘图）"
echo "       快捷键:"
echo "         c  = 选择显示的通道（勾选面板，按 1-9 也可单独开关）"
echo "         l  = 隐藏数值最大的通道（比如 millis 时间戳）"
echo "         n  = 归一化（不同量级一起看）   g = 对数纵轴"
echo "         x  = 切换横轴时间窗口           f = 冻结纵轴"
echo "         space 暂停 | r 重置 | s 存图 | q 退出"
echo "       关闭曲线窗口或本终端窗口后，8 秒内自动释放串口，IDE 就能上传程序了"
echo
echo "       （提示信息也记在 plot_ui.log）"
./.venv/bin/python serial_plot.py --window 400 2>&1 | tee plot_ui.log
