---
type: 指南
domain: 知识管理
status: 进行中
cssclasses:
  - home-dashboard
tags:
  - 领域/知识
  - 类型/清单
---

# Dusk Plugin Alignment

> [!home]+ 目标
> Dusk 的精致感来自 Minimal 主题、CSS snippets、按钮插件、tabs、Dataview/Datacore、Tasks、快捷入口和浮动工具。当前库先按优先级补齐插件，再逐步把首页从静态版升级为插件增强版。

> [!project] 当前状态
> 已从 Dusk public vault 补齐缺失插件目录，并合并到 `.obsidian/community-plugins.json`。
>
> - 启用插件：49 个
> - 插件目录：49 个
> - manifest 缺失：0 个
> - 首页已升级：`tabs` + `meta-bind-button` + `tasks` + `dataview`
> - 必要 snippets 已启用：`base`、`MCL Multi Column`、`MCL Wide Views`、`Gradient Callouts`、`datacore-classes`

## Phase 1 / 首页必需

> [!project] 先装这些
> - `tabs`
> - `obsidian-meta-bind-plugin`
> - `dataview`
> - `datacore`
> - `quickadd`
> - `obsidian-hotkeys-for-specific-files`
> - `obsidian-view-mode-by-frontmatter`
> - `obsidian-minimal-settings`
> - `obsidian-style-settings`
> - `iconic`

> [!task] 用途
> - `tabs`：实现 Dusk 首页顶部和下方的标签切换。
> - `obsidian-meta-bind-plugin`：实现 `BUTTON[...]` 红色按钮。
> - `dataview` / `datacore`：实现地图、收件箱、表格和动态查询。
> - `quickadd`：实现 Create Note。
> - `obsidian-hotkeys-for-specific-files`：实现一键打开 MOC / Inbox。
> - `obsidian-view-mode-by-frontmatter`：让首页默认阅读模式，避免看到源码。
> - `minimal-settings` / `style-settings`：接近 Dusk 的 Minimal 视觉配置。
> - `iconic`：文件夹和笔记图标。

## Phase 2 / 工作流增强

> [!para] 推荐继续装
> - `templater-obsidian`
> - `journals`
> - `nldates-obsidian`
> - `obsidian-projects`
> - `note-toolbar`
> - `homepage`
> - `home-tab`
> - `omnisearch`
> - `recent-files-obsidian`
> - `quick-explorer`
> - `obsidian-hover-editor`
> - `obsidian-outliner`

## Phase 3 / 视觉和辅助

> [!zeta] 可选
> - `obsidian-admonition`
> - `obsidian-list-callouts`
> - `obsidian-chartsview-plugin`
> - `pomodoro-timer`
> - `highlightr-plugin`
> - `editing-toolbar`
> - `tag-wrangler`
> - `statusbar-organizer`
> - `settings-search`
> - `obsidian-paste-image-rename`
> - `url-into-selection`
> - `novel-word-count`

## Phase 4 / 先不建议

> [!system] 谨慎
> - `todoist-sync-plugin`：需要 Todoist token。
> - `obsidian-custom-frames`：会嵌入外部网页。
> - `js-engine`：可执行 JS，等首页稳定后再启用。
> - `obsidian42-brat`：用于 beta 插件，先不急。
> - `garble-text`：演示/隐私用途，不影响首页。
> - `obsidian-grandfather`、`obsidian-trash-explorer`：维护类插件，后置。

## Dusk 启用插件完整清单

> [!capture] Dusk public vault
> - `obsidian-admonition`
> - `obsidian42-brat`
> - `obsidian-checklist-plugin`
> - `cmdr`
> - `custom-sort`
> - `datacore`
> - `dataview`
> - `editing-toolbar`
> - `obsidian-view-mode-by-frontmatter`
> - `obsidian-hider`
> - `home-tab`
> - `homepage`
> - `obsidian-hotkeys-for-specific-files`
> - `obsidian-hover-editor`
> - `templater-obsidian`
> - `obsidian-tasks-plugin`
> - `tag-wrangler`
> - `tabs`
> - `obsidian-style-settings`
> - `statusbar-organizer`
> - `settings-search`
> - `quickadd`
> - `quick-explorer`
> - `obsidian-projects`
> - `pomodoro-timer`
> - `obsidian-outliner`
> - `omnisearch`
> - `note-toolbar`
> - `nldates-obsidian`
> - `obsidian-minimal-settings`
> - `obsidian-meta-bind-plugin`
> - `js-engine`
> - `journals`
> - `iconic`
> - `obsidian-grandfather`
> - `recent-files-obsidian`
> - `obsidian-excalidraw-plugin`
> - `obsidian-trash-explorer`
> - `obsidian-list-callouts`
> - `highlightr-plugin`
> - `obsidian-paste-image-rename`
> - `url-into-selection`
> - `garble-text`
> - `obsidian-custom-frames`
> - `todoist-sync-plugin`
> - `novel-word-count`
> - `obsidian-chartsview-plugin`
