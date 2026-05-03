@echo off
chcp 65001 >nul
echo ========================================
echo Obsidian Folder Organization
echo Date: 2026-03-29
echo ========================================
echo.

echo === Creating new folders ===
mkdir "00-管理\标签体系" 2>nul
mkdir "00-管理\审查记录" 2>nul
mkdir "30-工作\项目" 2>nul
mkdir "30-工作\会议记录" 2>nul
mkdir "30-工作\周工作总结" 2>nul
mkdir "50-生活\日记" 2>nul
mkdir "50-生活\周记" 2>nul
mkdir "50-生活\月记" 2>nul
mkdir "99-归档" 2>nul
mkdir "未分类" 2>nul
echo [OK] New folders created
echo.

echo === Moving files ===
move "技术沉淀\*" "技术笔记\" >nul 2>&1
rmdir "技术沉淀" 2>nul
echo [OK] Moved: 技术沉淀 -^> 技术笔记

move "周工作总结\*" "30-工作\周工作总结\" >nul 2>&1
rmdir "周工作总结" 2>nul
echo [OK] Moved: 周工作总结 -^> 30-工作\周工作总结

move "TODO\*" "30-工作\项目\" >nul 2>&1
rmdir "TODO" 2>nul
echo [OK] Moved: TODO -^> 30-工作\项目

move "2025-11-13.md" "50-生活\日记\" >nul 2>&1
move "2025-11-28.md" "50-生活\日记\" >nul 2>&1
move "2026-03-29.md" "50-生活\日记\" >nul 2>&1
echo [OK] Moved diary files to 50-生活\日记

move "OPC UA 智能监控中心 - 功能总结文档.md" "30-工作\项目\" >nul 2>&1
move "docker 打包整个 python 环境.md" "30-工作\项目\" >nul 2>&1
echo [OK] Moved work files to 30-工作\项目

move "sd.md" "技术笔记\" >nul 2>&1
echo [OK] Moved sd.md to 技术笔记

move "🎒Stash 临时保存.md" "未分类\" >nul 2>&1
move ".ai-reader-healthcheck.md" "未分类\" >nul 2>&1
echo [OK] Moved stash files to 未分类
echo.

echo === Cleaning temp files ===
del "未命名 1.base" 2>nul
del "未命名.base" 2>nul
echo [OK] Deleted temp files
echo.

echo === Renaming folders ===
ren "AI 学习" "20-AI 学习"
echo [OK] Renamed: AI 学习 -^> 20-AI 学习

ren "技术笔记" "10-技术笔记"
echo [OK] Renamed: 技术笔记 -^> 10-技术笔记

ren "知识库" "40-知识库"
echo [OK] Renamed: 知识库 -^> 40-知识库

ren "思维笔记" "60-思维笔记"
echo [OK] Renamed: 思维笔记 -^> 60-思维笔记

ren "数据" "70-数据资料"
echo [OK] Renamed: 数据 -^> 70-数据资料

ren "Clippings" "80-Clippings"
echo [OK] Renamed: Clippings -^> 80-Clippings

ren "Excalidraw" "90-Excalidraw"
echo [OK] Renamed: Excalidraw -^> 90-Excalidraw

ren "模版" "Templates"
echo [OK] Renamed: 模版 -^> Templates

echo.
echo ========================================
echo SUCCESS! Organization complete!
echo ========================================
echo.
echo Please restart Obsidian to see changes.
pause
