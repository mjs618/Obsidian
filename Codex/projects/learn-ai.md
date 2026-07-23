# learn-ai

## UI 系统统一（2026-07-13）

- 视觉方向：采用“编辑式学习系统”方案，统一为内容优先的双主题界面。
- 已完成：全局设计 tokens、导航、首页、课程详情、复习、仪表盘、资料页、表单与反馈状态组件的统一。
- 响应式验收：覆盖浅色/深色、390/768/1440 三档视口、5 个核心页面，共 30 个组合。
- 自动化状态：主分支 `master` 已合并至 `62ed465`；Vitest、TypeScript 检查、生产构建均通过。
- 测试基础设施：Playwright 使用隔离端口，并通过 IPC 在 Windows 上可靠关闭服务，避免跨工作树误复用和进程残留。
- 非阻塞后续：暗色主题可补充 `color-scheme: dark`；HTML `theme-color` 可改为随主题切换。

## 容器运行状态（2026-07-13）

- 已基于 `master@62ed465` 重建 `learn-ai-app` 镜像并启动服务，映射端口 `3001:3001`。
- 容器健康检查、readiness、首页、搜索 API 和移动端浏览器冒烟测试通过。
- 完整 30 组合浏览器矩阵不适合直接复用生产限流配置，会触发 429；隔离测试环境已使用放宽限流配置完成该矩阵。

## 第一批安全与功能优化（2026-07-13）

- 状态：已快进合并至 `master@c9e43c5`；隔离 worktree 与功能分支已清理。
- 运维日志：`/api/access-logs`、`/api/audit-logs`、`/api/logs/dates`、`/api/logs` 已收紧为管理员权限；访客/普通用户/管理员分别为 401/403/200。
- 可信代理：新增 `TRUST_PROXY`，默认 `false`；客户端 IP 统一由 Express `req.ip` 解析，不再直接信任转发头。
- 限流范围：全局限流仅覆盖业务 API；静态资源、SPA、metrics、健康检查不消耗 API 配额，精确路径边界已覆盖。
- 改密会话：密码与撤销边界使用单 SQL 原子更新；撤销边界单调递增，覆盖并发登录、连续同毫秒改密、管理员禁用和 refresh 边界。改密返回替换 token，前端写入失败或刷新失败会清理 token 与 Zustand 会话。
- 验证：最终全量测试 57 个文件、799 项通过；TypeScript、生产构建通过；lint 为 0 error、1 条既有 warning。镜像 `learn-ai:security-hardening-batch-1` 构建成功，隔离容器完成权限、限流、代理和改密冒烟后已删除。
- 交付：最终提交 `c9e43c5`；最终跨任务审查无 Critical、Important 或 Minor 问题；合并后主工作区全量测试 799/799 通过。

## 第二批待办

- P2：统一前后端密码最小长度（当前前端 6、后端 8）。
- P2：让 ESLint 覆盖 `server/**/*.js`。
- P2：生产构建关闭 hidden source maps。
- P2：同步根 `package-lock.json` 版本 0.8.1 与 `package.json` 版本 0.12.0。
