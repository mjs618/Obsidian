# Obsidian 日常聚焦完善设计

## 背景

知识库已经形成稳定的 `HUB / PARA / ZETA / DAILY` 闭环，但实际使用时仍有三处摩擦：

1. `HUB/Home` 的“每日笔记”按钮打开 `DAILY/00-DAILY`，不能直接进入当天记录。
2. Homepage 启动时保留旧标签页且不刷新 Dataview，容易恢复成拥挤、过期的工作区。
3. 首页把工作台、索引和周期复盘清单计入收件箱或行动任务；每日模板还会生成 3 个空任务。

## 目标

- “每日笔记”按钮调用 Journals 的当天笔记命令。
- 启动时用 `HUB/Home` 替换旧主编辑标签页，并刷新 Dataview。
- 首页只统计真实内容页与真实行动区任务。
- 新建每日笔记不自动产生空任务。

## 非目标

- 不新增、移除或升级插件。
- 不移动、重命名或删除现有笔记。
- 不引入新的任务属性体系。
- 不修改无关项目、AI 日记和提示词资产。

## 设计

### 今日笔记

将 Meta Bind 按钮命令从特定文件跳转改为 `journals:journal:calendar:open-day`。该命令由已启用的 Journals 插件提供，负责打开或创建 `DAILY/DAILY/YYYY-MM-DD.md`。

### 启动页

保持 Homepage 指向 `HUB/Home`，把启动打开方式改为 `Replace all open notes`，把 `refreshDataview` 设为 `true`。手动打开主页仍保留当前笔记，避免日常导航时清空标签页。

### 统计口径

- 收件箱：只计 `未分类/` 与 `STICKY/` 中非 `工作台 / 索引 / MOC` 页面。
- 剪藏：只计 `80-Clippings/` 中非工作台、索引和 MOC 页面。
- 行动任务：允许 `Codex/TODO.md`、`Codex/projects/`、`30-工作/`、`未分类/`、`投资/`，以及真实周期笔记目录 `DAILY/DAILY/`、`DAILY/WEEKLY/`、`DAILY/MONTHLY/`。
- `DAILY/Weekly Notes.md`、`DAILY/Monthly Notes.md` 等说明页不再计入任务。

### 每日模板

保留“今日最重要推进、必须处理、可以放弃或延后”三个提示，但改为普通列表。QuickAdd 仍可在 `# New Tasks` 下插入真实复选框任务。

## 验证

1. 先运行静态契约检查，确认旧命令、旧启动配置和宽泛 `DAILY/` 过滤仍存在。
2. 修改后验证命令 ID、配置 JSON、任务正则、模板提示和代码围栏。
3. 用 Obsidian 点击“每日笔记”，确认创建或打开当天文件。
4. 返回主页确认收件箱、剪藏和行动任务口径已更新。

