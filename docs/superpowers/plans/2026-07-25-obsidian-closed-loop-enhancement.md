# Obsidian Dynamic Closed-Loop Enhancement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Strengthen the vault's daily action, project, AI-index, and Codex-memory loops without moving content, changing plugins, or introducing new automation dependencies.

**Architecture:** Keep static Markdown as the durable fallback and add small Dataview views only where content changes frequently. Use a path allowlist for actionable tasks, aggregate Codex project memories into the existing PARA project hub, and make the Codex memory lifecycle explicit in its existing governance file.

**Tech Stack:** Obsidian Markdown, Dataview/DataviewJS, PowerShell read-only verification, Git

---

## File map

- Modify `Codex/AGENTS.md`: define task-time retrieval, result correction, and experience promotion.
- Modify `HUB/Home.md`: scope task summaries and counts to explicit action areas.
- Modify `PARA/Projects.md`: expose recent Codex project memories and the cross-project task list.
- Modify `20-AI/AI日记/00-索引.md`: add dynamic recent daily-note and source views.
- Create `00-管理/审查记录/2026-07-25-闭环增强记录.md`: record the completed enhancement and evidence.
- Modify `Codex/projects/Obsidian.md`: persist the vault project state and remaining boundaries.

### Task 1: Strengthen the Codex memory lifecycle

**Files:**
- Modify: `Codex/AGENTS.md`
- Test: PowerShell and `rg` structural checks

- [ ] **Step 1: Run the pre-change contract check**

Run:

```powershell
rg -n "任务前召回|结果校正|经验升级|同类经验第二次出现" Codex/AGENTS.md
```

Expected: exit code `1` with no matches, proving the new lifecycle contract is not already present.

- [ ] **Step 2: Add task-time retrieval beneath the existing “启动时” list**

Insert this exact Markdown after the `notes/` list:

```markdown
重要任务进入执行前，再按相关性完成一次任务前召回：

1. 读取当前项目页，确认目标、状态、已知约束和下一步。
2. 检索相关历史决策、失败案例、检查清单、SOP 或 Skill。
3. 只在实际影响本次方案时说明复用了哪些历史记忆；没有匹配内容时不虚构引用。
```

- [ ] **Step 3: Add result correction and experience promotion before “会话收尾”**

Insert this exact section after “何时更新”：

```markdown
## 结果校正与经验升级

重要任务完成后，判断本次结果对已有记忆的影响：

- 历史判断被证实：补充验证条件和适用边界。
- 历史判断被推翻：保留旧结论，标明失效原因、新证据和当前结论。
- 结果仍不确定：记录待验证条件，不提前升级为长期规则。

经验按真实复用次数逐级升级：

1. 首次出现：写入最相关的项目页。
2. 同类经验第二次出现且仍有效：升级为检查清单或 SOP。
3. 第三次验证有效且适合自动执行：升级为 Skill、模板或固定规则。

经验升级不扩大任务授权范围；删除、外部写入和敏感信息处理仍遵循会话级安全规则。
```

- [ ] **Step 4: Verify the memory contract**

Run:

```powershell
$text = Get-Content -Raw -Encoding utf8 'Codex\AGENTS.md'
[pscustomobject]@{
  Recall = ([regex]::Matches($text, '任务前召回')).Count
  Correction = ([regex]::Matches($text, '历史判断被推翻')).Count
  SecondUse = ([regex]::Matches($text, '同类经验第二次出现')).Count
  ThirdUse = ([regex]::Matches($text, '第三次验证有效')).Count
}
```

Expected:

```text
Recall Correction SecondUse ThirdUse
------ ---------- --------- --------
     1          1         1        1
```

- [ ] **Step 5: Commit the memory lifecycle**

```powershell
git add -- Codex/AGENTS.md
git commit -m "docs: strengthen Codex memory loop"
```

### Task 2: Restrict the Home dashboard to actionable tasks

**Files:**
- Modify: `HUB/Home.md`
- Test: PowerShell structural and task-count checks

- [ ] **Step 1: Run the pre-change dashboard check**

Run:

```powershell
rg -n "const actionable = path|const excluded = path|const exclude = p" HUB/Home.md
```

Expected: two legacy definitions (`const excluded = path` and `const exclude = p`) and no `const actionable = path` definition.

- [ ] **Step 2: Replace the task-summary filter**

In the “任务摘要” DataviewJS block, replace the existing `excluded` function and task filter with:

```javascript
const actionable = path =>
  path === "Codex/TODO.md" ||
  /^(Codex\/projects|30-工作|DAILY|未分类|投资)\//.test(path);
const tasks = dv.pages()
  .file.tasks
  .where(t => !t.completed && actionable(t.path))
  .slice(0, 6);
```

Keep the existing rendering code unchanged.

- [ ] **Step 3: Replace the “今日焦点” page filter and counts**

At the start of the “今日焦点” DataviewJS block, replace the existing `exclude`, `pages`, `todo`, `done`, and `fresh` definitions with:

```javascript
const actionable = path =>
  path === "Codex/TODO.md" ||
  /^(Codex\/projects|30-工作|DAILY|未分类|投资)\//.test(path);
const pages = dv.pages().where(p => actionable(String(p.file.path)));
const todo = pages.file.tasks.where(t => !t.completed && actionable(t.path)).length;
const done = pages.file.tasks.where(t => t.completed && actionable(t.path)).length;
const fresh = pages
  .where(p => p.file.cday && p.file.cday.toISODate() === dv.date("today").toISODate())
  .length;
```

Keep the mini-card and inbox-strip rendering code unchanged.

- [ ] **Step 4: Verify both dashboard blocks use the same allowlist**

Run:

```powershell
$text = Get-Content -Raw -Encoding utf8 'HUB\Home.md'
[pscustomobject]@{
  ActionableDefinitions = ([regex]::Matches($text, 'const actionable = path =>')).Count
  LegacyDefinitions = ([regex]::Matches($text, 'const excluded = path|const exclude = p')).Count
  TodoPathMentions = ([regex]::Matches($text, 'path === "Codex/TODO\.md"')).Count
  AllowedPathRegexes = ([regex]::Matches($text, 'Codex\\/projects\|30-工作\|DAILY\|未分类\|投资')).Count
}
```

Expected:

```text
ActionableDefinitions LegacyDefinitions TodoPathMentions AllowedPathRegexes
--------------------- ----------------- ---------------- ------------------
                    2                 0                2                  2
```

- [ ] **Step 5: Verify the resulting action-area task baseline**

Run:

```powershell
$vaultRoot = (Resolve-Path '.').Path
$rows = foreach ($file in Get-ChildItem -LiteralPath $vaultRoot -Recurse -File -Filter '*.md') {
  $relative = $file.FullName.Substring($vaultRoot.Length + 1).Replace('\', '/')
  if ($relative -eq 'Codex/TODO.md' -or $relative -match '^(Codex/projects|30-工作|DAILY|未分类|投资)/') {
    $content = [IO.File]::ReadAllText($file.FullName)
    [pscustomobject]@{
      Open = ([regex]::Matches($content, '(?m)^\s*- \[ \]')).Count
      Closed = ([regex]::Matches($content, '(?m)^\s*- \[[xX]\]')).Count
    }
  }
}
[pscustomobject]@{
  Open = ($rows | Measure-Object Open -Sum).Sum
  Closed = ($rows | Measure-Object Closed -Sum).Sum
}
```

Expected at the 2026-07-25 baseline:

```text
Open Closed
---- ------
  22      4
```

- [ ] **Step 6: Commit the task-signal change**

```powershell
git add -- HUB/Home.md
git commit -m "fix: scope dashboard tasks to action areas"
```

### Task 3: Connect Codex project memory to the project hub

**Files:**
- Modify: `PARA/Projects.md`
- Test: `rg` structural checks

- [ ] **Step 1: Run the pre-change project-hub check**

Run:

```powershell
rg -n "Codex 项目记忆|FROM \"Codex/projects\"|Codex/TODO" PARA/Projects.md
```

Expected: exit code `1` with no matches.

- [ ] **Step 2: Add the Codex project-memory section before “Reviews”**

Insert this exact Markdown:

````markdown
## Codex 项目记忆

> [!info]+ AI 协作项目
> 这里动态显示 `Codex/projects` 中最近更新的项目记忆，只提供统一入口，不改变项目正文归属。

[[Codex/TODO|跨项目待办]]

```dataview
TABLE dateformat(file.mtime, "yyyy-MM-dd HH:mm") AS "最近更新"
FROM "Codex/projects"
SORT file.mtime DESC
LIMIT 10
```
````

- [ ] **Step 3: Verify the project aggregation contract**

Run:

```powershell
$text = Get-Content -Raw -Encoding utf8 'PARA\Projects.md'
[pscustomobject]@{
  Section = ([regex]::Matches($text, '## Codex 项目记忆')).Count
  Source = ([regex]::Matches($text, 'FROM "Codex/projects"')).Count
  Limit = ([regex]::Matches($text, 'LIMIT 10')).Count
  TodoLink = ([regex]::Matches($text, '\[\[Codex/TODO\|跨项目待办\]\]')).Count
}
```

Expected: all four properties equal `1`.

- [ ] **Step 4: Commit the project-hub change**

```powershell
git add -- PARA/Projects.md
git commit -m "feat: surface Codex projects in project hub"
```

### Task 4: Add dynamic intake views to the AI diary index

**Files:**
- Modify: `20-AI/AI日记/00-索引.md`
- Test: PowerShell path and structural checks

- [ ] **Step 1: Run the pre-change AI-index check**

Run:

```powershell
rg -n "最近自动收录|FROM \"20-AI/AI日记/2026\"|FROM \"20-AI/AI日记/Sources\"" '20-AI/AI日记/00-索引.md'
```

Expected: exit code `1` with no matches.

- [ ] **Step 2: Add dynamic recent views before “周度趋势复盘”**

Insert this exact Markdown:

````markdown
## 最近自动收录

> [!info]+ 防漏视图
> 新日报和来源页会先自动出现在这里；下方人工清单继续负责摘要、判断和精选。

### 日报与趋势复盘

```dataview
TABLE date AS "日期", type AS "类型", status AS "状态"
FROM "20-AI/AI日记/2026"
SORT date DESC, file.name DESC
LIMIT 20
```

### 来源页

```dataview
TABLE date AS "日期", status AS "状态"
FROM "20-AI/AI日记/Sources"
SORT date DESC, file.name DESC
LIMIT 20
```
````

- [ ] **Step 3: Verify the latest files are inside the query scopes**

Run:

```powershell
$paths = @(
  '20-AI\AI日记\2026\07\2026-07-24.md',
  '20-AI\AI日记\2026\07\2026-07-25.md',
  '20-AI\AI日记\Sources\2026-07-24-sources.md',
  '20-AI\AI日记\Sources\2026-07-25-sources.md'
)
$missing = $paths | Where-Object { -not (Test-Path -LiteralPath $_) }
[pscustomobject]@{
  Checked = $paths.Count
  Missing = $missing.Count
}
```

Expected:

```text
Checked Missing
------- -------
      4       0
```

- [ ] **Step 4: Verify the dynamic-view structure**

Run:

```powershell
$text = Get-Content -Raw -Encoding utf8 '20-AI\AI日记\00-索引.md'
[pscustomobject]@{
  Section = ([regex]::Matches($text, '## 最近自动收录')).Count
  DailySource = ([regex]::Matches($text, 'FROM "20-AI/AI日记/2026"')).Count
  SourcesSource = ([regex]::Matches($text, 'FROM "20-AI/AI日记/Sources"')).Count
  Limit20 = ([regex]::Matches($text, 'LIMIT 20')).Count
}
```

Expected:

```text
Section DailySource SourcesSource Limit20
------- ----------- ------------- -------
      1           1             1       2
```

- [ ] **Step 5: Commit the AI-index change**

```powershell
git add -- '20-AI/AI日记/00-索引.md'
git commit -m "feat: add dynamic AI diary intake"
```

### Task 5: Record the enhancement and update persistent project memory

**Files:**
- Create: `00-管理/审查记录/2026-07-25-闭环增强记录.md`
- Modify: `Codex/projects/Obsidian.md`
- Test: frontmatter and heading checks

- [ ] **Step 1: Confirm the audit record and memory entry do not exist**

Run:

```powershell
[pscustomobject]@{
  AuditExists = Test-Path -LiteralPath '00-管理\审查记录\2026-07-25-闭环增强记录.md'
  MemoryEntry = ([regex]::Matches(
    (Get-Content -Raw -Encoding utf8 'Codex\projects\Obsidian.md'),
    '## 2026-07-25：动态闭环增强'
  )).Count
}
```

Expected:

```text
AuditExists MemoryEntry
----------- -----------
      False           0
```

- [ ] **Step 2: Create the audit record**

Create `00-管理/审查记录/2026-07-25-闭环增强记录.md` with this exact content:

```markdown
---
type: 审查记录
domain: 知识管理
status: 已完成
tags:
  - 领域/知识
  - 类型/清单
  - 状态/已完成
created: 2026-07-25
updated: 2026-07-25
---

# 2026-07-25 闭环增强记录

## 结论

本轮没有扩目录、移动正文或增加插件，而是在现有结构中补强行动、项目、索引和 Codex 记忆四条闭环。

## 完成内容

- `HUB/Home.md` 的任务摘要和统计改为行动区白名单，排除提示词、模板、治理和知识资料中的示例复选框。
- `PARA/Projects.md` 增加最近 Codex 项目记忆和跨项目待办入口，不复制或移动项目正文。
- `20-AI/AI日记/00-索引.md` 增加日报、趋势复盘和来源页的动态防漏视图，保留人工摘要清单。
- `Codex/AGENTS.md` 增加任务前召回、结果校正和经验升级规则。

## 验证基线

- 行动区任务基线为 22 条未完成、4 条已完成；首页不再读取全库约 785 个复选框任务信号。
- 最近项目视图只读取 `Codex/projects`，按修改时间倒序显示 10 条。
- AI 日记动态视图覆盖 `2026-07-24`、`2026-07-25` 日报及对应来源页。
- 修改没有引入新的目录、插件依赖、文件移动或删除。

## 保留边界

- `HUB/Outputs`、`HUB/Review` 和 Permanent Note 数量保持不变；真实复用结果出现后再更新。
- 根目录未命名 Base/Canvas 文件不属于本轮范围。
- 真实克隆恢复演练仍是独立待办，本轮不执行远程写入。

## 相关入口

- [[HUB/Home]]
- [[PARA/Projects]]
- [[20-AI/AI日记/00-索引]]
- [[Codex/AGENTS]]
- [[00-管理/知识库治理规范]]
```

- [ ] **Step 3: Prepend the Obsidian project-memory entry**

Immediately after `# Obsidian` in `Codex/projects/Obsidian.md`, insert:

```markdown
## 2026-07-25：动态闭环增强

- 首页任务摘要和统计改为行动区白名单，只读取 `Codex/TODO.md`、`Codex/projects`、`30-工作`、`DAILY`、`未分类` 和 `投资`。
- `PARA/Projects.md` 已接入最近更新的 Codex 项目记忆和跨项目待办入口，项目正文仍保留原位。
- AI 日记索引增加动态防漏视图，新日报和来源页无需等待人工追加即可被看见，人工清单继续承担摘要和精选。
- `Codex/AGENTS.md` 已增加任务前召回、结果校正和经验按复用次数升级的规则。
- 本轮未移动、删除或重命名正文，未修改插件，未处理根目录未命名文件。
- 审查与验证记录见 `00-管理/审查记录/2026-07-25-闭环增强记录.md`。
```

- [ ] **Step 4: Verify the audit record and memory update**

Run:

```powershell
$audit = Get-Content -Raw -Encoding utf8 '00-管理\审查记录\2026-07-25-闭环增强记录.md'
$memory = Get-Content -Raw -Encoding utf8 'Codex\projects\Obsidian.md'
[pscustomobject]@{
  AuditFrontmatter = $audit.StartsWith("---`n") -or $audit.StartsWith("---`r`n")
  AuditHeading = ([regex]::Matches($audit, '# 2026-07-25 闭环增强记录')).Count
  MemoryHeading = ([regex]::Matches($memory, '## 2026-07-25：动态闭环增强')).Count
}
```

Expected:

```text
AuditFrontmatter AuditHeading MemoryHeading
---------------- ------------ -------------
            True            1             1
```

- [ ] **Step 5: Commit the audit and memory update**

```powershell
git add -- '00-管理/审查记录/2026-07-25-闭环增强记录.md' Codex/projects/Obsidian.md
git commit -m "docs: record Obsidian loop enhancement"
```

### Task 6: Run full verification

**Files:**
- Verify: all files changed in Tasks 1-5
- Test: whitespace, structure, links, and Git scope

- [ ] **Step 1: Run whitespace verification**

Run:

```powershell
git diff HEAD~5 --check
```

Expected: exit code `0` with no whitespace errors.

- [ ] **Step 2: Verify Markdown code fences are balanced**

Run:

```powershell
$files = @(
  'HUB\Home.md',
  'PARA\Projects.md',
  '20-AI\AI日记\00-索引.md',
  '00-管理\审查记录\2026-07-25-闭环增强记录.md'
)
$rows = foreach ($file in $files) {
  $text = Get-Content -Raw -Encoding utf8 $file
  $count = ([regex]::Matches($text, '```')).Count
  [pscustomobject]@{
    File = $file
    FenceCount = $count
    Balanced = ($count % 2 -eq 0)
  }
}
$rows
```

Expected: every row has `Balanced = True`.

- [ ] **Step 3: Verify the four feature contracts together**

Run:

```powershell
$agents = Get-Content -Raw -Encoding utf8 'Codex\AGENTS.md'
$home = Get-Content -Raw -Encoding utf8 'HUB\Home.md'
$projects = Get-Content -Raw -Encoding utf8 'PARA\Projects.md'
$index = Get-Content -Raw -Encoding utf8 '20-AI\AI日记\00-索引.md'
[pscustomobject]@{
  MemoryRecall = ([regex]::Matches($agents, '任务前召回')).Count
  MemoryPromotion = ([regex]::Matches($agents, '第三次验证有效')).Count
  ActionableDefinitions = ([regex]::Matches($home, 'const actionable = path =>')).Count
  ProjectSource = ([regex]::Matches($projects, 'FROM "Codex/projects"')).Count
  AIRecentViews = ([regex]::Matches($index, 'FROM "20-AI/AI日记/(2026|Sources)"')).Count
}
```

Expected:

```text
MemoryRecall MemoryPromotion ActionableDefinitions ProjectSource AIRecentViews
------------ --------------- --------------------- ------------- -------------
           1               1                     2             1             2
```

- [ ] **Step 4: Verify new wikilink targets**

Run:

```powershell
$targets = @(
  'Codex\TODO.md',
  'Codex\AGENTS.md',
  'HUB\Home.md',
  'PARA\Projects.md',
  '20-AI\AI日记\00-索引.md',
  '00-管理\知识库治理规范.md'
)
$targets | ForEach-Object {
  [pscustomobject]@{
    Target = $_
    Exists = Test-Path -LiteralPath $_
  }
}
```

Expected: every row has `Exists = True`.

- [ ] **Step 5: Verify Git scope and final history**

Run:

```powershell
git status --short
git log -6 --oneline
```

Expected:

- `git status --short` has no tracked modifications from this implementation.
- The last five implementation commits are:
  - `docs: strengthen Codex memory loop`
  - `fix: scope dashboard tasks to action areas`
  - `feat: surface Codex projects in project hub`
  - `feat: add dynamic AI diary intake`
  - `docs: record Obsidian loop enhancement`
- Existing unrelated untracked files, if any, remain untracked and unstaged.

- [ ] **Step 6: Report the verified result**

Report:

- Which five knowledge files were modified and which audit record was created.
- The actionable task baseline (`22` open, `4` closed).
- That project and AI diary views use existing Dataview only.
- That no existing content was moved or deleted and no plugin configuration changed.
- Any verification failure or remaining external check, especially the need to open Obsidian to visually confirm Dataview rendering.
