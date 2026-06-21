#!/bin/bash
# ERNIE 4.5 桌面启动器
# 双击此文件即可启动文心一言对话

cd "$(dirname "$0")"
exec /opt/homebrew/Cellar/python@3.11/3.11.15/bin/python3.11 ~/ai-assets/chat/ernie_chat.py