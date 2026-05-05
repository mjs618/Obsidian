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

# Dashboard Design Guide

> [!home]+ Design Rules
> 这个库的入口页统一使用 Obsidian 原生 Callout，不再使用 HTML 卡片。目标是在 Live Preview 和阅读模式里都稳定好看。

> [!capture] 结构
> - 首页用 `.dusk-homepage`，模块页用 `.home-dashboard`。
> - 首页第一屏采用 Dusk 式结构：分隔线、按钮栏、两个功能面板。
> - 高频入口用 `[!multi-column]` 包住多个 Callout。
> - 每个页面最多 2-4 组内容，避免变成目录墙。

> [!project] Callout 类型
> - `[!dusk-rule]`：首页 Dusk 风格分隔线。
> - `[!dusk-actions]`：首页按钮栏。
> - `[!custom_task]`：任务面板。
> - `[!custom_today]`：今日任务录入面板。
> - `[!hero]`：大号首页主视觉，当前首页不使用。
> - `[!home]`：模块页总说明。
> - `[!hub]`：主页、地图、收件箱、任务。
> - `[!capture]`：收集、灵感、临时记录。
> - `[!project]`：项目、推进、产出。
> - `[!todo]`：今天真正要看的动作。
> - `[!task]`：待处理、任务、归档。
> - `[!para]`：PARA 结构。
> - `[!zeta]`：Zettelkasten、资料、永久笔记。
> - `[!daily]`：日记、周报、复盘。
> - `[!sticky]`：草稿、脑暴、短期想法。
> - `[!system]`：模板、配置、治理。

> [!system] 视觉规则
> - 使用 `.home-dashboard` CSS class。
> - 首页额外使用 `.dusk-homepage`，保持窄内容区和红色强调。
> - 不在正文里手写 HTML 栅格。
> - 标题短，解释短，链接放在每张卡片第二行。
> - 卡片标题前的短标签由 CSS 生成，不在正文里重复写图标。

> [!task] 不做
> - 不在入口页使用 HTML 卡片。
> - 不把所有链接都堆到首页。
> - 不在日常页展示复杂规则。
> - 不新增过多同义入口。
