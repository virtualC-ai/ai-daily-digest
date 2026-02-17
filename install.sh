#!/bin/bash
# AI Daily Digest Skill - Quick Install Script
# 一键安装为 OpenClaw Skill

set -e

SKILL_NAME="ai-daily-digest"
SKILL_DIR="$HOME/.openclaw/workspace/skills/$SKILL_NAME"
REPO_URL="git@github.com:virtualC-ai/ai-daily-digest.git"

echo "=============================================="
echo "  AI Daily Digest Skill Installer"
echo "=============================================="
echo ""

# 检查 OpenClaw 安装
if [ ! -d "$HOME/.openclaw" ]; then
    echo "❌ Error: OpenClaw not found at ~/.openclaw"
    echo "Please install OpenClaw first: https://docs.openclaw.ai"
    exit 1
fi

echo "✓ OpenClaw found"

# 创建 skills 目录
mkdir -p "$HOME/.openclaw/workspace/skills"

# 克隆或更新仓库
if [ -d "$SKILL_DIR" ]; then
    echo "→ Updating existing skill..."
    cd "$SKILL_DIR"
    git pull origin main
else
    echo "→ Cloning skill repository..."
    git clone "$REPO_URL" "$SKILL_DIR"
    cd "$SKILL_DIR"
fi

# 设置执行权限
chmod +x run.sh
chmod +x scripts/*.sh

echo ""
echo "✓ Skill installed successfully!"
echo ""
echo "=============================================="
echo "  Usage"
echo "=============================================="
echo ""
echo "1. 直接运行:"
echo "   cd $SKILL_DIR"
echo "   ./run.sh"
echo ""
echo "2. 带参数运行:"
echo "   ./run.sh --hours 24 --top-n 10 --lang zh"
echo ""
echo "3. 在 OpenClaw 对话中使用:"
echo "   /digest"
echo ""
echo "4. 配置定时任务 (crontab -e):"
echo "   30 9 * * * cd $SKILL_DIR && ./run.sh"
echo ""
echo "=============================================="
echo "  Configuration"
echo "=============================================="
echo ""
echo "API Key 会自动从以下位置读取:"
echo "  1. ~/.openclaw/agents/main/agent/auth-profiles.json"
echo "  2. ~/.ai-daily-digest/config.json"
echo "  3. 环境变量 CEREBRAS_API_KEY"
echo ""
echo "如需手动配置:"
echo "   export CEREBRAS_API_KEY='your-key'"
echo ""
echo "=============================================="