# TODO

用于记录需要 Codex 或用户后续跟进的事项。

## 待跟进

- [x] Codex 海贼王主题：2026-07-19 已完成 Store 包激活兼容修复、任务页实机注入和截图验证；当前 `9344`/watcher/`pass=true`。详见 `projects/CodexDreamSkin.md`。

- [ ] Elder Care Scoping Review Agent：初始化 git/依赖环境，并推进 M1（项目创建、PCC、纳排标准、检索式草案）。

- [ ] Obsidian：决定是否统一 `20-AI/AI日记` / `AI学习` 的 `type/status/tags` 口径，并同步更新 `00-管理/标签与属性速查.md`。
- [ ] Obsidian：完成一次真实克隆/恢复演练，并把结果写入 `00-管理/恢复演练与隐私检查.md`。

- [ ] 系统存储：2026-06-04 复查，C 盘剩余约 6.0 GB；按 E:\learn\think-2-revert\storage-check-2026-06-04\storage-report.html 先清理 Temp、updater 缓存、C:\Espressif\dist 等绿色项，预计可释放约 7.3 GB。

## 已完成

- [x] 2026-07-20：完成并全局安装可复用的 `$creating-codex-themes` Skill；已通过官方校验、契约测试、105 项 Windows 回归和逐文件哈希核验。详见 `projects/CodexDreamSkin.md`。
- [x] 初始化 Codex 持久记忆空间。
- [x] 2026-07-05：已将 Windows 计划任务 `LarkChannelBridge.Bot.codex` 调整为长期运行策略：无运行时限、错过启动后补启动、失败后每 1 分钟重启最多 999 次；验证 bridge 进程仍在运行。




- [ ] 2026-07-10：C 盘再次接近满盘（199.2 GB 总量，剩余约 430.6 MB）。优先复核清理 AppData updater/cache、C:\Espressif\dist、WSL/Trae/Kimi 应用缓存；报告见本次 Codex 输出 storage-report.html。

  - 2026-07-10 已处理：将低风险缓存/安装包移动到 F:\CDriveCleanupQuarantine\20260710-085427，C 盘空闲从约 430 MB 提升到约 9.21 GB。未处理 Windows/Program Files/pagefile/NVIDIA NGX/WSL/应用配置等高风险或需人工确认项目。
