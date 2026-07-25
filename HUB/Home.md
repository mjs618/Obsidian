---
type: 工作台
domain: 知识管理
status: 进行中
cssclasses:
  - home-dashboard
  - dusk-homepage
  - no-inline
  - hide-properties_editing
  - hide-properties_reading
tags:
  - 领域/知识
  - 类型/汇总
  - 重要
---

# Home

> [!dusk-rule]
> ........................................................................................................................

> [!dusk-hero]
> **知识工作台**
> 唯一日常入口 · 捕获 · 项目 · 任务 · 沉淀 · 输出

> [!dusk-actions]
> `BUTTON[open_moc]` `BUTTON[open_daily_note]` `BUTTON[create_new_note]` `BUTTON[quick_switcher]` `BUTTON[open_inbox]`

> [!dusk-search]+ 全库搜索
> `BUTTON[omnisearch]`
>
> `BUTTON[quick_switcher]` `BUTTON[recent_files]`
>
> [[HUB/Map|知识地图]] · [[HUB/Inbox|收件箱]] · [[PARA/Projects|项目]] · [[ZETA/00-ZETA|沉淀]] · [[HUB/Outputs|输出]]

> [!dusk-status]+ 库概览
> ```dataviewjs
> const items = Array.of(
>   ["项目", '"30-工作"'],
>   ["AI", '"20-AI"'],
>   ["剪藏", '"80-Clippings"'],
>   ["收件箱", '"HUB"']
> );
> const wrap = dv.container.createDiv({ cls: "dusk-stat-grid" });
> for (const [label, query] of items) {
>   const count = dv.pages(query).length;
>   const card = wrap.createDiv({ cls: "dusk-stat" });
>   card.createSpan({ text: String(count), cls: "dusk-stat-number" });
>   card.createSpan({ text: label, cls: "dusk-stat-label" });
> }
> ```

> [!dusk-flow]+ 工作流
> [[HUB/Inbox|01 捕获]] → [[PARA/Projects|02 推进]] → [[HUB/Tasks|03 整理]] → [[ZETA/00-ZETA|04 沉淀]] → [[HUB/Outputs|05 输出]] → [[DAILY/00-DAILY|06 复盘]]

> [!dusk-use]+ 今天只做三件事
> 1. 先把新想法、链接、临时任务放进 [[HUB/Inbox]]，不现场分类。
> 2. 只推进 1 个项目或 1 条任务，入口是 [[PARA/Projects]] 和 [[HUB/Tasks]]。
> 3. 当天结束前，把最有价值的一条记录沉淀到 [[ZETA/00-ZETA]] 或今日笔记。

> [!dusk-next]+ 下一步
> ```dataviewjs
> const items = Array.of(
>   ["捕获新内容", "HUB/Inbox"],
>   ["推进项目", "PARA/Projects"],
>   ["处理整理队列", "HUB/Tasks"],
>   ["沉淀可复用知识", "ZETA/00-ZETA"],
>   ["准备输出成果", "HUB/Outputs"],
>   ["复习关键笔记", "HUB/Review"]
> );
> const wrap = dv.container.createDiv({ cls: "dusk-next-grid" });
> for (const [label, path] of items) {
>   const card = wrap.createEl("a", {
>     text: label,
>     cls: "internal-link dusk-next-card",
>     attr: { "data-href": path, href: path }
>   });
> }
> ```

> [!multi-column]
>
> > [!custom_task]+ 任务摘要
> > ```dataviewjs
> > const actionable = path =>
> >   path === "Codex/TODO.md" ||
> >   /^(Codex\/projects|30-工作|DAILY|未分类|投资)\//.test(path);
> > const tasks = dv.pages()
> >   .file.tasks
> >   .where(t => !t.completed && actionable(t.path))
> >   .slice(0, 6);
> > const wrap = dv.container.createDiv({ cls: "dusk-task-list" });
> > if (!tasks.length) {
> >   wrap.createDiv({ text: "暂无待处理任务。", cls: "dusk-task-empty" });
> > }
> > for (const task of tasks) {
> >   const row = wrap.createDiv({ cls: "dusk-task-row" });
> >   row.createSpan({ cls: "dusk-task-dot" });
> >   const text = row.createSpan({ text: task.text, cls: "dusk-task-text" });
> >   const source = row.createSpan({ cls: "dusk-task-source" });
> >   source.setText(task.path.split("/").pop().replace(/\.md$/, ""));
> > }
> > ```
>
> > [!custom_today]+ 今日焦点
> > **今天**
> >
> > ```dataviewjs
> > const actionable = path =>
> >   path === "Codex/TODO.md" ||
> >   /^(Codex\/projects|30-工作|DAILY|未分类|投资)\//.test(path);
> > const pages = dv.pages().where(p => actionable(String(p.file.path)));
> > const todo = pages.file.tasks.where(t => !t.completed && actionable(t.path)).length;
> > const done = pages.file.tasks.where(t => t.completed && actionable(t.path)).length;
> > const fresh = pages
> >   .where(p => p.file.cday && p.file.cday.toISODate() === dv.date("today").toISODate())
> >   .length;
> > const wrap = dv.container.createDiv({ cls: "dusk-mini-grid" });
> > for (const [label, value] of Array.of(["待办", todo], ["完成", done], ["新增", fresh])) {
> >   const card = wrap.createDiv({ cls: "dusk-mini" });
> >   card.createSpan({ text: String(value), cls: "dusk-mini-number" });
> >   card.createSpan({ text: label, cls: "dusk-mini-label" });
> > }
> > const queue = dv.container.createDiv({ cls: "dusk-inbox-strip" });
> > for (const [label, query] of Array.of(["收件箱", '"HUB"'], ["未分类", '"未分类"'], ["剪藏", '"80-Clippings"'])) {
> >   const item = queue.createDiv({ cls: "dusk-inbox-item" });
> >   item.createSpan({ text: label, cls: "dusk-inbox-label" });
> >   item.createSpan({ text: String(dv.pages(query).length), cls: "dusk-inbox-number" });
> > }
> > ```
> >
> > [[HUB/Inbox|打开收件箱记录任务]]

> [!dusk-recent]+ 最近更新
> ```dataviewjs
> const hidden = path => /^(SYSTEM|Templates|docs)\//.test(path);
> const pages = dv.pages()
>   .where(p => !hidden(p.file.path) && p.file.name !== "Home")
>   .sort(p => p.file.mtime, "desc")
>   .slice(0, 6);
> const wrap = dv.container.createDiv({ cls: "dusk-recent-list" });
> for (const page of pages) {
>   const row = wrap.createDiv({ cls: "dusk-recent-row" });
>   row.createEl("a", {
>     text: page.file.name,
>     cls: "internal-link dusk-recent-title",
>     attr: { "data-href": page.file.path, href: page.file.path }
>   });
>   row.createSpan({
>     text: page.file.mtime.toFormat("MM-dd HH:mm"),
>     cls: "dusk-recent-time"
>   });
> }
> ```

> [!dusk-rule]
> ........................................................................................................................

> [!dusk-map]+ 快速地图
> [[HUB/Map|全库地图]] · [[投资/00-索引|投资]] · [[HUB/Outputs|输出]] · [[HUB/Review|复习]] · [[PARA/00-PARA|PARA]] · [[ZETA/00-ZETA|ZETA]] · [[DAILY/00-DAILY|日记]] · [[STICKY/00-STICKY|便签]] · [[SYSTEM/00-SYSTEM|系统]]

````tabs
tab: 工作
```dataview
table dateformat(file.mtime, "yyyy-MM-dd") as "更新", type as "类型", status as "状态"
from "30-工作"
sort file.mtime desc
limit 12
```

tab: 知识
```dataview
table dateformat(file.mtime, "yyyy-MM-dd") as "更新", type as "类型", status as "状态"
from "20-AI" or "60-思维笔记" or "ZETA"
sort file.mtime desc
limit 12
```

tab: 系统
```dataview
table dateformat(file.mtime, "yyyy-MM-dd") as "更新", type as "类型", status as "状态"
from "HUB" or "PARA" or "DAILY" or "SYSTEM"
sort file.mtime desc
limit 12
```
````

```meta-bind-button
label: 知识地图
icon: lucide-map-pinned
hidden: true
id: open_moc
style: primary
actions:
  - type: command
    command: obsidian-hotkeys-for-specific-files:HUB/Map.md
```

```meta-bind-button
label: 每日笔记
icon: lucide-calendar
hidden: true
id: open_daily_note
style: primary
actions:
  - type: command
    command: obsidian-hotkeys-for-specific-files:DAILY/00-DAILY.md
```

```meta-bind-button
label: 新建笔记
icon: lucide-plus-circle
hidden: true
id: create_new_note
style: primary
actions:
  - type: command
    command: file-explorer:new-file
```

```meta-bind-button
label: 快速切换
icon: lucide-navigation
hidden: true
id: quick_switcher
style: primary
actions:
  - type: command
    command: switcher:open
```

```meta-bind-button
label: 全库搜索
icon: lucide-search
hidden: true
id: omnisearch
style: primary
actions:
  - type: command
    command: omnisearch:show-modal
```

```meta-bind-button
label: 最近文件
icon: lucide-history
hidden: true
id: recent_files
style: primary
actions:
  - type: command
    command: recent-files-obsidian:recent-files-open
```

```meta-bind-button
label: 收件箱
icon: lucide-inbox
hidden: true
id: open_inbox
style: primary
actions:
  - type: command
    command: obsidian-hotkeys-for-specific-files:HUB/Inbox.md
```
