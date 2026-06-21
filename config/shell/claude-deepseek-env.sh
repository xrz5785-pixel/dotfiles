# ═══════════════════════════════════════════════════════════════
# Claude Code → 中国区全模型矩阵（Anthropic Messages API）
# ═══════════════════════════════════════════════════════════════
# 主通道：OpenRouter（多模型自动可用）
# 备用通道：DeepSeek 直连（低延迟）
#
# 切换命令一览：
#   claude-or       → 默认 DeepSeek V4 Pro + Qwen 3.7-Max
#   claude-ds       → DeepSeek 直连（低延迟）
#   claude-nemotron → NVIDIA Nemotron 3 全家桶（免费）
#   claude-qwen     → Qwen 3.7-Max 全面接管（国产#1）
#
# ERNIE 5.1：仅 Hermes 可用（千帆 OpenAI 兼容 API）
# ═══════════════════════════════════════════════════════════════

if [[ -n "${OPENROUTER_API_KEY:-}" ]]; then
  # ── 主通道：OpenRouter ──────────────────────────
  export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
  export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"

  # Tier 模型映射
  export ANTHROPIC_MODEL="deepseek/deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek/deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="qwen/qwen3.7-max"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek/deepseek-v4-flash"
  export CLAUDE_CODE_SUBAGENT_MODEL="deepseek/deepseek-v4-flash"
  export CLAUDE_CODE_EFFORT_LEVEL="max"
fi

# ── NVIDIA Nemotron 3（运行 claude-nemotron 切换）───
claude-nemotron() {
  export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
  export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
  # Tier 模型映射：Ultra/Opus · Super/Sonnet · Nano/Haiku（全部免费）
  export ANTHROPIC_MODEL="nvidia/nemotron-3-super-120b-a12b:free"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="nvidia/nemotron-3-ultra-550b-a55b:free"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="nvidia/nemotron-3-super-120b-a12b:free"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="nvidia/nemotron-3-nano-30b-a3b:free"
  export CLAUDE_CODE_SUBAGENT_MODEL="nvidia/nemotron-3-nano-30b-a3b:free"
  export CLAUDE_CODE_EFFORT_LEVEL="max"
  echo "✅ Claude Code → NVIDIA Nemotron 3（Ultra/Super/Nano · OpenRouter）"
}

# ── 备用：DeepSeek 直连（运行 claude-ds 切换）───
claude-ds() {
  export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
  export ANTHROPIC_AUTH_TOKEN="$DEEPSEEK_API_KEY"
  export ANTHROPIC_MODEL="deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"
  export CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"
  export CLAUDE_CODE_EFFORT_LEVEL="max"
  echo "✅ Claude Code → DeepSeek 直连（低延迟）"
}

# ── Qwen 3.7-Max 全面接管（运行 claude-qwen 切换）───
claude-qwen() {
  export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
  export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
  export ANTHROPIC_MODEL="qwen/qwen3.7-max"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="qwen/qwen3.7-max"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="qwen/qwen3.7-max"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="qwen/qwen3.7-max"
  export CLAUDE_CODE_SUBAGENT_MODEL="qwen/qwen3.7-max"
  export CLAUDE_CODE_EFFORT_LEVEL="max"
  echo "✅ Claude Code → Qwen 3.7-Max 全面接管（国产#1）"
}

# ── 默认通道恢复（运行 claude-or 切换）───
claude-or() {
  export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
  export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
  export ANTHROPIC_MODEL="deepseek/deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek/deepseek-v4-pro"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="qwen/qwen3.7-max"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek/deepseek-v4-flash"
  export CLAUDE_CODE_SUBAGENT_MODEL="deepseek/deepseek-v4-flash"
  export CLAUDE_CODE_EFFORT_LEVEL="max"
  echo "✅ Claude Code → DeepSeek + Qwen（OpenRouter 默认通道）"
}
