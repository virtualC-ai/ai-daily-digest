#!/bin/bash
# AI Daily Digest Skill - Entry Point
# OpenCode Skill wrapper for ai-daily-digest

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 检查并安装 bun（如果需要）
if ! command -v bun &> /dev/null; then
    echo "[skill] Installing Bun runtime..."
    npm install -g bun
fi

# 检查 auth-profiles.json 是否存在
AUTH_PROFILES="$HOME/.openclaw/agents/main/agent/auth-profiles.json"
if [ ! -f "$AUTH_PROFILES" ]; then
    echo "[skill] Warning: OpenClaw auth-profiles.json not found at $AUTH_PROFILES"
    echo "[skill] Will try environment variables or fallback providers"
fi

# 解析参数
HOURS=48
TOP_N=15
LANG="zh"
OUTPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --hours)
            HOURS="$2"
            shift 2
            ;;
        --top-n)
            TOP_N="$2"
            shift 2
            ;;
        --lang)
            LANG="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "AI Daily Digest Skill"
            echo ""
            echo "Usage: ./run.sh [options]"
            echo ""
            echo "Options:"
            echo "  --hours <n>     Time range in hours (default: 48)"
            echo "  --top-n <n>     Number of top articles (default: 15)"
            echo "  --lang <lang>   Output language: zh or en (default: zh)"
            echo "  --output <path> Output file path"
            echo "  --help, -h      Show this help"
            echo ""
            echo "Examples:"
            echo "  ./run.sh                    # Generate with defaults"
            echo "  ./run.sh --hours 24         # Last 24 hours"
            echo "  ./run.sh --top-n 10 --lang en  # Top 10 in English"
            exit 0
            ;;
        *)
            echo "[skill] Error: Unknown argument $1"
            exit 1
            ;;
    esac
done

# 构建输出路径
if [ -z "$OUTPUT" ]; then
    DATE_STR=$(date +%Y%m%d)
    OUTPUT="./digest-${DATE_STR}.md"
fi

echo "[skill] AI Daily Digest - Starting..."
echo "[skill] Hours: $HOURS, Top-N: $TOP_N, Lang: $LANG"
echo "[skill] Output: $OUTPUT"
echo ""

# 运行主脚本
exec bun scripts/digest.ts \
    --hours "$HOURS" \
    --top-n "$TOP_N" \
    --lang "$LANG" \
    --output "$OUTPUT"