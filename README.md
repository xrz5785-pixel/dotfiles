# Dotfiles · 奚任重 M4 Mac

中国可用大模型全矩阵配置 + AI 基础设施配置。

## 包含

- **Claude Code**: 4 通道切换 (claude-or / qwen / ds / nemotron)
- **Hermes**: 6 层 fallback + 3 provider (OpenRouter / Qianfan / SiliconFlow)
- **Codex CLI**: 9 profiles 中国可用模型
- **Ollama**: 本地模型登记表 (ollama-seven.json v4)

## 安装

```bash
cd ~/.dotfiles
bash scripts/install.sh
```

## 安全

`.env` / `secrets.env` 不含在仓库中。手动部署到 `~/.config/shell/secrets.env` 和 `~/.hermes/.env`。
