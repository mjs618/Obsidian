# Obsidian Content Quality Phase 3 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clean low-risk content quality issues after the phase-2 structure migration.

**Architecture:** Use Git-aware moves for existing notes, then update a small set of manually maintained index and governance files. Keep empty placeholders in archive instead of deleting them.

**Tech Stack:** Obsidian Markdown, PowerShell, Git.

---

### Task 1: Move Low-Risk Files

**Files:**
- Move: `docker打包整个python环境.md` -> `10-技术笔记/docker打包整个python环境.md`
- Move: `🎒Stash临时保存.md` -> `99-归档/空白占位/🎒Stash临时保存.md`
- Move: `50-生活/日记/2025-11-13.md` -> `99-归档/空白占位/2025-11-13.md`
- Move: `50-生活/日记/2025-11-28.md` -> `99-归档/空白占位/2025-11-28.md`
- Move: `50-生活/日记/2026-03-29.md` -> `99-归档/空白占位/2026-03-29.md`
- Move: `未分类/.ai-reader-healthcheck.md` -> `99-归档/空白占位/.ai-reader-healthcheck.md`

- [ ] **Step 1: Create archive directory**

Run: `New-Item -ItemType Directory -Force -Path '99-归档\空白占位'`

Expected: directory exists.

- [ ] **Step 2: Move files with Git**

Run `git mv` for each listed move.

Expected: old paths are gone and new paths exist.

---

### Task 2: Update Indexes And Entry Metadata

**Files:**
- Create: `99-归档/空白占位/00-索引.md`
- Modify: `99-归档/00-索引.md`
- Modify: `50-生活/00-索引.md`
- Modify: `未分类/00-索引.md`
- Modify: `10-技术笔记/00-索引.md`
- Modify: `README.md`
- Modify: `标签仪表盘.md`
- Modify: `20-AI/AI日记/00-索引.md`

- [ ] **Step 1: Create archive placeholder index**

Create `99-归档/空白占位/00-索引.md` with frontmatter, file list, and handling rules.

- [ ] **Step 2: Update parent archive index**

Link to `99-归档/空白占位/00-索引` and describe this archive category.

- [ ] **Step 3: Update life and inbox indexes**

Remove blank diary links from `50-生活/00-索引.md`. Update `未分类/00-索引.md` to state that the inbox is currently empty.

- [ ] **Step 4: Add entry frontmatter**

Add governance-friendly frontmatter to `README.md`, `标签仪表盘.md`, and `20-AI/AI日记/00-索引.md`.

---

### Task 3: Verify And Commit

**Files:** read-only plus Git commit

- [ ] **Step 1: Verify paths**

Run `Test-Path` for old and new paths.

Expected: old root/inbox/blank diary paths are false; new archive and technical paths are true.

- [ ] **Step 2: Run targeted link scan**

Scan updated entry/index files for unresolved migration links.

Expected: no unresolved links in updated navigation files.

- [ ] **Step 3: Review Git status**

Run: `git status --short -uall`

Expected: moves and index/metadata edits only.

- [ ] **Step 4: Commit locally**

Commit with message: `chore: improve obsidian content quality phase 3`.

