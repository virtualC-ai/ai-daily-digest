#!/bin/bash
# OpenClaw Credential Helper for ai-daily-digest
# 读取 OpenClaw 配置的 Cerebras API Key

PROVIDER="cerebras"

# 尝试从系统 credential store 读取
if command -v secret-tool &> /dev/null; then
    # Linux (libsecret)
    API_KEY=$(secret-tool lookup openclaw-provider cerebras 2>/dev/null)
    if [ -n "$API_KEY" ]; then
        echo "$API_KEY"
        exit 0
    fi
fi

# 尝试从环境变量读取
if [ -n "$CEREBRAS_API_KEY" ]; then
    echo "$CEREBRAS_API_KEY"
    exit 0
fi

# 尝试从 OpenClaw 配置目录的 .env 文件读取
if [ -f "$HOME/.openclaw/.env" ]; then
    API_KEY=$(grep -E "^CEREBRAS_API_KEY=" "$HOME/.openclaw/.env" | cut -d'=' -f2 | tr -d '"' | head -1)
    if [ -n "$API_KEY" ]; then
        echo "$API_KEY"
        exit 0
    fi
fi

# 未找到
exit 1