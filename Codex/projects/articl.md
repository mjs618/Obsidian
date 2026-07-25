# articl / Article Fetcher

## 2026-06-11 项目检查

- 工作区：`E:\project\articl`。
- 项目定位：微博 V+ 文章抓取、离线阅读和 TTS 朗读工具。
- 架构：Python 抓取核心 + Tauri 2 / Vue 3 / TypeScript 桌面端。
- Python 入口：`core.py`，分发 `login_weibo.py`、`fetch_article_list.py`、`download_text_only.py`、`download_single.py`、`download_tts.py`。
- 桌面端：`desktop-app/src`，主要组件为 `Sidebar.vue`、`MainContent.vue`、`ScraperControl.vue`，状态管理在 `stores/`。
- 数据状态：`all_vip_articles.json` 和 `subscriptions/5205312904_articles.json` 均为 478 条元数据；`articles_text/5205312904/` 有 488 个 `.txt`，可能存在历史重复或标题变体。
- 关键风险：`requirements.txt` 只声明 `playwright`，但源码还使用 `bs4`、`edge_tts`；`browser_data/` 含登录态，不应提交或共享；仓库包含生成目录和依赖目录；`TECHNICAL_DESIGN.md` 内容与本项目不匹配。
- 产出：已重写 `PROJECT_SUMMARY.md`，记录项目定位、结构、流程、运行方式、风险和建议下一步。

## 后续建议

- 补齐 Python 依赖：`beautifulsoup4`、`edge-tts`。
- 明确开发期与正式版的数据目录策略。
- 配置 `.gitignore`，排除登录态、构建缓存、依赖目录和本地文章内容。
- 重新执行 `npm run build` / `cargo check`，确认旧构建错误是否仍存在。
- 清点 `articles_text/5205312904/` 多出的 10 个文本文件。
