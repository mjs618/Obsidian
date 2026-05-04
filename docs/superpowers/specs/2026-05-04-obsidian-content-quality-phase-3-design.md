# Obsidian Content Quality Phase 3 Design

## Goal

Phase 3 improves day-to-day vault quality after the structure migration. The scope is deliberately small: reduce root-level noise, make empty placeholders explicit, clear tool-generated residue from the inbox, and align key entry files with the governance rules.

## Scope

This phase changes organization and metadata only. It does not rewrite note bodies, delete user notes, install plugins, or change Obsidian app settings.

Included:

- Move root-level technical note `docker打包整个python环境.md` into `10-技术笔记/`.
- Move empty placeholder files into `99-归档/空白占位/`.
- Move `未分类/.ai-reader-healthcheck.md` into the same archive area as tool residue.
- Add an archive index for blank placeholders and tool residue.
- Update affected indexes: `未分类/00-索引.md`, `50-生活/00-索引.md`, `99-归档/00-索引.md`, `10-技术笔记/00-索引.md`.
- Add frontmatter to key entry files that still lack it: `README.md`, `标签仪表盘.md`, `20-AI/AI日记/00-索引.md`.

Excluded:

- Bulk frontmatter insertion across old notes.
- Deleting empty notes.
- Rewriting legacy historical documents.
- Resolving conceptual topic links inside AI learning notes.
- Enabling Dataview or Templater.

## Design

The archive path is `99-归档/空白占位/`. It is intentionally separate from active topic folders so empty notes and generated residue remain visible but no longer pollute daily navigation. The archive index records why files are there and what decision remains open.

The root directory should only contain vault-level entry files. After this phase, `README.md` and `标签仪表盘.md` remain at root; the Docker note moves into the technical notes section.

Indexes remain manually maintained. This matches the current plugin state: Dataview syntax exists in some files, but Dataview is not installed and should not be required for daily navigation.

## Verification

Verification for this phase checks:

- Old root technical note path no longer exists.
- Archive placeholder directory exists and contains the moved empty/residue files.
- `未分类` contains only its index unless new user content appears during execution.
- Core navigation links resolve for updated entry/index files.
- Git status is reviewed before commit.

