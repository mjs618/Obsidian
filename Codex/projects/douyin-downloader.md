# douyin-downloader

## 2026-07-05 Docker 部署

- 本地工作目录：`E:\project\dydownload`
- 来源仓库：`https://github.com/jiji262/douyin-downloader`
- 已用 Docker 部署为 REST API 服务模式。
- 宿主机访问地址：`http://localhost:51596`
- 健康检查：`GET /api/v1/health` 返回 `{"status":"ok"}`。
- 容器名：`douyin-downloader`
- 镜像名：`dydownload-douyin-downloader`
- 部署文件：
  - `Dockerfile`：补充安装 `fastapi` 和 `uvicorn`，否则 REST 服务模式无法启动。
  - `docker-compose.yml`：以 `python run.py -c config.yml --serve --serve-host 0.0.0.0 --serve-port 8000` 启动，映射 `51596:8000`。
  - `config.yml`：本地未跟踪配置文件，cookie 留空，不记录真实凭证。
- 注意：本机 `8000` 和 `18000` 端口已被占用，因此选择 `51596`。

## 2026-07-05 前端配置页

- 已为 REST 服务补充内置前端页面，访问入口：`http://localhost:51596/`。
- 页面支持：
  - 配置下载目录、线程数、重试次数、限速、代理。
  - 粘贴 Cookie 保存到服务端。
  - 提交下载链接并查看任务列表。
- 新增接口：
  - `GET /api/v1/settings`：返回非敏感配置，cookie 只返回是否已配置。
  - `PUT /api/v1/settings`：保存安全配置项；cookie 写入 `.cookies.json`，不写入 `config.yml`。
- Docker 挂载：
  - `./config.yml:/app/config.yml`
  - `./.cookies.json:/app/.cookies.json`
  - `./Downloaded:/app/Downloaded`
- 验证：
  - `python -m pytest tests\test_server.py`：12 passed。
  - Docker 容器 `douyin-downloader` 状态 healthy。
  - `GET /` 返回 200，页面包含 `/api/v1/settings`。

## 2026-07-05 独立前端界面优化

- 前端已从 `server/app.py` 内联 HTML 拆分为独立静态资源：
  - `server/static/index.html`
  - `server/static/app.css`
  - `server/static/app.js`
- `server/app.py` 现在挂载 `/static` 并通过根路径 `/` 返回静态入口。
- 新界面定位为本地 Docker 管理台：左侧导航 + 下载任务 + 运行配置 + 任务队列。
- 视觉验证：
  - Chrome 桌面视口：配置表单、下载表单可见，`.download-shell` 为 grid，无控制台错误。
  - Chrome 移动视口 390px：页面宽度等于视口宽度，表单可见，无控制台错误。
- 服务验证：
  - `python -m pytest tests\test_server.py`：13 passed。
  - `python -m py_compile server\app.py`：通过。
  - Docker 容器 `douyin-downloader` 状态 healthy。
  - `GET /`、`/static/app.css`、`/static/app.js`、`/api/v1/settings` 均返回 200。

## 2026-07-05 独立前端容器

- 新增 `frontend/` 静态站点，使用独立 Nginx 容器部署，不修改后端业务文件。
- 新前端入口：`http://localhost:51597/`；原后端入口继续使用 `http://localhost:51596/`。
- 前端容器通过 Docker 内网代理 `/api/` 到 `douyin-downloader:8000`，不需要后端跨域配置。
- 新界面采用紧凑型下载工作台布局，包含任务创建、运行配置、服务概览和任务队列。
- 验证：前端与服务测试共 15 项通过；桌面与窄屏无页面级横向溢出，API 配置读取正常，浏览器控制台无错误。

## 2026-07-05 Playwright Cookie 登录设计

- 已选择“嵌入式扫码登录”方案：独立 Cookie sidecar 使用 Playwright 打开抖音登录页，前端显示截图供扫码，登录成功后自动同步 Cookie。
- 继续保持 `server/` 和下载业务代码不变；Cookie 服务仅通过 Docker 内网访问。
- 不返回或记录 Cookie 明文，不处理验证码绕过、账号密码自动输入或多会话并发。
- 设计文档：`docs/superpowers/specs/2026-07-05-playwright-cookie-login-design.md`。

## 2026-07-05 Playwright Cookie 登录实现

- 新增独立 `cookie_service/` sidecar，提供 `/session`、`/session/{id}`、`/session/{id}/screenshot` 和取消接口。
- 前端通过 Nginx `/cookie-api/` 代理访问 sidecar；Cookie 获取按钮会打开扫码弹窗、轮询截图和状态。
- Cookie 同步不再依赖新增后端 API，sidecar 写入共享 `.cookies.json`，后端容器和 sidecar 通过 compose 挂载同一宿主文件。
- 已修复前端轮询竞态、过期响应覆盖、跨 session 删除串扰、未知状态 class 注入和页面离开未取消会话问题。
- 已修复截图验证码无法拖动：前端在截图上捕获 pointer 事件并转发坐标，`cookie_service` 通过 Playwright mouse API 操作真实页面；轮询间隔降为 1 秒以减少画面生成等待。
- 进一步优化扫码体验：截图改为预加载成功后再替换，首图失败时隐藏破图；拖动过程中 pointer move 做 80ms 节流，后端仅在 `up/click` 后截图，避免每次移动都截图导致拖动卡顿。
- 修复“没有弹出扫码”的问题：Playwright 打开抖音首页后改用多策略点击登录入口（role/text/css/DOM 脚本/右上角坐标兜底），避免只停留在首页等待 Cookie。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 5 passed；`python -m pytest tests` 395 passed, 1 skipped。
- Docker 实机启动验证已完成：`docker compose up --build -d` 成功启动 `douyin-downloader`、`douyin-downloader-cookie-login`、`douyin-downloader-frontend`；`GET /api/v1/health` 和前端代理 `GET /cookie-api/health` 均返回 `{"status":"ok"}`。
## 2026-07-05 独立前端可用性补齐

- 独立前端 `http://localhost:51597/` 已补齐更接近日常可用的操作：下载输入支持粘贴抖音分享文案、多行多链接解析和去重，并逐个调用现有 `/api/v1/download` 创建任务。
- Cookie 扫码弹窗新增“打开登录框”按钮，复用已有 pointer 接口点击抖音右上登录区域；用于处理页面停在首页、没有自动弹出扫码框的情况。
- 任务队列表格新增进度条、百分比和失败原因展示；未知状态仍走白名单 `status-unknown`，失败文案会 HTML escape。
- 本次仍保持独立部署思路：新功能主要落在 `frontend/`，不改变核心下载后端契约。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 12 passed；`python -m pytest tests` 401 passed, 1 skipped；Docker Compose 服务 `douyin-downloader` 与 `cookie-login` healthy，`frontend` 已在 `51597` 启动；Playwright 使用系统 Chrome 做页面烟测，确认批量创建 2 个任务请求、队列进度 80%、打开登录框 pointer click 坐标 `{x:1230,y:46}`。
## 2026-07-06 Cookie 拖动验证交互修复

- 修复 Cookie 扫码弹窗中滑块验证“拖动半天没反应”的体验问题：前端不再把 pointerdown/move/up 分散转发，也不再丢弃快速 move，而是在本地记录完整拖动轨迹，松手后通过一个 `drag` 请求发送 `points`。
- `cookie_service` sidecar 新增 `drag` pointer action：收到轨迹后用 Playwright mouse API 执行 move 起点、down、逐点 move、up，并在完成后刷新截图。
- 该修复仍只影响独立前端和 Cookie sidecar，不改变下载后端核心逻辑。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 12 passed；`python -m pytest tests\test_cookie_service.py -q` 19 passed；`python -m pytest tests -q` 401 passed, 1 skipped；Docker Compose 已重建并启动，后端和 Cookie sidecar healthy，前端 `http://localhost:51597/` 返回 200；浏览器烟测确认拖动会发送 `action: "drag"` 和 `points`。
## 2026-07-06 登录助手与队列易用性增强

- 独立前端继续按“好用易用”方向优化：Cookie 扫码弹窗新增拖动轨迹 SVG 覆盖层，用户拖动滑块时能看到路径；松手后仍通过 `drag + points` 发送完整轨迹给 sidecar。
- Cookie sidecar 的公共 session 状态新增诊断字段：`browser_ready`、`last_screenshot_at`、`last_pointer_action`、`last_pointer_at`。这些字段只暴露状态元数据，不暴露 Cookie。
- 前端 Cookie 弹窗新增诊断展示：浏览器连接状态、截图刷新状态、最近操作，减少“没反应”的不确定性。
- 任务队列新增易用操作：复制任务 ID、复制任务链接、失败任务一键重试。重试复用现有 `/api/v1/download`，不新增下载后端契约。
- 本次仍保持边界：主要修改 `frontend/`、`cookie_service/` 和测试，不改变核心下载逻辑。
- 验证：`python -m pytest tests -q` 402 passed, 1 skipped；`node --test tests\frontend_cookie_flow.test.mjs` 14 passed；Docker Compose 已重建启动，`douyin-downloader` 与 `cookie-login` healthy，`frontend` 监听 `http://localhost:51597/`；浏览器烟测确认失败任务重试、队列按钮、Cookie 诊断状态、拖动轨迹层和 `drag + points` 请求均生效。
## 2026-07-06 队列状态与扫码交互可用性修复

- 独立前端继续按“可用、易用、不影响原后端核心逻辑”的边界推进，主要修改 `frontend/` 与测试。
- 修复任务状态不一致：后端可能返回 `success`，前端现在统一归一为 `completed`，因此“已完成”筛选、状态样式和队列表格显示一致。
- 修复 Cookie 扫码拖动坐标偏移：截图真实比例为 `1280x900`，前端截图区域改为 `aspect-ratio: 1280 / 900`，坐标换算也会扣除 `object-fit: contain` 留白，提升滑块拖动命中率。
- Cookie 登录失败时优先展示 sidecar 返回的脱敏 `error`，不再只显示通用“登录未完成”；队列自动刷新失败时会提示“当前数据可能已过期”。
- 批量重试失败任务时，只要有任务创建成功就立即刷新队列，即使后续部分链接失败，用户也能马上看到已创建的重试任务。
- 使用 subagent 做了只读可用性审查，发现并确认上述 5 个缺口；主线程已完成修复。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 21 passed；`python -m pytest tests\test_frontend.py -q` 5 passed；`python -m pytest tests -q` 402 passed, 1 skipped；Docker 已重建前端，`douyin-downloader` 和 `cookie-login` healthy，`http://localhost:51597/` 返回 200；Playwright 使用系统 Chrome 冒烟确认 `success -> completed`、失败重试和截图比例生效。
## 2026-07-06 队列批量处理增强

- 独立前端 `http://localhost:51597/` 的任务队列继续增强易用性，仍只修改 `frontend/` 与对应测试，不改变下载后端 API 契约。
- 队列新增状态摘要：显示全部、运行中、失败、已完成数量，用户无需手动数表格行。
- 队列新增“复制失败链接”按钮：把所有失败任务 URL 按行复制到剪贴板，方便人工排查、重新整理或外部保存。
- 当当前队列没有失败任务时，“复制失败链接”和“重试失败任务”自动禁用，减少无效点击。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 23 passed；`python -m pytest tests\test_frontend.py -q` 5 passed；`python -m pytest tests -q` 402 passed, 1 skipped；Docker 已重建前端，`http://localhost:51597/` 返回 200；Playwright 使用系统 Chrome 冒烟确认复制失败链接、队列摘要和无失败任务禁用状态生效。
## 2026-07-06 队列搜索增强

- 独立前端 `http://localhost:51597/` 的任务队列新增本地关键词搜索，不改变后端 API 契约。
- 搜索框支持按任务 ID、URL、错误信息、原始状态和归一化状态过滤任务；可与状态筛选叠加使用。
- 该功能用于任务较多时快速定位失败项、特定链接或特定错误原因。
- 验证：先写失败测试再实现；`node --test tests\frontend_cookie_flow.test.mjs` 24 passed；`python -m pytest tests\test_frontend.py -q` 5 passed；`python -m pytest tests -q` 402 passed, 1 skipped；Docker 已重建前端，`http://localhost:51597/` 返回 200；Playwright 使用系统 Chrome 冒烟确认按错误信息搜索、与已完成筛选叠加、再搜索 completed/success 任务均生效。
## 2026-07-06 网络断开错误提示修复

- 用户在独立前端 `http://localhost:51597/#queue` 保存配置时看到原始 `Failed to fetch`。
- 调试确认当时 Docker Desktop Linux engine 未运行：`docker compose ps` 无法连接 Docker API，`http://localhost:51596` 和 `http://localhost:51597/api/v1/settings` 都无法连接；不是后端业务校验错误。
- 前端修复：`frontend/app.js` 的统一 `requestJson()` 现在会捕获 `fetch` 网络级 `TypeError / Failed to fetch`，转换为可操作中文提示：`无法连接服务，请确认 Docker 服务正在运行后重试`。该处理覆盖保存配置、创建任务、队列刷新和 Cookie sidecar 请求。
- 已启动 `com.docker.service` 并重建前端容器，当前 `douyin-downloader`、`cookie-login` healthy，`frontend` 监听 `http://localhost:51597/`。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 25 passed；`python -m pytest tests\test_frontend.py -q` 5 passed；`python -m pytest tests -q` 402 passed, 1 skipped；Playwright 冒烟确认模拟网络失败时显示中文提示，真实保存配置返回“配置已保存”。

## 2026-07-06 Cookie 登录完成判定与前端代理修复

- 修复独立前端 Cookie 自动登录弹窗中“未出现二维码但已显示登录完成”的问题：`cookie_service/browser.py` 不再只凭 `ttwid`、`odin_tt`、`passport_csrf_token` 这类基础 Cookie 判定完成，必须同时出现真实登录态 Cookie（如 `sessionid`、`sid_tt` 或 `sid_guard`）才结束会话并写入共享 `.cookies.json`。
- 修复 Docker 重建后 `http://localhost:51597/cookie-api/*` 偶发 502：`frontend/nginx.conf` 使用 Docker DNS `127.0.0.11` 动态解析上游，并保留 `/cookie-api/` 到 sidecar 根路径的重写，避免 Nginx 缓存旧容器 IP。
- 当前部署状态：`docker compose up -d --build cookie-login frontend` 已完成，`douyin-downloader` 和 `cookie-login` healthy，`frontend` 监听 `http://localhost:51597/`；`GET /`、`GET /api/v1/health`、`GET /cookie-api/health` 均返回 200。
- 验证：`python -m pytest tests -q` 通过，结果为 402 passed, 1 skipped。

## 2026-07-06 Cookie 短信验证码输入通道

- 修复独立前端 Cookie 自动登录遇到抖音短信验证码时无法输入的问题：`frontend/index.html` 的登录弹窗新增验证码输入表单，`frontend/app.js` 会把验证码通过 `/cookie-api/session/{id}/verification-code` 发送到 Cookie sidecar。
- `cookie_service/app.py` 新增验证码接口，`cookie_service/session.py` 负责转发到当前 Playwright 会话并刷新截图，`cookie_service/browser.py` 会在远端页面中定位可见验证码输入框、填入验证码、触发输入事件并点击确认按钮；不会在公开 session 状态中返回验证码或 Cookie。
- 已重新构建并启动 Docker 服务：`douyin-downloader` 与 `cookie-login` healthy，`frontend` 监听 `http://localhost:51597/`；`GET /`、`GET /api/v1/health`、`GET /cookie-api/health` 均返回 200，页面包含 `cookieVerificationCode` 和 `/verification-code` 调用。
- 验证：新增测试先失败后实现；`python -m pytest tests -q` 通过，结果为 405 passed, 1 skipped；`node --test tests\frontend_cookie_flow.test.mjs` 通过，结果为 26 passed。

## 2026-07-06 Cookie 登录后保存提示自动处理

- 修复独立前端 Cookie 登录流程中抖音弹出“是否保存登录信息”时用户很难点击保存的问题：`cookie_service/browser.py` 新增 `confirm_login_save_prompt()`，在检测到真实登录态 Cookie 后、返回 Cookie 前自动点击远端页面中的“保存/确认/信任/记住”类可见按钮。
- 该逻辑只运行在 Playwright sidecar 内，不改变下载后端业务逻辑，也不暴露 Cookie 或验证码。
- 验证：先新增失败测试，再实现；`python -m pytest tests -q` 通过，结果为 406 passed, 1 skipped；`node --test tests\frontend_cookie_flow.test.mjs` 通过，结果为 26 passed。
- 已重新构建并启动 Docker：`douyin-downloader` 与 `cookie-login` healthy，`frontend` 监听 `http://localhost:51597/`；`GET /`、`GET /api/v1/health`、`GET /cookie-api/health` 均返回 200。

## 2026-07-06 Cookie 状态显示未配置修复

- 修复用户登录成功后独立前端仍显示 `Cookie 未配置` 的问题。根因是 `config.yml` 中存在占位配置 `cookies: { msToken: '' }`，后端启动时把这个只有空值的 Cookie 字典缓存进 `CookieManager`，导致后续不会读取 sidecar 写入的共享 `.cookies.json`。
- `server/app.py` 现在只有在配置 Cookie 至少存在一个非空值时才写入 `CookieManager`；如果配置 Cookie 全为空，则回退加载 `.cookies.json`。
- 新增回归测试：当 `config.yml` 只有空 Cookie 值且 `.cookies.json` 已由 sidecar 写入登录态时，`GET /api/v1/settings` 必须返回 `cookies_configured: true`，同时不泄露 Cookie 键值。
- 验证：`python -m pytest tests -q` 通过，结果为 407 passed, 1 skipped。Docker 后端已重建，当前 `GET http://localhost:51597/api/v1/settings` 返回 `cookies_configured: true`。

## 2026-07-06 前端 Cookie 状态自动同步

- 继续完善独立前端可用性：`frontend/app.js` 将配置表单填充与服务状态渲染拆开，新增 `refreshSettingsStatus()`，每 5 秒轻量刷新 `/api/v1/settings` 的服务与 Cookie 状态。
- 该刷新只更新侧边栏和概览中的 `服务在线/离线`、`Cookie 已配置/未配置` 状态，不覆盖用户正在编辑的下载目录、线程数、代理或 Cookie 表单内容。
- 新增前端流测试：后端从 `cookies_configured:false` 变为 `true` 时，状态文案自动更新为 `Cookie 已配置`，同时保留用户正在输入的配置字段。
- 验证：`node --test tests\frontend_cookie_flow.test.mjs` 27 passed；`python -m pytest tests -q` 407 passed, 1 skipped。Docker 前端已用已构建镜像单独替换启动，当前 `http://localhost:51597/app.js` 包含 `refreshSettingsStatus`，`GET /api/v1/settings` 返回 `cookies_configured: true`。

## 2026-07-07 Cookie 文件热重载与测试隔离修复

- 修复独立前端登录成功后仍显示 Cookie 未配置的后端路径：server/app.py 的设置接口和下载执行前现在会通过 CookieManager.reload_cookies() 从共享 .cookies.json 重新读取 Cookie，避免后端缓存旧的残缺 Cookie。
- cookies_configured 不再按任意 Cookie 非空判断，而是要求 	twid、odin_tt、passport_csrf_token 三个关键字段非空；接口仍不返回 Cookie 明文。
- 修复测试污染真实部署 Cookie 文件的问题：	ests/test_relogin_retry.py 不再使用默认 CookieManager() 写项目根目录 .cookies.json，改为写 	mp_path 下的临时文件。
- 当前本地项目根 .cookies.json 已被早前测试残留污染为残缺测试键，真实 Cookie 需要重新通过前端自动获取登录生成；修复后 sidecar 写入新文件无需重启后端即可被状态接口识别。
- 验证：python -m pytest tests -q 结果为 410 passed, 1 skipped；Docker 重建后 douyin-downloader 和 cookie-login healthy，http://localhost:51597/ 返回 200，/cookie-api/health 返回 ok。
## 2026-07-07 Cookie 登录架构合同收敛

- 已确认采用方案 B：保留下载后端 `/api/v1/settings` 作为正式设置 API，同时保持 `cookie_service/` sidecar 只负责 Playwright 登录会话、截图、pointer/验证码辅助和 Cookie 捕获。
- Cookie 同步边界收敛为：sidecar 筛选并写入 Compose 共享 `.cookies.json` 文件；下载后端通过 `CookieManager.reload_cookies()` 读取共享文件，并通过 `/api/v1/settings` 只暴露 `cookies_configured` 等安全状态，不返回 Cookie 明文。
- 已更新项目内设计/计划文档，使其不再描述旧的 `BACKEND_URL` / 后端内网同步方案。
- 本轮验证：`python -m pytest tests/test_cookie_service.py tests/test_frontend.py tests/test_server.py tests/test_cookie_deployment.py -q` 为 48 passed；`python -m pytest tests/ -q` 为 410 passed, 1 skipped；`node --test tests\frontend_cookie_flow.test.mjs` 为 27 passed。
- Docker 运行时验证未完成：当前本机 `docker compose config` 失败，CLI 报 `docker: unknown command: docker compose`，且读取 `C:\Users\Administrator\.docker\config.json` 被拒绝。
