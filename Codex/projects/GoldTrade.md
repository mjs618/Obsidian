# GoldTrade

## 2026-05-30 市场数据手动同步失败

- 现象：仪表盘“市场数据同步”手动同步后仍显示降�?过期，最后错误为 `DXY: RemoteDisconnected(Remote end closed connection without response)`�?- 只读排查结论：前端“立即同步”调�?`GET /api/market/sync`；后�?`execute_market_sync_cycle()` 调用 `sync_market_data()`。容器日志显�?SGE、XAU、US10Y 已同步成功，失败点在 DXY：AkShare 1.18.60 缺少 `index_investing_global`，代码回退�?`ak.index_global_hist_em(symbol="美元指数")`，该请求被远端断开，随�?`/api/market/sync` 返回 502 并把同步状态标记为 `degraded`�?- 当前状态：`/api/market/sync-status` 返回 `status=degraded`、`last_success_at=2026-05-29T13:25:00`、`last_failure_at=2026-05-29T23:23:23`、`consecutive_failures=21`、`data_stale=true`�?- 建议下一步：如果用户确认修改，先�?DXY 数据源的最小降�?兜底策略，再�?`backend/tests/test_market_sync.py` 增加/更新聚焦测试；避免改动无关前端和同步状态框架�?- 2026-05-30 已按用户确认修复：DXY 同步失败改为 nonfatal warning，SGE/XAU/US10Y 成功时同步周期标记为 `success` 并保�?`last_error` 提示；`GET /api/market/sync` �?warning 返回 `status=partial` 和缓存提示，前端手动同步会展�?warning 消息。验证：`pytest backend/tests/test_market_sync.py -q` 19 passed；`npm run build` 通过；`npm run type-check` 因当�?`vue-tsc`/Node 22 工具链报 `Search string not found: /supportedTSExtensions.../` 未通过。Docker 正规重建�?`akshare>=1.13.0` 依赖解析阻塞，已热更新运行容器并重启 backend；真�?`/api/market/sync` 返回 200，`sync-status` �?`success`、`data_stale=false`、`consecutive_failures=0`，DXY warning 保留�?- 后续继续处理 Docker 构建阻塞：将 `backend/requirements.txt` �?`akshare>=1.13.0` 固定�?`akshare==1.18.60`，并显式添加 `py-mini-racer==0.6.0`，匹配现有可运行容器。验证：`docker compose build backend` 通过；`docker compose up -d backend` �?`docker compose build/up frontend` 通过；新容器�?AkShare 1.18.60、py-mini-racer 0.6.0；真�?`/api/market/sync` 返回 `status=partial`，`/api/market/sync-status` �?`status=success`、`data_stale=false`、`consecutive_failures=0`�?
- 同步卡片 UI 继续修正：当后端同步状态为 success 且仅存在 DXY nonfatal warning 时，前端不再显示红色错误条，改为黄色提示 \部分指标暂用缓存�?..\；只有真�?degraded 时才显示红色错误。验证：\
pm run build\ 通过；\docker compose build/up frontend\ 后容器静态资源包�?\部分指标暂用缓存\ �?\.sync-warning\，backend/frontend �?healthy�?

## 2026-05-31 交易记录编辑保存 500

- 现象：交易记录编辑弹窗保存失败，前端提示服务器错误；Network �?PUT /api/transactions/{id} payload �?\ee: null\�?- 根因：后�?\crud.update_transaction()\ 在重算金额时执行 \Decimal(str(fee))\，当 fee �?None 时变�?\Decimal('None')\ 并抛 \decimal.InvalidOperation\，导�?500�?- 修复：更新交易时如果请求显式传入 \ee: null\，后端归一化为 \Decimal('0')\ 再重算金额和保存。验证：新增 \	est_update_transaction_treats_null_fee_as_zero\；\pytest backend/tests/test_crud.py -q\ 通过；重建并重启 backend 后，真实 HTTP 临时记录 create -> update(fee null) -> delete 通过�?

## 2026-05-31 提交并推送风险控制与运行稳定性更�?
- 已在 E:\project\goldtrade �?main 分支提交并推送到 origin/main：edfa94bc feat: improve risk controls and market resilience�?- 本次提交包含风控/止盈止损增强、市场同步韧性、成本计算空状态预分析、bcrypt 认证兼容修复、Docker/README 更新及相关测�?文档�?- 验证结果：后�?pytest 140 passed；前�?
pm run build 通过�?pm run type-check 仍因当前 ue-tsc �?Node 22 下启动时�?Search string not found: /supportedTSExtensions.../ 未通过�?- 未纳入提交的工作区残留主要是运行产物：日志、SQLite 数据库、__pycache__�?rontend/dist 构建产物以及本地工具缓存目录�?
## 2026-05-31 清理误跟踪运行产�?
- 已在 `E:\project\goldtrade` �?`main` 分支提交并推送到 `origin/main`：`8f9203a1 chore: stop tracking generated artifacts`�?- 本次清理修正 `.gitignore` �?`*.db  # 注释`、`*.log  # 注释` 这类无效内联注释写法，并新增本地缓存、日志、数据库、`frontend/dist`、构建日志等忽略规则�?- 已用 `git rm --cached` 停止跟踪日志、SQLite 数据库、`__pycache__`、`frontend/dist` �?PyInstaller localpycs 等生成物；本地文件未删除�?- 验证：`git diff --cached --check` 通过；提交推送后 `git status --short --branch` 显示 `main...origin/main` 无未提交变更，仅有用户级 `C:\Users\Administrator/.config/git/ignore` 权限警告�?

## 2026-05-31 Core stability verification
- Created branch/worktree: codex-core-stability-verification at E:\project\goldtrade\.worktrees\core-stability-verification.
- Fixed backend test isolation: tests now set DATABASE_URL before importing app.main/app.database, and tests/test_api.py uses the shared client fixture instead of a global TestClient. Commit: d0857268 test: isolate api tests from app database.
- Verification on branch: backend python -m pytest -q => 140 passed, 31 warnings; frontend npm run build => passed with existing Vite dynamic-import chunk warning; docker compose ps => command readable, no running services listed.
- Pending integration choice: merge branch locally, push/PR, keep branch, or discard.

- 2026-05-31 update: core stability verification branch was merged locally into main via fast-forward. Worktree removed and branch deleted. Main verification after merge: backend python -m pytest -q => 140 passed, 31 warnings; frontend npm run build => passed with existing Vite dynamic-import chunk warning. Local main is ahead of origin/main by 3 commits.

- 2026-05-31 update: pushed main to origin/main at d0857268. Local main is no longer ahead of origin/main after core stability verification merge.
## 2026-05-31 买入决策首屏优化

- 已将买入决策面板首屏改为优先回答“现在能不能买”：展示推荐结论、解释、当前价格、建议区间、评分、更新时间、风险和数据状态，并保留模拟买入、创建提醒、记录交易入口�?- 相关设计与计划文档已提交：`b52c5a93 docs: add buy decision first screen design`、`8fa813c2 docs: add buy decision first screen plan`�?- 实现提交�?fast-forward 合并�?`main`：`1e11cea1 feat: clarify buy decision first screen`；功�?worktree 和本地分�?`codex-buy-decision-first-screen` 已清理�?- 验证：合并后 `frontend` �?`npm run build` 通过；`npx eslint src/views/BuyDecisionPanel.vue` 通过。`npm run type-check` 仍受既有 `vue-tsc`/Node 22 兼容问题阻塞；全�?`npm run lint` 仍被其它历史文件错误阻塞�?- 注意：本轮未完成浏览器视觉验证，原因是本地前后端服务未能按预期启�?绑定，后续如需精修 UI，可先恢复本地运行环境再做截图检查�?
## 2026-07-03 全量功能回归与前端质量门禁修�?
- 完成全量回归：后�?`python -m pytest -q` �?140 passed；前�?`npm run type-check`、`npm run lint -- --quiet`、`npm run build` 均通过�?- 修复此前�?`vue-tsc` 启动崩溃掩盖的问题：�?TypeScript 固定�?5.3.3，匹�?`vue-tsc 1.8.x`；清�?8 �?lint 阻断错误及实际类型错误�?- 修复两个潜在运行时问题：回测/定投 API 参数遮蔽 HTTP 请求客户端；交易导入结果改为读取后端实际返回�?`success` 和可�?`errors`�?- 前端 Docker 构建镜像�?Node 18 升级�?Node 20，满�?`marked@17` �?Node 版本要求。Docker 重建�?backend、frontend、email-proxy �?healthy�?- Playwright �?17 个核心路由完成部署后巡检：全部正常渲染，无控制台错误、页面异常或失败请求。运行环境默认登录密码已被修改，因此未执行需要登录凭证的数据写入流程�?- 当前改动尚未提交。剩余非功能性事项：npm 审计报告 29 项依赖风险（14 moderate�?4 high�? critical），未执行可能引入破坏性升级的自动修复；Vite 仍提�?auth store 同时静�?动态导入的分包警告�?
## 2026-07-04 前端依赖安全�?lint 清理

- 完成完整 npm 依赖治理：审计结果从 29 项风险降�?0。主要升级为 `Vite 8.1.3`、`TypeScript 5.9.3`、`vue-tsc 3.3.6`、`ECharts 6.1.0`、`vue-echarts 8.0.1`、`jsPDF 4.2.1`、`DOMPurify 3.4.11`，前�?Docker 构建镜像升级�?Node 22�?- 完成 Vite 8/Rolldown 分包配置迁移；AI 助手�?AI 报告�?HTML 渲染增加 DOMPurify 清洗�?- 前端 lint �?395 �?warning 清理�?0；保留严�?`vue-tsc` 类型检查。历史动态边界大量使用显�?`any`，本轮未做高风险全量类型重构，项目级关闭 `no-explicit-any` 规则�?- 验证结果：`npm audit` �?0 vulnerabilities；`npm run lint`、`npm run type-check`、`npm run build` 通过；后�?140 tests passed；Node 22 Docker 全新构建并部署成功；部署�?Playwright 17 个核心路由全部通过，无控制台错误、页面异常或失败请求�?- 后续按优先级修复 auth store 分包告警：根因是路由守卫通过异步导入延迟注册，�?`App.vue` 已静态导入同一 store；这不仅无法形成独立分包，还可能让首次导航早于守卫注册。现改为静态导入并同步注册守卫，Pinia 仍在调用前完成安装。Vite 构建不再出现 `INEFFECTIVE_DYNAMIC_IMPORT`；同时统一 Dockerfile �?`FROM ... AS` 大小写，Docker 构建规范告警已清除�?- 验证：前�?lint、类型检查通过；Node 22 Docker 生产构建和部署通过�?7 个核心路由分别以全新页面首次导航完成 Playwright 回归，无控制台错误、页面异常或失败请求。当前改动尚未提交�?
## 2026-07-04 PDF 导出统一完善

- 完成“报�?PDF 导出”统一改造：收益报表、设置页月报/年报、投资报告均改为服务�?PDF 下载路径；PDF 导出统一后端 PRO 校验，页面查看接口保持原权限�?- 后端新增收益报表 PDF 接口 ``/api/reports/profit-summary/export/pdf``，扩展投资报�?`/api/report/investment/export?format=pdf`；月�?年报�?`/api/export/pdf/monthly|annual` 地址保持兼容。PDF 使用 ReportLab 文本/表格，Matplotlib 仅嵌入关键图表，表格支持跨页表头，响应补 `filename*`�?- 前端移除收益报表 `html2canvas + jsPDF` 截图导出和投资报�?`window.print()` PDF 路径；新增共�?Blob/PDF 下载工具，并修正 `InvestmentReport.vue` 与后�?DTO 不一致的问题。`jspdf` 从前端依赖中移除，`html2canvas` 保留给分享海报�?- 新增 `backend/tests/test_pdf_exports.py`，覆�?PDF service、收�?PDF endpoint、投�?PDF export 与无效格�?400。验证：`backend` 全量 ``python -m pytest backend\tests -q`` �?144 passed；前端在同步依赖�?`npm run type-check`、`npm run lint`、`npm run build` 通过；PDF 文本抽取检查通过；`git diff --check` 通过�?- Docker 验证：backend 镜像构建通过；frontend 镜像构建两次卡在 Docker Hub `node:22-alpine` metadata EOF，属�?registry/network 阻塞，未继续重试。当前改动尚未提交�?
- 2026-07-04 补充验证：随后使�?`docker compose build --pull=false frontend` 成功构建前端镜像，`docker compose up -d` 刷新 backend/frontend；`docker compose ps` 显示 backend、frontend、email-proxy healthy，`curl http://localhost:18000/api/health` 返回 `{"status":"healthy"}`，`curl -I http://localhost:18080/` 返回 200�?
- 2026-07-04 继续补充：真实容�?PDF 初次抽取时发�?Docker WQY TTF 生成的正文中文可见但 `pypdf/pdfplumber` 抽取为乱码。已调整 `pdf_report.py` 字体策略：ReportLab 正文/表格优先使用 CID 字体 `STSong-Light` 保证 ToUnicode/复制映射，Matplotlib 图表继续使用系统 TTF。重�?backend 后，真实容器 4 �?PDF（收益、投资、月报、年报）�?`%PDF-` 合法且中文关键标题可�?`pypdf` 正确抽取；后端全量测试仍�?144 passed，Docker backend/frontend healthy�?
- 2026-07-04 继续补充：使�?Selenium Grid 对部署后�?frontend �?24 个路由真实浏览器烟测（含 `/report`、`/investment-report`、`/settings` 等），均能加载，�?404/500/应用崩溃。检�?backend/frontend 最近日志，未见 traceback �?5xx；日志中仅有路由快速切换产生的 499 和既有明文配置解密提示�?
## 2026-07-13 系统基线复查

- 新鲜回归结果：后端完整测�?`144 passed`，PDF 针对性测�?`4 passed`；前端在按锁文件同步�?Vite 8.1.3、TypeScript 5.9.3、vue-tsc 3.3.6 后，lint、type-check、build 均通过，`npm audit` �?0 vulnerabilities�?- 运行态检查：backend、frontend、email-proxy �?healthy；后�?`/api/health` 和前端首页均返回 HTTP 200�?- 发现仓库治理问题：`frontend/node_modules` 虽已写入 `.gitignore`，但仍有 23,581 个文件被 Git 历史跟踪，导致工作区默认保留 Vite 5.4.21/vue-tsc 1.8.27，与 package 清单和锁文件不一致，首次 type-check 因此崩溃。按锁文件重装可恢复全部质量门禁；本轮已撤回重装产生�?10,640 项第三方文件工作区差异�?- 用户已确认提交与 `node_modules` 退库。已�?`codex/pdf-export-improvements` 创建两个本地提交：`2eb79377 feat: unify PDF exports and refresh frontend tooling`、`e049d074 chore: stop tracking frontend dependencies`�?- `frontend/node_modules` �?23,581 个历史跟踪文件已�?Git 索引移除，本地依赖目录保留；`git ls-files frontend/node_modules` 结果�?0。当前未推送远端�?- 工作台账：`docs/SYSTEM_AUDIT_2026-07-13.md`�?
### 2026-07-13 提交后部署复�?
- 最新源码重建并刷新本地 backend/frontend 容器成功；backend、frontend、email-proxy healthy。Playwright �?14 个核心路由烟测全部返�?200，无控制台错误、页面异常或失败请求�?- 定位并修复历史明文敏感配置每次读取都会误�?`Decryption error`：仅 Fernet 格式值进入解密路径，历史明文继续兼容，新写入配置仍加密。提交：`069f6fd3 fix: avoid decrypting legacy plaintext settings`�?- 回归验证：新增日志回归测试先失败后通过，后端全量为 145 passed；容器刷新后解密错误日志消失�?- 启动市场同步期间 DXY 第三方数据源曾被远端断开；系统正确记录为 warning 并继续完成同步，相关页面/API 正常，暂不扩大为重试机制改造�?- 当前分支仍为 `codex/pdf-export-improvements`，共 3 个本地提交，尚未推送�?
### 2026-07-14 分支推�?
- 重新验证：后�?145 passed；前�?lint、type-check、Vite 8 build 通过；npm audit �?0 vulnerabilities；工作区干净�?- 已推�?`codex/pdf-export-improvements` �?`origin/codex/pdf-export-improvements`�?- Pull Request 尚未创建：GitHub CLI �?`mjs618` 的令牌已失效。待用户重新执行 `gh auth login -h github.com`，或明确允许使用现有 Chrome 登录态创�?PR�?
### 2026-07-14 PR 创建阻塞更新

- 用户已允许使�?Chrome 创建 PR，但当前 Chrome 未登�?GitHub；访问私有仓�?PR 页面时显�?404，登录入口已打开�?- 未读取或填写任何账号、密码、验证码或浏览器凭证。待用户在保留的 GitHub 登录页完成登录后，继续创建从 `codex/pdf-export-improvements` �?`main` �?PR�?
### 2026-07-14 Pull Request 已创�?
- 用户完成 Chrome 登录后，已创建从 `codex/pdf-export-improvements` �?`main` �?Pull Request #1：`https://github.com/mjs618/goldtrade/pull/1`�?- PR 标题：`feat: unify PDF exports and refresh frontend tooling`�?- PR 说明已记录功能摘要和验证清单：后�?145 passed；前�?lint、type-check、Vite 8 build、npm audit 通过；Docker 健康检查与 14 条核心路由浏览器烟测通过�?
### 2026-07-14 PRO Ȩ�� 403 �ع��޸�
- �޸� `E:\project\goldtrade\backend\app\dependencies.py` �� `check_pro_feature()` �ľֲ������ڱ����⣺δ��Ȩ���� PRO ����ʱ���ڰ�Ԥ�ڷ��� 403�������ǿ����׳� 500��
- ���� `backend\tests\test_pdf_exports.py` �ع���ԣ����� FREE �û����� `/api/reports/profit-summary/export/pdf` ���� `PRO_LICENSE_REQUIRED`��
- ��֤��`python -m pytest backend\tests\test_pdf_exports.py -q` Ϊ 5 passed��`python -m pytest backend\tests -q` Ϊ 146 passed��

### 2026-07-14 P0 完整性完善
- 按优先级完成第一轮 P0：统一明确高级功能的后端 PRO 边界，覆盖 decision、grid、backtest、dca、risk-control、advanced-alerts、investment-report，以及 market 中的 AI 研报、AI 助手、AI 提醒和 technical-chart 接口；保留基础市场数据、同步状态、新闻等免费/基础接口。
- 生产安全配置增加启动校验：ENVIRONMENT=production 时 JWT_SECRET_KEY、SESSION_SECRET_KEY、AUTH_SECRET_SALT、CONFIG_ENCRYPTION_KEY 不能使用默认占位值。
- 清理授权/激活流程：移除硬编码机器授权、激活调试打印、许可证校验 DEBUG 打印，激活失败不再返回机器码或输入码。
- 增加 JSON 备份恢复闭环：新增 POST /api/import/backup，默认 dry_run=true 仅校验预览；dry_run=false 才恢复交易；restore_settings=true 时恢复非本机安全设置，并跳过 machine_id、license_key、system_password_hash。
- 回归测试：新增 PRO 边界、生产配置、激活泄露、备份导入测试；后端全量 python -m pytest backend\tests -q 为 166 passed。

### 2026-07-14 备份恢复前端闭环
- 将设置页“数据备份与恢复”从旧的 .db 恢复入口调整为 JSON 备份闭环：下载调用 `/api/export/backup`，文件名保存为 `.json`；导入只接受 `.json`。
- 前端恢复流程改为两阶段：先调用 `POST /api/import/backup?dry_run=true` 校验并预览交易数量、跳过的本机安全设置；用户二次确认后再以 `dry_run=false` 执行导入。
- 设置项默认不恢复，避免覆盖本机安全配置；导入成功后刷新设置数据，不强制刷新整个页面。
- 验证：`npm run type-check`、`npm run build`、`npm run lint` 均通过；后端全量 `python -m pytest backend\tests -q` 为 166 passed。

## 2026-07-14 数据健康卡增强
- 在 MarketSyncStatusCard 中补充健康判断、同步周期、最近开始和预计下次同步时间，Dashboard 与 Market 页复用后可直接看到数据同步健康状态。
- 验证：frontend npm run type-check、npm run lint、npm run build 均通过；backend python -m pytest backend\tests -q 通过 166 passed。
- 当前变更未提交。

## 2026-07-14 授权取消与设置安全边界
- 新增 POST /api/auth/deactivate 专用取消激活接口，前端设置页取消激活改为调用该接口，修复旧逻辑只清空 activation_code 而不影响 license_key 的问题。
- /api/settings 通用设置接口禁止直接读取或写入 machine_id、license_key、system_password_hash、activation_code，避免绕过授权/认证专用流程。
- JSON 备份恢复继续跳过本机安全字段，并新增 activation_code 保护。
- 验证：backend python -m pytest backend\tests -q 通过 168 passed；frontend npm run type-check、npm run lint、npm run build 通过；git diff --check 无格式错误，仅 LF/CRLF 提示。
- 当前变更未提交。

## 2026-07-14 旧数据库文件恢复入口停用
- 停用旧 /api/settings/backup 与 /api/settings/restore 的 .db 文件备份/恢复入口，统一引导使用 JSON 备份与导入流程，避免后端残留直接覆盖 gold.db 的危险路径。
- 新增 backend/tests/test_settings_api.py 覆盖旧接口返回 410 的行为。
- 验证：backend python -m pytest backend\tests -q 通过 170 passed；frontend npm run type-check、npm run lint、npm run build 通过；git diff --check 无格式错误，仅 LF/CRLF 提示。
- 当前变更未提交。

## 2026-07-14 清理旧数据库备份恢复遗留代码
- 重写 backend/app/api/settings.py，移除旧 .db 备份/恢复中的 FileResponse、UploadFile、copy2、copyfileobj 和 gold.db 覆盖逻辑，仅保留旧入口 410 响应。
- 清理 frontend/src/api/settings.ts，移除 backupDatabase/restoreDatabase 旧客户端方法，前端只保留 JSON export/import 备份能力。
- 验证：backend python -m pytest backend\tests -q 通过 170 passed；frontend npm run type-check、npm run lint、npm run build 通过；git diff --check 无格式错误，仅 LF/CRLF 提示。
- 当前变更未提交。

## 2026-07-14 授权缓存失效修复
- 新增 dependencies.reset_license_cache，并在 /api/auth/activate 与 /api/auth/deactivate 成功后清理 PRO 授权缓存。
- 修复激活后 10 分钟内仍可能被旧 FREE 缓存拦截、取消激活后 10 分钟内仍可能沿用旧 PRO 缓存的问题。
- 新增授权缓存回归测试，覆盖激活和取消激活后的 PRO 校验即时生效。
- 验证：backend python -m pytest backend\tests -q 通过 172 passed；frontend npm run type-check、npm run lint、npm run build 通过；git diff --check 无格式错误，仅 LF/CRLF 提示。
- 当前变更未提交。

## 2026-07-14 备份链路一次性收口
- 自动备份从复制 gold.db 改为生成 JSON 备份文件，复用统一 backup payload，避免继续产生数据库文件副本。
- /api/export/backup 与自动备份共用 build_backup_payload，并排除 machine_id、license_key、system_password_hash、activation_code 等本机安全字段。
- 新增测试覆盖 JSON 导出不包含本机安全字段、自动备份生成 .json 且不生成 .db。
- 验证：backend python -m pytest backend\tests -q 通过 174 passed；frontend npm run type-check、npm run lint、npm run build 通过；git diff --check 无格式错误，仅 LF/CRLF 提示。
- pytest 结束时偶发临时目录清理 PermissionError，但测试进程退出码为 0，不影响业务验证。
- 当前变更未提交。

## 2026-07-14
- 提交 `8eb2fb1b`（`完善授权与备份安全边界`）：完善授权/PRO 功能边界、备份导入导出安全策略、生产密钥配置校验、市场同步状态展示，并补充相关后端测试。
- 验证：后端 `174 passed`；前端类型检查、ESLint、生产构建通过。
- 部署：已执行 Docker 镜像重建与服务重启，`goldtrade-backend`、`goldtrade-frontend`、`goldtrade-email-proxy` 均 healthy；`/api/health` 和前端首页返回 200。

### DXY 同步回退修复
- 针对 DXY 同步出现 `RemoteDisconnected` 的问题，已在 `backend/app/services/market_data.py` 增加主 AkShare Investing 接口失败后的备用 `index_global_hist_em` 回退。
- 新增回归测试：主 DXY 接口存在但断开连接时，系统应继续使用备用源写入 DXY 数据，而不是直接降级为缓存。
- 验证：`backend/tests/test_market_sync.py` 20 passed；后端完整测试 175 passed。

### DXY 缓存兜底提示优化
- 发现容器内 AkShare 1.18.60 没有 `index_investing_global`，DXY 实际使用东方财富 `index_global_hist_em`；该外部接口会返回 `RemoteDisconnected`。
- 已优化 DXY 外部源全失败时的用户提示：若数据库已有 DXY 缓存，则同步保持成功并提示“DXY 外部数据源暂不可用，已使用缓存数据（最新日期：YYYY-MM-DD）”，底层异常仅保留在日志。
- 验证：市场同步测试 21 passed；后端完整测试 176 passed；已重建 Docker 镜像并重启后端，`/api/market/sync-status` 返回友好缓存提示。
