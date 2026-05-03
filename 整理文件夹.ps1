# ========================================
# Obsidian 文件夹整理脚本
# 执行时间：2026-03-29
# ========================================

$basePath = "e:\Obsidian"
Write-Host "开始整理 Obsidian 文件夹..." -ForegroundColor Green
Write-Host "基础路径：$basePath" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 第 1 步：创建新文件夹
# ========================================
Write-Host "=== 第 1 步：创建新文件夹 ===" -ForegroundColor Yellow

$newFolders = @(
    "00-管理\标签体系",
    "00-管理\审查记录",
    "30-工作\项目",
    "30-工作\会议记录",
    "30-工作\周工作总结",
    "50-生活\日记",
    "50-生活\周记",
    "50-生活\月记",
    "99-归档",
    "未分类"
)

foreach ($folder in $newFolders) {
    $fullPath = Join-Path $basePath $folder
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "✓ 创建：$folder" -ForegroundColor Green
    } else {
        Write-Host "✓ 已存在：$folder" -ForegroundColor Gray
    }
}

Write-Host ""

# ========================================
# 第 2 步：移动文件
# ========================================
Write-Host "=== 第 2 步：移动文件和文件夹 ===" -ForegroundColor Yellow

# 移动技术沉淀到技术笔记
if (Test-Path "$basePath\技术沉淀") {
    Move-Item "$basePath\技术沉淀\*" "$basePath\技术笔记\" -Force
    Remove-Item "$basePath\技术沉淀" -Force
    Write-Host "✓ 移动：技术沉淀 → 技术笔记/" -ForegroundColor Green
}

# 移动周工作总结到 30-工作
if (Test-Path "$basePath\周工作总结") {
    Move-Item "$basePath\周工作总结\*" "$basePath\30-工作\周工作总结\" -Force
    Remove-Item "$basePath\周工作总结" -Force
    Write-Host "✓ 移动：周工作总结 → 30-工作/周工作总结/" -ForegroundColor Green
}

# 移动 TODO 到 30-工作/项目
if (Test-Path "$basePath\TODO") {
    Move-Item "$basePath\TODO\*" "$basePath\30-工作\项目\" -Force
    Remove-Item "$basePath\TODO" -Force
    Write-Host "✓ 移动：TODO → 30-工作/项目/" -ForegroundColor Green
}

# 移动根目录的日记文件到 50-生活/日记
$diaryFiles = @(
    "2025-11-13.md",
    "2025-11-28.md",
    "2026-03-29.md"
)

foreach ($file in $diaryFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\50-生活\日记\" -Force
        Write-Host "✓ 移动：$file → 50-生活/日记/" -ForegroundColor Green
    }
}

# 移动 OPC UA 相关文件到工作项目
$workFiles = @(
    "OPC UA 智能监控中心 - 功能总结文档.md",
    "docker 打包整个 python 环境.md"
)

foreach ($file in $workFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\30-工作\项目\" -Force
        Write-Host "✓ 移动：$file → 30-工作/项目/" -ForegroundColor Green
    }
}

# 移动技术相关到技术笔记
$techFiles = @(
    "sd.md"
)

foreach ($file in $techFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\技术笔记\" -Force
        Write-Host "✓ 移动：$file → 技术笔记/" -ForegroundColor Green
    }
}

# 移动临时文件到未分类
$stashFiles = @(
    "🎒Stash 临时保存.md",
    ".ai-reader-healthcheck.md"
)

foreach ($file in $stashFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\未分类\" -Force
        Write-Host "✓ 移动：$file → 未分类/" -ForegroundColor Green
    }
}

Write-Host ""

# ========================================
# 第 3 步：清理临时文件
# ========================================
Write-Host "=== 第 3 步：清理临时文件 ===" -ForegroundColor Yellow

$filesToDelete = @(
    "未命名 1.base",
    "未命名.base"
)

foreach ($file in $filesToDelete) {
    if (Test-Path "$basePath\$file") {
        Remove-Item "$basePath\$file" -Force
        Write-Host "✓ 删除：$file" -ForegroundColor Green
    }
}

Write-Host ""

# ========================================
# 第 4 步：重命名文件夹
# ========================================
Write-Host "=== 第 4 步：重命名文件夹 ===" -ForegroundColor Yellow

$renameMap = @{
    "AI 学习" = "20-AI 学习"
    "技术笔记" = "10-技术笔记"
    "知识库" = "40-知识库"
    "思维笔记" = "60-思维笔记"
    "数据" = "70-数据资料"
    "Clippings" = "80-Clippings"
    "Excalidraw" = "90-Excalidraw"
    "模版" = "Templates"
}

foreach ($oldName in $renameMap.Keys) {
    $oldPath = Join-Path $basePath $oldName
    $newName = $renameMap[$oldName]
    $newPath = Join-Path $basePath $newName
    
    if (Test-Path $oldPath) {
        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $oldPath -NewName $newName -Force
            Write-Host "✓ 重命名：$oldName → $newName" -ForegroundColor Green
        } else {
            Write-Host "⚠ 目标已存在：$newName" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠ 源文件夹不存在：$oldName" -ForegroundColor Yellow
    }
}

Write-Host ""

# ========================================
# 第 5 步：更新 Templates 文件夹
# ========================================
Write-Host "=== 第 5 步：整理 Templates 文件夹 ===" -ForegroundColor Yellow

# 移动标签体系审查清单到 Templates 根目录
if (Test-Path "$basePath\Templates\标签体系审查清单.md") {
    # 已经在正确位置
    Write-Host "✓ 标签体系审查清单已在 Templates/" -ForegroundColor Green
}

# 确保 Templater 子文件夹存在
$templaterPath = "$basePath\Templates\Templater"
if (-not (Test-Path $templaterPath)) {
    New-Item -ItemType Directory -Path $templaterPath -Force | Out-Null
    Write-Host "✓ 创建：Templates/Templater/" -ForegroundColor Green
}

Write-Host ""

# ========================================
# 第 6 步：创建文件夹说明文件
# ========================================
Write-Host "=== 第 6 步：创建文件夹说明 ===" -ForegroundColor Yellow

$readmeContent = @"
# 📁 Obsidian 文件夹结构

> 最后更新：2026-03-29

---

## 🏗️ 文件夹结构

\`\`\`
Obsidian/
├── 00-管理/                    # 管理系统（标签、配置等）
├── 10-技术笔记/                # 技术学习内容
├── 20-AI 学习/                 # AI 学习相关内容
├── 30-工作/                    # 工作项目、会议、总结
│   ├── 项目/
│   ├── 会议记录/
│   └── 周工作总结/
├── 40-知识库/                  # 结构化知识
├── 50-生活/                    # 生活记录
│   ├── 日记/
│   ├── 周记/
│   └── 月记/
├── 60-思维笔记/                # 认知思维、学习
├── 70-数据资料/                # 数据、量表
├── 80-Clippings/               # 文章剪藏
├── 90-Excalidraw/              # 绘图文件
├── 99-归档/                    # 历史归档
├── Templates/                  # 模板库
│   └── Templater/
└── 未分类/                     # 临时存放（定期清理）
\`\`\`

---

## 📋 文件夹说明

| 文件夹 | 用途 | 推荐标签 |
|--------|------|----------|
| 00-管理/ | 管理系统文档 | \`#领域/知识 #重要\` |
| 10-技术笔记/ | 技术学习 | \`#领域/技术 #类型/笔记\` |
| 20-AI 学习/ | AI 学习 | \`#领域/AI #类型/文章\` |
| 30-工作/ | 工作项目 | \`#领域/工作 #类型/项目\` |
| 40-知识库/ | 核心知识 | \`#领域/知识 #重要\` |
| 50-生活/ | 生活记录 | \`#领域/生活 #类型/汇总\` |
| 60-思维笔记/ | 思考学习 | \`#领域/思维 #类型/笔记\` |
| 70-数据资料/ | 数据参考 | \`#类型/资源\` |
| 80-Clippings/ | 文章剪藏 | \`#类型/文章\` |
| 90-Excalidraw/ | 绘图文件 | \`#类型/卡片\` |
| Templates/ | 模板文件 | \`#类型/模板\` |
| 99-归档/ | 历史归档 | \`#状态/归档\` |

---

## 🔗 相关文档

- [[00-标签体系使用指南]]
- [[00-推荐文件夹结构]]
- [[标签仪表盘]]

---

**整理完成时间**: 2026-03-29
"@

$readmePath = Join-Path $basePath "FOLDER_README.md"
$readmeContent | Out-File -FilePath $readmePath -Encoding utf8
Write-Host "✓ 创建：FOLDER_README.md" -ForegroundColor Green

Write-Host ""

# ========================================
# 完成
# ========================================
Write-Host "========================================" -ForegroundColor Green
Write-Host "✨ 文件夹整理完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "请重启 Obsidian 以查看更新后的结构。" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步建议：" -ForegroundColor Yellow
Write-Host "1. 重启 Obsidian" -ForegroundColor White
Write-Host "2. 查看 FOLDER_README.md 了解新结构" -ForegroundColor White
Write-Host "3. 为文件批量添加标签" -ForegroundColor White
Write-Host "4. 使用标签仪表盘查看整理效果" -ForegroundColor White
Write-Host ""
