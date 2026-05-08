# Obsidian 原生参考模板安装脚本
# 默认以当前仓库为目标；如需复制到其他 vault，可传入 -VaultRoot。

param(
    [string]$VaultRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
)

$sourceDir = $PSScriptRoot
$targetDir = Join-Path $VaultRoot "Templates\原生模板"

Write-Host "开始检查 Obsidian 原生参考模板..." -ForegroundColor Green
Write-Host ""

# 检查目标目录是否存在
if (-not (Test-Path $targetDir)) {
    Write-Host "创建模板目录：$targetDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

# 定义要复制的模板文件
$templateFiles = @(
    "📔 日记模板.md",
    "📋 会议记录模板.md",
    "📚 学习笔记模板.md",
    "🚀 项目规划模板.md",
    "📖 读书笔记模板.md",
    "📊 周工作总结模板.md",
    "📅 月度总结模板.md",
    "✅ 清单模板.md",
    "👥 人脉档案模板.md",
    "💡 灵感卡片模板.md",
    "📖 模板使用指南.md"
)

# 复制文件
$copiedCount = 0
foreach ($file in $templateFiles) {
    $sourcePath = Join-Path $sourceDir $file
    $targetPath = Join-Path $targetDir $file

    if (Test-Path $sourcePath) {
        if ((Resolve-Path $sourcePath).Path -ne (Resolve-Path $targetPath -ErrorAction SilentlyContinue).Path) {
            Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
            Write-Host "已复制：$file" -ForegroundColor Green
            $copiedCount++
        } else {
            Write-Host "已在目标目录：$file" -ForegroundColor Gray
        }
    } else {
        Write-Host "未找到：$file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "检查完成。共复制 $copiedCount 个文件到 $targetDir" -ForegroundColor Green
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Cyan
Write-Host "1. 打开 Obsidian，进入 设置 -> 核心插件 -> 模板" -ForegroundColor White
Write-Host "2. 如使用原生模板，设置模板文件夹位置为：Templates/原生模板" -ForegroundColor White
Write-Host "3. 设置 日期格式 为：YYYY-MM-DD" -ForegroundColor White
Write-Host "4. 设置 时间格式 为：HH:mm" -ForegroundColor White
Write-Host ""
Write-Host "提示：自动化模板仍维护在 SYSTEM/TEMPLATE/FORMAT，QuickAdd 和 Journals 不调用这里的原生参考模板。" -ForegroundColor Yellow
Write-Host ""

# 询问是否创建推荐文件夹结构
$response = Read-Host "是否检查并创建当前 vault 推荐的文件夹结构？(Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    $folders = @(
        "HUB\Inbox",
        "DAILY\DAILY",
        "DAILY\WEEKLY",
        "DAILY\MONTHLY",
        "30-工作\项目",
        "30-工作\会议记录",
        "ZETA\FLEETING",
        "ZETA\LITERATURE",
        "ZETA\PERMANENT",
        "70-数据资料",
        "Templates\原生模板",
        "SYSTEM\TEMPLATE\FORMAT",
        "99-归档"
    )

    foreach ($folder in $folders) {
        $folderPath = Join-Path $VaultRoot $folder
        if (-not (Test-Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
            Write-Host "已创建：$folder" -ForegroundColor Green
        } else {
            Write-Host "已存在：$folder" -ForegroundColor Gray
        }
    }

    Write-Host ""
    Write-Host "文件夹结构检查完成。" -ForegroundColor Green
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
