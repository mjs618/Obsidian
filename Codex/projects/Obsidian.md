# Obsidian

## 2026-05-31

- 季度治理复盘未修改 vault 正文或配置，只完成结构、标签、插件和 Git/备份策略取证。
- 结构主骨架仍稳定：日常入口以 `HUB/Home` 为主，结构地图以 `HUB/Map` 为主；根目录保留 `README.md`、`首页.md`、`标签仪表盘.md`，后台仍有 `00-管理/全库地图.md` 与 `00-管理/知识库工作台.md` 作为低频入口。
- 主要治理偏差集中在元数据口径而不是目录失控：`20-AI/AI日记` 持续使用 `type: AI日记 / AI日记-来源 / AI主题`、`status: 已整理`、`类型/来源`、`类型/主题`，`AI学习` 里仍有 `type: article`、`status: read`，与 `00-管理/标签与属性速查.md` 不一致。
- `AI日记` 自动化从 2026-06-13 起明确只写入新固定目录 `20-AI/AI日记`，日记路径为 `20-AI/AI日记/YYYY/MM/YYYY-MM-DD.md`，来源整理写入 `20-AI/AI日记/Sources/`，不再回写历史根目录。
- 提示词资产区仍基本守在 `20-AI/AI提示词库` 内，但其内部实际使用 `status: archived/testing`，比速查页当前声明的 `active/deprecated/review` 更宽；后续若继续维护，应先补文档口径而不是全库批量改值。
- Git 规则总体有效：`.obsidian/community-plugins.json` 中 55 个启用插件与 `SYSTEM/必要插件清单.md` 一致，且 `home-tab`、`novel-word-count`、`recent-files-obsidian` 的运行态 `data.json` 未被跟踪；当前最明确的噪音是已被 `.gitignore` 忽略但仍在索引中的 `.codex_hex_2026-05-06.html`、`.codex_hex_2026-05-07.html`。
- 备份策略仍有验证缺口：`00-管理/恢复演练与隐私检查.md` 只有 2026-05-12 的本地最小检查记录，尚未完成真实克隆/恢复演练；季度复盘建议优先补这项，而不是继续结构迁移。
