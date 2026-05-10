---
type: 管理
domain: 知识管理
status: 进行中
tags:
  - 领域/知识
  - 类型/配置
  - 状态/进行中
---

# Git 与 Obsidian 状态文件规则

本页用于区分哪些 Obsidian 文件应该进入 Git，哪些只是本机运行状态，避免每次打开库后出现无意义的变更。

## 应该纳入 Git

- Markdown 笔记、索引、模板和审查记录。
- `Templates`、`HUB`、`PARA`、`ZETA`、`DAILY`、`SYSTEM` 等库内正文。
- `.obsidian/community-plugins.json`、主题、CSS snippets、插件 manifest 和确认为稳定配置的 `data.json`。
- 图片、Excalidraw 文件和正文引用的附件。

## 不建议纳入 Git

这些文件会随本机打开记录、字数缓存或 UI 状态频繁变化，默认不作为知识库内容提交：

- `.obsidian/plugins/home-tab/data.json`
- `.obsidian/plugins/novel-word-count/data.json`
- `.obsidian/plugins/recent-files-obsidian/data.json`
- `.obsidian/workspace*.json`
- `.obsidian/cache/`
- `.obsidian/graph.json`
- `.codex-temp/`
- `local-reports/`
- `.codex_hex_*.html`

## 自动化产物边界

自动化或外部工具生成的临时文件默认不作为知识库正文提交，除非它们已经被整理成 Markdown 笔记、审查记录或模板说明。

- `.codex-temp/`、`local-reports/` 和 `.codex_hex_*.html` 视为临时输出，默认忽略。
- `docs/superpowers/` 目前保留为自动化计划和规格记录；若某份计划已经沉淀为正式治理文档，再把结论迁移到 `00-管理` 或对应分区。
- 根目录出现新的脚本、HTML、报告或批量工具时，先判断是“长期维护工具”还是“一次性产物”。长期工具需要说明入口；一次性产物应忽略、归档或转写成审查记录。

## 已跟踪状态文件的处理

如果某个运行状态文件已经被 Git 跟踪，单独写入 `.gitignore` 不会立刻让它从状态列表消失。确认它只是本机状态后，可以只从 Git 索引移除，保留本地文件：

```powershell
git rm --cached -- .obsidian/plugins/home-tab/data.json
git rm --cached -- .obsidian/plugins/novel-word-count/data.json
git rm --cached -- .obsidian/plugins/recent-files-obsidian/data.json
```

执行前先确认这些文件没有保存必须同步到其他设备的配置。执行后再检查：

```powershell
git status --short
```

## 备份策略

`Obsidian Git` 的 30 分钟自动提交只是本地版本快照；没有自动 push 时，不等于异地备份。当前建议：

- 本地自动提交用于找回近期误改。
- 每周至少手动检查一次 `git status --short` 和远程 push 状态。
- 每月确认一次远程仓库、云盘或磁盘快照是否能独立恢复。
- 不把 `.obsidian/workspace*.json`、`graph.json` 和运行态插件缓存作为备份完整性的判断标准。

## 换行规则

仓库根目录的 `.gitattributes` 固定了常见文本文件的换行规则：

- Markdown、JSON、YAML、CSS、JS 使用 LF，减少跨平台 diff 噪音。
- PowerShell 和批处理脚本使用 CRLF，符合 Windows 本地使用习惯。
- 图片、PDF、ZIP 等附件按二进制处理。

如果 Git 提示已有文件下次触碰时会换行转换，通常不是内容错误。优先在一次专门的格式化提交里处理，不要混入正文整理提交。
