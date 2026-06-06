# GoldTrade

## 2026-05-30 市场数据手动同步失败

- 现象：仪表盘“市场数据同步”手动同步后仍显示降级/过期，最后错误为 `DXY: RemoteDisconnected(Remote end closed connection without response)`。
- 只读排查结论：前端“立即同步”调用 `GET /api/market/sync`；后端 `execute_market_sync_cycle()` 调用 `sync_market_data()`。容器日志显示 SGE、XAU、US10Y 已同步成功，失败点在 DXY：AkShare 1.18.60 缺少 `index_investing_global`，代码回退到 `ak.index_global_hist_em(symbol="美元指数")`，该请求被远端断开，随后 `/api/market/sync` 返回 502 并把同步状态标记为 `degraded`。
- 当前状态：`/api/market/sync-status` 返回 `status=degraded`、`last_success_at=2026-05-29T13:25:00`、`last_failure_at=2026-05-29T23:23:23`、`consecutive_failures=21`、`data_stale=true`。
- 建议下一步：如果用户确认修改，先加 DXY 数据源的最小降级/兜底策略，再用 `backend/tests/test_market_sync.py` 增加/更新聚焦测试；避免改动无关前端和同步状态框架。
- 2026-05-30 已按用户确认修复：DXY 同步失败改为 nonfatal warning，SGE/XAU/US10Y 成功时同步周期标记为 `success` 并保留 `last_error` 提示；`GET /api/market/sync` 对 warning 返回 `status=partial` 和缓存提示，前端手动同步会展示 warning 消息。验证：`pytest backend/tests/test_market_sync.py -q` 19 passed；`npm run build` 通过；`npm run type-check` 因当前 `vue-tsc`/Node 22 工具链报 `Search string not found: /supportedTSExtensions.../` 未通过。Docker 正规重建被 `akshare>=1.13.0` 依赖解析阻塞，已热更新运行容器并重启 backend；真实 `/api/market/sync` 返回 200，`sync-status` 为 `success`、`data_stale=false`、`consecutive_failures=0`，DXY warning 保留。
- 后续继续处理 Docker 构建阻塞：将 `backend/requirements.txt` 的 `akshare>=1.13.0` 固定为 `akshare==1.18.60`，并显式添加 `py-mini-racer==0.6.0`，匹配现有可运行容器。验证：`docker compose build backend` 通过；`docker compose up -d backend` 和 `docker compose build/up frontend` 通过；新容器内 AkShare 1.18.60、py-mini-racer 0.6.0；真实 `/api/market/sync` 返回 `status=partial`，`/api/market/sync-status` 为 `status=success`、`data_stale=false`、`consecutive_failures=0`。

- 同步卡片 UI 继续修正：当后端同步状态为 success 且仅存在 DXY nonfatal warning 时，前端不再显示红色错误条，改为黄色提示 \部分指标暂用缓存：...\；只有真正 degraded 时才显示红色错误。验证：\
pm run build\ 通过；\docker compose build/up frontend\ 后容器静态资源包含 \部分指标暂用缓存\ 与 \.sync-warning\，backend/frontend 均 healthy。

## 2026-05-31 交易记录编辑保存 500

- 现象：交易记录编辑弹窗保存失败，前端提示服务器错误；Network 中 PUT /api/transactions/{id} payload 含 \ee: null\。
- 根因：后端 \crud.update_transaction()\ 在重算金额时执行 \Decimal(str(fee))\，当 fee 为 None 时变成 \Decimal('None')\ 并抛 \decimal.InvalidOperation\，导致 500。
- 修复：更新交易时如果请求显式传入 \ee: null\，后端归一化为 \Decimal('0')\ 再重算金额和保存。验证：新增 \	est_update_transaction_treats_null_fee_as_zero\；\pytest backend/tests/test_crud.py -q\ 通过；重建并重启 backend 后，真实 HTTP 临时记录 create -> update(fee null) -> delete 通过。

## 2026-05-31 提交并推送风险控制与运行稳定性更新

- 已在 E:\project\goldtrade 的 main 分支提交并推送到 origin/main：edfa94bc feat: improve risk controls and market resilience。
- 本次提交包含风控/止盈止损增强、市场同步韧性、成本计算空状态预分析、bcrypt 认证兼容修复、Docker/README 更新及相关测试/文档。
- 验证结果：后端 pytest 140 passed；前端 
pm run build 通过；
pm run type-check 仍因当前 ue-tsc 在 Node 22 下启动时报 Search string not found: /supportedTSExtensions.../ 未通过。
- 未纳入提交的工作区残留主要是运行产物：日志、SQLite 数据库、__pycache__、rontend/dist 构建产物以及本地工具缓存目录。
## 2026-05-31 清理误跟踪运行产物

- 已在 `E:\project\goldtrade` 的 `main` 分支提交并推送到 `origin/main`：`8f9203a1 chore: stop tracking generated artifacts`。
- 本次清理修正 `.gitignore` 中 `*.db  # 注释`、`*.log  # 注释` 这类无效内联注释写法，并新增本地缓存、日志、数据库、`frontend/dist`、构建日志等忽略规则。
- 已用 `git rm --cached` 停止跟踪日志、SQLite 数据库、`__pycache__`、`frontend/dist` 和 PyInstaller localpycs 等生成物；本地文件未删除。
- 验证：`git diff --cached --check` 通过；提交推送后 `git status --short --branch` 显示 `main...origin/main` 无未提交变更，仅有用户级 `C:\Users\Administrator/.config/git/ignore` 权限警告。

## 2026-05-31 Core stability verification
- Created branch/worktree: codex-core-stability-verification at E:\project\goldtrade\.worktrees\core-stability-verification.
- Fixed backend test isolation: tests now set DATABASE_URL before importing app.main/app.database, and tests/test_api.py uses the shared client fixture instead of a global TestClient. Commit: d0857268 test: isolate api tests from app database.
- Verification on branch: backend python -m pytest -q => 140 passed, 31 warnings; frontend npm run build => passed with existing Vite dynamic-import chunk warning; docker compose ps => command readable, no running services listed.
- Pending integration choice: merge branch locally, push/PR, keep branch, or discard.

- 2026-05-31 update: core stability verification branch was merged locally into main via fast-forward. Worktree removed and branch deleted. Main verification after merge: backend python -m pytest -q => 140 passed, 31 warnings; frontend npm run build => passed with existing Vite dynamic-import chunk warning. Local main is ahead of origin/main by 3 commits.

- 2026-05-31 update: pushed main to origin/main at d0857268. Local main is no longer ahead of origin/main after core stability verification merge.
## 2026-05-31 买入决策首屏优化

- 已将买入决策面板首屏改为优先回答“现在能不能买”：展示推荐结论、解释、当前价格、建议区间、评分、更新时间、风险和数据状态，并保留模拟买入、创建提醒、记录交易入口。
- 相关设计与计划文档已提交：`b52c5a93 docs: add buy decision first screen design`、`8fa813c2 docs: add buy decision first screen plan`。
- 实现提交已 fast-forward 合并到 `main`：`1e11cea1 feat: clarify buy decision first screen`；功能 worktree 和本地分支 `codex-buy-decision-first-screen` 已清理。
- 验证：合并后 `frontend` 下 `npm run build` 通过；`npx eslint src/views/BuyDecisionPanel.vue` 通过。`npm run type-check` 仍受既有 `vue-tsc`/Node 22 兼容问题阻塞；全量 `npm run lint` 仍被其它历史文件错误阻塞。
- 注意：本轮未完成浏览器视觉验证，原因是本地前后端服务未能按预期启动/绑定，后续如需精修 UI，可先恢复本地运行环境再做截图检查。
