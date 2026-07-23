# Obsidian 知识库均衡整理 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在不移动、删除或批量改写笔记的前提下，修复当前导航、补齐 7 月 AI 日记索引和少量正式笔记元数据，并留下可复查的审查记录。

**Architecture:** 保留现有“工作流层 + 内容库层”结构，只修改导航面、索引面和明确缺失的 frontmatter。所有改动均为局部 Markdown/YAML 编辑；验证以目标链接可解析、日期覆盖完整、frontmatter 边界有效和 Git 差异可解释为准。

**Tech Stack:** Obsidian Markdown、wikilink、YAML frontmatter、PowerShell、Git

---

## 文件结构

**修改：**

- `HUB/Map.md`：全库结构与工作流映射。
- `SYSTEM/00-SYSTEM.md`：系统治理入口与模板路径说明。
- `20-AI/AI日记/00-索引.md`：AI 日报、来源和周度复盘入口。
- `20-AI/AI日记/AI资讯日报 2026-6-1.md`：历史正式日报。
- `20-AI/AI日记/Sources/2026-06-08-sources.md`：历史来源页。
- `20-AI/AI日记/Sources/2026-06-09-sources.md`：历史来源页。
- `20-AI/AI日记/Sources/2026-06-10-sources.md`：历史来源页。
- `20-AI/AI日记/Sources/2026-07-21-sources.md`：7 月来源页。
- `投资/gold/weekly-report.md`：黄金市场周报。
- `00-管理/审查记录/00-索引.md`：知识库审查记录入口。
- `Codex/projects/Obsidian.md`：长期可复用的知识库状态记忆。

**创建：**

- `00-管理/审查记录/2026-07-23-均衡整理记录.md`：本轮审计、取舍、结果和延期项。

**Git 边界：**

- `HUB/Map.md`、`20-AI/AI日记/00-索引.md`、`投资/gold/weekly-report.md` 和 `Codex/projects/Obsidian.md` 已包含本轮开始前的用户改动。
- 实施完成后只检查差异，不提交实施改动，避免把用户既有内容混入新提交。

### Task 1: 收口导航并移除目录型伪链接

**Files:**

- Modify: `HUB/Map.md:85`
- Modify: `SYSTEM/00-SYSTEM.md:49`

- [ ] **Step 1: 记录修改前目标行**

Run:

```powershell
rg -n -C 2 '^\| HUB \||SYSTEM/TEMPLATE/FORMAT' 'HUB/Map.md' 'SYSTEM/00-SYSTEM.md'
```

Expected:

- `HUB/Map.md` 的 HUB 行仍指向 `首页`、`任务邮箱` 和 `未分类/收件箱处理台`。
- `SYSTEM/00-SYSTEM.md` 使用 `[[SYSTEM/TEMPLATE/FORMAT]]` 指向目录而非笔记。

- [ ] **Step 2: 把 HUB 映射改为真实入口**

将 `HUB/Map.md` 的 HUB 行替换为：

```markdown
| HUB | 首页、地图、收件箱、任务、输出、复习 | [[HUB/Home]]、[[HUB/Map]]、[[HUB/Inbox]]、[[HUB/Tasks]]、[[HUB/Outputs]]、[[HUB/Review]] |
```

- [ ] **Step 3: 把目录型 wikilink 改为路径说明**

将 `SYSTEM/00-SYSTEM.md` 第 49 行替换为：

```markdown
4. 对会影响新建笔记的变更，检查 [[Templates/00-索引]] 和 `SYSTEM/TEMPLATE/FORMAT`。
```

- [ ] **Step 4: 验证导航结果**

Run:

```powershell
rg -n '^\| HUB \|' 'HUB/Map.md'
rg -n '\[\[SYSTEM/TEMPLATE/FORMAT\]\]' 'SYSTEM/00-SYSTEM.md'
```

Expected:

- 第一条命令只显示新的 6 个 HUB 入口。
- 第二条命令无输出。

### Task 2: 补齐 2026 年 7 月 AI 日记索引

**Files:**

- Modify: `20-AI/AI日记/00-索引.md`

- [ ] **Step 1: 保留现有未提交内容**

Run:

```powershell
git diff -- '20-AI/AI日记/00-索引.md'
```

Expected:

- 可以看到用户已加入的“周度趋势复盘”区。
- 后续编辑不得删除或重写该区。

- [ ] **Step 2: 在“日报”区按倒序加入 7 月日报**

加入以下 17 个链接，并根据对应日报 `## 今日重点` 的前 1—2 个高信号事件写一句话摘要：

```markdown
- [[20-AI/AI日记/2026/07/2026-07-23|2026-07-23]]
- [[20-AI/AI日记/2026/07/2026-07-22|2026-07-22]]
- [[20-AI/AI日记/2026/07/2026-07-21|2026-07-21]]
- [[20-AI/AI日记/2026/07/2026-07-19|2026-07-19]]
- [[20-AI/AI日记/2026/07/2026-07-17|2026-07-17]]
- [[20-AI/AI日记/2026/07/2026-07-16|2026-07-16]]
- [[20-AI/AI日记/2026/07/2026-07-15|2026-07-15]]
- [[20-AI/AI日记/2026/07/2026-07-14|2026-07-14]]
- [[20-AI/AI日记/2026/07/2026-07-13|2026-07-13]]
- [[20-AI/AI日记/2026/07/2026-07-12|2026-07-12]]
- [[20-AI/AI日记/2026/07/2026-07-10|2026-07-10]]
- [[20-AI/AI日记/2026/07/2026-07-09|2026-07-09]]
- [[20-AI/AI日记/2026/07/2026-07-08|2026-07-08]]
- [[20-AI/AI日记/2026/07/2026-07-07|2026-07-07]]
- [[20-AI/AI日记/2026/07/2026-07-06|2026-07-06]]
- [[20-AI/AI日记/2026/07/2026-07-04|2026-07-04]]
- [[20-AI/AI日记/2026/07/2026-07-03|2026-07-03]]
```

摘要只概括原文，不引入新事实；保留现有 6 月及 5 月条目。

- [ ] **Step 3: 在“来源归档”区按倒序加入 7 月来源页**

加入：

```markdown
- [[20-AI/AI日记/Sources/2026-07-23-sources]]
- [[20-AI/AI日记/Sources/2026-07-22-sources]]
- [[20-AI/AI日记/Sources/2026-07-21-sources]]
- [[20-AI/AI日记/Sources/2026-07-19-sources]]
- [[20-AI/AI日记/Sources/2026-07-17-sources]]
- [[20-AI/AI日记/Sources/2026-07-16-sources]]
- [[20-AI/AI日记/Sources/2026-07-15-sources]]
- [[20-AI/AI日记/Sources/2026-07-14-sources]]
- [[20-AI/AI日记/Sources/2026-07-13-sources]]
- [[20-AI/AI日记/Sources/2026-07-12-sources]]
- [[20-AI/AI日记/Sources/2026-07-10-sources]]
- [[20-AI/AI日记/Sources/2026-07-09-sources]]
- [[20-AI/AI日记/Sources/2026-07-08-sources]]
- [[20-AI/AI日记/Sources/2026-07-07-sources]]
- [[20-AI/AI日记/Sources/2026-07-06-sources]]
- [[20-AI/AI日记/Sources/2026-07-04-sources]]
- [[20-AI/AI日记/Sources/2026-07-03-sources]]
```

- [ ] **Step 4: 验证日报和来源覆盖**

Run:

```powershell
$index = Get-Content -Raw -Encoding UTF8 '20-AI\AI日记\00-索引.md'
$dailyMissing = Get-ChildItem '20-AI\AI日记\2026\07' -File -Filter '2026-07-??.md' | Where-Object { $index -notmatch [regex]::Escape($_.BaseName) }
$sourceMissing = Get-ChildItem '20-AI\AI日记\Sources' -File -Filter '2026-07-*-sources.md' | Where-Object { $index -notmatch [regex]::Escape($_.BaseName) }
"日报缺失: $($dailyMissing.Count)"
"来源缺失: $($sourceMissing.Count)"
```

Expected:

```text
日报缺失: 0
来源缺失: 0
```

### Task 3: 为 6 篇正式笔记补最小 frontmatter

**Files:**

- Modify: `20-AI/AI日记/AI资讯日报 2026-6-1.md:1`
- Modify: `20-AI/AI日记/Sources/2026-06-08-sources.md:1`
- Modify: `20-AI/AI日记/Sources/2026-06-09-sources.md:1`
- Modify: `20-AI/AI日记/Sources/2026-06-10-sources.md:1`
- Modify: `20-AI/AI日记/Sources/2026-07-21-sources.md:1`
- Modify: `投资/gold/weekly-report.md:1`

- [ ] **Step 1: 为历史日报补 frontmatter**

在 `20-AI/AI日记/AI资讯日报 2026-6-1.md` 顶部加入：

```yaml
---
date: 2026-06-01
type: AI日记
domain: AI
status: 已整理
tags:
  - 领域/AI
  - 类型/汇总
  - AI新闻
  - 行业观察
---
```

- [ ] **Step 2: 为 3 篇 6 月来源页补 frontmatter**

分别使用对应日期，在三篇来源页顶部加入以下结构：

```yaml
---
date: 2026-06-08
type: AI日记-来源
domain: AI
status: 已整理
tags:
  - 领域/AI
  - 类型/来源
  - AI新闻
---
```

`2026-06-09-sources.md` 使用 `date: 2026-06-09`，`2026-06-10-sources.md` 使用 `date: 2026-06-10`；其他字段相同。

- [ ] **Step 3: 为 7 月 21 日来源页补 frontmatter**

在 `20-AI/AI日记/Sources/2026-07-21-sources.md` 顶部加入：

```yaml
---
date: 2026-07-21
type: AI日记来源
domain: AI
status: 已整理
tags:
  - 领域/AI
  - 类型/来源
  - AI日记
---
```

- [ ] **Step 4: 为黄金周报补 frontmatter**

在 `投资/gold/weekly-report.md` 顶部加入：

```yaml
---
date: 2026-07-17
type: 市场周报
domain: 投资
status: 进行中
tags:
  - 领域/投资
  - 类型/汇总
  - 黄金
---
```

- [ ] **Step 5: 验证 6 篇笔记字段完整**

Run:

```powershell
$targets = @(
  '20-AI\AI日记\AI资讯日报 2026-6-1.md',
  '20-AI\AI日记\Sources\2026-06-08-sources.md',
  '20-AI\AI日记\Sources\2026-06-09-sources.md',
  '20-AI\AI日记\Sources\2026-06-10-sources.md',
  '20-AI\AI日记\Sources\2026-07-21-sources.md',
  '投资\gold\weekly-report.md'
)
foreach ($file in $targets) {
  $content = Get-Content -Raw -Encoding UTF8 $file
  $ok = $content -match '(?ms)^---\s*\r?\n.*?^type:\s*.+$.*?^domain:\s*.+$.*?^status:\s*.+$.*?^tags:\s*\r?\n.*?^---\s*$'
  "$ok`t$file"
}
```

Expected: 6 行均以 `True` 开头。

### Task 4: 写入审查记录并接入索引

**Files:**

- Create: `00-管理/审查记录/2026-07-23-均衡整理记录.md`
- Modify: `00-管理/审查记录/00-索引.md`

- [ ] **Step 1: 创建本轮审查记录**

使用以下结构和结论：

```markdown
---
type: 审查记录
domain: 知识管理
status: 已完成
tags:
  - 领域/知识
  - 类型/清单
  - 状态/已完成
---

# 2026-07-23 均衡整理记录

## 结论

当前知识库骨架稳定，不需要再次迁移目录。本轮只收口导航、补索引和少量正式笔记元数据。

## 审计基线

- 全库共 514 篇 Markdown；排除 `.codex-temp`、`Codex` 和 `docs` 后，本轮内容审计覆盖 445 篇。
- 全库基线有 51 篇无 frontmatter，其中正式内容缺口集中在 5 篇 AI 日记/来源页和 1 篇黄金周报。
- 144 篇有 frontmatter 但缺 `domain`，其中 116 篇位于 AI 提示词库；本轮不批量改写。
- 已识别的真实导航问题是 `SYSTEM/00-SYSTEM.md` 的目录型伪链接，以及 `HUB/Map.md` 的旧 HUB 映射。

## 本轮完成

- HUB 工作流映射改为当前真实入口。
- 2026 年 7 月日报与来源页接入 AI 日记索引。
- 6 篇正式笔记补齐最小 frontmatter。
- 未移动、重命名或删除文件，未修改 `.obsidian`。

## 外部参考

- [Obsidian Internal links](https://github.com/obsidianmd/obsidian-help/blob/master/en/Linking%20notes%20and%20files/Internal%20links.md)
- [voidashi/obsidian-vault-template](https://github.com/voidashi/obsidian-vault-template)
- [Obsidian Dataview](https://github.com/blacksmithgu/obsidian-dataview)
- [Obsidian Linter rules](https://github.com/platers/obsidian-linter/blob/master/docs/rules.md)

## 延期项

- AI 提示词库 116 篇缺 `domain`：需要单独制定受控字段口径后再分批处理。
- 根目录两个未命名 Base、两个历史 HTML 和旧整理脚本：未确认用途前不移动或删除。
- `99-归档/空白占位`：删除前仍需人工确认留痕价值。
```

- [ ] **Step 2: 接入审查索引**

在 `00-管理/审查记录/00-索引.md` 的“已有记录”顶部加入：

```markdown
- [[00-管理/审查记录/2026-07-23-均衡整理记录]]：收口导航、补齐 7 月 AI 索引和 6 篇正式笔记元数据，并记录延期治理项。
```

- [ ] **Step 3: 验证审查记录可达**

Run:

```powershell
rg -n '2026-07-23-均衡整理记录' '00-管理/审查记录/00-索引.md'
Test-Path '00-管理/审查记录/2026-07-23-均衡整理记录.md'
```

Expected:

- 第一条命令显示新增索引行。
- 第二条命令输出 `True`。

### Task 5: 全量验证与记忆收尾

**Files:**

- Modify: `Codex/projects/Obsidian.md`

- [ ] **Step 1: 检查目标差异和格式**

Run:

```powershell
git diff --check
git diff -- 'HUB/Map.md' 'SYSTEM/00-SYSTEM.md' '20-AI/AI日记/00-索引.md' '20-AI/AI日记/AI资讯日报 2026-6-1.md' '20-AI/AI日记/Sources/2026-06-08-sources.md' '20-AI/AI日记/Sources/2026-06-09-sources.md' '20-AI/AI日记/Sources/2026-06-10-sources.md' '20-AI/AI日记/Sources/2026-07-21-sources.md' '投资/gold/weekly-report.md' '00-管理/审查记录/00-索引.md' '00-管理/审查记录/2026-07-23-均衡整理记录.md'
```

Expected:

- `git diff --check` 无错误。
- 差异只包含计划中的导航、索引、frontmatter 和审查记录内容。

- [ ] **Step 2: 复查已知断链和日期覆盖**

Run:

```powershell
rg -n '\[\[SYSTEM/TEMPLATE/FORMAT\]\]' 'SYSTEM/00-SYSTEM.md'
$index = Get-Content -Raw -Encoding UTF8 '20-AI\AI日记\00-索引.md'
$dailyMissing = Get-ChildItem '20-AI\AI日记\2026\07' -File -Filter '2026-07-??.md' | Where-Object { $index -notmatch [regex]::Escape($_.BaseName) }
$sourceMissing = Get-ChildItem '20-AI\AI日记\Sources' -File -Filter '2026-07-*-sources.md' | Where-Object { $index -notmatch [regex]::Escape($_.BaseName) }
"日报缺失: $($dailyMissing.Count)"
"来源缺失: $($sourceMissing.Count)"
```

Expected:

- 第一条命令无输出。
- 日报和来源缺失均为 0。

- [ ] **Step 3: 更新长期记忆**

在 `Codex/projects/Obsidian.md` 的 `## 2026-07-23` 下追加：

```markdown
- 完成一次均衡整理：`HUB/Map.md` 的 HUB 映射已收口到真实入口，`SYSTEM/00-SYSTEM.md` 不再把目录写成 wikilink，2026 年 7 月 AI 日报与来源页已接入 `20-AI/AI日记/00-索引.md`。
- 仅为 5 篇 AI 日记/来源页和 `投资/gold/weekly-report.md` 补最小 frontmatter；未批量处理 AI 提示词库 116 篇缺 `domain`，未移动或删除根目录杂项和归档占位。
- 审查依据与延期项记录在 `00-管理/审查记录/2026-07-23-均衡整理记录.md`。
```

- [ ] **Step 4: 最终检查工作区边界**

Run:

```powershell
git status --short
```

Expected:

- 新增本轮审查记录和实施计划。
- 目标文件显示计划内修改。
- 用户原有的其他修改和未跟踪文件仍然保留。
- 不暂存、不提交实施改动。
