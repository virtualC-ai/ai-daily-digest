# AI Daily Digest Skill

从 90 个 Hacker News 顶级技术博客抓取最新文章，通过 AI 多维评分筛选，生成一份结构化的每日精选日报。

## 特点

- **AI 驱动**: 使用 Cerebras GLM 4.7 (或其他 OpenAI-compatible API) 进行智能评分和摘要
- **RPi 优化**: 针对 Raspberry Pi 优化并发和网络设置
- **多层级降级**: Cerebras → Gemini → OpenAI-compatible，确保服务可用性
- **自动配置**: 自动从 OpenClaw auth-profiles.json 读取 API key
- **中文输出**: 自动生成中文标题、摘要和趋势分析

## 安装

### 1. 克隆仓库

```bash
cd ~/.openclaw/workspace/skills
git clone git@github.com:virtualC-ai/ai-daily-digest.git
```

### 2. 安装依赖

```bash
cd ai-daily-digest
# Bun 会自动安装（通过 npx -y bun）
```

### 3. 配置 API Key（已自动完成）

项目会自动从 `~/.openclaw/agents/main/agent/auth-profiles.json` 读取 Cerebras API Key。

如需手动配置：
```bash
export CEREBRAS_API_KEY="your-key"
```

## 使用方法

### 命令行

```bash
# 使用 wrapper 脚本（推荐）
./run.sh

# 或带参数
./run.sh --hours 48 --top-n 15 --lang zh

# 直接使用 bun
bun scripts/digest.ts --hours 24 --top-n 10 --lang zh --output ./digest.md
```

### 作为 OpenCode Skill

在对话中输入：
```
/digest
```

或：
```
生成今天的技术日报
```

## 参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--hours` | 时间范围（小时） | 48 |
| `--top-n` | 精选文章数量 | 15 |
| `--lang` | 输出语言 (zh/en) | zh |
| `--output` | 输出文件路径 | ./digest-YYYYMMDD.md |

## 输出示例

生成的 Markdown 文件包含：
- 📝 今日看点（宏观趋势总结）
- 🏆 今日必读（Top 3 深度展示）
- 📊 数据概览（统计表格 + 可视化图表）
- 分类文章列表（按 6 大分类分组）

## 技术栈

- **运行时**: Bun (TypeScript)
- **AI Provider**: Cerebras GLM 4.7 (primary), Gemini/OpenAI (fallback)
- **RSS 解析**: 原生 XML 解析
- **并发控制**: 5 RSS + 2 AI (RPi 优化)

## 文件结构

```
ai-daily-digest/
├── scripts/
│   ├── digest.ts              # 主脚本
│   └── run-with-openclaw.sh   # OpenClaw 集成脚本
├── run.sh                     # Skill 入口脚本
├── SKILL.md                   # 本文件
└── README.md                  # 原始文档
```

## 配置优先级

1. `~/.openclaw/agents/main/agent/auth-profiles.json` (自动)
2. `~/.ai-daily-digest/config.json` (用户配置)
3. 环境变量 `CEREBRAS_API_KEY`

## 定时任务

建议添加到 crontab：
```bash
# 每天早上 9:30 生成日报
30 9 * * * cd ~/.openclaw/workspace/skills/ai-daily-digest && ./run.sh
```

## License

MIT (fork from vigorX777/ai-daily-digest)