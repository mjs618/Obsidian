# Obsidian Governance Phase 1 Design

## Goal

Stabilize the Obsidian vault as a usable knowledge management system without moving or renaming existing notes. This phase focuses on discoverability, maintenance routines, configuration guidance, and safe Git synchronization.

## Scope

This phase will:

- Improve the vault entry points with a practical `README.md` and section indexes.
- Add management documentation under `00-管理`.
- Standardize documented rules for folders, tags, frontmatter, links, archives, and review cadence.
- Record current plugin/configuration gaps for Templater, Dataview, Excalidraw, and Obsidian Git.
- Add a repeatable health-check checklist for future maintenance.
- Update `.gitignore` for local Obsidian noise and generated artifacts.

This phase will not:

- Move, rename, merge, or delete existing notes or folders.
- Merge `AI日记` and `AI学习` into `20-AI`.
- Merge `Templates` and `模版`.
- Rewrite long-form note content.
- Install plugins or change Obsidian UI settings directly.
- Run `git commit`, `git push`, or any external synchronization action during implementation unless explicitly requested later.

## Existing Context

The vault already has a numbered folder structure:

- `00-管理`
- `10-技术笔记`
- `30-工作`
- `40-知识库`
- `50-生活`
- `60-思维笔记`
- `70-数据资料`
- `80-Clippings`
- `90-Excalidraw`
- `99-归档`

It also has active parallel areas:

- `AI学习`
- `AI日记`
- `Templates`
- `模版`
- `未分类`

The current issue is not absence of structure; it is that governance documents, templates, plugin expectations, indexes, and daily usage rules are not consistently connected to the actual notes.

## Deliverables

### Vault Entry

Update `README.md` into a concise vault home page with:

- Purpose of the vault.
- Main folder map.
- Daily/weekly/monthly maintenance entry points.
- Links to management documents and dashboards.
- Clear warning that phase 1 does not migrate files.

### Section Indexes

Create lightweight `00-索引.md` files where missing:

- `10-技术笔记/00-索引.md`
- `30-工作/00-索引.md`
- `40-知识库/00-索引.md`
- `50-生活/00-索引.md`
- `60-思维笔记/00-索引.md`
- `70-数据资料/00-索引.md`
- `80-Clippings/00-索引.md`
- `90-Excalidraw/00-索引.md`
- `未分类/00-索引.md`

Existing `AI日记/00-索引.md` will not be overwritten unless a small consistency note is needed.

Each index should be manually maintainable and useful even without Dataview. If Dataview snippets are included, they must be optional and clearly marked.

### Management Documents

Add documents under `00-管理`:

- `00-管理/00-管理索引.md`
- `00-管理/知识库治理规范.md`
- `00-管理/定期维护清单.md`
- `00-管理/插件与同步配置说明.md`

These files should consolidate practical rules instead of duplicating all existing `00-*` root documents.

### Health Check

Add a repeatable checklist under `00-管理/审查记录` or `Templates` that covers:

- Empty notes.
- Notes without tags/frontmatter.
- Orphan candidates.
- Dead-end notes.
- Broken or unresolved wiki links.
- Large embedded assets.
- Root-level clutter.
- Git status before and after structural work.
- Plugin/template mismatch.

### Git Hygiene

Update `.gitignore` conservatively for local/editor noise while preserving useful vault files. Suggested ignores:

- OS/editor temporary files.
- Obsidian cache/workspace churn if appropriate.
- Generated local reports if introduced.

Do not ignore content directories, markdown notes, images, or plugin manifests by default.

## Data Rules

### Frontmatter

New governance and index notes should use a small consistent frontmatter block:

```yaml
---
type: 管理
domain: 知识管理
status: 进行中
tags:
  - 领域/知识
  - 类型/汇总
---
```

For section indexes, `type` can be `索引`.

### Links

Use Obsidian wiki links for internal navigation. Prefer links to existing files. Avoid introducing fake links solely for future ideas unless they are clearly marked as planned.

### Tags

Keep the current multidimensional tag system:

- `领域/*`
- `类型/*`
- `状态/*`
- priority/action tags such as `重要`, `待整理`, `待复习`

Do not create a competing tag taxonomy in this phase.

## Implementation Boundaries

All changes should be plain Markdown or `.gitignore` edits. No scripts should modify user notes in bulk. No destructive commands should be used. If a future migration is needed, it should be a separate phase with explicit approval.

## Verification

After implementation:

- Confirm expected new files exist.
- Confirm no existing content files were moved or deleted.
- Run a lightweight scan for Markdown count, empty files, and major folder indexes.
- Check `git status --short` and distinguish new governance files from pre-existing vault changes.

## Open Decisions For Later Phases

- Whether to create `20-AI` and migrate `AI学习` plus `AI日记`.
- Whether to merge `Templates` and `模版`.
- Whether to install or enable Dataview and Templater.
- Whether to convert long clippings into atomic notes and topic cards.
- Whether to commit the current large folder reorganization as a Git baseline.
