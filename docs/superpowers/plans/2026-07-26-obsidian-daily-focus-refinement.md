# Obsidian Daily Focus Refinement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the Obsidian homepage open a real daily note, start cleanly, and show trustworthy inbox and task signals.

**Architecture:** Keep the existing Homepage, Journals, Meta Bind, Dataview, and QuickAdd plugins. Change only their current Markdown/config integration and the daily template; use static contract checks plus an Obsidian UI smoke test.

**Tech Stack:** Obsidian Markdown, DataviewJS, Meta Bind, Journals, Homepage JSON, PowerShell, Git

---

### Task 1: Capture the failing contracts

**Files:**
- Test: `HUB/Home.md`
- Test: `.obsidian/plugins/homepage/data.json`
- Test: `SYSTEM/TEMPLATE/FORMAT/template_daily_note.md`

- [ ] **Step 1: Check the daily button still targets the MOC**

Run:

```powershell
rg -n 'command: obsidian-hotkeys-for-specific-files:DAILY/00-DAILY.md' HUB/Home.md
```

Expected: one match, proving the button does not open today's note.

- [ ] **Step 2: Check the startup config still keeps old notes**

Run:

```powershell
$config = Get-Content -Raw -Encoding UTF8 '.obsidian/plugins/homepage/data.json' | ConvertFrom-Json
$config.homepages.'Main Homepage' | Select-Object openMode, refreshDataview
```

Expected: `openMode` is `Keep open notes` and `refreshDataview` is `False`.

- [ ] **Step 3: Check the task filter and daily template still create noise**

Run:

```powershell
$home = Get-Content -Raw -Encoding UTF8 'HUB/Home.md'
$template = Get-Content -Raw -Encoding UTF8 'SYSTEM/TEMPLATE/FORMAT/template_daily_note.md'
[pscustomobject]@{
  BroadDailyFilters = ([regex]::Matches($home, '30-工作\|DAILY\|未分类')).Count
  EmptyTemplateTasks = ([regex]::Matches($template, '(?m)^- \[ \] (今日最重要推进|必须处理|可以放弃或延后)：')).Count
}
```

Expected: `BroadDailyFilters = 2` and `EmptyTemplateTasks = 3`.

### Task 2: Implement the smallest coherent change

**Files:**
- Modify: `HUB/Home.md`
- Modify: `.obsidian/plugins/homepage/data.json`
- Modify: `SYSTEM/TEMPLATE/FORMAT/template_daily_note.md`

- [ ] **Step 1: Point the daily button at Journals**

Replace the Meta Bind command with:

```yaml
command: journals:journal:calendar:open-day
```

- [ ] **Step 2: Narrow task and queue counts**

Use real daily folders:

```javascript
const actionable = path =>
  path === "Codex/TODO.md" ||
  /^(Codex\/projects|30-工作|未分类|投资)\//.test(path) ||
  /^DAILY\/(DAILY|WEEKLY|MONTHLY)\//.test(path);
```

Exclude `工作台 / 索引 / MOC` pages from inbox and clipping counts.

- [ ] **Step 3: Make startup deterministic**

Set:

```json
"openMode": "Replace all open notes",
"refreshDataview": true
```

Keep `manualOpenMode` unchanged.

- [ ] **Step 4: Stop creating empty daily tasks**

Change the three template prompts from unchecked tasks to ordinary list items.

### Task 3: Verify statically

**Files:**
- Verify: `HUB/Home.md`
- Verify: `.obsidian/plugins/homepage/data.json`
- Verify: `SYSTEM/TEMPLATE/FORMAT/template_daily_note.md`

- [ ] **Step 1: Run the post-change contract**

Expected:

```text
DailyCommand=1
OldDailyCommand=0
PreciseDailyFilters=2
BroadDailyFilters=0
EmptyTemplateTasks=0
StartupMode=Replace all open notes
RefreshDataview=True
```

- [ ] **Step 2: Run Markdown and JSON integrity checks**

Run `git diff --check`, parse Homepage JSON, and confirm all fenced blocks in `HUB/Home.md` remain balanced.

### Task 4: Verify in Obsidian

**Files:**
- UI: `HUB/Home.md`
- Expected creation/open: `DAILY/DAILY/2026-07-26.md`

- [ ] **Step 1: Reload the changed configuration**

Use Obsidian settings or an app restart so Homepage reads the updated JSON.

- [ ] **Step 2: Click “每日笔记”**

Expected: Obsidian opens or creates `DAILY/DAILY/2026-07-26.md`; it must not open `DAILY/00-DAILY.md`.

- [ ] **Step 3: Return to Home**

Expected: the homepage renders without Dataview errors and the inbox/task counts exclude structural pages and recurring guide checklists.

### Task 5: Record the verified result

**Files:**
- Create: `00-管理/审查记录/2026-07-26-日常聚焦完善记录.md`
- Modify: `Codex/projects/Obsidian.md`

- [ ] **Step 1: Record only verified facts**

Document the changed files, UI verification, and any unresolved startup limitations.

- [ ] **Step 2: Inspect the final diff**

Run `git status --short` and `git diff --check`. Do not commit unless the user explicitly requests a commit.

