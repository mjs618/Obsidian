# Obsidian 库内杂项清理 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 安全删除 12 个已确认的低价值杂项，修复直接相关的索引和维护记录，并确保所有删除可从 Git 历史恢复。

**Architecture:** 使用一组明确列举的路径完成定点删除，不使用通配符或旧整理脚本。删除与两个原本干净的治理文件形成一个独立提交；三个已有未提交内容的留痕文件只做最小文本更新，不暂存，以免把用户原有改动一起提交。

**Tech Stack:** Obsidian Markdown、PowerShell、Git、ripgrep

---

## 文件结构

### 删除

- `.codex_hex_2026-05-06.html`
- `.codex_hex_2026-05-07.html`
- `未命名.base`
- `未命名 1.base`
- `organize.bat`
- `organize_folders.ps1`
- `整理文件夹.ps1`
- `99-归档/空白占位/.ai-reader-healthcheck.md`
- `99-归档/空白占位/2025-11-13.md`
- `99-归档/空白占位/2025-11-28.md`
- `99-归档/空白占位/2026-03-29.md`
- `99-归档/空白占位/🎒Stash临时保存.md`

### 修改并随删除提交

- `99-归档/空白占位/00-索引.md`：移除失效链接，保留清理与恢复留痕。
- `00-管理/审查记录/知识库健康检查模板.md`：将具体 Stash 检查改为通用残留检查。

### 修改但不单独暂存

以下文件已有本轮范围外的工作区内容。只做最小更新，但不运行 `git add`：

- `00-管理/审查记录/2026-07-23-均衡整理记录.md`
- `Codex/TODO.md`
- `Codex/projects/Obsidian.md`

### 保持不变

- `.gitignore`：现有 `.codex_hex_*.html` 规则已经正确。
- `00-管理/历史整理文档/*`：其中的脚本名称属于真实历史记录。
- `.obsidian/*`：本轮不修改插件或界面配置。

---

### Task 1: 建立删除前安全基线

**Files:**
- Inspect: 12 个删除目标
- Inspect: `.gitignore`
- Inspect: `00-管理/审查记录/2026-07-23-均衡整理记录.md`
- Inspect: `Codex/TODO.md`
- Inspect: `Codex/projects/Obsidian.md`

- [ ] **Step 1: 确认暂存区为空**

Run:

```powershell
$stagedPaths = @(git diff --cached --name-only)
if ($stagedPaths.Count -ne 0) {
    $stagedPaths
    throw "暂存区已有内容，停止执行以避免混入用户改动。"
}
"STAGING_BASELINE_OK"
```

Expected:

```text
STAGING_BASELINE_OK
```

- [ ] **Step 2: 确认 12 个目标文件全部存在**

Run:

```powershell
$cleanupTargets = @(
    '.codex_hex_2026-05-06.html',
    '.codex_hex_2026-05-07.html',
    '未命名.base',
    '未命名 1.base',
    'organize.bat',
    'organize_folders.ps1',
    '整理文件夹.ps1',
    '99-归档/空白占位/.ai-reader-healthcheck.md',
    '99-归档/空白占位/2025-11-13.md',
    '99-归档/空白占位/2025-11-28.md',
    '99-归档/空白占位/2026-03-29.md',
    '99-归档/空白占位/🎒Stash临时保存.md'
)
$missingTargets = @($cleanupTargets | Where-Object { -not (Test-Path -LiteralPath $_) })
if ($missingTargets.Count -ne 0) {
    $missingTargets
    throw "删除目标与设计不一致，停止执行。"
}
"TARGET_BASELINE_OK:$($cleanupTargets.Count)"
```

Expected:

```text
TARGET_BASELINE_OK:12
```

- [ ] **Step 3: 确认 12 个文件都已由 Git 跟踪**

Run:

```powershell
$trackedTargets = @(git ls-files -- $cleanupTargets)
if ($trackedTargets.Count -ne 12) {
    $trackedTargets
    throw "存在无法通过 Git 历史恢复的目标，停止执行。"
}
"TRACKING_BASELINE_OK:$($trackedTargets.Count)"
```

Expected:

```text
TRACKING_BASELINE_OK:12
```

- [ ] **Step 4: 确认两个 Base 是相同空壳**

Run:

```powershell
$baseHashA = (Get-FileHash -Algorithm SHA256 -LiteralPath '未命名.base').Hash
$baseHashB = (Get-FileHash -Algorithm SHA256 -LiteralPath '未命名 1.base').Hash
if ($baseHashA -ne $baseHashB) {
    throw "两个 Base 内容不再相同，停止执行。"
}
Get-Content -Raw -Encoding UTF8 -LiteralPath '未命名.base'
```

Expected:

```text
views:
  - type: table
    name: 表格
```

- [ ] **Step 5: 确认 HTML 忽略规则有效**

Run:

```powershell
git check-ignore --no-index -v -- '.codex_hex_2026-05-06.html' '.codex_hex_2026-05-07.html'
```

Expected: 两行都由 `.gitignore` 中的 `.codex_hex_*.html` 规则命中。

- [ ] **Step 6: 记录三个重叠留痕文件的现有状态**

Run:

```powershell
git status --short -- `
  '00-管理/审查记录/2026-07-23-均衡整理记录.md' `
  'Codex/TODO.md' `
  'Codex/projects/Obsidian.md'
```

Expected:

```text
?? 00-管理/审查记录/2026-07-23-均衡整理记录.md
 M Codex/TODO.md
 M Codex/projects/Obsidian.md
```

- [ ] **Step 7: 确认两个随删除提交的治理文件原本干净**

Run:

```powershell
$cleanBoundaryPaths = @(
    '99-归档/空白占位/00-索引.md',
    '00-管理/审查记录/知识库健康检查模板.md'
)
$dirtyBoundaryPaths = @(git status --porcelain=v1 -- $cleanBoundaryPaths)
if ($dirtyBoundaryPaths.Count -ne 0) {
    $dirtyBoundaryPaths
    throw "计划单独提交的治理文件已有改动，停止执行。"
}
"CLEAN_COMMIT_BOUNDARY_OK:$($cleanBoundaryPaths.Count)"
```

Expected:

```text
CLEAN_COMMIT_BOUNDARY_OK:2
```

---

### Task 2: 定点删除 12 个杂项

**Files:**
- Delete: 12 个已验证目标

- [ ] **Step 1: 使用明确路径删除已跟踪文件**

Run:

```powershell
git rm -- `
  '.codex_hex_2026-05-06.html' `
  '.codex_hex_2026-05-07.html' `
  '未命名.base' `
  '未命名 1.base' `
  'organize.bat' `
  'organize_folders.ps1' `
  '整理文件夹.ps1' `
  '99-归档/空白占位/.ai-reader-healthcheck.md' `
  '99-归档/空白占位/2025-11-13.md' `
  '99-归档/空白占位/2025-11-28.md' `
  '99-归档/空白占位/2026-03-29.md' `
  '99-归档/空白占位/🎒Stash临时保存.md'
```

Expected: Git 输出 12 行 `rm`，每行对应一个设计内目标。

- [ ] **Step 2: 验证 12 个文件均已消失**

Run:

```powershell
$remainingTargets = @($cleanupTargets | Where-Object { Test-Path -LiteralPath $_ })
if ($remainingTargets.Count -ne 0) {
    $remainingTargets
    throw "仍有目标文件未删除。"
}
"REMOVAL_OK:$($cleanupTargets.Count)"
```

Expected:

```text
REMOVAL_OK:12
```

- [ ] **Step 3: 验证 Git 仅将这些目标标记为删除**

Run:

```powershell
git diff --cached --name-status
```

Expected: 恰好 12 行，状态均为 `D`，路径与删除清单完全一致。

---

### Task 3: 修复索引与健康检查模板

**Files:**
- Modify: `99-归档/空白占位/00-索引.md`
- Modify: `00-管理/审查记录/知识库健康检查模板.md`

- [ ] **Step 1: 将空白占位索引改为清理留痕**

Replace the complete content of `99-归档/空白占位/00-索引.md` with:

```markdown
---
type: 索引
domain: 归档
status: 已完成
tags:
  - 状态/归档
  - 类型/汇总
---

# 空白占位索引

本目录曾用于隔离低价值、空白或工具残留文件，避免在未确认前直接删除。

## 当前状态

2026-07-23 已完成清理，当前没有待处理的空白占位文件。

本次删除：

- 3 个空白日记占位。
- 1 个 Stash 临时文件。
- 1 个 AI Reader 健康检查残留。

所有删除内容仍保留在清理前的 Git 历史中。需要恢复时，只取回指定文件，不回滚整个知识库。

## 后续规则

- 新的空白笔记先确认是否误建，再决定补写或删除。
- 工具健康检查残留不进入长期知识区。
- 不确定是否有价值的内容先隔离并记录来源，不直接删除。
```

- [ ] **Step 2: 将过期的 Stash 检查改为通用检查**

In `00-管理/审查记录/知识库健康检查模板.md`, replace:

```markdown
- [ ] 检查 `🎒Stash临时保存.md` 是否需要处理。
```

with:

```markdown
- [ ] 检查归档区是否出现新的空白占位或工具残留。
```

- [ ] **Step 3: 验证索引不再包含失效链接**

Run:

```powershell
rg -n "2025-11-13|2025-11-28|2026-03-29|Stash临时保存|ai-reader-healthcheck" -- '99-归档/空白占位/00-索引.md'
```

Expected: 无输出，退出码为 1。

- [ ] **Step 4: 验证模板已使用通用检查**

Run:

```powershell
rg -n "检查归档区是否出现新的空白占位或工具残留" -- '00-管理/审查记录/知识库健康检查模板.md'
```

Expected: 输出一行新的检查项。

- [ ] **Step 5: 验证 Markdown 差异没有空白错误**

Run:

```powershell
git diff --check -- `
  '99-归档/空白占位/00-索引.md' `
  '00-管理/审查记录/知识库健康检查模板.md'
```

Expected: 无输出，退出码为 0。

- [ ] **Step 6: 暂存两个原本干净的治理文件**

Run:

```powershell
git add -- `
  '99-归档/空白占位/00-索引.md' `
  '00-管理/审查记录/知识库健康检查模板.md'
```

- [ ] **Step 7: 核对待提交边界**

Run:

```powershell
$expectedCommittedPaths = @(
    '.codex_hex_2026-05-06.html',
    '.codex_hex_2026-05-07.html',
    '未命名.base',
    '未命名 1.base',
    'organize.bat',
    'organize_folders.ps1',
    '整理文件夹.ps1',
    '99-归档/空白占位/.ai-reader-healthcheck.md',
    '99-归档/空白占位/00-索引.md',
    '99-归档/空白占位/2025-11-13.md',
    '99-归档/空白占位/2025-11-28.md',
    '99-归档/空白占位/2026-03-29.md',
    '99-归档/空白占位/🎒Stash临时保存.md',
    '00-管理/审查记录/知识库健康检查模板.md'
)
$actualCommittedPaths = @(git diff --cached --name-only)
$unexpectedPaths = @($actualCommittedPaths | Where-Object { $_ -notin $expectedCommittedPaths })
$missingPaths = @($expectedCommittedPaths | Where-Object { $_ -notin $actualCommittedPaths })
if ($unexpectedPaths.Count -ne 0 -or $missingPaths.Count -ne 0) {
    [pscustomobject]@{
        Unexpected = $unexpectedPaths
        Missing = $missingPaths
    }
    throw "暂存边界与设计不一致。"
}
"STAGING_SCOPE_OK:$($actualCommittedPaths.Count)"
```

Expected:

```text
STAGING_SCOPE_OK:14
```

- [ ] **Step 8: 提交删除和直接索引修复**

Run:

```powershell
git commit -m "chore: remove obsolete Obsidian leftovers"
```

Expected: 提交成功，包含 12 个删除和 2 个治理文件修改。

---

### Task 4: 更新审查记录和持久记忆

**Files:**
- Modify: `00-管理/审查记录/2026-07-23-均衡整理记录.md`
- Modify: `Codex/TODO.md`
- Modify: `Codex/projects/Obsidian.md`

- [ ] **Step 1: 更新均衡整理记录的完成项**

In `00-管理/审查记录/2026-07-23-均衡整理记录.md`, replace:

```markdown
- 未移动、重命名或删除文件，未修改 `.obsidian`。
```

with:

```markdown
- 经用户确认后，可恢复删除 12 个低价值杂项；未移动或重命名其他文件，未修改 `.obsidian`。
```

Then remove these two resolved items from `## 延期项`:

```markdown
- 根目录两个未命名 Base、两个历史 HTML 和旧整理脚本：未确认用途前不移动或删除。
- `99-归档/空白占位`：删除前仍需人工确认留痕价值。
```

The remaining `## 延期项` section must contain only:

```markdown
- AI 提示词库 116 篇缺 `domain`：需要单独制定受控字段口径后再分批处理。
```

- [ ] **Step 2: 将 TODO 收敛到真实恢复演练**

In `Codex/TODO.md`, replace:

```markdown
- [ ] Obsidian：确认是否把已跟踪的 `.codex_hex_2026-05-06.html`、`.codex_hex_2026-05-07.html` 从 Git 索引移除，并补一次真实恢复演练记录。
```

with:

```markdown
- [ ] Obsidian：完成一次真实克隆/恢复演练，并把结果写入 `00-管理/恢复演练与隐私检查.md`。
```

- [ ] **Step 3: 更新 Obsidian 项目记忆**

Under `Codex/projects/Obsidian.md` → `## 2026-07-23`, append:

```markdown
- 经用户确认采用“可恢复删除”：清理 2 个空 Base、2 个已忽略但仍被跟踪的 HTML 快照、3 个旧整理脚本和 5 个空白占位；删除内容仍可从 Git 历史恢复。
```

Do not rewrite the older dated sections; their references describe the state at those historical checkpoints.

- [ ] **Step 4: 验证三个文件的目标文本**

Run:

```powershell
rg -n "可恢复删除 12 个低价值杂项|AI 提示词库 116 篇缺" -- '00-管理/审查记录/2026-07-23-均衡整理记录.md'
rg -n "完成一次真实克隆/恢复演练" -- 'Codex/TODO.md'
rg -n "经用户确认采用“可恢复删除”" -- 'Codex/projects/Obsidian.md'
```

Expected: 三条命令都能找到各自的新文本。

- [ ] **Step 5: 验证重叠文件格式但不暂存**

Run:

```powershell
git diff --check -- 'Codex/TODO.md' 'Codex/projects/Obsidian.md'
git status --short -- `
  '00-管理/审查记录/2026-07-23-均衡整理记录.md' `
  'Codex/TODO.md' `
  'Codex/projects/Obsidian.md'
```

Expected:

```text
?? 00-管理/审查记录/2026-07-23-均衡整理记录.md
 M Codex/TODO.md
 M Codex/projects/Obsidian.md
```

Do not run `git add` for these three files. Their pre-existing changes belong to the broader current worktree.

---

### Task 5: 完成全量验证

**Files:**
- Verify: 12 个删除目标
- Verify: 5 个直接相关留痕文件
- Verify: `.gitignore`

- [ ] **Step 1: 再次确认 12 个目标全部不存在**

Run:

```powershell
$remainingTargets = @($cleanupTargets | Where-Object { Test-Path -LiteralPath $_ })
if ($remainingTargets.Count -ne 0) {
    $remainingTargets
    throw "清理后仍有目标文件存在。"
}
"FINAL_REMOVAL_OK:$($cleanupTargets.Count)"
```

Expected:

```text
FINAL_REMOVAL_OK:12
```

- [ ] **Step 2: 确认删除提交可用于恢复**

Run:

```powershell
git show --name-status --format=oneline -1
```

Expected: 最新提交为 `chore: remove obsolete Obsidian leftovers`，并列出 12 个删除与 2 个治理文件修改。

- [ ] **Step 3: 确认 HTML 忽略规则仍然生效**

Run:

```powershell
git check-ignore --no-index -v -- '.codex_hex_2026-05-06.html' '.codex_hex_2026-05-07.html'
```

Expected: 两个路径仍由 `.gitignore` 中的 `.codex_hex_*.html` 命中。

- [ ] **Step 4: 检查现行导航和任务没有失效引用**

Run:

```powershell
rg -n "\[\[(99-归档/空白占位/)?(2025-11-13|2025-11-28|2026-03-29|🎒Stash临时保存)" -- `
  '99-归档/空白占位/00-索引.md' `
  '00-管理/审查记录/知识库健康检查模板.md' `
  '00-管理/审查记录/2026-07-23-均衡整理记录.md' `
  'Codex/TODO.md'
```

Expected: 无输出，退出码为 1。

- [ ] **Step 5: 检查所有本轮 Markdown 更新**

Run:

```powershell
git diff --check -- `
  '00-管理/审查记录/2026-07-23-均衡整理记录.md' `
  'Codex/TODO.md' `
  'Codex/projects/Obsidian.md'
```

Expected: 无输出，退出码为 0。

- [ ] **Step 6: 核对最终工作区边界**

Run:

```powershell
git status --short
```

Expected:

- 12 个删除目标和两个已提交治理文件不再出现在工作区状态中。
- `00-管理/审查记录/2026-07-23-均衡整理记录.md`、`Codex/TODO.md`、`Codex/projects/Obsidian.md` 保持未暂存状态。
- 其他进入本轮前就存在的工作区改动保持原状。
