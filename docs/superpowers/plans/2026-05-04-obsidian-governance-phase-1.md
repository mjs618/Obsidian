# Obsidian Governance Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the vault easier to enter, review, and maintain without moving or renaming existing notes.

**Architecture:** This is a documentation and governance pass. The vault keeps its current folder layout; new Markdown indexes and management documents provide navigation, rules, and maintenance routines. `.gitignore` is updated conservatively for local noise only.

**Tech Stack:** Obsidian Markdown, wiki links, optional Dataview/Templater references, Git.

---

### Task 1: Management Hub

**Files:**
- Create: `00-管理/00-管理索引.md`
- Create: `00-管理/知识库治理规范.md`
- Create: `00-管理/定期维护清单.md`
- Create: `00-管理/插件与同步配置说明.md`

- [ ] **Step 1: Create `00-管理/00-管理索引.md`**

Add a concise management entry that links to governance rules, maintenance checklist, plugin/sync notes, existing root guidance files, and review records.

- [ ] **Step 2: Create `00-管理/知识库治理规范.md`**

Document the folder roles, tag taxonomy, minimal frontmatter, link rules, capture workflow, and archive rules. State clearly that phase 1 does not migrate existing files.

- [ ] **Step 3: Create `00-管理/定期维护清单.md`**

Add daily, weekly, monthly, and quarterly maintenance routines that can be followed without plugins.

- [ ] **Step 4: Create `00-管理/插件与同步配置说明.md`**

Record current plugin status: Obsidian Git, Excalidraw, Tasks, Calendar are installed; Dataview and Templater are referenced by notes but not installed. Document that Excalidraw config still references the old `Excalidraw` path while the current folder is `90-Excalidraw`.

- [ ] **Step 5: Verify management hub links**

Run: `Test-Path` on all four files and inspect the first lines with `Get-Content`.

Expected: all four files exist under `00-管理`.

---

### Task 2: Section Indexes

**Files:**
- Create: `10-技术笔记/00-索引.md`
- Create: `30-工作/00-索引.md`
- Create: `40-知识库/00-索引.md`
- Create: `50-生活/00-索引.md`
- Create: `60-思维笔记/00-索引.md`
- Create: `70-数据资料/00-索引.md`
- Create: `80-Clippings/00-索引.md`
- Create: `90-Excalidraw/00-索引.md`
- Create: `未分类/00-索引.md`

- [ ] **Step 1: Create technical notes index**

List existing technical notes and recommend grouping quick references, environment management, Git/Obsidian, and project-specific notes.

- [ ] **Step 2: Create work index**

List project notes, weekly summaries, and empty future areas such as meetings.

- [ ] **Step 3: Create knowledge-base index**

Link the five chapter notes and the summary note so the knowledge-base material has a stable entry point.

- [ ] **Step 4: Create life and thinking indexes**

Add practical indexes for `50-生活` and `60-思维笔记`, including notes on empty daily files and future weekly/monthly reviews.

- [ ] **Step 5: Create data, clipping, Excalidraw, and inbox indexes**

Add simple entry points for low-volume areas. The inbox index should explain the review criteria for `未分类`.

- [ ] **Step 6: Verify no existing index was overwritten**

Run: `git status --short -- */00-索引.md 未分类/00-索引.md`

Expected: all listed files are new (`??`) unless a file existed before implementation.

---

### Task 3: Vault Entry And Git Hygiene

**Files:**
- Modify: `README.md`
- Modify: `.gitignore`

- [ ] **Step 1: Replace `README.md` with vault home page**

Write the vault purpose, main areas, active entry points, maintenance cadence, and phase-1 boundary. Link to the management hub and important indexes.

- [ ] **Step 2: Update `.gitignore` conservatively**

Ignore OS/editor noise, local temporary files, and optional generated local reports. Do not ignore Markdown, images, `.obsidian` plugin manifests, or content directories.

- [ ] **Step 3: Verify `.gitignore` does not hide content**

Run: `git check-ignore README.md "10-技术笔记/00-索引.md" "执行机构.png"`

Expected: no output for content files.

---

### Task 4: Health Check Checklist

**Files:**
- Create: `00-管理/审查记录/知识库健康检查模板.md`

- [ ] **Step 1: Create repeatable health-check template**

Include sections for empty notes, missing frontmatter, missing tags, orphan candidates, dead-end notes, broken links, large embedded assets, root clutter, Git status, plugin mismatch, and next actions.

- [ ] **Step 2: Link health-check template from management hub**

Update `00-管理/00-管理索引.md` to link the template.

- [ ] **Step 3: Verify checklist path**

Run: `Test-Path "00-管理/审查记录/知识库健康检查模板.md"`

Expected: `True`.

---

### Task 5: Verification And Review

**Files:**
- Read-only verification over vault.

- [ ] **Step 1: Confirm no files were moved or deleted by this phase**

Run: `git status --short`

Expected: pre-existing moves/deletions may still appear, but phase-1 implementation should only add or modify the planned files.

- [ ] **Step 2: Confirm all target files exist**

Run a `Test-Path` check for management docs, section indexes, `README.md`, `.gitignore`, and the health-check template.

Expected: all planned paths return `True`.

- [ ] **Step 3: Confirm Markdown count increased only by planned additions**

Run: `Get-ChildItem -Path . -Recurse -File -Filter *.md -Force | Where-Object { $_.FullName -notmatch '\\.git\\' -and $_.FullName -notmatch '\\.obsidian\\' } | Measure-Object`

Expected: count increases by the new plan/governance/index/checklist files.

- [ ] **Step 4: Stage only phase-1 files if committing is requested or appropriate**

Use explicit paths with `git add -- <paths>`. Do not stage unrelated vault reorganizations.

- [ ] **Step 5: Summarize implementation**

Report created/modified files, verification result, and remaining recommendations for phase 2.
