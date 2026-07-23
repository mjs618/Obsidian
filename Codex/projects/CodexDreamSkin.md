# Codex Dream Skin

## 2026-07-20：可复用主题创建 Skill

- 已完成并全局安装 Skill `creating-codex-themes`；源码位于 `C:\Users\Administrator\Documents\Codex\2026-07-16\fei-away-codex-dream-skin-https\work\repo\skills\creating-codex-themes`，安装位置为 `C:\Users\Administrator\.codex\skills\creating-codex-themes`。
- 后续可通过 `$creating-codex-themes` 创建其他 Codex Dream Skin 主题；工作流固定经过静态契约校验、实时 CDP 校验和视觉截图验收三道门。
- Skill 提供原子化 `new-theme.ps1` 脚手架与分阶段 `validate-theme.ps1` 校验器；主题 manifest、CSS 桥接、响应式断点、图片签名、路径边界和运行状态均有回归测试覆盖。
- 发布验证：Skill 契约测试通过；官方 `quick_validate.py` 通过；PowerShell 语法错误为 0；Windows 全回归 `105 tests / 103 pass / 0 fail / 2 skipped`；最终独立复审 `Critical 0 / Important 0`。
- 源目录与全局安装目录共 7 个文件，逐文件 SHA-256 完全一致。
- 已将 `feat/one-piece-skin` 本地快进合并到 `main`，最终提交为 `f357448`；未推送远端。干净 `main` 验证为 Windows `102/102`、Skill 契约通过、官方 Skill 校验通过；105 项结果包含原功能工作区中尚未提交的电影感主题刷新测试。
- 合并前 `main` 基线失败根因：Windows PowerShell 5.1 / .NET Framework 4 不接受 `[IO.File]::Replace(..., $null)` 的备份路径；提交 `0f9d58b` 改用同目录真实恢复备份并覆盖故障恢复场景，修复后基线通过。
- 干净 CRLF checkout 曾暴露测试误报：frontmatter 实际值已规范化换行，但 here-string 期望值未规范化；提交 `f357448` 统一规范化两侧换行，LF 与 CRLF 工作区均通过。

## 2026-07-19：电影版海贼王主题最终实机闭环

- 当前 Microsoft Store Codex 版本：`26.715.4045.0`，AUMID 为 `OpenAI.Codex_2p2nqsd0c76g0!App`。
- 最终根因：主题分支仍直接启动 WindowsApps 内的 `ChatGPT.exe`，且 Codex 自身重启会中断启动脚本；随后系统又拉起普通实例，导致用户一直看到无主题窗口。
- 代码修复：移植 `IApplicationActivationManager` 包激活启动层，补全参数引用、manifest ApplicationId/AUMID 解析及状态恢复身份传递；启动与恢复脚本不再直接执行 WindowsApps EXE。
- 回归验证：PowerShell/Node 完整套件 `105 pass / 0 fail / 0 skipped`。
- 实机状态：主题 Codex PID `60544`，CDP `127.0.0.1:9344`，watcher PID `46028`，主题 `one-piece` 版本 `1.1.0`，实时验证 `pass=true`。
- 排障任务运行期间，Codex 宿主会为维持当前任务自动拉起一个 `type=action...` 的默认 profile 窗口；不要反复终止它，应隐藏该宿主窗口并将主题实例置前。正常从已安装快捷方式冷启动不依赖此宿主行为。
- 最终截图：`outputs/one-piece-final.png`；任务页已实际显示海贼王背景、金色侧栏和电影感遮罩。
- 已将 27 个运行时文件逐个校验后原子同步到 `%LOCALAPPDATA%\CodexDreamSkin\engine`，旧引擎保留时间戳备份；安装副本再次通过 `105/105` 测试。
- 已创建桌面与开始菜单快捷方式 `Codex 海贼王电影主题.lnk`，指向安装引擎并使用 `-Theme one-piece -RestartExisting`；桌面同时保留恢复快捷方式。

## 2026-07-18：新版 Codex 主题已实机修复

- 先前“`26.715.3651.0` 不支持 CDP”的结论已被实机实验推翻，不再作为当前结论。
- 根因一：当前 Codex 使用 Chromium `150.0.7871.124`；Chrome 136+ 要求 `--remote-debugging-port` 必须搭配非默认 `--user-data-dir`，而旧 Windows 启动流程没有默认传入隔离 profile。
- 根因二：本机 CIM/WMI 因页面文件错误不可用，旧端口归属校验因此误判；已改为 WMI 失败时使用 `Get-Process` 精确校验官方 `ChatGPT.exe` 路径，未取消安全校验。
- 根因三：海贼王开发分支仍直接执行 WindowsApps 内的 EXE；正式安装改用上游新版的 `IApplicationActivationManager` 包激活链路。
- 修复后实机状态：端口 `9344`、验证 `pass=true`、正式 injector 位于 `%LOCALAPPDATA%\CodexDreamSkin\engine`、默认 profile 位于 `%LOCALAPPDATA%\CodexDreamSkin\codex-profile`。
- 已创建桌面和开始菜单快捷方式：`Codex 海贼王主题.lnk`；参数为正式启动器加 `-RestartExisting`。
- 最终截图：`outputs/final-verification.png`；当前任务页已显示海贼王背景，首页会显示海贼王 Hero 和卡片。

## 2026-07-18：已推翻的旧结论（保留作排障记录）

- 当前 Microsoft Store 包版本：`26.715.3651.0`。
- 已验证 Store 激活与直接运行官方 `ChatGPT.exe` 均不开放 Chromium CDP（9335/9341）；Electron Node Inspector（9342）也未开放。
- 旧日志证明 `26.715.2305.0` 曾可注入，但该旧包已从本机用户包、全用户包和预配包中清理，Microsoft Store 只保留当前版本。
- 结论：`Codex-Dream-Skin` 当前基于运行时调试端口的 Windows 架构无法用于 `26.715.3651.0`；继续修改 CSS、主题图片或校验器不会生效。
- 已恢复原生配置并移除 Dream Skin 桌面/开始菜单快捷方式、托盘状态和运行状态文件；源码与海贼王主题资产保留，供未来兼容版本复用。
- 不采用修改 `WindowsApps`、重打包或重签名官方应用的方案，除非用户后续明确授权并接受签名、更新和安全风险。

## 2026-07-17：海贼王主题

- 工作目录：`C:\Users\Administrator\Documents\Codex\2026-07-16\fei-away-codex-dream-skin-https\work\repo`
- 分支：`feat/one-piece-skin`
- 已验证提交：`5d64ecdfdb29b0e282d20b7b8863230049eddddd`
- 状态：可复用主题引擎和独立 `one-piece` 主题包已完成静态开发与回归验证。
- 范围：首页使用夕阳路飞图，任务、设置、技能和插件页使用蓝天梅丽号图；导航与建议文案采用海贼主题，原生控件保持可交互。
- 安全边界：不修改 `WindowsApps` 或 `app.asar`；CDP 仅绑定 `127.0.0.1`；主题加载器限制路径、图片和文案映射；支持恢复。
- 验证：PowerShell 完整套件 100 pass、0 fail、2 个文件符号链接测试因当前 Windows EPERM 跳过；junction 和其余路径安全测试通过。通用/旧渲染器、Node 语法、PowerShell 解析、`git diff --check` 和两轮独立复审均通过。
- 最终补强：安装/启动在任何修改或重启前执行完整主题 payload 预检；Node 缺失时恢复流程仍可安全清理；React 原地文本更新与断连重插不会产生过期恢复；copy selector 由 loader 和 renderer 双重精确白名单限制。
- 2026-07-17 实机安装首次失败：用户 `config.toml` 含 Codex 自动生成的合法 `[desktop.open-in-target-preferences]`，旧解析器误判为不安全 nested table。已按 TDD 修复并保留 nested array、受管键冲突和 Unicode 转义绕过检查；真实配置副本安装与字节级恢复验证通过。
- 交付包：`outputs/Codex-One-Piece-Skin.zip`，SHA-256 `4BCFAC38D03FBF982A118FEE793C32A8225D8C8859355C5780ACA6EC5E2EF9C7`。
- 待跟进：当前 Codex 任务结束并关闭应用后，执行安装、启动与截图验证，检查首页和普通任务页；不要在活动开发任务中重启 Codex。
- 授权：两张《海贼王》图片由用户提供，仅限个人使用，不公开分发。
