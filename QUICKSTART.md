# AI Daily Digest - OpenClaw Skill

> AI 驱动的技术博客日报生成工具，针对 Raspberry Pi 和 OpenClaw 优化

## 🚀 快速开始

### 安装

```bash
# 方法1: 使用安装脚本
curl -fsSL https://raw.githubusercontent.com/virtualC-ai/ai-daily-digest/main/install.sh | bash

# 方法2: 手动克隆
cd ~/.openclaw/workspace/skills
git clone git@github.com:virtualC-ai/ai-daily-digest.git
cd ai-daily-digest
chmod +x run.sh
```

### 使用

```bash
# 默认运行（48小时，15篇文章，中文输出）
./run.sh

# 自定义参数
./run.sh --hours 24 --top-n 10 --lang zh --output ./my-digest.md

# 在 OpenClaw 对话中
/digest
```

## ✨ 特性

| 特性 | 说明 |
|------|------|
| 🤖 **AI 驱动** | Cerebras GLM 4.7 智能评分和摘要 |
| 🔄 **多级降级** | Cerebras → Gemini → OpenAI-compatible |
| 🎯 **RPi 优化** | 5 RSS + 2 AI 并发，适合树莓派 |
| 🔌 **自动配置** | 自动读取 OpenClaw auth-profiles.json |
| 🇨🇳 **中文输出** | 自动生成中文标题、摘要和趋势分析 |

## 📋 数据来源

90 个顶级技术博客 RSS，包括：
- Simon Willison
- Paul Graham  
- Andrej Karpathy 推荐源
- Hacker News 热门博客

## ⚙️ 配置

自动读取 API Key（优先级）：

1. `~/.openclaw/agents/main/agent/auth-profiles.json`
2. `~/.ai-daily-digest/config.json`
3. 环境变量 `CEREBRAS_API_KEY`

## 📁 项目结构

```
ai-daily-digest/
├── run.sh              # Skill 入口脚本 ⭐
├── install.sh          # 快速安装脚本
├── skill.json          # OpenCode skill 配置
├── SKILL.md            # Skill 文档
├── scripts/
│   ├── digest.ts       # 主程序
│   └── run-with-openclaw.sh
└── README.md
```

## 🕐 定时任务

```bash
# 每天早上 9:30 生成日报
crontab -e
# 添加: 30 9 * * * cd ~/.openclaw/workspace/skills/ai-daily-digest && ./run.sh
```

## 📝 输出示例

生成文件 `digest-20250217.md` 包含：
- 📝 今日看点（3-5 句趋势总结）
- 🏆 今日必读（Top 3 深度展示）
- 📊 数据概览（统计 + 可视化图表）
- 📑 分类文章列表（6 大分类）

## 🔧 技术栈

- **运行时**: Bun (TypeScript)
- **AI Provider**: Cerebras GLM 4.7 (primary)
- **并发**: 5 RSS + 2 AI (RPi 优化)
- **依赖**: 0 第三方库，纯原生实现

## 📜 变更日志

### v1.1.0 (当前)
- ✅ 添加 OpenClaw 集成，自动读取 auth-profiles.json
- ✅ RPi 性能优化（并发降级、重试机制）
- ✅ 多级 AI provider 降级支持
- ✅ 封装为可直接使用的 OpenCode skill

### v1.0.0 (上游)
- 原始功能实现（vigorX777）

## 🤝 致谢

Fork from [vigorX777/ai-daily-digest](https://github.com/vigorX777/ai-daily-digest)

## License

MIT