#!/bin/bash
# AI Daily Digest - OpenClaw Integration Script
# 自动读取 OpenClaw 配置并运行日报生成

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[ai-digest]${NC} AI Daily Digest - OpenClaw Integration"
echo ""

# 尝试从多个来源获取 Cerebras API Key
CEREBRAS_API_KEY=""

# 1. 从 OpenClaw auth-profiles.json 读取（如果存在）
OPENCLAW_AUTH="$HOME/.openclaw/agents/main/agent/auth-profiles.json"
if [ -f "$OPENCLAW_AUTH" ]; then
    # 尝试提取 cerebras 的 key（如果存储在文件中）
    CEREBRAS_API_KEY=$(jq -r '.profiles["cerebras:default"].apiKey // empty' "$OPENCLAW_AUTH" 2>/dev/null || echo "")
fi

# 2. 从环境变量读取
if [ -z "$CEREBRAS_API_KEY" ]; then
    CEREBRAS_API_KEY="${CEREBRAS_API_KEY:-$CEREBRAS_API_KEY}"
fi

# 3. 从 .env 文件读取
if [ -z "$CEREBRAS_API_KEY" ] && [ -f "$PROJECT_DIR/.env" ]; then
    CEREBRAS_API_KEY=$(grep -E "^CEREBRAS_API_KEY=" "$PROJECT_DIR/.env" | cut -d'=' -f2 | tr -d '"' | head -1)
fi

# 4. 从用户配置读取
if [ -z "$CEREBRAS_API_KEY" ] && [ -f "$HOME/.ai-daily-digest/config.json" ]; then
    CEREBRAS_API_KEY=$(jq -r '.cerebrasApiKey // empty' "$HOME/.ai-daily-digest/config.json" 2>/dev/null || echo "")
fi

# 检查是否找到 API Key
if [ -z "$CEREBRAS_API_KEY" ]; then
    echo -e "${RED}[ai-digest] Error: 未找到 CEREBRAS_API_KEY${NC}"
    echo ""
    echo "请通过以下方式之一配置："
    echo "  1. 环境变量: export CEREBRAS_API_KEY='your-key'"
    echo "  2. 项目 .env 文件: echo 'CEREBRAS_API_KEY=your-key' > $PROJECT_DIR/.env"
    echo "  3. 用户配置目录: mkdir -p ~/.ai-daily-digest && echo '{\"cerebrasApiKey\":\"your-key\"}' > ~/.ai-daily-digest/config.json"
    echo ""
    echo "获取 Cerebras API Key: https://cloud.cerebras.ai/"
    exit 1
fi

echo -e "${GREEN}[ai-digest]${NC} ✓ API Key 已配置"
echo ""

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
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --hours <n>     时间范围（小时），默认: 48"
            echo "  --top-n <n>     精选文章数，默认: 15"
            echo "  --lang <lang>   语言 (zh/en)，默认: zh"
            echo "  --output <path> 输出文件路径"
            echo "  --help, -h      显示帮助"
            echo ""
            echo "示例:"
            echo "  $0 --hours 24 --top-n 10"
            echo "  $0 --lang en --output ./my-digest.md"
            exit 0
            ;;
        *)
            echo -e "${RED}[ai-digest] Error: 未知参数 $1${NC}"
            exit 1
            ;;
    esac
done

# 构建输出路径
if [ -z "$OUTPUT" ]; then
    DATE_STR=$(date +%Y%m%d)
    OUTPUT="./digest-${DATE_STR}.md"
fi

# 切换到项目目录
cd "$PROJECT_DIR"

# 检查 bun 是否可用
if ! command -v bun &> /dev/null; then
    echo -e "${YELLOW}[ai-digest] 未找到 bun，尝试使用 npx...${NC}"
    BUN_CMD="npx -y bun"
else
    BUN_CMD="bun"
fi

# 运行 digest
echo -e "${GREEN}[ai-digest]${NC} 开始生成日报..."
echo "  时间范围: ${HOURS} 小时"
echo "  精选数量: ${TOP_N} 篇"
echo "  输出语言: ${LANG}"
echo "  输出文件: ${OUTPUT}"
echo ""

export CEREBRAS_API_KEY
export PATH

$BUN_CMD scripts/digest.ts \
    --hours "$HOURS" \
    --top-n "$TOP_N" \
    --lang "$LANG" \
    --output "$OUTPUT"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}[ai-digest]${NC} ✅ 日报生成成功!"
    echo "  文件: $(realpath "$OUTPUT")"
else
    echo ""
    echo -e "${RED}[ai-digest]${NC} ❌ 生成失败"
    exit 1
fi