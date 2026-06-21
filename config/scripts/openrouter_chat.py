#!/usr/bin/env python3
"""OpenRouter 通用终端聊天 —— 支持全部中国可用顶级大模型"""

import os
import sys
import argparse
from pathlib import Path
from openai import OpenAI

# ── 模型注册表 ──
MODELS = {
    "ds": {
        "id": "deepseek/deepseek-v4-pro",
        "name": "DeepSeek V4 Pro",
        "tagline": "编程最强 · 1M上下文",
        "color": "34",   # blue
        "label": "DeepSeek",
    },
    "qwen": {
        "id": "qwen/qwen3.7-max",
        "name": "Qwen 3.7-Max",
        "tagline": "国产#1 · 综合旗舰",
        "color": "36",   # cyan
        "label": "Qwen Max",
    },
    "glm": {
        "id": "z-ai/glm-5.2",
        "name": "GLM 5.2",
        "tagline": "智谱旗舰 · 中文优化",
        "color": "35",   # magenta
        "label": "GLM",
    },
    "kimi": {
        "id": "moonshotai/kimi-k2.6",
        "name": "Kimi K2.6",
        "tagline": "月之暗面 · 长文之王",
        "color": "33",   # yellow
        "label": "Kimi",
    },
    "mistral": {
        "id": "mistralai/mistral-large-2512",
        "name": "Mistral Large",
        "tagline": "欧洲最强 · 多语言",
        "color": "32",   # green
        "label": "Mistral",
    },
    "grok": {
        "id": "x-ai/grok-4.3",
        "name": "Grok 4.3",
        "tagline": "xAI旗舰 · 实时推理",
        "color": "37",   # white
        "label": "Grok",
    },
    "nemotron": {
        "id": "nvidia/nemotron-3-super-120b-a12b",
        "name": "Nemotron Super",
        "tagline": "NVIDIA旗舰 · 120B MoE",
        "color": "92",   # bright green
        "label": "Nemotron",
    },
}

# ── 颜色 ──
BOLD = "\033[1m"
RESET = "\033[0m"
DIM = "\033[2m"


def load_api_key():
    """从 secrets.env 或环境变量读取 OPENROUTER_API_KEY"""
    secrets = Path.home() / ".config/shell/secrets.env"
    if secrets.exists():
        for line in secrets.read_text().splitlines():
            line = line.strip()
            if line.startswith("export ") and "OPENROUTER_API_KEY=" in line:
                _, v = line.replace("export ", "").split("=", 1)
                return v.strip('"').strip("'")
    return os.environ.get("OPENROUTER_API_KEY", "")


def clear():
    os.system("clear")


def print_banner(model_key):
    m = MODELS[model_key]
    c = m["color"]
    width = 48
    name_line = f"{m['name']} · {m['tagline']}"
    pad = (width - len(name_line) - 2) // 2

    clear()
    print(f"""
\033[{c}m{BOLD}╔{'═'*width}╗
║{' '*pad}{name_line}{' '*(width-len(name_line)-2-pad)}║
║{'OpenRouter 高速通道':^{width}}║
╚{'═'*width}╝{RESET}
{DIM}输入 /clear 清屏 | /exit 退出 | /model 查看可选模型{RESET}
""")


def chat(model_key):
    api_key = load_api_key()
    if not api_key:
        print("\033[31m❌ 未找到 OPENROUTER_API_KEY\033[0m")
        sys.exit(1)

    client = OpenAI(api_key=api_key, base_url="https://openrouter.ai/api/v1")
    m = MODELS[model_key]
    current_key = model_key

    system_prompt = (
        f"你是 {m['name']}，{m['tagline']}。"
        f"运行在奚任重的M4 Mac上，通过OpenRouter接入。"
        f"用中文回答，简洁专业，代码给出可执行版本。"
    )

    print_banner(current_key)
    messages = [{"role": "system", "content": system_prompt}]

    while True:
        try:
            user_input = input(f"\n\033[33m你 › {RESET}")
        except (EOFError, KeyboardInterrupt):
            print(f"\n{DIM}👋 {m['label']} 已退出{RESET}")
            break

        if not user_input.strip():
            continue

        cmd = user_input.strip()

        if cmd == "/exit":
            print(f"\n{DIM}👋 {m['label']} 已退出{RESET}")
            break

        if cmd == "/clear":
            messages = [{"role": "system", "content": system_prompt}]
            print_banner(current_key)
            continue

        if cmd == "/model":
            print(f"\n{DIM}可选模型:{RESET}")
            for k, v in MODELS.items():
                marker = " ← 当前" if k == current_key else ""
                print(f"  {DIM}/model {k}{RESET} → {v['name']} ({v['tagline']}){marker}")
            continue

        if cmd.startswith("/model "):
            new_key = cmd.split(" ", 1)[1].strip()
            if new_key in MODELS:
                current_key = new_key
                nm = MODELS[current_key]
                system_prompt = (
                    f"你是 {nm['name']}，{nm['tagline']}。"
                    f"运行在奚任重的M4 Mac上，通过OpenRouter接入。"
                    f"用中文回答，简洁专业，代码给出可执行版本。"
                )
                messages = [{"role": "system", "content": system_prompt}]
                print_banner(current_key)
                print(f"{DIM}✅ 已切换至 {nm['name']}{RESET}")
            else:
                print(f"{DIM}未知模型: {new_key}，可用: {', '.join(MODELS.keys())}{RESET}")
            continue

        messages.append({"role": "user", "content": user_input})
        cm = MODELS[current_key]
        c = cm["color"]

        print(f"\n\033[{c}m{cm['label']} › {RESET}", end="", flush=True)

        try:
            stream = client.chat.completions.create(
                model=cm["id"],
                messages=messages,
                stream=True,
                temperature=0.7,
                extra_headers={
                    "HTTP-Referer": "https://github.com/xrz5785-pixel",
                    "X-Title": f"{cm['name']} Desktop",
                },
            )

            full_response = ""
            for chunk in stream:
                delta = chunk.choices[0].delta
                if delta.content:
                    print(delta.content, end="", flush=True)
                    full_response += delta.content

            print()
            messages.append({"role": "assistant", "content": full_response})

        except Exception as e:
            print(f"\n\033[31m❌ API 错误: {e}\033[0m")
            messages.pop()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="OpenRouter 通用终端聊天")
    parser.add_argument("model", choices=list(MODELS.keys()), help="模型标识")
    args = parser.parse_args()
    chat(args.model)
