# XianyuGou

## 2026-07-05 闲鱼商品导入防重复与筛选

- 商品导入新增同账号同闲鱼商品防重复：如果商品模板已带有相同 `source_xianyu_account_id` + `source_xianyu_item_id`，再次导入时不新建模板，只回填商品镜像的 `projected_template_id` 并计入跳过。
- 设置页商品导入弹窗新增导入状态筛选：未导入 / 已导入 / 全部，默认显示未导入，并在切换筛选时清空已选项，降低误导入风险。
- 验证：`python -m unittest discover -p 'test*.py'` 21 tests OK；`npm test -- --run` 91 tests passed；`npm run build` 通过；`docker compose up -d --build backend web` 成功；`http://localhost:15173`、`http://localhost:18001/api/health`、`/api/product-templates` 均返回 200。

## 2026-07-05 闲鱼商品按账号隔离导入

- 商品管理新增“从闲鱼导入”流程：设置页的商品模板 Tab 可选择闲鱼账号、拉取该账号商品镜像、预览后勾选导入为商品模板。
- 后端新增 `xianyu_items` 商品镜像表，按 `(account_id, item_id)` 唯一约束隔离不同闲鱼账号；接口包括 `sync-items`、`items` 列表和 `items/import-templates`。
- 导入模板时写入 `source_xianyu_account_id` 与 `source_xianyu_item_id`，保留来源账号和平台商品 ID；不会跨账号导入或去重。
- 复用现有加密 Cookie / MTOP 客户端，商品列表接口确认为 `mtop.idle.web.xyh.item.list`；前端和接口响应不暴露 `raw_item` 或敏感凭证。
- 验证：`python -m unittest discover -p 'test*.py'` 20 tests OK；`npm test -- --run` 90 tests passed；`npm run build` 通过；`docker compose up -d --build backend web` 成功；`http://localhost:15173`、`http://localhost:18001/api/health`、`/api/product-templates`、`/api/xianyu/accounts` 均返回 200。

## 2026-07-05 镜像订单投影状态筛选

- 镜像订单弹窗新增投影状态筛选：全部 / 已生成交易 / 未生成交易，方便直接定位已拉取但尚未生成交易的订单。
- 前端新增 `filterXianyuOrdersByProjection` helper，按 `projected_transaction_id` 过滤镜像订单；测试覆盖 `all/projected/unprojected` 三种状态。
- 验证：`npm test -- --run tests/services/xianyuService.test.ts` 7 tests passed；`npm test -- --run` 87 tests passed；`python -m unittest discover -p 'test*.py'` 15 tests OK；`npm run build` 通过；`docker compose up -d --build web` 成功；`http://localhost:15173` 返回 200。

## 2026-07-05 镜像订单投影汇总

- 镜像订单弹窗顶部新增汇总文案：共多少单、已生成交易多少单、未生成交易多少单，帮助解释“同步拉取成功但新增 0”的原因。
- 前端新增 `summarizeXianyuOrders` helper，按 `projected_transaction_id` 统计镜像订单投影状态。
- 扩展 `tests/services/xianyuService.test.ts` 覆盖镜像订单汇总；同步相关 service 测试增至 6 个。
- 验证：`npm test -- --run` 86 tests passed；`npm run build` 通过；`python -m unittest discover -p 'test*.py'` 15 tests OK；`docker compose up -d --build web` 成功；`http://localhost:15173` 返回 200。

## 2026-07-05 闲鱼同步结果直达镜像订单

- 订单同步页在同步结果 Alert 中新增“查看镜像订单”按钮；当本次同步 `fetched > 0` 时，用户可直接打开对应账号的镜像订单列表，确认平台订单已拉取并安全脱敏展示。
- 前端新增 `hasSyncedOrdersToView` helper 控制是否显示该入口，避免没有拉取到任何平台订单时展示无效操作。
- 扩展 `tests/services/xianyuService.test.ts` 覆盖入口显示判断；同步结果相关 helper 测试增至 5 个。
- 验证：`npm test -- --run` 85 tests passed；`npm run build` 通过；`python -m unittest discover -p 'test*.py'` 15 tests OK；`docker compose up -d --build web` 成功；`http://localhost:15173` 返回 200。

## 2026-07-05 闲鱼同步“无新增”结果提示完善

- 前端新增 `formatSyncResultMessage`，统一格式化订单同步结果；当接口成功拉取到订单但 `created_count=0` 时，明确提示“无新增”，并说明订单之前已同步或不是成交订单，已按订单号安全跳过。
- 订单同步页 toast 与结果 Alert 统一使用该文案，避免用户把“拉取成功但新增 0”误解为没有同步到账户订单数据。
- 扩展 `tests/services/xianyuService.test.ts` 覆盖“成功但无新增”的文案。
- 验证：`npm test -- --run` 84 tests passed；`npm run build` 通过；`python -m unittest discover -p 'test*.py'` 15 tests OK；`docker compose up -d --build web` 成功；`http://localhost:15173` 返回 200。

## 2026-07-05 闲鱼同步前端并发提示完善

- 前端 `xianyuService.syncOrders` 增加同账号本地 in-flight 防重：同一账号已有同步请求未结束时，第二次调用不再发送后端请求，直接提示“该账号订单同步正在进行中，请稍后再试”。
- 后端返回 HTTP 409 时，前端统一转换为稳定中文提示，避免把不稳定的后端 detail 直接透出给用户。
- 扩展 `tests/services/xianyuService.test.ts` 覆盖 409 提示与本地重复调用拦截。
- 由于 web 镜像构建时 `npm ci` 发现 `package-lock.json` 与 `package.json` 不一致，已用 `npm install --package-lock-only` 重新生成锁文件，使 Docker web 构建恢复可用。
- 验证：`npm test -- --run` 83 tests passed；`npm run build` 通过；`python -m unittest discover -p 'test*.py'` 15 tests OK；`docker compose up -d --build web` 成功；`http://localhost:15173` 返回 200。

## 2026-07-05 闲鱼订单同步并发保护与部署验证

- 修复：`sync_orders_for_account` 增加按账号粒度的内存锁；同一账号已有同步任务运行时，后续同步请求立即返回冲突错误，避免重复点击导致并发拉取/写入互相干扰。
- 接口：`POST /api/xianyu/accounts/{account_id}/sync-orders` 捕获并发同步错误并返回 HTTP 409。
- 验证：`python -m unittest discover -p 'test*.py'` 15 tests OK；`python -m compileall -q app` 通过；`docker compose up -d --build backend` 已重建并启动后端；重建后实际同步返回成功，拉取 37 条，新增 0 条、跳过 37 条，账号在线且无最近错误。
- 说明：新增 0 条是订单号去重生效后的预期结果；本记录不包含任何 Cookie、Token 或订单明细。

## 2026-07-05 MTOP token 自动刷新修复

- 根因：MTOP token 过期时同时下发新的 `_m_h5_tk` 与 `_m_h5_tk_enc`，旧客户端只更新前者，重试时因 token 对不匹配返回 `FAIL_SYS_TOKEN_ILLEGAL`。
- 修复：自动刷新时同步更新两个 token，并将更新后的完整 Cookie 重新加密持久化到账户。
- 验证：使用原过期 Cookie 自动恢复，拉取 37 条订单；账号恢复在线且错误清空。后端重启后再次同步成功，确认刷新结果已持久化。
- 回归测试：新增 `test_mtop_client.py`，并扩展 `test_order_service.py` 覆盖刷新 token 配对与 Cookie 持久化。

## 2026-07-04 闲鱼订单同步兼容修复

- 根因：闲鱼卖家订单接口响应已改为 `module.items`，订单号、买家、商品、价格和时间字段也改为嵌套结构；旧解析器将成功响应误判为 0 单。
- 修复：兼容新响应与字段结构，按 `module.nextPage` 翻页，只导入交易成功订单，并保留订单号去重。
- 验证：接口拉取 37 条，其中 25 条交易成功、12 条非成功；首次同步新增 25 条，重复同步新增 0 条；25 条同步交易均写入有效价格和质保日期。
- 回归测试：`server/backend/test_order_service.py` 覆盖新响应解析、嵌套字段、状态过滤和分页。

## 2026-07-04 本地 Docker 部署

- 仓库：`https://github.com/mjs618/xianyugou.git`
- 本地路径：`E:\project\xianyugou`
- 项目结构：Vite/React 前端、Node 邮件服务、Python FastAPI 后端，使用 `docker-compose.yml` 启动三项服务。
- 原始端口冲突：`5173` 被已有容器 `seo2-web-1` 占用，`8000` 与本机已有服务冲突，`3001` 也无法作为邮件服务宿主机端口发布。
- 最终本机访问地址：前端 `http://localhost:15173`，后端 `http://localhost:18001`，邮件服务 `http://localhost:13001`。

## 2026-07-04 Docker 配置优化

- `docker-compose.yml` 支持通过 `WEB_PORT`、`BACKEND_PORT`、`MAIL_PORT` 覆盖宿主机端口，默认分别为 `15173`、`18001`、`13001`。
- 前端构建参数注入 `VITE_BACKEND_URL` 和 `VITE_MAIL_SERVER_URL`，默认随 `BACKEND_PORT` 和 `MAIL_PORT` 展开，避免源码写死本机端口。
- 后端 CORS 改为读取 `CORS_ORIGINS`，Compose 默认随 `WEB_PORT` 展开。
- 根 `Dockerfile` 改为 `NODE_VERSION` 构建参数，默认 `20-alpine`，不再依赖已 EOL 的 `node:18-alpine`。
- 后端 `server/backend/Dockerfile` 保留 Python wheel 安装路径，移除 apt/gcc 依赖，并修正依赖复制层。
- Docker Desktop 曾停止，恢复方式是启动 `com.docker.service` 后再启动 `D:\docker\Docker Desktop.exe`。

## 验证结果

- `docker compose up -d --build web` 通过，前端 TypeScript/Vite 构建通过。
- `docker compose ps`：`xianyugou-web`、`xianyugou-backend`、`xianyugou-mail` 均为 Up。
- `http://localhost:15173` 返回 200。
- `http://localhost:18001/api/health` 返回 `{"ok":true,"service":"xianyu-backend",...}`，并带有 `access-control-allow-origin: http://localhost:15173`。
- `http://localhost:13001/api/health` 返回 `{"ok":true,"service":"mail-server",...}`。
- 前端构建产物包含 `localhost:18001` 和 `localhost:13001`。

## 2026-07-04 前端“数据加载失败”排障

- 现象：浏览器首页显示“数据加载失败”，提示无法连接默认后端 `http://localhost:18001`。
- 根因：`index.html` 的 CSP `connect-src` 仍只允许旧端口 `8000` 和 `3001`，浏览器拦截了前端请求 `http://localhost:18001/*`。
- 修复：将 CSP 本地连接白名单调整为 `http://localhost:*`、`http://127.0.0.1:*`、`ws://localhost:*`、`ws://127.0.0.1:*`，然后重建 web 容器。
- 验证：Playwright 使用系统 Chrome 打开 `http://localhost:15173`，控制台无错误，DOM 中渲染 13 个仪表盘卡片；等待页面 ready 后截图显示首页卡片和图表正常。

## 2026-07-05 安全订单同步基线与订单镜像层

- 分支：`codex/safe-order-lifecycle-sync`。
- 决策：继续采用保守同步路线；不承诺 Cookie + 非官方 MTOP 能完全避免闲鱼风控，只做低频、串行、fail-closed、不绕过验证码/风控的安全实现。
- P0 安全基线：`server/backend/data/secret.key` 已从 Git 跟踪中移除并加入忽略；Docker 默认端口绑定到 `127.0.0.1`；前端/后端/邮件服务默认本机端口对齐；既有数据库存在但密钥缺失时后端拒绝启动，避免静默生成新密钥导致旧密文不可解。
- MTOP 脱敏：非 JSON 响应不再把原始响应片段写入 `MtopError`，避免 Cookie/Token 或网关正文泄漏到日志/前端错误。
- 订单同步可靠性：兼容当前 `module.items`、嵌套订单字段、`module.nextPage` 翻页；只投影交易成功/完成类订单；自动刷新 `_m_h5_tk` 时同步保存匹配的 `_m_h5_tk_enc` 并重新加密持久化 Cookie。
- 订单镜像层：新增 `xianyu_orders`，按 `(account_id, order_no)` 唯一幂等保存平台订单快照和提取字段；同步流程先写镜像，再做交易投影，避免把平台源数据直接压扁成 `transactions`。
- 提交：`1c83fd9` 设计文档；`0453b26` 密钥退出版本控制；`6c796fc` 缺失密钥 fail-closed；`5da2550` MTOP parse 错误脱敏；`c2051d5` 订单镜像层。
- 验证：`python -m pytest server/backend -q` 17 passed；`npm test -- --run` 80 passed；`npm run build` 最终复测 exit 0（保留既有 Vite use-client/chunk-size 警告）。
- 未闭环：Git 历史中曾提交过旧 `secret.key`，应在受控维护窗口轮换密钥/重新录入敏感配置；本地仍有未提交的 `package-lock.json` 机械变更、`server/backend/Dockerfile`、`.playwright-cli/`、`src/vite-env.d.ts`。
## 2026-07-05 镜像订单查询接口

- 新增提交：`01bfbd0 feat: expose sanitized xianyu order mirrors`。
- 后端新增 `GET /api/xianyu/accounts/{account_id}/orders`，返回账号下 `xianyu_orders` 镜像订单列表，按 `last_seen_at` 倒序；响应不包含 `raw_order`，避免前端暴露平台原始响应。
- 前端新增 `XianyuOrder` 类型与 `listOrders(accountId, limit)` service 方法；本步未改页面布局，保持范围最小。
- 验证：新增 `server/backend/test_xianyu_order_routes.py` 覆盖接口返回脱敏镜像；`python -m pytest server/backend -q` 18 passed；本步实现前也跑过 `npm test -- --run` 80 passed 和 `npm run build` 通过。
## 2026-07-05 订单同步页镜像订单查看

- 新增提交：`089f805 feat: show sanitized xianyu order mirrors`。
- 订单同步页每个账号新增“镜像”按钮，可打开只读订单镜像表，展示订单号、买家、商品、状态、金额、交易时间、最近同步时间。
- 前端 `xianyuService.listOrders` 增加防御：即使后端意外返回 `raw_order`，也会在归一化时丢弃，避免平台原始响应继续传给页面。
- 新增 `tests/services/xianyuService.test.ts` 覆盖 `listOrders` 调用参数、日期归一化和 `raw_order` 脱敏。
- 验证：`npm test -- --run` 12 files / 81 tests passed；`npm run build` 通过；`python -m pytest server/backend -q` 18 passed。## 2026-07-05 镜像订单投影状态回填

- 新增提交：`de9bba9 feat: track xianyu order projections`。
- 后端同步流程在写入 `xianyu_orders` 镜像后，会把新建或已存在的 `transactions.id` 回填到 `projected_transaction_id`；已有交易查询前移到订单完成状态过滤之前，确保历史已投影订单即使平台状态变化也能显示已生成。
- 前端订单同步页的镜像订单表新增“投影”列，按 `projected_transaction_id` 显示“已生成 / 未生成”；不展示 `raw_order`。
- 新增 `server/backend/test_xianyu_order_projection.py`，覆盖新建交易回填、已有交易回填、非完成状态但已有交易仍回填三个场景。
- 验证：`python -m pytest server/backend -q` 21 passed；`npm test -- --run` 81 passed；`npm run build` 通过（保留既有 Vite use-client 和 chunk-size 警告）。

## 2026-07-08 闲鱼账号编辑接口补齐

- 修复前端 `updateAccount()` 调用 `PATCH /api/xianyu/accounts/{account_id}` 但后端未暴露对应路由的问题；后端新增 `XianyuAccountUpdate` schema 和账号更新 PATCH 路由，复用既有 `account_service.update_account()`。
- 新增 `server/backend/test_xianyu_account_routes.py` 覆盖账号备注更新、响应脱敏和不暴露 Cookie；扩展 `tests/services/xianyuService.test.ts` 覆盖前端 `updateAccount()` PATCH 调用与日期归一化。
- 验证：`npm run check` 通过；`npm run test -- tests/services/xianyuService.test.ts` 12 tests passed；`python -m unittest test_xianyu_account_routes test_order_service test_xianyu_order_routes test_xianyu_item_service test_xianyu_item_routes` 15 tests OK。后端测试仍有既有 `datetime.utcnow()` 弃用警告。

## 2026-07-08 闲鱼商品导入参数与后端校验
- 设置页“从闲鱼导入商品”弹窗新增导入参数：默认成本和质保天数；打开弹窗时默认成本为 0，质保天数优先使用系统默认质保天数，导入时传给 `items/import-templates`。
- 后端 `XianyuItemImportRequest` 增加校验：`default_cost >= 0`，`warranty_days >= 1`，非法导入参数在路由层返回 422，避免创建不可用商品模板。
- 验证：`python -m pytest server/backend -q` 31 passed；`npm test -- --run` 92 passed；`npm run build` 通过（保留既有 Vite use-client/chunk-size 警告）。

## 2026-07-08 Docker 镜像重建与服务更新
- 执行 `docker compose up -d --build`，按当前工作区重新构建并替换 `web`、`backend`、`mail` 三个服务容器。
- 更新后端口绑定均为本机回环：web `127.0.0.1:15173`，backend `127.0.0.1:18001`，mail `127.0.0.1:13001`。
- 验证：`docker compose ps` 三个容器 Up；`http://localhost:15173` 返回 200；`http://localhost:18001/api/health` 返回 200；`http://localhost:13001/api/health` 返回 200。

## 2026-07-09 闲鱼订单投影匹配商品模板
- 订单同步投影交易时新增按闲鱼商品 ID 匹配已导入商品模板：从订单 `itemVO.itemId` 等字段提取商品 ID，按同账号 `source_xianyu_account_id` + `source_xianyu_item_id` 查找启用模板。
- 命中模板时，新建交易会写入 `product_template_id`，并使用模板 `default_cost` 和 `warranty_days` 计算利润与质保，避免同步订单继续以成本 0 和系统默认质保入账。
- 验证：新增后端回归测试覆盖订单 `itemId` 命中模板；`python -m pytest server/backend -q` 32 passed；`npm test -- --run` 92 passed；`npm run build` 通过（保留既有 Vite use-client/chunk-size 警告）。

## 2026-07-09 CookieCloud 中期方案准备
- 项目：xianyugou。已在后端接入 CookieCloud 可选刷新链路：配置 COOKIE_CLOUD_HOST/UUID/PASSWORD 后，订单/商品同步遇到 AUTH_FAIL 会拉取 goofish.com Cookie，校验通过后加密保存并重试一次。
- 安全边界：不保存/记录真实 Cookie 或凭证；验证码、滑块、风控不绕过，仍交由人工处理。
- 验证：server/backend pytest 36 passed；前端 npm test 92 passed；npm run build 通过。
- 待办：部署前在运行环境配置 CookieCloud env，并由浏览器插件同步最新 goofish.com 登录态；需要时再重建镜像更新服务。

## 2026-07-09 镜像重建与服务重启
- 已执行 docker compose up -d --build，构建 xianyugou-backend、xianyugou-web、xianyugou-mail 镜像；backend 容器重建。
- 已执行 docker compose restart，backend/mail/web 全部重启。
- 验证：docker compose ps 三个服务均 Up；web / 返回 200；backend /docs 返回 200；mail /api/health 返回 ok。
- 备注：构建期间仍有既有 Vite use client 与 chunk size 警告，不影响本次启动。

## 2026-07-09 商品同步入口前置
- 问题：用户在当前界面看不到如何同步商品信息；原能力藏在设置页商品模板导入弹窗内。
- 处理：在闲鱼同步页账号操作区新增“同步商品”和“商品镜像”入口；同步成功后可查看商品镜像摘要、价格、状态、模板导入状态和最近同步时间。
- 前端服务：syncItems 增加本地并发保护，并将 409 冲突转换为稳定提示。
- 验证：xianyuService 单测 14 passed；完整前端测试 94 passed；npm run build 通过；docker compose up -d --build 后 web/backend 探活 200。
- 备注：构建期间仍有既有 Vite use client 与 chunk size 警告，不影响启动。

## 2026-07-09 商品同步返回 0 的修复
- 问题：闲鱼同步页点击“同步商品”后提示拉取 0 个商品、更新 0 个镜像。
- 根因：闲鱼商品接口实际返回结构为顶层 cardList，每项商品在 cardData 内；原解析器只覆盖 module.cardList/items 等旧路径，导致成功响应被解析为空列表。
- 修复：item_service 增加顶层 cardList 解析，支持 cardData 展平，并兼容顶层 nextPage 分页字段。
- 验证：新增后端测试覆盖顶层 cardList；server/backend pytest 37 passed；重建 backend 镜像后账号 2 商品同步返回 fetched=8、upserted_count=8；商品镜像接口可读取到 8 条摘要；backend /docs 返回 200。
- 安全：诊断仅查看响应结构摘要，未记录 Cookie 或凭证；临时诊断脚本已删除。

## 2026-07-09 商品模板账号分类与图片修复
- 问题：闲鱼导入到商品模板后，列表只显示“闲鱼导入”分类，看不出来源账号；模板也没有图片字段，导致图片在导入链路中丢失。
- 根因：xianyu_items 有 account_id/image_url，但 ProductTemplate 模型、schema、前端类型和模板列表未保存/展示 image_url；设置页未为模板列表加载闲鱼账号映射。
- 修复：ProductTemplate 增加 image_url；导入模板时写入镜像图片，已有模板缺图时补齐；SQLite 启动迁移新增 image_url 并按 source_xianyu_account_id/source_xianyu_item_id 从 xianyu_items 回填。
- 前端：设置页商品模板表新增图片列和来源账号列，来源账号支持筛选；阿里 heic 图片展示时转为可展示缩略图 URL；初始化设置页时加载闲鱼账号映射。
- 验证：后端 pytest 37 passed；前端 productTemplateService 8 passed；完整前端测试 95 passed；npm run build 通过；docker compose 重建后 web/backend 200，product-templates API 返回 image_url/source_xianyu_account_id。

## 2026-07-09 商品模板账号筛选增强
- 在已有来源账号列基础上，商品模板页工具栏新增来源筛选：全部模板、手动模板、各闲鱼账号模板，并显示数量。
- 图片展示增加失败兜底：外链缩略图加载失败时显示“无图”，避免空白误判为列表丢字段。
- 验证：productTemplateService 8 passed；完整前端测试 95 passed；npm run build 通过；docker compose up -d --build web 后 web 返回 200。

## 2026-07-09 擦亮费/运营支出计入财务
- 问题：财务统计只聚合订单收入、商品成本和返利统计，闲鱼擦亮费没有独立记账入口，因此不会计入总成本和净利润。
- 修复：新增 OperatingExpense/运营支出模型、schema、服务和 `/api/expenses` CRUD；默认类型支持“擦亮”，财务页可新增/删除运营支出并查看明细。
- 财务口径：`totalCost = 商品成本 + 运营支出`，`totalProfit = 总收入 - totalCost`；趋势和月度对比按支出发生日期扣减利润。商品利润排行暂不分摊运营支出，避免把一笔擦亮费错误归到具体商品。
- 备份恢复：迁移服务加入 `operating_expenses`，避免导出/导入时丢失擦亮费记录。
- 验证：新增后端财务测试覆盖运营支出计入总览/趋势/月度；server/backend pytest 39 passed；前端 vitest 99 passed；npm run build 通过；docker compose up -d --build 后 web/backend 探活 200，`/api/expenses` 返回 200。

## 2026-07-09 质保按发货时间起算与订单质保开关
- 决策：交易新增发货时间 shipped_at；质保到期按 shipped_at + warranty_days 计算，缺少 shipped_at 时兼容使用交易时间。财务交易时间 trade_at 不改，避免影响收入统计口径。
- 无质保口径：订单可关闭质保，使用 warranty_days=0 且 warranty_end=null 表示；不进入质保看板和到期提醒。
- 闲鱼同步：订单投影交易时解析 consignTime/sellerShipTime/shipTime/sendTime 等发货字段，优先作为质保起算时间。
- 前端展示：交易表单新增“订单质保”开关和“发货时间（质保起算）”；交易详情、质保看板、交易导出显示发货时间。
- 验证：npm run check、npm test（99 passed）、server/backend python -m unittest discover（34 passed）、npm run build 通过。

## 2026-07-09 售后超时跟进提醒
- 功能：通知检查新增售后跟进提醒；待处理工单超过 24 小时、处理中工单超过 48 小时，会生成 aftersales_pending 通知，并按当天同工单去重。
- 前端：售后工单页新增“超时未完成”统计、“超时”筛选 Tab 和行内红色超时小时数标识。
- 验证：新增后端通知服务测试覆盖超时生成和同日去重；npm run check、npm test（99 passed）、server/backend python -m unittest discover（36 passed）、npm run build 通过。

## 2026-07-09 售后提醒通知定位工单
- 功能：通知中心点击 aftersales_pending 提醒时，如果通知带 ref_id，则跳转到 `/after-sales?ticketId=<工单ID>`。
- 前端：售后工单页读取 ticketId 参数，自动清空筛选并用“定位”标签和高亮行标出目标工单；通知跳转逻辑抽成 `src/utils/notificationNavigation.ts` 并补单测。
- 验证：新增 notificationNavigation 单测；npm run check、npm test（101 passed）、server/backend python -m unittest discover（36 passed）、npm run build 通过。

## 2026-07-09 导航待办徽标
- 功能：侧边栏和移动底栏在质保、售后、财务入口显示待办数量徽标，分别对应 warrantyUrgent、afterSalesPending、rebatePending。
- 前端：新增 `src/utils/navigationBadges.ts` 映射导航路径到待办数量；`PendingSummary` 抽为前端类型，MainLayout 直接使用 store 中的 pendingSummary 展示 Badge。
- 验证：新增 navigationBadges 单测；npm run check、npm test（103 passed）、server/backend python -m unittest discover（36 passed）、npm run build 通过。

## 2026-07-09 折叠侧栏待办徽标
- 前端导航增加折叠态徽标：桌面侧栏收起时，质保/售后/财务待办数量显示在图标上；展开态和移动端底部导航保持徽标显示。
- 抽出 src/utils/layoutNavigation.ts 并添加 tests/utils/layoutNavigation.test.ts 覆盖折叠/展开行为。
- 验证：npm run check、npm test（105 passed）、npm run build 通过；构建仍有既有 use client 和大 chunk 警告。

## 2026-07-09 售后提醒定位分页闭环
- 使用 subagent 勘察后选择完善售后提醒定位：`/after-sales?ticketId=<id>` 命中第 2 页及以后工单时，售后列表会自动切到目标所在页并保留高亮。
- 新增 `src/utils/pagination.ts`，覆盖目标记录页码计算和数据缩小后的页码 clamp，避免受控分页停在空页。
- 验证：subagent 规格审查通过；代码质量审查发现 P2 后已修复并复审通过；`npm run check`、`npm test`（108 passed）、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 交易详情质保操作收敛
- 交易详情页的质保操作与“订单可选择是否质保”对齐：只有已完成、质保天数大于 0、且已有质保到期时间的订单才显示“延长质保/提前结束”。
- 在 `src/utils/warranty.ts` 新增 `canManageWarranty`，并添加 `tests/utils/warranty.test.ts` 覆盖不质保、待发货、售后中等不可维护场景。
- 验证：`npm run check`、`npm test`（109 passed）、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 交易详情质保起算文案
- 交易详情页质保信息的“起算时间”与质保开关对齐：不质保显示“不质保”，有质保但未发货显示“发货后起算”，已发货显示实际发货时间。
- 在 `src/utils/warranty.ts` 新增 `getWarrantyStartLabel`，并扩展 `tests/utils/warranty.test.ts` 覆盖起算文案。
- 验证：`npm run check`、`npm test`（110 passed）、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 质保看板起算展示统一
- 质保看板卡片和列表视图统一使用 `getWarrantyStartLabel` 展示起算信息：不质保、发货后起算、实际发货时间与交易详情页一致。
- 看板标题和日历说明强调“质保按发货时间起算”，减少与交易时间混淆。
- 验证：`npm run check`、`npm test`（110 passed）、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 商品模板默认不质保
- 商品模板支持 `warranty_days=0` 表示默认不质保；手动新增/编辑模板和闲鱼商品导入模板入口都允许填写 0。
- 模板列表质保天数显示统一为 `不质保` / `N 天`，复用 `getWarrantyDaysLabel`；前端服务测试覆盖 `warranty_days=0` 原样提交。
- 验证：`npm run check`、`npm test`（112 passed）、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 商品模板不质保后端闭环
- 后端商品模板创建/编辑和闲鱼商品导入模板接口统一允许 `warranty_days=0` 表示不质保，并通过 Pydantic `ge=0` 拒绝负数。
- 修复商品模板 `PATCH` 后响应序列化不稳定：更新模板时显式写入 `updated_at`，避免 SQLAlchemy `onupdate` 异步懒加载导致 `MissingGreenlet`。
- 修复 Windows/Node 22 下 Vite 3 构建路径问题：`vite.config.ts` 的 `root` 从 `process.cwd()` 固定为 `__dirname`，避免入口 HTML 被当作绝对输出名。
- 验证：后端 `python -m unittest discover` 40 passed；前端 `npm run check`、`npm test` 112 passed、`npm run build` 通过；仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 全局默认质保支持关闭
- 系统设置的默认质保周期支持 `warranty_days=0`，表示后续新订单默认不质保；前端设置页输入框最小值同步放宽到 0，并增加 0 的含义提示。
- 后端 settings 更新逻辑从“必须大于 0”改为“不能为负数”，负数仍会被拒绝。
- 验证：后端 `python -m unittest discover` 42 passed；前端 `npm run check`、`npm test` 113 passed、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-09 闲鱼同步结果与商品镜像筛选体验
- 订单同步和商品同步结果文案统一走前端 service helper：成功但无新增/无更新时明确说明“之前已同步或镜像一致”，避免误判为失败。
- 订单同步结果和商品同步结果在拉取到平台数据时提供“查看镜像订单/查看商品镜像”入口；商品同步无拉取结果时不再强制打开空镜像弹窗。
- 商品镜像弹窗新增“全部 / 已导入模板 / 未导入模板”筛选，并用汇总 helper 统计总数、已导入和未导入数量。
- 验证：先新增 xianyuService RED 测试确认 helper 缺失失败；实现后 `npm test -- tests/services/xianyuService.test.ts` 17 passed，`npm run check` 通过，`npm test` 18 files / 116 tests passed。
- 备注：后端测试未运行，因本轮只做前端体验和 service helper，且后端测试会触碰本地后端数据库/缓存状态。

## 2026-07-10 交易表单继承默认不质保
- 新建交易表单改为根据系统默认质保天数生成初始质保状态：`warranty_days=0` 时订单质保开关默认关闭，保存并继续后也保持关闭。
- 新增 `getWarrantyFormDefaults` 和 `getEnabledWarrantyDays`：开启质保时保证使用正数天数；如果当前和默认都是 0，则用 30 天作为手动开启质保的兜底周期。
- 验证：后端 `python -m unittest discover` 42 passed；前端 `npm run check`、`npm test` 118 passed、`npm run build` 通过；构建仍有既有 `use client` 和大 chunk 警告。

## 2026-07-10 闲鱼订单镜像投影状态补齐

- 根因：订单同步投影此前只把交易成功/完成类平台状态写入 transactions，待发货、已付款、已发货、待收货、退款处理中等设计文档要求投影的镜像订单会被状态过滤跳过，前端显示为“未生成交易”。
- 修复：订单投影新增平台状态到内部交易状态映射：已付款/待发货/已发货/待收货 -> pending；退款处理中/退款中/售后中 -> aftersales；交易成功/完成/部分退款成功 -> completed；全额退款成功只更新已有交易为 closed。已有 xianyu_order_no 的交易复用原投影并回填镜像 projected_transaction_id，避免重复创建。
- 前端：订单镜像汇总提示补充哪些状态会生成交易、哪些状态只保留镜像，便于解释“未生成交易”。
- 验证：python -m unittest test_xianyu_order_projection.py 7 tests OK；python -m unittest test_xianyu_order_mirror.py test_xianyu_order_projection.py test_xianyu_order_routes.py 10 tests OK；npm test -- tests/services/xianyuService.test.ts 19 tests passed；npm run check 通过。

## 2026-07-10 渐进式架构治理与阶段 0 基线保护

- 决策：继续采用模块化单体；FastAPI + SQLite 是唯一业务数据源，未来 12 个月保持单机、单用户、本地 Docker，不引入微服务、权限体系或新数据库。
- 安全边界：完整保留当前未提交成果和现有业务数据；每阶段必须可备份、可验证、可回滚，不接受清库重建。
- 文档：新增架构治理设计与阶段 0 实施计划，后续依次推进 Alembic、单一数据源收敛、后端模块治理、前端模块治理和性能运维闭环。
- 阶段 0：新增 SQLite 在线备份/校验工具，生成 SHA-256、完整性结果和表记录数清单；不读取业务字段值，不复制或打印密钥，不覆盖已有备份。
- Docker：新增自动加载的 `docker-compose.override.yml`，把容器 `/app/backups` 独立映射到宿主机忽略目录，数据库仍保留在 named volume。
- 验证：备份焦点测试 6 passed；后端 63 passed + 5 subtests；前端 120 passed；生产构建通过；真实预 Alembic 备份已创建并复验；web/backend/mail 健康检查均返回 200。
- 下一步：为阶段 1 编写并执行 Alembic 基线迁移计划，迁移前继续使用已验证备份作为回滚点。

## 2026-07-10 Alembic 数据库迁移体系

- 当前未提交的 71 个有效应用改动已完成安全检查并提交为 Alembic 前应用基线；`.playwright-cli/`、数据库、备份和密钥继续忽略。
- 后端新增 packaged Alembic 环境：`20260710_01` 为完整 ORM 空库基线，`20260710_02` 以幂等方式补齐历史手写迁移遗漏的商品来源和发货时间索引。
- 现有库接管流程先验证全部必需表和列，再 stamp 到基线并升级到 head；结构缺失时在写入版本号前停止。
- 应用启动已移除 `Base.metadata.create_all`、手写 `ALTER TABLE` 和 `_ensure_sqlite_columns`，现在只读校验数据库 revision；current 与 packaged head 不一致时拒绝启动。
- 真实 Docker 数据库已接管到 `20260710_02`，新后端容器启动正常；预 Alembic 备份再次复验通过。
- 验证：后端 68 passed + 5 subtests；前端 120 passed；生产构建通过；web/backend/mail 均 Up，三个 HTTP 健康检查均返回 200。
- 下一步：阶段 2 收敛单一数据源，审计并移除前端 Dexie 业务数据读写与旧迁移入口，仅保留非业务本地配置。

## 2026-07-10 阶段 2A 页面数据边界收敛

- 页面业务数据读取已统一经过后端服务：Dashboard、客户列表、客户详情和质保看板不再直接访问 Dexie；跨实体关联改为基于后端服务返回结果在内存中组合。
- 设置页移除旧“迁移到后端”入口、连接检测和双向覆盖逻辑；安全状态改为说明后端 AES-256-GCM 加密及数据库与 `data/secret.key` 配套备份要求。
- 前端启动链与服务层删除已迁移到后端的兼容空操作，包括本地字段迁移、推荐返利、客户统计重算和回收站清理占位函数。
- 新增 `backendDataBoundary.test.ts` 架构边界测试，防止页面重新引入业务 IndexedDB 或恢复已废弃迁移逻辑。
- 验证：前端 19 files / 124 tests passed，TypeScript 检查和生产构建通过；后端 68 passed + 5 subtests；Web 容器重建成功，容器映射端口 web/backend 均返回 200；Alembic current=head=`20260710_02`；预 Alembic 备份复验通过。
- 提交：`5e63f0f`、`4511815`、`5515850`。下一步进入阶段 2B，独立治理附件 Dexie、浏览器端备份密码加密工具和残余本地数据库依赖。

## 2026-07-10 阶段 2B 附件与本地存储收敛

- 附件统一由 FastAPI + SQLite BLOB 管理，新增上传、批量元数据、内容读取和删除 API；交易与售后继续保存字符串附件 ID，备份导入导出格式不变。
- 前端附件服务改走 multipart 后端 API，图片直接使用后端内容 URL；真实切换前核对附件与引用均为 0，因此没有需要迁移的现存附件数据。
- 浏览器端只保留 PBKDF2-SHA256 + AES-256-GCM 的完整 JSON 备份密码加密；旧字段加密、IndexedDB 主密钥库与 `crypto.ts` 已删除。
- Dexie、fake-indexeddb、`src/db` 和未使用的数据库测试助手已删除；架构边界测试禁止业务 IndexedDB 依赖回流。
- 验证：前端 21 files / 130 tests passed，TypeScript 与生产构建通过；后端 71 passed + 5 subtests；Backend/Web 容器重建成功且 HTTP 200；真实附件上传、SHA-256 内容比对、删除后 404 冒烟通过，测试附件清理后数量为 0；Alembic current=head=`20260710_02`，预 Alembic 备份复验通过。
- 提交：设计 `d331c28`，计划 `faab308`，实现 `c93c864`、`8ab26c2`、`d36fd35`、`4135949`。分支继续保留为 `codex/safe-order-lifecycle-sync`，后续进入阶段 3 后端模块边界治理。
- 已知未扩展范围：npm 仍报告既有依赖漏洞，Vite 仍有既有 `use client` 与大 chunk 警告；附件孤儿定时清理、缩略图、病毒扫描与对象存储不在当前单机范围内。

## 2026-07-10 阶段 3A 后端路由模块边界

- 原 `routers/settings.py` 同时承载设置、商品模板、财务、运营支出、审计和备份迁移六个领域，现已拆为六个独立模块，均统一导出 `router`，`main.py` 显式注册。
- 所有公开 URL、HTTP 方法、Query 边界、response model、异常状态码和路由层 `commit` 行为保持不变；数据库、Alembic 与前端调用无需迁移。
- 新增精确 method/path 路由契约测试和源码边界测试，防止领域重新混入 `settings.py` 或恢复间接多 router 注册。
- 重构中发现 `settings` 配置对象与同名路由模块碰撞，配置对象明确别名为 `app_settings`；安全基线测试从脆弱的局部变量名字符串断言改为匹配显式 `.cors_origin_list` 使用。
- 验证：前端 21 files / 130 tests passed，TypeScript 与生产构建通过；后端 73 passed + 5 subtests；后端容器重建成功，健康、设置、商品模板、财务、支出、审计和备份导出七个只读端点均返回 200；Alembic current=head=`20260710_02`，预 Alembic 备份复验通过。
- 提交：设计 `434a768`，计划 `49abb42`，实现 `40e33c5`。分支继续保留为 `codex/safe-order-lifecycle-sync`。
- 下一步：阶段 3B 独立治理 `schemas.py` 的领域边界；暂不触碰闲鱼订单/商品大服务，避免在路由拆分后立即扩大重构面。
## 2026-07-10 阶段 3B 后端 Schema 领域边界

- 原 400 行 `app/schemas.py`（40 个公开模型）已按客户、交易、售后、返利、支出、商品模板、设置、审计、迁移、附件、闲鱼等领域拆分为 `app/schemas/` 包。
- `app.schemas` 通过显式 `__all__` 保持原有导入门面，路由与服务调用方无需迁移；OpenAPI 名称、字段约束、数据库和公开 API 契约均未改变。
- 新增 Schema 边界测试，精确约束 40 个公开导出、代表模型的领域归属、关键 Pydantic 校验规则和 OpenAPI 组件，防止后续重新形成单文件聚合。
- 验证：前端 21 个文件 / 130 项测试通过，TypeScript 检查与生产构建通过；后端 77 passed + 5 subtests；后端容器重建成功，健康、设置、交易、闲鱼账号和 OpenAPI 五个端点均返回 200；Alembic current=head=`20260710_02`，预 Alembic 备份复验通过。
- 提交：设计 `63a8881`，计划 `43d248f`，实现 `ab77411`。分支继续保留为 `codex/safe-order-lifecycle-sync`，未合并、未推送。
- 下一步：阶段 3C 优先审计闲鱼订单与商品同步的大型服务边界，再选择一个可独立验证的最小拆分点；继续保持 API、数据库和同步行为不变。
## 2026-07-10 阶段 3C 闲鱼订单解析边界

- 审计确认闲鱼同步热点为 556 行 `order_service.py` 与 368 行 `item_service.py`；本阶段选择风险最低的订单载荷解析边界，不同时移动 ORM 投影或鉴权编排。
- 新增仅依赖标准库的 `order_parser.py`，集中负责订单字段提取、价格兼容、平台状态映射、MTOP 响应列表和交易/发货时间解析；网络、数据库、账号锁、Cookie 刷新、交易投影与同步日志继续留在 `order_service.py`。
- `order_service.py` 从 556 行降至 346 行，解析器为 224 行；公开同步服务入口、API、数据库与 OpenAPI 契约均保持不变。
- 新增解析器行为、函数归属和依赖边界测试；原 `test_order_service.py` 中直接调用私有解析函数的测试已迁移到新解析器公共接口。全量回归曾发现 3 个旧测试引用，确认生产代码无依赖后通过测试归属迁移解决，未在编排服务保留兼容别名。
- 验证：前端 21 个文件 / 130 项测试通过，TypeScript 检查和生产构建通过；后端 81 passed + 12 subtests；后端容器重建成功，健康、闲鱼账号、已有账号订单列表和 OpenAPI 均返回 200；Alembic current=head=`20260710_02`，预 Alembic 备份复验通过。
- 提交：设计 `27cffaf`，计划 `7ffef16`，RED 契约 `f52a329`，实现 `d3f8fb9`，测试归属校正 `d138aa1`，备份命令文档校正 `ef3cc2f`。分支继续保留为 `codex/safe-order-lifecycle-sync`，未合并、未推送。
- 下一步：阶段 3D 对 `item_service.py` 采用同样的最小纯解析器边界；保持商品镜像、模板导入、鉴权重试和 API 行为不变。
## 2026-07-10 阶段 3D 闲鱼商品解析边界

- 从 368 行 `item_service.py` 中抽离仅依赖标准库的 `item_parser.py`，集中负责卡片解包、商品 ID/标题/价格/状态/图片、列表响应和用户 ID 解析。
- MTOP 分页、CookieCloud 鉴权重试、账号状态、商品镜像和模板幂等投影继续留在服务；公开服务入口、API、数据库和 OpenAPI 契约不变。
- `item_service.py` 降至 221 行，解析器为 163 行；没有引入订单/商品通用解析基类、DTO 或分页抽象。
- 新增解析器行为、函数归属、标准库依赖和服务源码边界测试，并完成预期 RED→GREEN 验证；全仓库无调用方依赖旧私有解析函数，无需兼容别名。
- 验证：前端 21 个文件 / 130 项测试通过，TypeScript 检查和生产构建通过；后端 85 passed + 12 subtests；后端容器重建成功，健康、闲鱼账号、已有账号商品列表和 OpenAPI 均返回 200；Alembic current=head=`20260710_02`，预 Alembic 备份复验通过。
- 提交：设计 `f39255a`，计划 `b6ec838`，RED 契约 `c2315dc`，实现 `8e92963`。分支继续保留为 `codex/safe-order-lifecycle-sync`，未合并、未推送。
- 下一步：阶段 3E 审计剩余大型后端服务（优先财务、迁移和交易服务），选择一个纯计算或只读边界继续最小化拆分，避免同时触碰多领域事务。
## 2026-07-12 阶段 3E 财务纯计算边界

- 审计 312 行财务服务、298 行迁移服务和 299 行交易服务后，选择风险最低的财务纯计算层；迁移服务紧邻清库恢复，交易服务可抽离纯逻辑过少，均暂不处理。
- 新增 `finance_calculations.py`，独立负责月份范围、财务总览、商品利润排行、连续日趋势和跨年月对比；仅依赖标准库与既有 `round2`，不依赖 SQLAlchemy、ORM 或数据库会话。
- `finance_service.py` 从 312 行降至 189 行，计算模块为 165 行；服务继续负责时间窗口和 SQL 查询，所有公开函数、API 字段、统计口径和数据库行为保持不变。
- 新增纯计算行为、函数归属和依赖边界测试，并完成预期 RED→GREEN；现有财务集成测试保持原文件不变。
- 脏工作区保护：发现已有自动同步、账号恢复、数据库迁移、datetime 和前端构建优化等未提交改动；阶段 3E 仅精确暂存自身文件，用户原有改动完整保留且未纳入提交。
- 验证：后端 118 passed + 12 subtests；前端 21 个文件 / 132 项测试、TypeScript 检查和生产构建通过；财务聚焦/边界测试 9 passed，财务 OpenAPI 路径生成成功，宿主机预 Alembic 备份复验通过。
- 容器说明：Docker daemon 未运行；当前未提交 entrypoint 会自动把真实库迁移到新 `20260711_01`，因此未启动 Docker、未重建容器、未迁移或读取真实数据库。该项是有意的安全边界，不代表接口容器冒烟已验证。
- 提交：设计 `0d992a1`，计划 `7fc6008`，RED 契约 `aef91f9`，实现 `5dab3f4`。分支继续保留为 `codex/safe-order-lifecycle-sync`，未合并、未推送。
- 下一步：暂停继续叠加架构拆分，优先审计并闭环当前未提交的自动同步/迁移改动；完成其数据迁移安全验证和归属确认后，再进入阶段 3F。

## 2026-07-12 自动同步与迁移安全收口

- 自动同步安全边界已下沉到服务层：暂停账号在构造 MTOP 客户端前即被拒绝，订单与商品 API 返回 409；手动订单同步增加 60 分钟预检并返回 429，同账号并发锁继续保留。
- CookieCloud 刷新重试按真实 `risk`、`auth_fail`、`unknown` 分类；普通 invalid/risk 账号更新有效 Cookie 后恢复 online，paused 账号仍必须更新 Cookie 后显式恢复。
- 容器自动迁移在任何已有且未到 head 的 SQLite 库执行 adopt/upgrade 前创建并验证备份；空库不备份，备份失败保持旧 revision 并阻断启动。compose 已有 `/app/backups` 持久挂载，真实 Docker 数据库未启动或迁移。
- 健康响应兼容值恢复为 `service=xianyu-backend`，保留 `scheduler_running`；datetime 改为 timezone-aware API 后剥离时区，保持 SQLite naive UTC 口径。
- 验证证据：同步安全聚焦测试 41 passed，前端闲鱼服务 21 passed；迁移与健康 12 passed；datetime 6 passed + 7 subtests；Vite 生产构建通过。后端全量曾达到 127 passed + 12 subtests，仅剩旧并发冲突测试隔离问题，已修正并单测通过。
- 提交：设计 `158b658`，计划 `4c8b147`，同步安全 `d9c04fd`，迁移备份 `362865e`，datetime `750ce17`，路由测试隔离 `4b88436`，Vite 分块 `9d0c847`。
- 最终验证：恢复项目锁定依赖后，后端 132 passed + 12 subtests；前端 22 files / 139 tests，TypeScript 与生产构建通过。依赖锁提交为 `c154449`。
- 环境说明：全局 Conda 同时安装 Gradio 6.17.3，其 Starlette 1.x 约束与本项目 FastAPI 0.115 / Starlette 0.38 不可共存，因此 `pip check` 仍报告 3 条全局工具冲突；后续应为项目建立独立虚拟环境或只用容器。Docker daemon 仍不可连接，未执行真实数据库迁移或容器冒烟。
- 工作区说明：另一条并发通知/图片功能改动仍未提交并完整保留，本轮没有暂存或覆盖这些文件。

## 2026-07-15 项目与 UI 只读审查

- 结论：交易、客户、推荐链、质保、售后、财务、邮件、闲鱼同步、设置/备份等核心业务模块已齐，不建议继续横向堆新模块；下一阶段应先补跨页面基础闭环。
- 必补优先级：先做统一 API Token 解锁入口与移动端“更多”导航；再做交易等长表单的未保存离开保护、接入 `/api/metrics` 的系统运行状态页、全站语义/键盘可访问性，以及覆盖认证和关键流程的 Playwright 端到端冒烟。
- 运行态证据：Docker `web/backend/mail` 均为 healthy；桌面与 390px 移动视口的 11 个主要路由均完成只读检查。无 Token 的新会话会批量触发 401 且没有统一认证门；移动端底栏只有首页/交易/客户/质保/财务，售后、推荐链、邮件、订单同步和设置缺少可发现入口。
- UI 证据：绝大多数页面没有语义化一级标题，布局没有 `nav`/跳过导航；交易和客户列表存在大量只有图标、没有可访问名称的操作按钮，以及无 `href` 的点击式链接；交易录入没有未保存变更拦截。
- 状态缺口：后端已有 `/api/metrics`，但前端没有对应页面/服务；备份页却提示“可在 Metrics 页查看最近备份时间”，形成断链。
- 验证：`npm run check` 通过；`npm test -- --run` 为 26 个文件、232 项测试全部通过。未执行会写入 `dist` 的生产构建，未修改项目源码、未提交或推送。
- 下一步建议：以“认证入口 + 移动端更多导航”为第一闭环，完成后再按上面顺序推进其余必补项。

## 2026-07-15 UI 基础闭环实施

- 分支继续使用 `codex/safe-order-lifecycle-sync`；保留进入会话前已有的后端改动和前端页面拆分，未回退、未暂存、未提交、未推送。
- P0 认证闭环：新增根级 `AuthGate`，无会话 Token 时不挂载业务路由；支持后端离线重试、Token 校验解锁，并在任一业务接口返回 401 时清除失效会话、收回业务页面。
- P0 移动导航：保留 5 项快捷底栏，页头新增覆盖全部 10 个一级模块的完整导航抽屉；底栏和内容区适配 `safe-area-inset-bottom`。
- P1 防丢与运维：交易表单新增站内路由阻止和 `beforeunload` 确认；设置页新增消费既有 `/api/metrics` 的“运行状态”，展示账号、同步、备份、通知和调度器指标，并修正备份页 Metrics 断链文案。
- P1 可访问性：布局新增跳过导航、桌面/移动导航地标、`main` 与全局 `h1`；补可见焦点和减少动画；仪表盘导航卡改为真实链接，交易/客户高频操作补可访问名称。
- 测试基础：固定安装 `@playwright/test@1.55.0`，新增独立 15174 端口、全 API mock 的 Chromium 冒烟；Vitest 显式排除 `tests/e2e/**`，React Fast Refresh 在 test mode 关闭以支持 jsdom 组件测试。
- 验证：`npm test -- --run` 为 30 个文件、246 项全部通过；`npm run build` exit 0（保留既有 `use client` 与大 chunk 警告）；Playwright 桌面解锁/语义、390px 完整导航、系统运行状态 3 项全部通过；Docker `web/backend/mail` 均 healthy，当前容器 Web、后端健康和公开认证状态端点均为 HTTP 200。
- 文档：实现设计与逐步进度位于 `docs/superpowers/specs/2026-07-15-ui-foundation-closure-design.md` 和 `docs/superpowers/plans/2026-07-15-ui-foundation-closure.md`。
- 待确认：当前 Docker Web 仍是重建前版本；需用户确认后再提交本轮文件并重建/部署容器。依赖安装仍报告既有 11 项 npm 漏洞，不自动执行可能产生破坏性升级的 `npm audit fix`。

## 2026-07-16 UI 基础闭环提交与 PR

- 用户确认“全部提交”；当前工作区 61 个文件统一提交为 `8b11db3 feat: complete UI foundation and modularize pages`，包含 UI 基础闭环、页面模块拆分、认证 CORS 修复及对应测试。
- 分支 `codex/safe-order-lifecycle-sync` 已推送并跟踪同名远端；本地与远端 ahead/behind 均为 0，工作区 clean。
- 已创建面向 `main` 的 Draft PR：`https://github.com/mjs618/xianyugou/pull/1`，标题为 `feat: harden Xianyu lifecycle, architecture, and UI foundation`。该 PR 包含长期分支相对 `main` 的 63 个累计提交、311 个文件，不只包含最新一个 UI 提交；PR 正文已按同步安全、数据库/架构、业务治理和 UI 基础四组说明完整范围。
- 提交前验证：后端 `368 passed + 12 subtests`；前端 `30 files / 246 tests`；生产构建通过；Playwright Chromium 3 项通过；staged diff 无空白错误，未发现数据库、环境文件、密钥文件或常见 Token 模式。
- 未执行 Docker 重建或部署；线上/本地运行容器仍保持提交前版本，需另行确认部署窗口。

## 2026-07-16 Docker 重建部署

- 按用户确认执行 `docker compose up -d --build backend web`；前端生产构建完成并替换 `web` 容器，`backend` 镜像重建后内容哈希未变化，Compose 保留原健康容器；未改动的 `mail` 保持运行。
- 容器验证：`web`、`backend`、`mail` 均为 `healthy`；绑定端口分别为 `127.0.0.1:15173`、`127.0.0.1:18001`、`127.0.0.1:13001`。
- HTTP 验证：Web 首页、后端 `/api/health`、公开认证状态 `/api/auth/token-status`、邮件 `/api/health` 均返回 200；无 Token 访问业务接口返回 401 且保留正确 CORS 响应头，OPTIONS 预检返回 200。
- 真实页面验证：无凭证 Chromium 新会话可见“解锁系统”、`API Token` 输入框和“验证并进入”按钮，业务首页未提前挂载；未读取或输出 Token 与业务数据。
- 当前部署对应提交 `8b11db3`，Draft PR 仍为 `https://github.com/mjs618/xianyugou/pull/1`；本次部署未产生项目源码改动。

## 2026-07-16 订单同步任务优先 UI 优化

- 用户确认采用 A 方案“任务优先控制台”：页面先展示全部账号、待处理、有效自动同步和 CookieCloud 状态；熔断账号明确呈现“更新 Cookie → 校验 → 恢复”，同步说明与 Cookie 获取方法默认折叠。
- 原固定宽度账号表格改为响应式账号卡片网格；熔断账号常显“更新 Cookie / 校验并恢复”，正常账号常显订单/商品同步，校验、镜像、日志、编辑和删除收进“更多”；删除与恢复仍保留确认，所有 API 与业务处理器不变。
- 新增纯总览派生层、总览组件、账号卡片组件和订单同步局部样式；桌面总览 4 列，390px 为单列，真实长错误文本未撑破卡片。
- 验证：前端全量 `33 files / 252 tests`，TypeScript 与生产构建通过；Playwright `5 passed`，覆盖订单同步桌面与 390px；真实 Docker 页面桌面/移动只读检查通过，检测到的非 GET 写请求为 0。
- 部署：`docker compose up -d --build web` 成功，`web/backend/mail` 均为 healthy；Web 为新容器，后端与邮件服务未重建，未触发同步、恢复、编辑或删除。
- 提交：设计 `de14094`，计划 `a593391`，总览派生 `a749e0e`，任务总览 `680367e`，响应式账号卡片 `75f3b76`，浏览器覆盖 `31f4812`。设计与计划分别位于 `docs/superpowers/specs/2026-07-16-order-sync-ui-optimization-design.md`、`docs/superpowers/plans/2026-07-16-order-sync-ui-optimization.md`。
- 已知未扩展项：npm 仍报告既有 11 项依赖漏洞，Vite 仍有既有 `use client` 与约 796 KiB 主 chunk 告警；本轮未执行破坏性依赖升级。

## 2026-07-16 闲鱼回复助手 MVP

- 方案决策：首阶段集成到现有项目控制台，不做 Chrome 插件；固定规则优先、OpenAI 兼容模型兜底，只生成候选并由人工复制发送，不接入闲鱼发消息或自动发送链路。
- 后端：新增回复助手配置和规则模型、Alembic 迁移 `20260716_01`、配置/规则 CRUD 与候选生成 API；账号必须有效且未删除，可选关联商品模板；AI 上下文限制为最近 10 条并设置总字符预算。
- 安全边界：API Key 只在服务端保存，前端仅显示是否已配置；模型输入仅包含必要的会话文本、商品名和默认售价；审计日志只记录关联 ID、来源、风险和命中规则，不记录买家消息、候选正文或密钥；高风险候选禁止复制。
- 前端：新增“回复助手”工作台、近期上下文输入、规则配置抽屉、AI 配置与加载失败重试；输入变化或生成失败会清除旧候选；生成请求不自动重试，避免重复模型计费。
- 验证：功能分支阶段后端 `392 passed + 12 subtests`、前端 `34 files / 261 tests`、Playwright Chromium `4 passed`；合并到订单同步 UI 最新提交后重新验证为后端 `392 passed + 12 subtests`、前端 `35 files / 263 tests`、生产构建通过、Playwright Chromium `6 passed`；新增 diff 未发现密钥或闲鱼发送路径。
- 分支与提交：功能提交 `26f6ec4`、`d3bdaa1`、`470076a`、`db56d8f`、`f096648`、`d43b664`、`f9fc29c`、`bd17c24` 已本地合并到 `codex/safe-order-lifecycle-sync`，合并提交为 `3fd79bd`；临时 `codex/xianyu-reply-assistant` 分支和 worktree 已清理。合并完成时目标分支比远端领先 9 个提交，尚未推送。
- 未部署：数据库迁移会修改真实数据库，本轮未重建 Docker 或升级运行实例；需在确认部署窗口并完成数据库备份后单独执行。
- 后续完善决策：候选安全闭环采用“生成时检查输出 + 复制前由后端复检编辑后最终文本”；风险文本必须二次确认，复检不调用 AI、不保存正文，也不增加闲鱼读取或发送能力。设计已提交为 `97394a1`，文档位于 `docs/superpowers/specs/2026-07-16-reply-candidate-safety-closure-design.md`，尚待实施；当前目标分支比远端领先 10 个提交。
