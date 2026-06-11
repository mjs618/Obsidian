# Codex Plugins

## 2026-06-09 插件审计

- 当前 `C:\Users\Administrator\.codex\config.toml` 已启用：`browser`、`chrome`、`computer-use`、`github`、`openai-developers`、`codex-security`、`documents`、`spreadsheets`、`presentations`、`figma`、`canva`、`hyperframes`、`remotion`、`biorender`、`nvidia`、`sharepoint`、`windsor-ai`。
- 默认推荐使用策略：本地网页/localhost 优先 `Browser`；需要用户现有 Chrome 登录态、标签页或扩展状态时用 `Chrome`；GitHub 仓库/PR/CI 用 `GitHub`；OpenAI API/Agents/ChatGPT Apps 用 `OpenAI Developers`；PPT/表格/文档成品用 `Presentations`、`Spreadsheets`、`Documents`；安全审查用 `Codex Security`。
- 当前 `E:\learn\think-2-revert\open-design` 项目最有价值的插件组合：`GitHub`、`Browser`/`Chrome`、`OpenAI Developers`、`HyperFrames`、`Presentations`、`Spreadsheets`、`Documents`、`Figma`、`Canva`、`Codex Security`。项目是 pnpm monorepo，包含 Open Design 插件、技能、设计系统、Next.js Web、Electron Desktop、daemon 和 PR 工具。
- 按需使用，不默认启用到工作流中心：`BioRender` 仅科学图；`NVIDIA` 仅 GPU/Omniverse/物理 AI；`SharePoint` 仅 Microsoft 共享文档；`Windsor.ai` 仅营销/业务数据连接；`Remotion` 仅 React 视频项目。
- 本次修复了 Chrome 插件本地配置：`chrome/latest` junction 已指向完整的 `26.602.40724` 目录；`scripts/browser-client.mjs` 与 `skills/control-chrome/SKILL.md` 可访问；插件自带 `check-native-host-manifest.js --json` 检查结果为 `correct: true`。

## 2026-06-11 Agent Reach 安装

- 已按 `https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md` 在 Windows 本机安装 Agent Reach。
- Python 虚拟环境：`C:\Users\Administrator\.agent-reach-venv`；用户级命令包装器：`C:\Users\Administrator\.local\bin\agent-reach.cmd`、`C:\Users\Administrator\.local\bin\yt-dlp.cmd`。
- `mcporter` 已通过 npm 全局安装，Exa MCP 已写入用户级配置 `C:\Users\Administrator\.mcporter\mcporter.json`；已清理误写入项目目录的 `config\mcporter.json`。
- 2026-06-11 验证：`agent-reach doctor` 显示基础渠道中 YouTube、V2EX、RSS、Exa 全网语义搜索、任意网页可用；GitHub CLI 存在但当前普通环境未认证；Twitter/X、Reddit、小红书、小宇宙、雪球、LinkedIn 等可选渠道尚未配置。

## 2026-06-11 Agent Reach Twitter 状态

- 已安装 `twitter-cli` 0.8.5 到 `C:\Users\Administrator\.agent-reach-venv`，并创建用户级包装器 `C:\Users\Administrator\.local\bin\twitter.cmd`。
- 已给 `twitter.cmd` 设置 `PYTHONUTF8=1` 和 `PYTHONIOENCODING=utf-8`，避免 Windows GBK 控制台输出帮助文本时报 UnicodeEncodeError。
- 2026-06-11 验证：`twitter --help` 可用；`twitter status` 返回 `not_authenticated`，当前阻塞是缺少 Twitter/X Cookie。
- 自动从 Chrome/Edge 提取 Cookie 的操作被权限审查拒绝；后续需要用户主动提供 Cookie-Editor 导出的 Header String，再运行 `agent-reach configure twitter-cookies "..."` 后复查。
