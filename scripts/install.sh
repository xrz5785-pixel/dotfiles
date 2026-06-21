#!/bin/bash
# Dotfiles 安装脚本 — 中国可用大模型全矩阵配置
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

ln_safe() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] || [ -f "$dst" ]; then
    echo "  skip: $dst (exists)"
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  link: $dst -> $src"
  fi
}

echo "=== Dotfiles · 中国可用大模型全矩阵 ==="
echo ""

ln_safe "$DOTFILES/config/shell/claude-deepseek-env.sh" "$HOME/.config/shell/claude-deepseek-env.sh"
ln_safe "$DOTFILES/config/codex/config.toml"           "$HOME/.codex/config.toml"
ln_safe "$DOTFILES/config/ai-stack/ollama-seven.json"   "$HOME/.config/ai-stack/ollama-seven.json"
ln_safe "$DOTFILES/config/hermes/config.yaml"           "$HOME/.hermes/config.yaml"
ln_safe "$DOTFILES/config/scripts/openrouter_chat.py"    "$HOME/ai-assets/chat/openrouter_chat.py"

echo ""
echo "--- Desktop 启动器 ---"
for f in "$DOTFILES"/desktop/*.command; do
  name="$(basename "$f")"
  ln_safe "$f" "$HOME/Desktop/$name"
done

echo ""
echo "✅ Done. 密钥文件请手动部署:"
echo "   ~/.config/shell/secrets.env"
echo "   ~/.hermes/.env"
