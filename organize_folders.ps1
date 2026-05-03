# Obsidian Folder Organizer Script
# Date: 2026-03-29

$basePath = "e:\Obsidian"
Write-Host "Starting folder organization..." -ForegroundColor Green

# Step 1: Create new folders
Write-Host "`n=== Creating new folders ===" -ForegroundColor Yellow

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
        Write-Host "[OK] Created: $folder" -ForegroundColor Green
    }
}

# Step 2: Move files
Write-Host "`n=== Moving files ===" -ForegroundColor Yellow

# Move 技术沉淀 to 技术笔记
if (Test-Path "$basePath\技术沉淀") {
    Move-Item "$basePath\技术沉淀\*" "$basePath\技术笔记\" -Force
    Remove-Item "$basePath\技术沉淀" -Force
    Write-Host "[OK] Moved: 技术沉淀 -> 技术笔记/" -ForegroundColor Green
}

# Move 周工作总结 to 30-工作
if (Test-Path "$basePath\周工作总结") {
    Move-Item "$basePath\周工作总结\*" "$basePath\30-工作\周工作总结\" -Force
    Remove-Item "$basePath\周工作总结" -Force
    Write-Host "[OK] Moved: 周工作总结 -> 30-工作/周工作总结/" -ForegroundColor Green
}

# Move TODO to 30-工作/项目
if (Test-Path "$basePath\TODO") {
    Move-Item "$basePath\TODO\*" "$basePath\30-工作\项目\" -Force
    Remove-Item "$basePath\TODO" -Force
    Write-Host "[OK] Moved: TODO -> 30-工作/项目/" -ForegroundColor Green
}

# Move diary files to 50-生活/日记
$diaryFiles = @("2025-11-13.md", "2025-11-28.md", "2026-03-29.md")
foreach ($file in $diaryFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\50-生活\日记\" -Force
        Write-Host "[OK] Moved: $file -> 50-生活/日记/" -ForegroundColor Green
    }
}

# Move work files to 30-工作/项目
$workFiles = @("OPC UA 智能监控中心 - 功能总结文档.md", "docker 打包整个 python 环境.md")
foreach ($file in $workFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\30-工作\项目\" -Force
        Write-Host "[OK] Moved: $file -> 30-工作/项目/" -ForegroundColor Green
    }
}

# Move tech files to 技术笔记
if (Test-Path "$basePath\sd.md") {
    Move-Item "$basePath\sd.md" "$basePath\技术笔记\" -Force
    Write-Host "[OK] Moved: sd.md -> 技术笔记/" -ForegroundColor Green
}

# Move stash files to 未分类
$stashFiles = @("🎒Stash 临时保存.md", ".ai-reader-healthcheck.md")
foreach ($file in $stashFiles) {
    if (Test-Path "$basePath\$file") {
        Move-Item "$basePath\$file" "$basePath\未分类\" -Force
        Write-Host "[OK] Moved: $file -> 未分类/" -ForegroundColor Green
    }
}

# Step 3: Delete temp files
Write-Host "`n=== Cleaning temp files ===" -ForegroundColor Yellow

$filesToDelete = @("未命名 1.base", "未命名.base")
foreach ($file in $filesToDelete) {
    if (Test-Path "$basePath\$file") {
        Remove-Item "$basePath\$file" -Force
        Write-Host "[OK] Deleted: $file" -ForegroundColor Green
    }
}

# Step 4: Rename folders
Write-Host "`n=== Renaming folders ===" -ForegroundColor Yellow

Rename-Item -Path "$basePath\AI 学习" -NewName "20-AI 学习" -Force
Write-Host "[OK] Renamed: AI 学习 -> 20-AI 学习" -ForegroundColor Green

Rename-Item -Path "$basePath\技术笔记" -NewName "10-技术笔记" -Force
Write-Host "[OK] Renamed: 技术笔记 -> 10-技术笔记" -ForegroundColor Green

Rename-Item -Path "$basePath\知识库" -NewName "40-知识库" -Force
Write-Host "[OK] Renamed: 知识库 -> 40-知识库" -ForegroundColor Green

Rename-Item -Path "$basePath\思维笔记" -NewName "60-思维笔记" -Force
Write-Host "[OK] Renamed: 思维笔记 -> 60-思维笔记" -ForegroundColor Green

Rename-Item -Path "$basePath\数据" -NewName "70-数据资料" -Force
Write-Host "[OK] Renamed: 数据 -> 70-数据资料" -ForegroundColor Green

Rename-Item -Path "$basePath\Clippings" -NewName "80-Clippings" -Force
Write-Host "[OK] Renamed: Clippings -> 80-Clippings" -ForegroundColor Green

Rename-Item -Path "$basePath\Excalidraw" -NewName "90-Excalidraw" -Force
Write-Host "[OK] Renamed: Excalidraw -> 90-Excalidraw" -ForegroundColor Green

Rename-Item -Path "$basePath\模版" -NewName "Templates" -Force
Write-Host "[OK] Renamed: 模版 -> Templates" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "SUCCESS! Folder organization complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green
Write-Host "Please restart Obsidian to see the changes." -ForegroundColor Cyan
