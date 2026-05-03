# Obsidian 模板系统安装脚本
# 此脚本会将模板文件复制到你的 Obsidian 笔记库

$sourceDir = "e:\fun\wechat\one"
$targetDir = "E:\Obsidian\模版"

Write-Host "🚀 开始安装 Obsidian 模板系统..." -ForegroundColor Green
Write-Host ""

# 检查目标目录是否存在
if (-not (Test-Path $targetDir)) {
    Write-Host "📁 创建模板目录：$targetDir" -ForegroundColor Yellow
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
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
        Write-Host "✅ 已复制：$file" -ForegroundColor Green
        $copiedCount++
    } else {
        Write-Host "⚠️  未找到：$file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 安装完成！共复制 $copiedCount 个文件到 $targetDir" -ForegroundColor Green
Write-Host ""
Write-Host "📝 下一步操作：" -ForegroundColor Cyan
Write-Host "1. 打开 Obsidian，进入 设置 → 核心插件 → 模板" -ForegroundColor White
Write-Host "2. 设置 模板文件夹位置 为：模版" -ForegroundColor White
Write-Host "3. 设置 日期格式 为：YYYY-MM-DD" -ForegroundColor White
Write-Host "4. 设置 时间格式 为：HH:mm" -ForegroundColor White
Write-Host ""
Write-Host "💡 提示：按 Ctrl+P 打开命令面板，输入'模板：插入模板'即可使用" -ForegroundColor Yellow
Write-Host ""

# 询问是否创建推荐文件夹结构
$response = Read-Host "是否创建推荐的文件夹结构？(Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    $obsidianBase = "E:\Obsidian"
    
    $folders = @(
        "00-Inbox",
        "01-日记",
        "02-项目",
        "03-学习",
        "04-工作",
        "05-总结",
        "06-人脉",
        "07-创意",
        "99-归档"
    )
    
    foreach ($folder in $folders) {
        $folderPath = Join-Path $obsidianBase $folder
        if (-not (Test-Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
            Write-Host "✅ 已创建：$folder" -ForegroundColor Green
        } else {
            Write-Host "⏭️  已存在：$folder" -ForegroundColor Gray
        }
    }
    
    Write-Host ""
    Write-Host "🎉 文件夹结构创建完成！" -ForegroundColor Green
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
