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

## 换行规则

仓库根目录的 `.gitattributes` 固定了常见文本文件的换行规则：

- Markdown、JSON、YAML、CSS、JS 使用 LF，减少跨平台 diff 噪音。
- PowerShell 和批处理脚本使用 CRLF，符合 Windows 本地使用习惯。
- 图片、PDF、ZIP 等附件按二进制处理。

如果 Git 提示已有文件下次触碰时会换行转换，通常不是内容错误。优先在一次专门的格式化提交里处理，不要混入正文整理提交。
