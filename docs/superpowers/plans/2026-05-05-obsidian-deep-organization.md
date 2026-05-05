# Obsidian Deep Organization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the vault to the approved two-layer structure: Dusk workflow modules for daily navigation, numbered folders for durable content, with cleaned entry points, indexes, links, and temporary files.

**Architecture:** Keep `HUB / PARA / ZETA / DAILY / SYSTEM` as the workflow layer and `00-99` plus topic folders as the content library layer. Make entry pages and indexes responsible for navigation only, then refine high-value long notes and verify links, empty files, and frontmatter distribution.

**Tech Stack:** Obsidian Markdown, YAML frontmatter, Obsidian wikilinks, Dataview blocks, PowerShell validation commands, Git.

---

### Task 1: Inventory And Protection

**Files:**
- Read: `README.md`
- Read: `首页.md`
- Read: `HUB/Home.md`
- Read: `HUB/Map.md`
- Read: `00-管理/知识库工作台.md`
- Read: `00-管理/00-管理索引.md`
- Read: `docs/superpowers/specs/2026-05-05-obsidian-deep-organization-design.md`
- Create: `00-管理/审查记录/2026-05-05-深度整理清单.md`

- [ ] **Step 1: Capture current git status**

Run:

```powershell
git status --short
```

Expected: shows existing `.obsidian/plugins/*/data.json` modifications from Obsidian runtime state and no task edits yet except the plan file if not committed.

- [ ] **Step 2: Create the inventory record**

Create `00-管理/审查记录/2026-05-05-深度整理清单.md` with this structure:

```markdown
---
type: 审查记录
domain: 知识管理
status: 进行中
tags:
  - 领域/知识
  - 类型/清单
  - 状态/进行中
---

# 2026-05-05 深度整理清单

## 整理边界

- 采用双层体系收敛：`HUB / PARA / ZETA / DAILY / SYSTEM` 是工作流层，`00-99` 编号目录是内容库层。
- 允许移动和重命名文件，但只在职责明显错误、历史文档降频、空白内容清理或链接修复需要时执行。
- 历史内容优先归档或降频，不直接删除知识正文。
- 只删除空文件和本次整理产生的临时文件。
- 不修改 `.obsidian` 插件运行状态文件。

## 当前状态

| 项目 | 结果 |
| --- | --- |
| 日常入口 | `HUB/Home.md` |
| 全库地图 | `HUB/Map.md` |
| 后台治理 | `00-管理/00-管理索引.md` |
| 空文件 | `2026-05-04.md` |
| 重点长文 | `10-技术笔记/sd.md`、`80-Clippings/The End of Coding Andrej Karpathy on Agents, AutoResearch, and the Loopy Era of AI.md` |

## 本次处理批次

- [ ] 入口收敛
- [ ] 索引重建
- [ ] 内容提炼
- [ ] 归档与清理
- [ ] 验证

## 最终清理记录

整理完成后在这里记录删除、归档、移动和剩余风险。
```

- [ ] **Step 3: Run baseline scans**

Run:

```powershell
Get-ChildItem -Recurse -File -Filter *.md | Where-Object { $_.FullName -notmatch '\\.git\\|\\.obsidian\\|\\.codex-temp\\' } | Group-Object { ($_.FullName.Substring((Get-Location).Path.Length+1).Split('\')[0]) } | Sort-Object Name | Select-Object Name,Count
```

Expected: prints Markdown file counts per top-level folder.

Run:

```powershell
Get-ChildItem -Recurse -File -Filter *.md | Where-Object { $_.Length -eq 0 } | ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length+1) }
```

Expected: includes `2026-05-04.md` before cleanup.

- [ ] **Step 4: Commit the inventory batch**

Run:

```powershell
git add -- "docs/superpowers/plans/2026-05-05-obsidian-deep-organization.md" "00-管理/审查记录/2026-05-05-深度整理清单.md"
git commit -m "docs: add obsidian deep organization plan"
```

Expected: one commit containing only the plan and inventory record.

### Task 2: Entry Point Convergence

**Files:**
- Modify: `README.md`
- Modify: `首页.md`
- Modify: `HUB/Home.md`
- Modify: `HUB/Map.md`
- Modify: `00-管理/知识库工作台.md`
- Modify: `00-管理/00-管理索引.md`
- Modify: `SYSTEM/00-SYSTEM.md`

- [ ] **Step 1: Rewrite `README.md` as repository-level overview**

Keep frontmatter. Replace body after `# Obsidian Vault` with concise sections:

```markdown
> [!info]+ Dusk Knowledge System
> 日常入口是 [[HUB/Home]]；结构地图是 [[HUB/Map]]。编号目录继续作为长期内容库。

## 快速开始

1. 日常使用从 [[HUB/Home]] 开始。
2. 不确定放哪里，先进入 [[HUB/Inbox]]。
3. 想理解全库结构，打开 [[HUB/Map]]。
4. 系统治理、标签和模板，从 [[00-管理/00-管理索引]] 进入。

## 两层结构

| 层级 | 目录 | 职责 |
| --- | --- | --- |
| 工作流层 | `HUB`、`PARA`、`ZETA`、`DAILY`、`STICKY`、`SYSTEM` | 捕获、行动、沉淀、复盘和系统入口 |
| 内容库层 | `00-管理` 到 `99-归档`、`Templates`、`未分类` | 长期内容、资料、模板和归档 |

## 维护原则

- 入口只保留少数稳定页面，避免重复导航。
- 新内容先收集，再分拣、整理、链接和提炼。
- 历史方案优先归档或降频，不直接删除知识正文。
```

- [ ] **Step 2: Rewrite `首页.md` as lightweight Chinese doorway**

Keep frontmatter. Make it a short Chinese guide that points to `HUB/Home` and avoids duplicating task dashboards.

- [ ] **Step 3: Update `HUB/Home.md`**

Keep Dataview and Meta Bind blocks that already work. Adjust visible text so the page states it is the single daily entry, with direct links to capture, projects, tasks, knowledge distillation, recent updates, and map.

- [ ] **Step 4: Update `HUB/Map.md`**

Make it the only structural map. Add a two-layer mapping table connecting workflow modules to content folders.

- [ ] **Step 5: Update management entry pages**

Make `00-管理/知识库工作台.md` and `00-管理/00-管理索引.md` explicitly backend-only. Keep governance, audit, configuration, route map, and history links.

- [ ] **Step 6: Run entry link check**

Run:

```powershell
Select-String -Path README.md,首页.md,"HUB/Home.md","HUB/Map.md","00-管理/知识库工作台.md","00-管理/00-管理索引.md","SYSTEM/00-SYSTEM.md" -Encoding UTF8 -Pattern "HUB/Home|HUB/Map|00-管理/00-管理索引"
```

Expected: each entry page points to the correct primary entry, structure map, or backend governance page.

- [ ] **Step 7: Commit entry convergence**

Run:

```powershell
git add -- README.md 首页.md HUB/Home.md HUB/Map.md "00-管理/知识库工作台.md" "00-管理/00-管理索引.md" SYSTEM/00-SYSTEM.md
git commit -m "docs: converge obsidian entry points"
```

Expected: one commit containing entry page changes only.

### Task 3: Index Rebuild

**Files:**
- Modify: `10-技术笔记/00-索引.md`
- Modify: `20-AI/00-索引.md`
- Modify: `30-工作/00-索引.md`
- Modify: `40-知识库/00-索引.md`
- Modify: `50-生活/00-索引.md`
- Modify: `60-思维笔记/00-索引.md`
- Modify: `70-数据资料/00-索引.md`
- Modify: `80-Clippings/00-索引.md`
- Modify: `90-Excalidraw/00-索引.md`
- Modify: `99-归档/00-索引.md`
- Modify: `Templates/00-索引.md`
- Modify: `未分类/00-索引.md`

- [ ] **Step 1: Normalize index sections**

For each index, use these section headings where useful:

```markdown
## 这个分区负责什么

## 核心入口

## 重点内容

## 整理规则

## 相关地图
```

- [ ] **Step 2: Keep indexes as folder guides**

Do not turn index pages into topic essays. Use short bullet links and one-sentence descriptions.

- [ ] **Step 3: Add backlink to `HUB/Map`**

Each major index should include a related map link:

```markdown
- [[HUB/Map]]：查看全库结构。
```

- [ ] **Step 4: Run index coverage scan**

Run:

```powershell
Get-ChildItem -Recurse -File -Filter "00-*.md" | Where-Object { $_.FullName -notmatch '\\.git\\|\\.obsidian\\|\\.codex-temp\\|docs\\superpowers' } | ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length+1) } | Sort-Object
```

Expected: major folders all have `00-索引.md` or equivalent entry files.

- [ ] **Step 5: Commit index rebuild**

Run:

```powershell
git add -- "10-技术笔记/00-索引.md" "20-AI/00-索引.md" "30-工作/00-索引.md" "40-知识库/00-索引.md" "50-生活/00-索引.md" "60-思维笔记/00-索引.md" "70-数据资料/00-索引.md" "80-Clippings/00-索引.md" "90-Excalidraw/00-索引.md" "99-归档/00-索引.md" "Templates/00-索引.md" "未分类/00-索引.md"
git commit -m "docs: rebuild main vault indexes"
```

Expected: one commit containing only index pages.

### Task 4: Content Distillation

**Files:**
- Modify: `10-技术笔记/sd.md`
- Modify: `80-Clippings/The End of Coding Andrej Karpathy on Agents, AutoResearch, and the Loopy Era of AI.md`
- Modify: `80-Clippings/剪藏处理台.md`
- Modify: `40-知识库/知识库核心知识与构建方法总结.md`
- Modify: `40-知识库/00-索引.md`
- Modify: `20-AI/AI日记/Topics/00-AI主题地图.md`
- Modify: `60-思维笔记/00-思维主题地图.md`

- [ ] **Step 1: Add navigation summaries to long notes**

At the top of each long note after frontmatter and title, add compact sections:

```markdown
## 快速摘要

- 这篇笔记解决什么问题：
- 最有用的结论：
- 后续复用场景：

## 相关入口

- [[HUB/Map]]
- 对应主题或项目入口
```

- [ ] **Step 2: Improve `sd.md`**

Keep original technical material. Add a readable top summary that explains purpose, input/output context, key fields, unresolved checks, and related project link.

- [ ] **Step 3: Improve Karpathy clipping**

Keep transcript/source content. Add an extraction block with five reusable ideas, personal judgment, and links to AI topic map and agent workflow themes.

- [ ] **Step 4: Distill `40-知识库` method notes**

Add a section in `40-知识库/知识库核心知识与构建方法总结.md` named `可复用原则卡片` with 5-10 principles linked back to the five chapter notes.

- [ ] **Step 5: Update topic maps**

Add links from AI and thinking topic maps to the newly improved notes where relevant.

- [ ] **Step 6: Commit content distillation**

Run:

```powershell
git add -- "10-技术笔记/sd.md" "80-Clippings/The End of Coding Andrej Karpathy on Agents, AutoResearch, and the Loopy Era of AI.md" "80-Clippings/剪藏处理台.md" "40-知识库/知识库核心知识与构建方法总结.md" "40-知识库/00-索引.md" "20-AI/AI日记/Topics/00-AI主题地图.md" "60-思维笔记/00-思维主题地图.md"
git commit -m "docs: distill high value vault notes"
```

Expected: one commit containing long-note and topic-map improvements.

### Task 5: Archive And Cleanup

**Files:**
- Modify: `99-归档/00-索引.md`
- Modify: `00-管理/历史整理文档/00-文件夹索引.md`
- Modify: `00-管理/审查记录/2026-05-05-深度整理清单.md`
- Delete: `2026-05-04.md`
- Clean: `.codex-temp` only if it contains files created by this task and no user data.

- [ ] **Step 1: Archive or downgrade historical docs**

Keep `00-管理/历史整理文档` in place unless a specific file clearly belongs in `99-归档`. Update its index to say these are historical references and not current operating rules.

- [ ] **Step 2: Delete the root empty file**

Remove `2026-05-04.md` because it is empty and has no content value.

- [ ] **Step 3: Clean task-owned temporary files**

Inspect `.codex-temp`. Delete only files created during this execution. Leave unknown files in place and record them as not touched.

- [ ] **Step 4: Update final cleanup record**

In `00-管理/审查记录/2026-05-05-深度整理清单.md`, fill `最终清理记录` with deleted files, archived or downgraded historical docs, files intentionally not touched, and remaining risks.

- [ ] **Step 5: Commit cleanup**

Run:

```powershell
git add -- "99-归档/00-索引.md" "00-管理/历史整理文档/00-文件夹索引.md" "00-管理/审查记录/2026-05-05-深度整理清单.md"
git add -u -- 2026-05-04.md
git commit -m "docs: archive old guidance and clean empty notes"
```

Expected: one commit containing archive/index updates and empty file deletion.

### Task 6: Final Verification

**Files:**
- Modify: `00-管理/审查记录/2026-05-05-深度整理清单.md`

- [ ] **Step 1: Verify no empty Markdown files remain**

Run:

```powershell
Get-ChildItem -Recurse -File -Filter *.md | Where-Object { $_.Length -eq 0 } | ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length+1) }
```

Expected: no output.

- [ ] **Step 2: Verify frontmatter distribution**

Run:

```powershell
Get-ChildItem -Recurse -File -Filter *.md | Where-Object { $_.FullName -notmatch '\\.git\\|\\.obsidian\\|\\.codex-temp\\' } | Select-String -Encoding UTF8 -Pattern '^type:\s*(.+)$' | ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() } | Group-Object | Sort-Object Count -Descending | Select-Object Count,Name
```

Expected: shows known type values such as `索引`, `MOC`, `笔记`, `工作台`, and `管理`.

- [ ] **Step 3: Run Markdown diff check**

Run:

```powershell
git diff --check
```

Expected: no whitespace errors.

- [ ] **Step 4: Run final git status**

Run:

```powershell
git status --short
```

Expected: only pre-existing `.obsidian/plugins/*/data.json` runtime changes remain uncommitted.

- [ ] **Step 5: Commit verification record if changed**

Run:

```powershell
git add -- "00-管理/审查记录/2026-05-05-深度整理清单.md"
git commit -m "docs: record obsidian organization verification"
```

Expected: commit only if verification record changed after Task 5.
