#!/bin/bash
# Qwen 3.7-Max 桌面启动器
# 双击此文件即可启动通义千问对话

cd "$(dirname "$0")"
exec /opt/homebrew/Cellar/python@3.11/3.11.15/bin/python3.11 ~/ai-assets/chat/qwen_max_chat.py