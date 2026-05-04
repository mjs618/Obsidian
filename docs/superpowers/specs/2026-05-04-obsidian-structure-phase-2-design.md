# Obsidian Structure Phase 2 Design

## Goal

Complete the second-stage vault structure migration now that the Git baseline is clean. This phase consolidates the parallel AI and template areas, moves root-level management documents into `00-管理`, updates navigation, and aligns the AI diary automation with the final path.

## Scope

This phase will:

- Create `20-AI` as the unified AI area.
- Move `AI学习` into `20-AI/AI学习`.
- Move `AI日记` into `20-AI/AI日记`.
- Create a new `20-AI/00-索引.md`.
- Update the AI diary automation to write only to `E:\Obsidian\20-AI\AI日记`.
- Keep `Templates` as the standard template root.
- Move `模版` into `Templates/原生模板`.
- Update template indexes and plugin notes.
- Move root-level `00-*` management and historical organization documents into `00-管理/历史整理文档`.
- Update README, management indexes, and affected wiki links.
- Use Git-aware moves where possible so history is preserved.
- Commit the migration locally without pushing.

This phase will not:

- Rewrite long-form note content.
- Delete empty notes.
- Extract base64 images or reorganize attachments.
- Install or enable Obsidian plugins.
- Change Obsidian UI settings directly.
- Push to remote.

## Target Structure

After this phase, the top level should be closer to:

```text
00-管理/
10-技术笔记/
20-AI/
30-工作/
40-知识库/
50-生活/
60-思维笔记/
70-数据资料/
80-Clippings/
90-Excalidraw/
99-归档/
Templates/
docs/
未分类/
README.md
```

`20-AI` should contain:

```text
20-AI/
  00-索引.md
  AI学习/
  AI日记/
```

`Templates` should contain:

```text
Templates/
  00-索引.md
  Templater/
  原生模板/
  标签体系审查清单.md
```

`00-管理` should contain:

```text
00-管理/
  00-管理索引.md
  历史整理文档/
  审查记录/
  标签体系/
  定期维护清单.md
  插件与同步配置说明.md
  知识库治理规范.md
```

## Migration Rules

### AI

Move existing content without changing note bodies first:

- `AI学习` -> `20-AI/AI学习`
- `AI日记` -> `20-AI/AI日记`

Then update affected links:

- `[[AI学习/00-索引]]` -> `[[20-AI/AI学习/00-索引]]`
- `[[AI日记/00-索引]]` -> `[[20-AI/AI日记/00-索引]]`
- Any AI diary topic links should stay relative by basename where they already resolve, or use the new full path when needed.

The AI diary automation should no longer fall back to the old `E:\Obsidian\AI日记` path after the migration. Its project directory should be fixed to `E:\Obsidian\20-AI\AI日记`.

### Templates

Keep `Templates` as the template root because it already contains Templater-specific material.

Move:

- `模版` -> `Templates/原生模板`

Then update:

- `Templates/00-索引.md`
- links that reference `模版/00-索引`
- plugin notes explaining that `Templates/原生模板` contains Obsidian-native-style templates.

### Root Management Documents

Move root-level management documents into:

- `00-管理/历史整理文档`

Candidate files:

- `00-DailyNotes 自动标签配置指南.md`
- `00-批量添加标签指南.md`
- `00-推荐文件夹结构.md`
- `00-整理完成总结.md`
- `00-文件夹整理计划.md`
- `00-文件夹索引.md`
- `00-标签体系使用指南.md`
- `00-标签体系快速入门.md`
- `00-标签体系配置总结.md`
- `00-标签增强插件配置指南.md`
- `00-标签速查卡片.md`

Do not move `标签仪表盘.md` in this phase unless doing so is required for consistency. It can remain a high-level dashboard at the root.

## Link Strategy

Use full vault-relative wiki links for cross-folder navigation. Prefer exact file paths for indexes and management documents.

After migration, run a targeted link scan over:

- `README.md`
- `00-管理/**/*.md`
- `20-AI/**/*.md`
- `Templates/**/*.md`
- all `00-索引.md` files

Fix broken links introduced by the migration. Pre-existing unresolved links inside research notes or templates can be left alone if unrelated.

## Automation Update

Update the existing `ai` automation:

- Project directory: `E:\Obsidian\20-AI\AI日记`
- Remove old-directory fallback language.
- Continue writing daily notes under `YYYY\MM\YYYY-MM-DD.md`.
- Continue writing `00-索引.md`, `Sources`, and `Topics` under `20-AI\AI日记`.
- Keep the rule that it does not run `git commit` or `git push`.

## Verification

After migration:

- `git status --short` should show only expected moves and edits before commit.
- Top-level `AI学习`, `AI日记`, and `模版` should no longer exist.
- `20-AI/AI学习`, `20-AI/AI日记`, and `Templates/原生模板` should exist.
- Root-level `00-*` management documents should live under `00-管理/历史整理文档`.
- New/updated indexes should have no newly introduced unresolved links.
- Local commit should be created.
- No push should be performed.

## Deferred Work

The following remain for later phases:

- Delete or fill empty notes.
- Extract embedded base64 assets from `10-技术笔记/sd.md`.
- Install or configure Dataview and Templater.
- Split long clippings into summary and atomic notes.
- Clean up root-level scripts and decide whether they belong under `00-管理`.
