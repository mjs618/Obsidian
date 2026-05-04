# Obsidian Structure Phase 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Consolidate AI, templates, and root-level management documents into the phase-2 target structure.

**Architecture:** Use Git-aware directory moves for content migration, then update a small set of navigation and governance documents. Automation configuration is updated through the Codex automation tool after local file migration succeeds.

**Tech Stack:** Obsidian Markdown, PowerShell, Git, Codex automation config.

---

### Task 1: Preflight

**Files:** read-only

- [x] **Step 1: Verify clean content baseline**

Run: `git status --short -uall`

Expected: no tracked or untracked content changes. Warnings about `C:\Users\Administrator/.config/git/ignore` may appear and are not part of this vault.

- [x] **Step 2: Verify source directories exist**

Run `Test-Path` for `AI学习`, `AI日记`, `Templates`, `模版`, and `00-管理`.

Expected: all return `True`.

---

### Task 2: Move Directories

**Files:**
- Move: `AI学习` -> `20-AI/AI学习`
- Move: `AI日记` -> `20-AI/AI日记`
- Move: `模版` -> `Templates/原生模板`
- Move: root `00-*` management docs -> `00-管理/历史整理文档`

- [x] **Step 1: Create target directories**

Create `20-AI`, `00-管理/历史整理文档`, and ensure `Templates` exists.

- [x] **Step 2: Move AI directories with Git**

Use `git mv AI学习 20-AI/AI学习` and `git mv AI日记 20-AI/AI日记`.

- [x] **Step 3: Move native templates with Git**

Use `git mv 模版 Templates/原生模板`.

- [x] **Step 4: Move root historical management docs**

Use `git mv` for the root `00-*` documents listed in the design into `00-管理/历史整理文档`.

- [x] **Step 5: Verify old top-level directories are gone**

Run `Test-Path AI学习`, `Test-Path AI日记`, and `Test-Path 模版`.

Expected: all return `False`.

---

### Task 3: Update Navigation

**Files:**
- Modify: `README.md`
- Modify: `00-管理/00-管理索引.md`
- Modify: `00-管理/知识库治理规范.md`
- Modify: `00-管理/插件与同步配置说明.md`
- Modify: `00-管理/标签体系/00-索引.md`
- Modify: `Templates/00-索引.md`
- Create: `20-AI/00-索引.md`

- [x] **Step 1: Create `20-AI/00-索引.md`**

Add a top-level AI area index linking to `20-AI/AI学习/00-索引` and `20-AI/AI日记/00-索引`.

- [x] **Step 2: Update README**

Replace old `AI学习`, `AI日记`, and `模版` entries with `20-AI` and `Templates/原生模板`.

- [x] **Step 3: Update management links**

Point historical management document links to `00-管理/历史整理文档/...`; point AI links to `20-AI/...`; point native template links to `Templates/原生模板/...`.

- [x] **Step 4: Update template index**

Make `Templates/00-索引.md` the unified template entry and link to `Templates/原生模板/00-索引`.

---

### Task 4: Update Automation

**Files:** Codex automation `ai`

- [x] **Step 1: Update AI diary automation**

Use `automation_update` to set the project path to `E:\Obsidian\20-AI\AI日记`, remove old-directory fallback language, and keep the no commit/no push rule.

- [x] **Step 2: Verify automation text**

Read `C:\Users\Administrator\.codex\automations\ai\automation.toml` and confirm it contains `E:\Obsidian\20-AI\AI日记` and no longer instructs fallback to `E:\Obsidian\AI日记`.

---

### Task 5: Verification And Commit

**Files:** read-only plus Git commit

- [x] **Step 1: Verify target paths**

Run `Test-Path` for `20-AI/AI学习`, `20-AI/AI日记`, `Templates/原生模板`, and `00-管理/历史整理文档`.

Expected: all return `True`.

- [x] **Step 2: Run targeted link scan**

Scan `README.md`, `00-管理/**/*.md`, `20-AI/**/*.md`, `Templates/**/*.md`, and all `00-索引.md` files for unresolved links introduced by migration.

Expected: no unresolved links in updated navigation files.

- [x] **Step 3: Review Git staged/unstaged status**

Run `git status --short -uall` and `git diff --name-status --cached --find-renames=50%`.

Expected: moves and navigation edits only.

- [x] **Step 4: Commit locally**

Commit with message: `chore: migrate obsidian structure phase 2`.

- [x] **Step 5: Verify post-commit state**

Run `git status --short -uall`.

Expected: clean status except the known global ignore permission warning. No push.

