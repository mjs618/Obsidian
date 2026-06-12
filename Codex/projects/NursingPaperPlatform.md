# Nursing Paper Platform

## 项目定位

老年护理学术论文自动化平台，面向本科老年护理教师和护理学科研人员，目标是用流程化工作台辅助完成范围综述/Meta分析与数据分析型论文。

## 2026-06-04 设计文档完善

- 设计文档位置：`E:\product\nursing_paper_platform\nursing_paper_platform_design.md`。
- 文档版本从 v2.0 更新为 v2.1。
- 已补齐项目成功标准、架构边界、非功能指标、数据追溯规则、后端 API、异常流程、测试策略、风险评估、成本估算和 MVP 验收清单。
- 修正了原文目录列出 15-20 章但正文缺失的问题，并把附录顺延为第 20 章。
- 补齐了综述模块和数据分析模块中跳号的流程细节，包括检索去重、全文精筛、写作生成、数据清洗、图表和 Findings。

## 后续关注

- 若进入开发，应优先把 MVP 成功标准转成可执行任务：项目管理、PICO、检索/导入、初筛、Gate、导出。
- 中文数据库接入不宜作为首期硬依赖；首期应支持检索式生成和 RIS/Excel 手动导入。
- 统计数字、引用和 Gate 后数据必须保持可追溯，AI 不应生成确定性统计结果或参考文献。

## 2026-06-04 前端原型方案批准

- 用户选择并批准纯前端可交互原型路线，不接后端、不接真实 AI，先用本地假数据验证完整流程。
- 批准的产品形态为“流程工作台”：左侧项目/流程导航，中间当前步骤主操作区，右侧 Gate、AI建议、任务状态和来源追溯。
- 已写入 spec：`E:\product\nursing_paper_platform\docs\superpowers\specs\2026-06-04-nursing-paper-frontend-prototype-design.md`。
- 后续进入开发时应先创建 Vue 3 + Vite 前端项目，并实现项目总览、PICO、检索式、文献初筛、Gate、数据提取、CSV预检/统计结果、写作草稿与导出模拟。

## 2026-06-04 前端原型实现

- 已在 `E:\product\nursing_paper_platform` 创建 Vue 3 + Vite 纯前端原型。
- 主要入口：`src/App.vue`、`src/styles.css`、`src/components/`、`src/data/`。
- 已实现流程工作台：项目切换、9 步流程导航、PICO、检索式、文献初筛、Gate 面板、任务队列、来源追溯、数据提取、CSV/统计分析、写作草稿和导出模拟。
- 已安装依赖并生成 `package-lock.json`；`npm run build` 通过。
- 已用 Playwright 在同一命令内验证生产预览：页面标题/内容渲染、切换到文献初筛、点击第一篇“纳入”后计数从 `0/5` 变为 `1/5`。
- 当前目录不是 git 仓库，无法提交 commit；已添加 `.gitignore` 排除 `node_modules/`、`dist/` 等生成物。

## 2026-06-04 前端原型体验闭环

- 已补齐前端原型的流程闭环：Gate checklist 确认、主按钮阻塞/推进、Gate 审计提示、写作段落人工核查状态、导出 readiness 与 Gate 汇总。
- 新增正式 e2e 验证：`tests/e2e/flow-closure.spec.js`，并在 `package.json` 增加 `npm run test:flow`。
- 为可重复验证加入开发依赖 `@playwright/test`；本机已安装 Playwright Chromium。
- 验证结果：`npm run build` 通过；`npm run test:flow` 通过，覆盖首屏、文献初筛计数、Gate A 确认、推进到全文精筛、写作人工核查、导出阻塞和移动端标题可见性。
- in-app Browser 对本地地址返回 `net::ERR_BLOCKED_BY_CLIENT`，本轮改用外部环境启动 Vite 服务并运行 Playwright 测试完成验证。

## 2026-06-04 前端原型 Gate A-E 完整闭环

- 已把 Gate B 从演示阻塞项改为可确认 Gate，并将导出 readiness 调整为 Gate A/B/C/D/E 全部通过后才可模拟导出。
- 导出页文案已同步为完整导出预演：通过全部 Gate 后可点击 Word、PRISMA、XLSX、图表导出项查看模拟成功反馈，不生成真实文件。
- e2e 测试 `tests/e2e/flow-closure.spec.js` 已扩展为完整路径：初筛纳入、Gate A、Gate B、质量评价、Gate C、Gate D、写作人工核查、Gate E、进入导出并模拟 Word 导出。
- 验证结果：`npm run build` 通过；`npm run test:flow` 通过，1 个 Playwright 流程测试通过。

## 2026-06-04 前端原型本地状态持久化

- 已为 Vue 前端原型增加 `localStorage` 自动保存，覆盖当前项目、当前步骤、草稿章节、文献判断、已访问流程、Gate checklist / 状态和写作草稿。
- 顶部新增“重置演示”按钮，可一键恢复初始演示数据，便于反复走流程。
- e2e 测试已覆盖刷新恢复：完成初筛纳入与 Gate A 后刷新页面，仍保留 `1 / 5` 判断进度和 Gate A 已确认状态；完整导出路径与重置回 PICO 也继续通过。
- 验证结果：`npm run build` 通过；`npm run test:flow` 通过，1 个 Playwright 流程测试通过。

## 2026-06-04 前端原型审计时间线

- 已新增右侧“审计时间线”面板，基于当前本地状态自动汇总项目创建、文献初筛人工判断、Gate 通过、论文草稿人工核查和模拟导出事件。
- 审计事件不单独持久化，直接从文献判断、Gate、草稿和导出状态计算，避免与原型状态重复或漂移。
- e2e 测试已覆盖 Gate A 通过后时间线出现对应记录、刷新后保留人工判断记录、模拟 Word 导出后出现“模拟导出”审计事件。
- 验证结果：`npm run build` 通过；`npm run test:flow` 通过，1 个 Playwright 流程测试通过。

## 2026-06-04 前端原型检索/手动导入模拟

- 已在检索策略页新增手动导入补齐面板，支持模拟 RIS 与 Excel 题录导入，用于覆盖中文数据库或外部检索失败时的 MVP 替代路径。
- RIS 模拟导入会追加 3 篇样本文献到初筛列表，并记录字段缺失与待去重摘要；重复点击同一种导入不会重复追加同一批文献。
- 导入批次已纳入 `localStorage` 自动保存，并在右侧审计时间线显示“检索/导入已记录”。
- e2e 测试 `tests/e2e/flow-closure.spec.js` 已扩展：检索页模拟 RIS 导入后，初筛计数从 `0 / 5` 变为 `0 / 8`，刷新后仍保留导入记录和初筛进度。
- 验证结果：`npm run build` 通过；`npm run test:flow` 通过，1 个 Playwright 流程测试通过。

## 2026-06-04 后端接口最小实现

- 已在 `E:\product\nursing_paper_platform` 新增最小 Node 内置 HTTP 后端，不引入新依赖，入口为 `backend/api.mjs`，启动脚本为 `npm run api`。
- 当前后端为内存态原型接口，统一返回 `{ success, data, error, request_id }` envelope；尚未接数据库、真实 AI、真实检索 API 或文件上传。
- 已覆盖 MVP 核心接口：`GET/POST /api/projects`、项目详情/时间线、`PUT /api/projects/{id}/pico`、检索式生成、检索任务、RIS 导入、文献列表、文献初筛、Gate 查询/确认、项目任务、任务详情、导出任务阻塞。
- 新增 `tests/backend/api.test.mjs` 和 `npm run test:api`，测试覆盖统一响应、PICO 保存、RIS 导入后文献数从 5 到 8、初筛判断、Gate A 确认，以及 Gate B 未确认时阻止导出。
- 验证结果：`npm run build` 通过；`npm run test:api` 通过；`npm run test:flow` 通过。
- 后续若继续后端，应优先把内存态替换为 FastAPI + 持久化存储，或先让前端从该 mock API 读取项目/文献/Gate 状态。

## 2026-06-04 前后端接口同步入口

- 已新增前端 API client：`src/api/client.mjs`，负责统一响应 envelope 解包、后端 snake_case 到前端 camelCase 字段映射，以及 `ApiClientError` 错误封装；类型声明为 `src/api/client.d.mts`。
- 已新增 `npm run test:client` 和 `tests/frontend/api-client.test.mjs`，覆盖项目列表映射、文献列表映射、导出阻塞错误解析。
- 后端 `backend/api.mjs` 已补 CORS/OPTIONS 预检支持，便于 Vite 前端从浏览器访问本地 mock API。
- `WorkflowShell` 顶部新增“同步接口”入口；当配置 `VITE_API_BASE_URL` 时，`App.vue` 可从后端拉取项目列表和当前项目文献列表。未配置时继续保持本地演示数据。
- 本轮未把 Gate、草稿、导出等完整状态改为服务端驱动，避免一次性重构；当前只是打通项目/文献读取入口。
- 验证结果：`npm run build` 通过；`npm run test:api` 通过；`npm run test:client` 通过；`npm run test:flow` 通过。
- 后续建议：先补一个前端 e2e 或集成测试覆盖 `VITE_API_BASE_URL` 下点击“同步接口”的真实行为，再逐步把 RIS 导入、初筛判断和 Gate 确认改为调用后端接口。

## 2026-06-04 前后端同步 e2e 验证

- 已新增 `tests/e2e/api-sync.spec.js` 和 `npm run test:api-sync`，测试内启动 mock API 与 Vite 前端，配置 `VITE_API_BASE_URL` 后验证“同步接口”真实浏览器行为。
- 测试会先通过后端 RIS 导入接口把文献数扩展到 8 篇，再点击前端“同步接口”，验证顶部状态显示 `接口已同步：8 篇文献`、初筛页显示 `0 / 8`，并在刷新后保留同步结果。
- 前端同步成功后已新增审计事件“接口同步已记录”，并随本地状态持久化，避免接口同步行为不可追溯。
- 验证结果：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow` 均通过。
- 后续建议：下一步把检索页“模拟导入 RIS”改为调用后端 `/api/projects/{id}/imports/ris`，再把初筛判断改为调用 `/api/literature/{id}/screening`。

## 2026-06-04 Docker 打包与运行验证

- 已新增生产服务能力：`backend/api.mjs` 支持 `/health` 健康检查，并在传入 `STATIC_DIR` 时托管 Vite 构建后的前端静态文件，非 API 路由回退 `index.html` 支持 SPA 刷新。
- 已新增 Docker 部署文件：`Dockerfile`、`.dockerignore`、`docker-compose.yml`；镜像名为 `nursing-paper-platform:latest`，容器默认监听 `8787`。
- `package.json` 新增 `npm run start`，生产入口为 `node backend/api.mjs`。
- Docker 镜像已成功构建，容器 `nursing-paper-platform` 已启动，端口映射 `8787:8787`，`docker ps` 显示状态为 `healthy`。
- 运行验证通过：`http://127.0.0.1:8787/health` 返回 `{"service":"nursing-paper-platform","status":"ok"}`；`/api/projects` 返回统一 envelope 项目列表；`/` 返回前端 HTML 且包含前端资源入口。
- 回归验证通过：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow` 均通过。
- 当前上线形态仍是本地 Docker 内存态原型：重启容器会丢失接口运行期内存数据，尚未接数据库、真实 AI、真实检索 API 或文件上传。

## 2026-06-04 RIS 导入与初筛接入后端

- 前端 API client 已新增 `importRis(projectId, fileName)` 和 `updateScreening(literatureId, decision, exclusionReason)`，并补充类型声明与 `tests/frontend/api-client.test.mjs` 覆盖。
- `App.vue` 在配置 `VITE_API_BASE_URL` 时，检索页“模拟导入 RIS”会调用后端 `/api/projects/{id}/imports/ris`，随后重新拉取文献列表；未配置 API 时仍保持本地演示逻辑。
- `App.vue` 在配置 API 时，文献初筛“纳入/排除/不确定”会调用后端 `/api/literature/{id}/screening`，并用后端返回记录更新当前列表。
- `tests/e2e/api-sync.spec.js` 已扩展为真实前后端调用链：先同步 5 篇，点击页面导入 RIS 后变为 8 篇，再点击第一篇“纳入”并验证 `初筛判断已同步接口` 与 `1 / 8` 刷新后保留。
- 本地验证通过：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并通过 compose 启动新容器；容器状态 healthy，首页加载最新资源 `index-D23Q1v7w.js`，`/health`、文献列表、RIS 导入和初筛 PATCH 均验证通过。
- 当前仍是内存态后端；容器重启会丢失 RIS 导入和初筛判断。下一步若继续，应优先把 Gate 确认或导出任务接到前端真实 API，或开始引入持久化存储。

## 2026-06-04 Gate A 确认接入后端

- 前端 API client 已新增 `confirmGate(projectId, gateId, checklistItemIds)`，并在 `tests/frontend/api-client.test.mjs` 覆盖 checklist 请求体与后端 gate 状态映射。
- `App.vue` 在配置 `VITE_API_BASE_URL` 时，右侧 Gate 确认会调用后端 `/api/projects/{id}/gates/{gateId}/confirm`，成功后更新本地 Gate 状态和审计文本；未配置 API 时仍保持本地演示逻辑。
- `tests/e2e/api-sync.spec.js` 已扩展：同步接口、后端 RIS 导入、后端初筛判断后，勾选 Gate A 三项并确认，验证 `Gate 已同步接口` 与 `Gate A：初筛抽查 已通过`，刷新后仍保留通过状态。
- 本地验证通过：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并通过 compose 重启；容器状态 healthy，首页加载最新资源 `index-DdnIqG68.js`，`/health` 与 Gate A confirm API 均验证通过。
- 当前仍是内存态后端；下一步建议把导出任务从前端模拟切到 `/api/projects/{id}/export-tasks`，同时保留 Gate 未通过时的阻塞提示。

## 2026-06-04 导出任务接入后端

- 前端 API client 已新增并修正 `createExportTask(projectId, format)` 的后端 envelope 映射，返回 `data.task` 中的任务 ID、状态、进度、消息和结果字段。
- `App.vue` 在配置 `VITE_API_BASE_URL` 时，导出页 Word/PRISMA/XLSX/图表按钮会调用后端 `/api/projects/{id}/export-tasks`；未配置 API 时仍保持本地模拟导出逻辑。
- `tests/frontend/api-client.test.mjs` 已覆盖导出任务成功映射；`tests/e2e/api-sync.spec.js` 已扩展为完整 API 同步链路：同步项目文献、后端 RIS 导入、后端初筛、Gate A-E 逐项确认、刷新保留状态，并在导出页提交 Word 导出任务。
- 本地验证通过：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并通过 compose 启动；容器 `nursing-paper-platform` 状态 healthy，首页加载最新资源 `index-CMHx3WGe.js`，`/health` 正常，容器内 Gate A-E confirm API 与 Word 导出任务 API 验证通过，导出接口返回 `202` 和 queued task。
- 当前仍是 Docker 内存态原型；容器重启会丢失 Gate 状态和导出任务运行期数据。下一步若继续后端，应优先考虑持久化存储，或补齐项目详情/任务轮询在前端的真实展示。

## 2026-06-04 项目快照接口与任务队列同步

- 后端 `backend/api.mjs` 新增只读项目快照接口：`GET /api/projects/{id}/snapshot`，一次返回项目、Gate、任务队列和时间线，用于前端同步完整项目状态。
- 前端 API client 已新增 `loadProjectSnapshot(projectId)`，映射 project、gates、tasks、timeline；类型声明同步更新。
- `App.vue` 的“同步接口”现在会同时拉取项目快照和文献列表：Gate 状态、远端时间线摘要和右侧任务队列会随后端状态刷新；创建导出任务成功后，也会把返回的导出任务加入右侧任务队列。
- 测试已按 TDD 补充：后端测试覆盖 snapshot 返回 Gate/任务/时间线；client 测试覆盖 snapshot 映射；API e2e 覆盖 Word 导出任务进入任务队列。
- 最终验证通过：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并启动；容器 `nursing-paper-platform` 状态 healthy，首页加载最新资源 `index-CUeH3waC.js`，`/health`、`/api/projects/review-001/snapshot`、Gate A-E confirm、Word 导出任务和导出后 snapshot 任务读取均验证通过。
- 当前后端仍是内存态 mock API；下一步若继续完善后端，优先级仍应放在持久化存储、项目状态恢复、任务轮询/任务结果生成，避免前端和后端状态在容器重启后丢失。

## 2026-06-04 Mock API 文件持久化

- 后端 `backend/api.mjs` 新增可选 JSON 文件持久化：启动时从 `DATA_FILE` 读取状态，成功的非 GET API 请求后写回状态文件；未配置 `DATA_FILE` 时仍保持内存态 mock API。
- 已覆盖的可持久化运行期状态包括：RIS 导入文献、初筛人工判断、Gate 确认、任务队列和时间线。
- Docker 配置已接入持久化：`docker-compose.yml` 设置 `DATA_FILE=/app/data/state.json`，并挂载 `./data:/app/data`；`.gitignore` 和 `.dockerignore` 已排除 `data/`，避免运行期状态进入源码或镜像上下文。
- 测试按 TDD 补充：`tests/backend/api.test.mjs` 新增“写入状态 -> 关闭服务 -> 同数据文件重启 -> 状态仍存在”的后端测试，初始失败为重启后文献数回到 5，实现后通过。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并启动；容器状态 healthy。通过接口写入 RIS 导入、初筛 include 和 Gate A passed 后，`data/state.json` 已生成；`docker compose restart nursing-paper-platform` 后再次读取接口，确认文献数仍为 8、`lit-001` 仍为 include、Gate A 仍为 passed。
- 当前持久化仍是原型级 JSON 文件方案，适合本地 Docker 演示和状态恢复；后续生产化仍应迁移到数据库，并补任务结果文件、并发写入保护和数据迁移策略。

## 2026-06-05 导出任务轮询与结果生成

- 后端 `backend/api.mjs` 已让 export task 支持轮询推进：`GET /api/tasks/{id}` 第一次把任务从 `queued` 推进到 `running` / 50%，第二次推进到 `succeeded` / 100%，并生成 mock 导出文件结果。
- 导出任务现在记录 `format`，完成结果包含 `files[]`、`file_name` 和 `download_url`，例如 `review-001-word-task-3.docx`；当前仍是 mock 文件元数据，不生成真实 Word 文件。
- 配置 `DATA_FILE` 时，任务轮询导致的状态变化也会写回 JSON 持久化文件，避免容器重启后 completed task 丢失。
- 前端 API client 新增 `getTask(taskId)`；`App.vue` 在 API 模式提交导出任务后会轮询任务状态，更新右侧任务队列，并在导出页显示完成文件名。
- 测试按 TDD 补充：后端测试覆盖导出任务轮询到 succeeded 和文件结果；client 测试覆盖 `getTask` 映射；API e2e 覆盖浏览器导出完成态和任务队列完成消息。
- 最终验证通过：`npm run build`、`npm run test:api`、`npm run test:client`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并启动；容器状态 healthy。容器内确认 Gate A-E 后提交 Word 导出任务，接口验证第一次查询 `running/50`，第二次查询 `succeeded/100`，结果文件为 `review-001-word-task-3.docx`；重启容器后 snapshot 仍保留该任务的 succeeded 状态和结果文件名。
- 下一步若继续后端，建议补下载接口或真实 artifact 生成；也可以先补任务失败/重试接口，让任务队列具备失败闭环。

## 2026-06-05 Mock 导出文件下载接口

- 后端 `backend/api.mjs` 已实现任务结果下载接口：`GET /api/tasks/{id}/files/{format}`，用于下载已完成 export task 的 mock artifact。
- 下载接口仅允许访问 `succeeded` 任务的 `result.files[]`，任务不存在返回 `TASK_NOT_FOUND`，任务未完成返回 `TASK_NOT_READY`，文件格式不匹配返回 `TASK_FILE_NOT_FOUND`。
- 当前下载内容仍是 mock 文本 artifact，但响应头按格式返回：Word 使用 `application/vnd.openxmlformats-officedocument.wordprocessingml.document`，并设置 `Content-Disposition: attachment; filename="..."`。
- 前端 `ExportWorkspace` 已新增“下载 mock 文件”链接；`App.vue` 在导出任务完成后读取 `download_url` 并拼接 API base URL 显示下载入口。未配置 API 的本地演示路径仍只显示模拟导出消息。
- 测试按 TDD 补充：后端测试覆盖下载响应头、文件名和 mock 内容；API e2e 覆盖导出完成后下载链接指向 `/api/tasks/{id}/files/word`。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 已重新构建并启动；容器状态 healthy，首页加载最新资源 `index-D2qbAn1M.js`。容器内创建 Word 导出任务并轮询到 succeeded 后，下载接口返回 200、正确 MIME、正确 `Content-Disposition`，mock 内容包含平台标识和任务 ID。
- 下一步若继续，可把 mock 文本替换为真实 Word/XLSX/SVG/ZIP artifact 生成，或先补任务失败/重试接口。

## 2026-06-05 去除 Mock 数据与真实导出收口

- 已将 `E:\product\nursing_paper_platform` 从固定样例/Mock 原型推进为干净空白项目工作台：默认项目改为 `未命名护理综述项目`，初始文献、任务队列、分析表、提取表、草稿内容均为空，不再内置老年痴呆音乐疗法、养老机构 CSV 等样例数据。
- RIS 导入已改为读取用户上传的真实 RIS 文件内容：后端 `/api/projects/{id}/imports/ris` 必须接收 `ris_content`，前端通过文件选择读取文本后提交；缺失或空 RIS 会返回校验错误。
- 导出已从 mock Word/XLSX 改为实际可下载轻量 artifact：`manuscript` Markdown、`prisma` SVG、`csv`、`audit` JSON；下载内容不再包含 mock/模拟文案，前端本地模式也会生成 Blob 下载文件。
- 后端初始状态、检索策略接口和 Docker 运行时已同步清理：`search-strategies` 需要先保存 PICO 才生成基于 PICO 的检索式；Dockerfile 已复制 `src/utils`，避免容器启动缺 RIS parser。
- 已删除旧 `data/state.json`，避免 Docker 挂载持久化时继续加载旧假文献、旧任务和旧 mock 导出记录。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。Docker 已重新构建并启动，`docker compose ps` 显示 healthy；`http://127.0.0.1:8787/health` 返回 ok，`/api/projects` 只返回空白项目，`/api/projects/review-001/literature` 返回 0 篇，snapshot 中 tasks 为空。
- 当前仍不是生产级完整系统：尚未接数据库、真实外部检索 API、真实 AI、用户认证或真实 Word/DOCX/XLSX 生成；但运行态已不再依赖 mock 数据，后续重点应转向真实项目创建/编辑、PICO 表单持久化、CSV/全文上传和数据库化。

## 2026-06-05 PICO 保存与检索式生成接入

- 前端 `PicoWorkspace` 已从静态字段改为可编辑表单，保存时通过 `App.vue` 更新当前项目状态；配置 API 时调用 `PUT /api/projects/{id}/pico`，本地模式也会持久保存到 localStorage。
- 前端 API client 新增 `savePico(projectId, pico)` 和 `createSearchStrategies(projectId)`；类型新增 `PicoConfig` 与 `SearchStrategy`。
- 检索策略页不再显示固定检索式和固定数量；保存 PICO 后可生成 PubMed、Cochrane Library、CNKI、万方四条基于 PICO 字段拼接的检索式，预估数量保持 `null/待查询`，不编造结果数。
- 后端保存 PICO 时会更新项目状态为 `PICO 已保存`、completion 至少 10，并写入时间线；`POST /search-strategies` 在未保存 PICO 时返回 `VALIDATION_PICO_REQUIRED`，保存后才生成检索式。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。Docker 已重建并重启，最终清理验证写入的 `data/state.json` 后，`/api/projects` 回到空白项目，`/literature` 为 0，snapshot tasks 为空。
- 下一步真实可用优先级：项目创建/重命名接口与 UI、数据库化持久化、真实 CSV/全文上传、真实外部检索 API 或明确手动导入工作流。

## 2026-06-05 项目创建与重命名接入

- 后端 `POST /api/projects` 已支持创建真实项目，并为新项目初始化 Gate A-E、空任务队列与项目创建时间线；`PATCH /api/projects/{id}` 已支持项目标题更新并写入时间线。
- 前端侧栏新增项目创建表单；工作台顶部新增项目标题保存入口。配置 API 时会调用后端 `createProject` / `updateProject`，本地模式也会更新 localStorage。
- 修复 localStorage 恢复顺序：先恢复项目列表，再校验 `activeProjectId`，避免刷新后新建项目被回退到默认 `review-001`。
- API E2E 已覆盖新建项目、重命名、保存 PICO、生成检索式、RIS 导入、初筛、Gate A-E、导出 artifact 的完整链路。
- 当前验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 8787 已验证真实中文项目创建/重命名、Gate 初始化、空任务和空文献；验证生成的 `data/state.json` 已删除，容器重启后确认只剩空白默认项目。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、CSV/全文上传和正式 DOCX/XLSX 生成仍待后续实现。

## 2026-06-05 真实 CSV 上传与预检接口

- 后端新增真实 CSV 导入接口：`POST /api/projects/{id}/imports/csv`，请求必须包含 `csv_content`；空内容或没有数据行会返回校验错误。
- 后端新增 CSV 预检查询接口：`GET /api/projects/{id}/analysis/csv-profile`，返回当前项目的文件名、行数、列数、缺失值预警和变量角色。
- 新增轻量 CSV parser：`src/utils/csv.mjs`，支持基础引号/逗号解析、缺失值统计、连续变量/分类变量/时间列/疑似 ID 列推断；不会生成伪 Table 1 或伪回归结果。
- 前端分析页新增“选择 CSV 文件”，配置 API 时调用后端导入接口，本地模式用同一 parser 生成预检摘要；预检状态纳入 localStorage 和审计时间线。
- API client 新增 `importCsv` 与 `loadCsvProfile`，并补充类型声明。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 8787 已重建并实测：导入 `baseline-container.csv` 后返回 3 行、5 列，识别 `age/mmse_score` 为连续变量、`group` 为分类变量、`visit_date` 为时间列、`participant_id` 为疑似 ID，并记录 `mmse_score` 1 个缺失值；随后删除验证生成的 `data/state.json` 并重启容器，确认回到空白默认项目与空 CSV profile。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、全文/PDF 上传和正式 DOCX/XLSX 生成仍待后续实现。

## 2026-06-05 真实全文材料上传接口

- 后端新增全文材料接口：`POST /api/projects/{id}/fulltexts` 与 `GET /api/projects/{id}/fulltexts`；上传必须包含真实 `content`，空内容返回 `VALIDATION_FULLTEXT_CONTENT_REQUIRED`。
- 后端保存全文材料正文到运行态状态，但列表和上传响应只返回元数据：文件名、来源 URI、状态、字符数、备注、上传时间，避免大文本在 UI/API 中反复回传。
- 前端 API client 新增 `uploadFullText` 与 `listFullTexts`，并补充 `FullTextItem` 类型声明。
- 前端“全文精筛”步骤新增“选择全文文件”入口和全文材料清单；上传真实文本/PDF 转写材料后显示文件名、状态、字符数和备注。本地模式同样记录真实文件元数据，不生成伪精筛结论。
- API E2E 已覆盖从项目创建、PICO、RIS 导入、初筛，到全文精筛上传真实全文材料，再继续 Gate B-E、CSV 预检和导出 artifact 的浏览器链路。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 8787 已重建并实测：上传 `container-fulltext.txt` 后 `/fulltexts` 返回 1 份材料、字符数 185、项目状态为 `全文材料已上传`、时间线包含 `全文材料上传`；随后删除验证生成的 `data/state.json` 并重启容器，确认回到空白默认项目且全文材料数为 0。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、PDF 二进制解析/对象存储、正式 DOCX/XLSX 生成仍待后续实现。

## 2026-06-05 审计导出纳入真实输入追溯

- 后端审计 artifact `audit` 已从项目快照扩展为真实输入追溯：下载 JSON 现在包含 `csv_profile`、`full_texts` 元数据和项目 `timeline`。
- `full_texts` 只导出元数据（文件名、来源 URI、状态、字符数、备注、上传时间），不把全文正文写进审计下载，避免大文本和敏感材料在导出中扩散。
- 本地模式的审计 JSON 也同步补充 `csvProfile`、`fullTexts` 和 `timeline`，避免未配置 API 时丢失追溯信息。
- 后端测试新增 audit 导出覆盖：写入真实 RIS、CSV、全文材料，确认 Gate A-E 后导出 `audit`，下载 JSON 必须包含 CSV profile、全文材料元数据和 `CSV 导入` / `全文材料上传` 时间线。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`；残留扫描只剩测试中的 `assert.doesNotMatch(download.text, /mock|模拟/)` 防回归断言。
- Docker 8787 已重建并实测：完整写入 RIS、CSV、全文、Gate 后导出 `review-001-audit-task-1.json`，下载 JSON 包含 `container-baseline.csv`、`container-fulltext.txt`、CSV 变量角色和完整时间线；随后删除验证生成的 `data/state.json` 并重启容器，确认回到空白默认项目。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、PDF 二进制解析/对象存储、正式 DOCX/XLSX 生成仍待后续实现。

## 2026-06-05 去除伪 AI 初筛语义

- RIS 导入后的文献记录已从 `ai_decision/confidence/reason` 迁移为 `screening_status/screening_note`，默认状态为 `needs_review`，说明为“真实 RIS 导入，等待人工初筛或全文核验”。
- 初筛页不再展示“AI 判断依据”“AI 置信度”“建议纳入/建议排除”，改为展示“待人工初筛/全文核验”和导入说明，避免在未接真实 AI 时误导用户。
- 写作草稿状态去掉 `ai_generated` 与 `aiGenerated` 字段，写作页不再保留“AI生成”标签逻辑；空草稿默认状态为 `draft` / 待人工核查。
- API client 不再兼容回退旧 `ai_decision/reason` 字段，避免旧状态把伪 AI 语义带回 UI。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- 残留扫描 `rg "AI 判断依据|AI 置信度|AI 批量初筛|AI判断JSON|ai_decision|aiDecision|aiGenerated|ai_generated|AI生成|建议纳入|建议排除|mock|Mock|MOCK|模拟|假数据|样例|示例|demo|Demo|演示" src backend Dockerfile docker-compose.yml` 无命中；测试中只保留防回归断言。
- Docker 8787 已重建并实测：上传真实 RIS 后 `/literature` 返回 `screening_status=needs_review` 和 `screening_note`，不再包含 `ai_decision`、`confidence`、`reason`；随后删除验证生成的 `data/state.json` 并重启容器，确认回到空白默认项目。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、PDF 二进制解析/对象存储、正式 DOCX/XLSX 生成仍待后续实现。

## 2026-06-06 论文导出升级为真实 DOCX

- `manuscript` 导出已从 Markdown 文本升级为真实 OOXML DOCX：后端结果文件扩展名改为 `.docx`，下载 MIME 为 `application/vnd.openxmlformats-officedocument.wordprocessingml.document`，响应体返回 ZIP/DOCX 二进制。
- 新增/接入 `src/utils/docx.mjs` 无依赖轻量 DOCX 生成器，包含 `[Content_Types].xml`、`_rels/.rels` 和 `word/document.xml`；正文包含平台标题、项目、任务 ID、导出摘要、Gate 状态和已纳入文献。
- 前端本地导出同步改为 `论文 DOCX`，本地模式生成 `.docx` Blob；导出面板文案已从“论文 Markdown”改为“论文 DOCX”。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。残留扫描只剩测试中的 `assert.doesNotMatch(..., /mock|模拟/)` 和全文上传允许 `.md` 文件类型。
- Docker 8787 已重建并实测：导入真实 RIS、人工 include、确认 Gate A-E、创建 `manuscript` 导出后，下载 `review-001-manuscript-task-2.docx` 返回 DOCX MIME，前 4 字节为 `PK\x03\x04`，内容包含 `word/document.xml`、平台标题和 task id，且不包含 mock/模拟标记。
- 验证生成的 `data/state.json` 已删除并重启容器；复查 `/api/projects` 只剩默认 `review-001`，`/literature` 为 0，snapshot tasks 为 0。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、PDF 二进制解析/对象存储、XLSX 生成和更完整的 Word 排版仍待后续实现。

## 2026-06-06 文献导出升级为真实 XLSX

- 新增 `src/utils/xlsx.mjs` 无依赖轻量 XLSX 生成器，输出真实 OOXML ZIP，包括 `[Content_Types].xml`、`_rels/.rels`、`xl/workbook.xml`、`xl/_rels/workbook.xml.rels` 和 `xl/worksheets/sheet1.xml`。
- 后端新增 `xlsx` 导出格式：`POST /api/projects/{id}/export-tasks` 支持 `format=xlsx`，完成后下载 `review-001-xlsx-task-N.xlsx`，MIME 为 `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`，表格包含 task id、项目 id、题录标题、作者、期刊、年份、人工初筛决定和排除原因。
- 后端新增导出格式白名单校验：只允许 `manuscript`、`prisma`、`csv`、`xlsx`、`audit`；未知格式返回 `VALIDATION_EXPORT_FORMAT`，避免生成 `.dat` 伪 artifact。
- 前端导出页新增“文献 XLSX”按钮，本地模式也用同一 XLSX 生成器创建 `.xlsx` Blob；旧 `word` 测试用例已清理为 `unknown`。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。残留扫描只剩测试中的 `assert.doesNotMatch(..., /mock|模拟/)` 防回归断言。
- Docker 8787 已重建并实测：导入真实 RIS、人工 include、确认 Gate A-E、创建 `xlsx` 导出后，下载 `review-001-xlsx-task-1.xlsx` 返回 XLSX MIME，前 4 字节为 `PK\x03\x04`，内容包含 `xl/worksheets/sheet1.xml`、真实题录标题和 task id，且未知导出格式被 400 拒绝。
- 验证生成的 `data/state.json` 已删除并重启容器；复查 `/api/projects` 只剩默认 `review-001`，`/literature` 为 0，snapshot tasks 为 0。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、PDF 二进制解析/对象存储和更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-06 全文材料支持二进制对象存储

- 后端 `POST /api/projects/{id}/fulltexts` 新增 `file_base64` / `content_type` 上传路径，支持 PDF、DOCX 等二进制全文材料；旧 `content` 文本路径保留兼容。
- 配置 `DATA_FILE` 时，二进制全文默认保存到同级 `objects/fulltexts/{projectId}/...` 对象目录；状态中只记录相对 `object_key`、`object_uri`、`byte_count`、`content_type` 等元数据，不保存或回显 base64/正文，也不保存绝对路径。
- 前端全文上传从 `file.text()` 改为 `file.arrayBuffer()` + base64，避免 PDF/Word 被错误当作文本；本地模式也记录真实字节数元数据。
- 全文材料列表对二进制材料显示字节数，旧文本材料仍可显示字符数；API client 映射新增 `contentType`、`byteCount`、`objectKey`、`objectUri`。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。残留扫描显示 `file.text()` 只剩 RIS/CSV 文本导入，mock/模拟只剩测试防回归断言。
- Docker 8787 已重建并实测：上传 PDF 字节流 `container-real-fulltext.pdf` 后，接口返回 `content_type=application/pdf`、`byte_count=44`、`character_count=0`、`local-object://...`；宿主机 `data/objects/...pdf` 文件字节与上传内容一致，列表不回显 `content` 或 `file_base64`。
- 验证生成的 `data/state.json` 和对象文件已删除并重启容器；复查默认项目仍为空白，题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：数据库持久化、真实外部检索 API、真实 AI、用户认证、PDF 文本解析/结构化抽取，以及更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-06 接入真实 PubMed 外部检索导入

- 后端新增 `POST /api/projects/{id}/imports/pubmed`，通过 NCBI E-utilities 的 `esearch.fcgi` + `esummary.fcgi` 拉取真实 PubMed 题录，并导入到项目文献列表。
- PubMed 导入记录使用 `pubmed-{pmid}` 作为稳定 ID，source 为 `PubMed`，保留题名、作者、期刊、年份；默认 `screening_status=needs_review`，不生成伪 AI 判断字段。
- 后端支持去重：同一 PMID 重复导入时 `imported_count=0`、`duplicate_pairs` 计数增加；导入成功会更新项目状态和时间线。
- API client 新增 `importPubMed(projectId, query, retmax)`；前端检索式页的 PubMed 策略卡新增“导入 PubMed”按钮，点击后调用后端并刷新题录列表，导入记录写入当前会话。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。残留扫描显示 mock/模拟只剩测试防回归断言，`file.text()` 只剩 RIS/CSV 文本导入。
- Docker 8787 已重建并实测真实外部调用：`query='frailty nursing'`、`retmax=1` 成功从 PubMed 拉取 PMID `42243604`，题名为 `Giving room for the existential response to serious illness...`，导入后 source 为 `PubMed`、状态为待人工初筛，且无 `ai_decision/confidence` 字段。
- 验证生成的 `data/state.json` 已删除并重启容器；复查默认项目仍为空白，题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：数据库持久化、用户认证、真实 AI、PDF 文本解析/结构化抽取，以及更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-06 全文原始文件下载接口

- 后端新增 `GET /api/fulltexts/{id}/file`，可下载已上传的全文原始文件；二进制对象从 `data/objects/fulltexts/...` 读取，文本兼容路径可直接下载文本内容。
- 全文元数据新增 `download_url=/api/fulltexts/{id}/file`；响应头设置原文件名和原 `content_type`，并校验对象路径必须位于对象存储根目录内，避免路径逃逸。
- 前端全文材料列表新增“下载原文”链接；API 模式下会把后端相对 URL 转成完整 API 地址，避免 Vite 开发服务器下链接打到错误来源。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。残留扫描只剩测试中的 mock/模拟防回归断言和兼容旧 `object_path` 清理逻辑。
- Docker 8787 已重建并实测：上传 `downloadable-fulltext.pdf` 后返回 `download_url`，GET 下载接口返回 `application/pdf`、`Content-Disposition` 包含原文件名，下载字节与上传 PDF 字节完全一致。
- 验证生成的 `data/state.json` 和对象文件已删除并重启容器；复查默认项目仍为空白，题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：数据库持久化、用户认证、真实 AI、PDF 文本解析/结构化抽取，以及更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-06 后端认证接口接入

- 后端新增配置式认证层：设置 `APP_ADMIN_PASSWORD_HASH` 与 `APP_SESSION_SECRET` 后，除 `/health` 与 `/api/auth/*` 外的 `/api/*` 接口需要 Bearer token 或 `npp_session` Cookie。
- 新增 `/api/auth/login`、`GET /api/auth/session`、`POST /api/auth/logout`；密码哈希格式为 `pbkdf2-sha256:<iterations>:<salt>:<hex-hash>`，测试覆盖错误密码 401、未登录 401、登录后访问项目接口。
- 默认未配置认证时保持现有本地/Docker 运行方式，8787 容器已重建验证：`/health` healthy，`/api/projects` 返回空白默认项目，`data/objects` 文件数为 0。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- 仍未完成生产级目标：数据库持久化、真实 AI、PDF 文本解析/结构化抽取，以及更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-07 SQLite 数据库持久化接入

- 后端新增 SQLite 状态存储路径：`createApiServer({ databaseFile })` 会使用 Node 22 `node:sqlite` 创建 `app_state` 表，并把真实运行状态写入 `state.db`；旧 `DATA_FILE` JSON 路径保留兼容。
- Docker Compose 已从 `DATA_FILE=/app/data/state.json` 切换为 `DATABASE_FILE=/app/data/state.db`，对象存储目录仍位于同一 `data/objects` 挂载下。
- 后端测试新增 SQLite 跨重启持久化覆盖：导入真实 RIS、人工初筛、确认 Gate A 后关闭服务，直接查询 SQLite `app_state` 表，再重启服务确认文献、人工判断和 Gate 状态可读回。
- E2E `flow-closure` 测试已改为自启动 Vite 随机端口，避免误打到本机 5173 上的其他应用。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- Docker 8787 已重建验证 SQLite：写入 `sqlite-container-check.ris` 后重启容器仍读回 1 篇题录；随后删除验证生成的 `state.db` 并重启，复查默认项目为空白、题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：真实 AI、PDF 文本解析/结构化抽取，以及更完整的 Word/Excel 排版仍待后续实现；SQLite 目前是状态表持久化，不是完全规范化业务表。

## 2026-06-07 前端认证登录闭环

- 前端 API client 新增 `login(username, password)` 与 Bearer token 自动附加；登录后后续项目、文献、Gate、导出等 API 请求会带 `Authorization: Bearer ...`。
- `App.vue` 新增最小认证状态：接口返回 `AUTH_REQUIRED` 时显示“接口登录”表单；登录成功后清空密码、保留“接口登录成功”提示，并自动重新同步真实项目数据。
- 新增 E2E `tests/e2e/api-auth.spec.js`：启动带真实 PBKDF2 密码哈希配置的后端，验证 401 后出现登录表单，输入凭据后可同步默认项目和 0 篇文献。
- API client 单元测试新增 token 传递断言；`flow-closure`/`api-auth` 均使用自启动 Vite 随机端口，避免误连本机其他 5173 应用。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/api-auth.spec.js --reporter=line`。
- Docker 8787 已重建验证：默认未启用认证时浏览器仍直接进入工作台，可见默认项目和 PICO 配置，不显示登录页；接口复查题录 0、全文 0、对象文件 0。
- 仍未完成生产级目标：真实 AI、PDF 文本解析/结构化抽取，以及更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-07 PDF 文本提取接口接入

- 后端全文上传新增文本型 PDF 解析：`content_type=application/pdf` 且 PDF 内容流可读时，会从 `stream ... endstream` 文本绘制指令中提取真实文本，记录 `text_extraction_status`、`extracted_text_length` 和 `extracted_text_url`。
- 新增 `GET /api/fulltexts/{id}/extracted-text`，返回已提取的全文文本；全文列表和上传响应只返回提取元数据，不回显 `extracted_text` 正文，避免大文本扩散。
- 解析器是无依赖轻量实现，支持未压缩 PDF 内容流中的 literal string / hex string 文本；对压缩流或不可读 PDF 不编造结果，状态为不可用。
- 后端测试新增文本型 PDF 上传覆盖：上传真实 PDF 字节后断言提取状态为 `succeeded`，独立接口返回原文文本，列表不回显正文。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/api-auth.spec.js --reporter=line`。
- Docker 8787 已重建并实测：上传 `container-extractable.pdf` 后返回 `extracted_text_url`，GET extracted-text 返回 `Container PDF extraction validates real full text parsing.`；随后删除验证生成的 `state.db` 和对象文件并重启，复查默认项目为空白、题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：真实 AI、压缩/扫描版 PDF 的完整解析或 OCR，以及更完整的 Word/Excel 排版仍待后续实现。

## 2026-06-09 真实 AI 初筛后端接口接入

- 后端新增 `POST /api/literature/{id}/ai-screening`：只在配置真实 OpenAI-compatible provider 时调用外部模型，并把返回的 `decision`、`confidence`、`rationale` 写入题录 `ai_decision`、`ai_confidence`、`ai_rationale`、`ai_model`、`ai_screened_at` 字段。
- 未配置 AI 时接口返回 503 `AI_NOT_CONFIGURED`，不会生成伪 AI 判断，也不会覆盖人工 `user_decision`；模型返回格式无效或 provider 调用失败时返回 502 `AI_SCREENING_FAILED`。
- AI 配置来源：`createApiServer({ ai: { apiKey, baseUrl, model } })`，或环境变量 `OPENAI_API_KEY`/`AI_API_KEY`、`OPENAI_BASE_URL`/`AI_API_BASE_URL`、`OPENAI_MODEL`/`AI_MODEL`。
- TDD 验证：先新增后端测试并确认 404 失败，再实现接口；`npm run test:api` 通过 27 个后端用例，新增覆盖未配置拒绝和配置后真实 HTTP 请求 `/v1/chat/completions`。
- 回归验证通过：`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/api-auth.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- 运行态验证：Docker Desktop Linux engine 当前不可用，`docker compose up -d --build` 无法连接 Docker API；已改用本地 Node 后端在 `http://127.0.0.1:8787/` 启动，健康检查、项目/题录/全文空白接口和应用内浏览器页面均可访问。
- 仍未完成生产级目标：前端触发 AI 建议按钮、真实线上 AI 凭据配置、压缩/扫描版 PDF/OCR、更完整 Word/Excel 排版、SQLite 规范化业务表仍待后续推进。

## 2026-06-09 前端 AI 初筛入口与生产同源 API 修复

- 前端 API client 新增 `requestAiScreening(literatureId)`，并把后端 `ai_decision`、`ai_confidence`、`ai_rationale`、`ai_model`、`ai_screened_at` 映射为前端文献字段。
- `LiteratureScreeningWorkspace.vue` 新增“获取 AI 建议”按钮和 AI 建议展示区；组件仍保持 props down / events up，只发出 `request-ai-screening` 事件，实际接口调用由 `App.vue` 编排。
- `App.vue` 新增 `requestAiScreening` 处理：调用真实后端 `/api/literature/{id}/ai-screening`，成功后只更新 `ai_*` 建议字段；不覆盖人工 `userDecision`，未配置接口时只提示“AI 建议需要后端接口”。
- 修复生产可用性问题：Docker/静态生产构建未设置 `VITE_API_BASE_URL` 时，前端现在默认使用 `window.location.origin` 调用同源 API；保留显式 `VITE_API_BASE_URL` 优先级，Vite 本地未配置时仍可走本地模式。
- 新增 E2E：`tests/e2e/ai-screening.spec.js` 覆盖配置真实 OpenAI-compatible provider 后页面点击 AI 建议并保持人工判断不变；`tests/e2e/static-prod-api.spec.js` 覆盖生产静态页无需构建时 API URL 也能同步同源后端。
- 验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/api-auth.spec.js --reporter=line`、`npx playwright test tests/e2e/ai-screening.spec.js --reporter=line`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- Docker 8787 已重建并验证：容器 healthy，`/api/projects/review-001/literature` 返回 0 篇，`/api/literature/not-found/ai-screening` 命中新后端路由并返回 `LITERATURE_NOT_FOUND`；应用内浏览器刷新后“同步接口”按钮启用，点击后显示 `接口已同步：0 篇文献`。
- 仍未完成生产级目标：真实线上 AI 凭据配置、压缩/扫描版 PDF/OCR、更完整 Word/Excel 排版、SQLite 规范化业务表仍待后续推进。

## 2026-06-09 PDF FlateDecode 压缩流提取增强

- 后端 PDF 文本提取从只支持未压缩内容流，扩展为支持 `/Filter /FlateDecode` 压缩文本流；实现使用 Node `zlib.inflateSync`，并兼容 raw deflate 的 `inflateRawSync` fallback。
- 提取逻辑仍只从可读文本绘制指令中提取真实 literal/hex string；不可解压、扫描件或无文本层 PDF 不编造 OCR 结果，仍返回 `text_extraction_status=not_available`。
- 后端测试新增两类真实压缩流覆盖：zlib-wrapped FlateDecode 与 raw deflate FlateDecode，均通过上传 PDF 字节、读取 `/api/fulltexts/{id}/extracted-text` 验证原文文本。
- 验证通过：`npm run test:api`（29 个后端用例）、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- Docker 8787 已重建并实测 raw deflate 压缩 PDF：上传 `container-compressed-extractable.pdf` 后返回 `text_extraction_status=succeeded`，GET extracted-text 返回 `Container compressed PDF extraction validates FlateDecode parsing.`。
- 验证数据已清理：删除本轮生成的 `data/state.db` 与 `data/objects/fulltexts` 后重启容器；复查健康、题录 0、全文 0、对象文件 0，新的空白 `state.db` 已生成。
- 仍未完成生产级目标：扫描版 PDF/OCR、真实线上 AI 凭据配置、更完整 Word/Excel 排版、SQLite 规范化业务表仍待后续推进。

## 2026-06-09 DOCX 全文文本提取接入

- 后端全文上传的文本提取能力从 PDF 扩展到 DOCX：当上传 `application/vnd.openxmlformats-officedocument.wordprocessingml.document` 或 `.docx` 文件时，会读取 ZIP 包内 `word/document.xml` 并提取真实 `w:t` 文本。
- DOCX ZIP 读取支持 stored 与 deflate 条目；提取结果继续只通过 `/api/fulltexts/{id}/extracted-text` 返回，上传响应和全文列表只保留 `text_extraction_status`、`extracted_text_length`、`extracted_text_url` 等元数据，不回显正文。
- TDD 验证：先新增 DOCX 上传提取测试并确认失败（状态为 `not_available`），再实现后端解析；最终 `npm run test:api` 通过 30 个后端用例。
- 回归验证通过：`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- Docker 8787 已重建并实测：上传 `container-extractable.docx` 后返回 `text_extraction_status=succeeded`，GET extracted-text 返回 `DOCX Container Check Container DOCX extraction validates real document parsing.`。
- 验证数据已清理：删除本轮生成的 `data/state.db` 与 DOCX 对象文件后重启容器；复查健康 ok、题录 0、全文 0、对象文件 0。
- 仍未完成生产级目标：扫描版 PDF/OCR、真实线上 AI 凭据配置、更完整 Word/Excel 排版、SQLite 规范化业务表仍待后续推进。

## 2026-06-09 SQLite 业务表持久化增强

- 后端 SQLite 持久化从单一 `app_state` JSON blob 扩展为同步写入规范化业务表：`projects`、`literature`、`gates`、`csv_profiles`、`full_texts`、`tasks`、`timeline`。
- `app_state` 仍保留为旧数据兼容路径；当 `app_state` 缺失时，后端会从业务表重建运行状态，避免数据库只有不可查询 blob。
- TDD 验证：先扩展 SQLite 跨重启测试，要求业务表存在并写入项目/文献/Gate/时间线，随后删除 `app_state` 再重启服务验证文献人工判断、Gate A 和时间线仍能恢复；实现前失败为 `no such table: projects`，实现后通过。
- 回归验证通过：`npm run test:api`（30 个后端用例）、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`、`npx playwright test tests/e2e/api-auth.spec.js --reporter=line`、`npx playwright test tests/e2e/ai-screening.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- Docker 8787 已重建并实测：导入真实 RIS、人工 include、确认 Gate A 后，宿主机 `data/state.db` 中业务表分别有项目、文献、Gate 和时间线记录；删除 `app_state` 后重启容器，API 仍恢复 1 篇文献、人工判断 include、Gate A passed 和时间线。
- 验证数据已清理：删除本轮生成的 `data/state.db` 后重启容器；复查健康 ok、题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：扫描版 PDF/OCR、真实线上 AI 凭据配置、更完整 Word/Excel 排版、进一步数据库约束/索引/迁移策略仍待后续推进。

## 2026-06-09 PRISMA 导出与 SQLite 多项目修复

- 后端 PRISMA 导出仍输出真实 SVG 流程图，但新增动态文本 XML 转义，避免项目标题包含 `&`、`<`、`>`、`"` 时生成非法 SVG。
- 新增后端测试覆盖含特殊字符项目标题的 PRISMA SVG：确认文件 MIME 为 `image/svg+xml`，标题被转义，且 Imported/Included/Excluded 统计来自真实项目状态。
- Docker 实测时暴露并修复 SQLite 多项目问题：`gates.id` 原先作为全局主键，创建第二个项目会因重复 `gate-a` 到 `gate-e` 失败；已改为 `(project_id, id)` 复合主键。
- 新增旧表迁移：启动时检测旧 `gates` 表若仍是单列主键，会重建为复合主键表并搬迁已有 Gate 记录。
- 新增后端测试覆盖 SQLite 多项目持久化：创建第二个项目后数据库中 `projects=2`、`gates=10`、`gate-a=2`，新项目 snapshot 仍有独立 5 个 Gate。
- 验证通过：`npm run test:api`（32 个后端用例）、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- Docker 8787 已重建并实测：创建 `Container & PRISMA <Review>` 项目成功，导出 `project-2-prisma-task-1.svg` 返回转义后的 `Container &amp; PRISMA &lt;Review&gt;`，未出现原始未转义标题。
- 验证数据已清理：删除本轮生成的 `data/state.db` 后重启容器；复查健康 ok、默认项目 1 个、题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：扫描版 PDF/OCR、真实线上 AI 凭据配置、更完整 Word/Excel 排版、进一步数据库索引/迁移版本管理仍待后续推进。

## 2026-06-09 后端错误分类边界修复

- 修复顶层 HTTP 异常处理：请求体 JSON 解析错误才返回 `VALIDATION_JSON_INVALID`；服务端运行期异常改为 500 `INTERNAL_SERVER_ERROR`，不再伪装成 JSON 校验失败。
- 新增 `requestJsonError()` 标记请求体解析错误，`readJson()` 捕获 JSON.parse 失败后打专用错误码；顶层 catch 只对该错误码返回 400。
- 500 错误响应使用固定 detail `Unexpected server error`，避免把内部 TypeError、数据库错误或路径细节暴露给前端。
- 后端测试新增两类覆盖：非法 JSON 请求体仍返回 400 `VALIDATION_JSON_INVALID`；内部运行期异常返回 500 `INTERNAL_SERVER_ERROR` 且不包含 `TypeError` / `Cannot read` 细节。
- 验证通过：`npm run test:api`（34 个后端用例）、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`；`rg "mock|模拟" -n` 无命中。
- Docker 8787 已重建并实测：非法 JSON 请求返回 400 `VALIDATION_JSON_INVALID`，健康检查 ok，默认项目 1 个、题录 0、全文 0、任务 0、对象文件 0。
- 仍未完成生产级目标：扫描版 PDF/OCR、真实线上 AI 凭据配置、更完整 Word/Excel 排版、进一步数据库索引/迁移版本管理仍待后续推进。

## 2026-06-09 扫描版 PDF 文本提取状态闭环

- 后端全文上传新增 `text_extraction_reason` 元数据；无文本层/扫描版 PDF 仍不编造 OCR 文本，返回 `text_extraction_status=not_available`，并明确提示“扫描版或图片型 PDF 需要先进行 OCR”。
- `/api/fulltexts/{id}/extracted-text` 在无可提取文本时会把提取失败原因放入错误 detail，全文列表也返回该原因，便于前端提示用户下一步。
- SQLite `full_texts` 表新增 `text_extraction_reason` 列，并带旧库补列逻辑；API client、类型和全文材料列表已同步显示文本提取状态。
- 验证通过：`npm run test:api`（35 个后端用例）、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。
- 仍未完成生产级目标：真正 OCR 引擎接入、真实线上 AI 凭据配置、更完整 Word/Excel 排版、进一步数据库索引/迁移版本管理仍待后续推进。

## 2026-06-09 真实 AI 配置状态闭环

- 后端新增 `GET /api/config/status`，返回非敏感运行配置状态；AI 部分只暴露 `enabled`、`api_key_configured`、`model_configured`、`model`、`provider`、`missing` 和提示文案，不返回 API key。
- `AI_NOT_CONFIGURED` 错误 detail 已改为具体缺失项提示，便于前端和部署人员判断需要配置 `OPENAI_API_KEY`/`AI_API_KEY` 与 `OPENAI_MODEL`/`AI_MODEL`。
- 前端 API client 新增 `loadConfigStatus()`；同步接口时会刷新 AI 配置状态，文献初筛页显示 AI 是否可用，未配置时禁用“获取 AI 建议”按钮。
- 验证通过：`npm run test:api`（35 个后端用例）、`npm run test:client`（21 个前端 client 用例）、`npm run build`、`npx playwright test tests/e2e/ai-screening.spec.js --reporter=line`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`、`npx playwright test tests/e2e/api-auth.spec.js --reporter=line`。
- 仍未完成生产级目标：真正 OCR 引擎接入、更完整 Word/Excel 排版、进一步数据库索引/迁移版本管理、任务失败/重试闭环仍待后续推进。

## 2026-06-09 DOCX/XLSX 导出结构增强

- DOCX 生成器新增小节标题和表格支持，原有 `title + paragraphs` 调用保持兼容；论文导出现在包含“导出摘要”“Gate 审核状态”“已纳入文献”“全文材料与数据文件”等结构化小节。
- XLSX 生成器从单 sheet 兼容扩展为多 sheet，保留旧 `sheetName + rows` 调用；文献 XLSX 导出现在包含 `Summary`、`Literature`、`Gates`、`FullTexts`、`CsvProfile`、`Timeline` 六个工作表，并带冻结首行与自动筛选声明。
- 后端 artifact 生成已把真实项目、文献、Gate、全文材料、CSV profile 和时间线写入导出文件，避免导出只是一张文献表。
- 验证通过：`npm run test:api`（35 个后端用例）、`npm run test:client`（21 个前端 client 用例）、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`。
- 仍未完成生产级目标：真正 OCR 引擎接入、进一步数据库索引/迁移版本管理、任务失败/重试闭环、DOCX/XLSX 更精细样式和引用排版仍待后续推进。

## 2026-06-09 SQLite 迁移版本与查询索引增强

- 后端 SQLite 迁移记录从仅保存 ID/时间，增强为保存迁移顺序 `sequence` 和说明 `description`；新增迁移版本 `20260609_005_migration_metadata_and_status_indexes`。
- 启动时会为旧 `schema_migrations` 表幂等补齐 `sequence` 与 `description` 列，并继续保留既有迁移记录的 `applied_at`。
- 新增项目内常用状态查询索引：`idx_projects_updated_at`、`idx_literature_project_screening`、`idx_full_texts_project_status`、`idx_tasks_project_created`。
- 后端测试已覆盖迁移版本元数据和索引集合；验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`。
- 仍未完成生产级目标：真正 OCR 引擎接入、真实线上 AI 凭据配置、更细的数据库迁移执行框架/回滚策略、DOCX/XLSX 引用排版细化。


## 2026-06-09 导出归档多文件下载闭环

- 前端导出页从“只显示最后一次导出链接”增强为“已生成文件”列表；连续导出 DOCX、XLSX 等多种格式后，每个文件都有独立下载入口。
- `TaskItem` 与 API client 现在保留后端任务的 `format` 和 `result.files`，项目快照重新同步后可从已完成任务恢复下载列表。
- 导出下载 URL 改为使用实际 `apiBaseUrl` 统一拼接，覆盖显式 `VITE_API_BASE_URL` 与生产同源 API 两种场景。
- 本地无后端模式也会把生成的 blob 导出文件加入同一文件列表，保证原型流程仍可下载。
- E2E 已扩展：API 同步流程连续导出 DOCX 与 XLSX 后同时显示两个下载链接，并在点击“同步接口”后仍保留下载入口。
- 验证通过：`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:api`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`。
- 本轮尝试启动本地 Vite 服务到 `127.0.0.1:5174`，但后台进程未成功保留；未继续强行启动，主要可用性由 Playwright e2e 覆盖。

## 2026-06-09 任务失败与重试闭环设计

- 已确认下一步优先推进“任务失败/重试闭环”，作为 OCR、导出和 AI 后续异步任务的通用可靠性基础。
- 设计 spec 已写入 `E:\product\nursing_paper_platform\docs\superpowers\specs\2026-06-09-task-failure-retry-design.md`。
- 设计范围：扩展任务失败元数据、重试次数/上限、失败与重试时间线事件、前端任务队列失败原因与重试按钮、JSON/SQLite 持久化和测试覆盖。
- 明确不做：OCR 实现、AI 调用策略改造、外部队列/worker、任务管理大页面、新依赖。
- 当前项目目录不是 Git 仓库，无法提交该 spec；后续若需要版本管理，应先确认是否初始化或关联 Git 仓库。

## 2026-06-10 任务失败与重试闭环实现

- 已完成 export 异步任务失败/重试闭环：后端记录 `attempts`、`max_attempts`、`error_code`、`error_message`、`failed_at`、`updated_at`，并在失败和重试时写入时间线事件。
- 重试仅支持 export 任务；失败任务可重试到 `max_attempts` 上限，达到上限返回 `TASK_RETRY_LIMIT_REACHED`。
- SQLite normalized `tasks` 表已新增失败元数据列并支持旧库幂等补列；删除 `app_state` 后仍可从业务表恢复失败任务状态。
- 前端 API client 已映射失败元数据；任务队列 UI 显示失败原因、尝试次数、重试按钮和重试上限，并补充 progressbar ARIA 与长文本换行保护。
- 新增浏览器测试 `tests/e2e/task-retry.spec.js`，覆盖 fail-once 导出失败、点击重试、生成下载链接、再次同步后下载入口保留。
- 本轮完整验证通过：`npm run test:api`、`npm run test:client`、`npm run build`、`npx playwright test tests/e2e/task-retry.spec.js --reporter=line`、`npm run test:api-sync`、`npm run test:flow`、`npx playwright test tests/e2e/static-prod-api.spec.js --reporter=line`。
- 当前目录仍不是 Git 仓库，无法生成 git diff 或提交；如需版本管理，需要先确认仓库初始化/关联策略。
- 仍未完成生产级目标：真实线上 AI 凭据配置、OCR 引擎接入、外部 worker/队列、DOCX/XLSX 引用排版细化。
## 2026-06-10 项目完整测试与使用需求评估

- 本轮未修改项目源码，按现有设计文档和测试覆盖做可用性评估：构建、后端 API、前端 API client、全部 Playwright E2E 和生产静态服务冒烟均通过。
- 验证通过：`npm run build`；`npm run test:api`（41 个后端用例）；`npm run test:client`（23 个前端 client 用例）；`npx playwright test tests/e2e --reporter=line --workers=1`（6 个 E2E 全通过）；生产构建由 `createApiServer({ staticDir: "dist" })` 服务时，页面标题可见、同步接口按钮可见、`/health` 返回 `ok`。
- 结论：当前项目满足“本地 MVP / 演示级使用需求”，可以完成 PICO、检索式、RIS/CSV/全文导入、初筛与 Gate、人工作业留痕、写作复核、导出任务、失败重试和下载入口等闭环。
- 边界：尚不能认定满足生产级真实科研平台需求；仍缺真实线上 AI 凭据与稳定调用验证、OCR 引擎、外部 worker/队列、大规模性能验证、DOCX/XLSX 引用排版细化，以及真实用户可用性测试。
- 当前目录仍没有可读 Git 元数据，无法用 `git status` / `git log` 校验工作区差异或最近提交。

## 2026-06-10 OCR provider 接入进展

- 本轮推进生产级缺口中的“扫描版 PDF/OCR”：后端新增可配置 OCR provider，PDF 原生文本提取仍优先；只有有效 PDF 无文本层时才调用 OCR。
- 支持两类配置路径：`createApiServer({ ocr: { extractText } })` 供嵌入式/测试接入；生产部署可配置 `OCR_COMMAND`、`OCR_ARGS_JSON`、`OCR_TIMEOUT_MS` 调外部 OCR 程序，命令通过 `execFile` 执行，不拼接 shell 字符串。
- OCR 成功时全文材料状态为 `text_extraction_status=succeeded`，保存 `extracted_text` 并暴露 `/api/fulltexts/{id}/extracted-text`；OCR 未配置时仍保留原先“需要先进行 OCR”的明确提示；OCR 失败时上传不崩溃，状态为 `not_available` 并记录失败原因。
- `/api/config/status` 新增非敏感 `ocr` 状态，只返回 `enabled`、`provider_configured`、`message`，不暴露 OCR 命令、参数或路径；前端 API client 和类型已同步映射 `OcrConfigStatus`。
- TDD 验证：新增扫描版 PDF 配置 OCR 后可提取文本测试，先确认失败为 `not_available`，实现后通过；新增 OCR 配置状态测试，先确认缺少 `ocr` 字段，后实现通过。
- 回归验证通过：`npm run test:api`（43 个后端用例）、`npm run test:client`（23 个前端 client 用例）、`npm run build`、`npx playwright test tests/e2e --reporter=line --workers=1`（6 个 E2E）。
- 仍未完成生产级目标：真实 OCR 二进制/服务部署与样本库验证、真实线上 AI 凭据稳定调用、外部 worker/队列、大规模性能验证、DOCX/XLSX 引用排版细化、真实用户可用性测试。

## 2026-06-10 后台任务执行器生产化进展

- 本轮推进生产级缺口中的“外部/后台任务执行”：新增后端后台任务执行模式，导出任务创建或重试后可由服务端执行器推进，不再依赖 `GET /api/tasks/{id}` 轮询请求产生执行副作用。
- 兼容策略：默认仍保留既有 polling 模式，避免破坏现有前端流程；显式配置 `taskExecutor: "background"` 或环境变量 `TASK_EXECUTOR=background` 后启用后台执行。
- 新增 `TASK_EXECUTION_DELAY_MS` / `taskExecutionDelayMs` 控制本地执行器调度延迟；服务关闭时会清理 pending timers；后台执行中的状态变更会写回 JSON/SQLite 持久化。
- Docker Compose 默认加入 `TASK_EXECUTOR=background` 和 `TASK_EXECUTION_DELAY_MS=25`，使仓库自带部署配置更接近生产运行方式。
- TDD 验证：先新增“后台模式下不调用 `/api/tasks/{id}`，仅从 snapshot 看到任务完成”测试，确认失败为任务仍 `queued`；实现后通过。随后新增 `TASK_EXECUTOR=background` 环境变量启用测试，确认失败后接入环境配置并通过。
- 回归验证通过：`npm run test:api`（45 个后端用例）、`npm run test:client`（23 个前端 client 用例）、`npm run build`、`npx playwright test tests/e2e --reporter=line --workers=1`（6 个 E2E）。`docker compose config` 可解析并显示后台任务环境变量，但本机 Docker 配置读取有 `C:\Users\Administrator\.docker\config.json` access denied 警告。
- 仍未完成生产级目标：真正外部队列/worker 进程或 Redis/BullMQ/Celery 级持久队列、真实 OCR 二进制/服务部署与样本库验证、真实线上 AI 凭据稳定调用、大规模性能验证、DOCX/XLSX 引用排版细化、真实用户可用性测试。

## 2026-06-10 DOCX/XLSX 参考文献导出增强

- 本轮推进生产级缺口中的“DOCX/XLSX 引用排版细化”：导出 artifact 现在会基于 `user_decision=include` 的真实文献生成格式化参考文献。
- DOCX 论文主文件新增“参考文献”章节；XLSX 导出新增 `References` 工作表，包含 `reference_number`、`formatted_reference`、题名、作者、期刊、年份、来源和文献 ID，便于投稿前人工核查与二次整理。
- 引用格式当前采用保守的编号式格式：`[1] Huang M, Carter P. Title. Journal. 2024.`；作者解析支持 RIS 常见 `Family, Given; Family, Given` 形式并转为首字母缩写。
- 若没有已纳入文献，DOCX/XLSX 会明确写入“暂无已纳入文献，无法生成参考文献。”，避免暗示已生成完整引用。
- TDD 验证：新增独立 artifact 测试，先确认 DOCX 缺少“参考文献”失败；实现后验证 DOCX 和 XLSX 均包含格式化引用与 `References` sheet。
- 回归验证通过：`npm run test:api`（46 个后端用例）、`npm run test:client`（23 个前端 client 用例）、`npm run build`、`npx playwright test tests/e2e --reporter=line --workers=1`（6 个 E2E）。
- 仍未完成生产级目标：AMA/APA/GB/T 等多格式引用选择、DOI/PMID/卷期页码字段完善、真实 OCR 二进制/服务部署与样本库验证、真实线上 AI 凭据稳定调用、真正外部队列/worker、大规模性能验证、真实用户可用性测试。

## 2026-06-10 请求体大小限制与资源保护

- 本轮推进生产级资源保护缺口：后端 JSON 请求体读取新增大小限制，默认 10MB，可通过 `createApiServer({ maxRequestBodyBytes })` 或环境变量 `MAX_REQUEST_BODY_BYTES` 配置。
- 超过限制的请求现在返回 HTTP 413，错误码 `REQUEST_BODY_TOO_LARGE`，不会继续进入项目创建、导入、上传等业务逻辑。
- 登录接口和普通 `/api` 路由共用同一请求体限制；畸形 JSON 仍保持原有 HTTP 400 / `VALIDATION_JSON_INVALID` 行为。
- TDD 验证：新增超限请求测试，先确认当前会错误创建项目并返回 201；实现后返回 413 并通过。
- 完整回归验证通过：`npm run test:api`（50 个后端用例）、`npm run test:client`（23 个前端 client 用例）、`npm run build`、`npx playwright test tests/e2e --reporter=line --workers=1`（6 个 E2E）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实线上 AI 稳定调用、真正外部队列/worker、大规模性能验证、真实用户可用性测试。

## 2026-06-10 文献列表分页能力

- 本轮推进生产级大规模数据处理缺口：后端 `/api/projects/{projectId}/literature` 支持可选 `limit` / `offset` 分页参数，默认仍保持全量返回兼容旧前端流程。
- 分页响应新增 `total`、`limit`、`offset` 和当前页 `items`，用于上百/上千题录场景下分批加载与后续 UI 分页。
- 前端 API client `listLiterature(projectId, { limit, offset })` 已同步支持分页 query，并映射返回的分页元数据；不传参数时仍请求原 URL。
- TDD 验证：先新增 `limit=1&offset=1` 后端测试确认缺少分页元数据失败；实现后通过。随后新增 client 分页 URL 测试，先确认仍请求无分页 URL；实现后通过。
- 完整回归验证通过：`npm run test:api`（50 个后端用例）、`npm run test:client`（23 个前端 client 用例）、`npm run build`、`npx playwright test tests/e2e --reporter=line --workers=1`（6 个 E2E）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实线上 AI 稳定调用、真正外部队列/worker、大规模性能/压测、真实用户可用性测试。

## 2026-06-10 生产 CORS 来源限制

- 为后端 API 增加可配置 CORS 来源限制：默认保持 `*` 兼容本地/既有用法；通过 `corsOrigin` / `CORS_ORIGIN` 配置生产允许来源，支持逗号分隔的多来源列表。
- 配置生产来源后，匹配的 `Origin` 会回显到 `access-control-allow-origin` 并返回 `Vary: Origin`；未匹配来源不返回 allow-origin，避免生产环境继续宽放跨站请求。
- 覆盖测试：`tests/backend/api.test.mjs` 新增生产来源限制用例。
- 验证通过：`npm run test:api` 51/51；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6。

## 2026-06-10 生产模式认证强制

- 为后端 API 增加生产启动保护：当 `NODE_ENV=production` 且认证未启用时，`createApiServer()` 会立即失败，提示配置 `APP_ADMIN_PASSWORD_HASH` 和 `APP_SESSION_SECRET`，避免生产部署默认裸奔。
- 开发/测试默认未配置认证仍保持兼容；生产模式下提供有效 `pbkdf2-sha256:<iterations>:<salt>:<hex-hash>` 和 session secret 后可正常创建服务。
- `docker-compose.yml` 已要求生产环境提供 `APP_ADMIN_PASSWORD_HASH` 和 `APP_SESSION_SECRET`，`APP_ADMIN_USERNAME` 默认 `admin`。
- TDD 验证：新增 `requires authentication when NODE_ENV is production`，先确认 RED 为缺少预期异常，再实现后 GREEN。
- 验证通过：`npm run test:api` 52/52；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；`docker compose config` 在缺少认证变量时按预期失败，提供占位变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实线上 AI 稳定调用、真正外部队列/worker、大规模性能/压测、真实用户可用性测试。

## 2026-06-10 AI provider 超时与重试保护

- 本轮推进生产级缺口中的“真实线上 AI 稳定调用”：后端 AI 初筛 provider 调用新增可配置超时与有限重试。
- 支持 `AI_TIMEOUT_MS` / `ai.timeoutMs`，默认 30000ms；超时会通过 `AbortController` 中断请求并返回 `AI_SCREENING_FAILED`，错误 detail 明确包含超时时间，避免请求无限挂起。
- 支持 `AI_MAX_RETRIES` / `ai.maxRetries`，默认 1，最大限制为 3；仅对网络/超时/5xx 等可恢复失败重试，AI 响应结构或 JSON 内容错误不重试。
- `docker-compose.yml` 已加入非敏感默认值：`AI_TIMEOUT_MS=30000`、`AI_MAX_RETRIES=1`。
- TDD 验证：新增慢 provider 超时测试，先确认 RED 为缺少 abort signal；新增首次 502 后重试成功测试，先确认 RED 为直接返回 502；实现后两者 GREEN。
- 验证通过：`npm run test:api` 54/54；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实线上 AI 真实凭据/真实供应商稳定调用验证、真正外部队列/worker、大规模性能/压测、真实用户可用性测试。

## 2026-06-10 外部任务 worker 单步执行

- 本轮推进生产级缺口中的“真正外部队列/worker”：后端新增 `runTaskWorkerOnce()`，可在不启动 HTTP API 的情况下，从 SQLite/JSON 持久化状态加载 queued/running export 任务并推进一步，发生变更后写回持久化存储。
- 新增 CLI 入口：`node backend/api.mjs worker-once`；`package.json` 新增 `npm run worker:once`，方便本地、cron 或容器任务单次执行。
- `docker-compose.yml` 从 API 内置 background 执行调整为 API `TASK_EXECUTOR=polling`，并新增 `nursing-paper-worker` 服务循环调用 `worker-once`，两个服务共享 `/app/data/state.db`。
- TDD 验证：新增 “advances persisted export tasks from an external worker without API polling” 测试，先确认 RED 为 `runTaskWorkerOnce` 未导出；实现后通过。测试覆盖 API 只创建 queued 任务、关闭 API、外部 worker 两次推进后重新打开 API 读取到 succeeded artifact。
- 验证通过：`npm run test:api` 55/55；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：Redis/BullMQ/Celery 级持久队列与并发锁、真实 OCR 服务部署验证、真实 AI 凭据/供应商稳定调用验证、大规模性能/压测、真实用户可用性测试。

## 2026-06-10 外部 worker 并发写入保护

- 本轮继续推进“真正外部队列/worker”生产缺口：修正外部 worker 基于旧状态快照保存时可能覆盖 API 进程并发更新的问题。
- SQLite worker 保存路径从“整份 state 覆盖写入”改为只写回本轮推进过的 task 记录和新增 timeline 事件；随后从 normalized SQLite 表重建 `app_state`，让 API 下次启动仍读取到最新一致状态。
- task upsert 增加终态保护：仅当当前任务仍处于 `queued` / `running` 时更新，避免旧 worker 覆盖已经 `succeeded` / `failed` 的任务终态。
- TDD 验证：新增 stale snapshot 测试，先确认 RED 为 worker 覆盖并发项目标题；实现后 GREEN，验证并发项目标题保留且任务推进到 `running`。
- 验证通过：`npm run test:api` 56/56；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：Redis/BullMQ/Celery 级持久队列与强并发锁、真实 OCR 服务部署验证、真实 AI 凭据/供应商稳定调用验证、大规模性能/压测、真实用户可用性测试。

## 2026-06-10 生产 readiness 就绪检查

- 本轮推进生产可观测性/部署就绪缺口：新增 `GET /ready`，区别于仅表示进程存活的 `/health`。
- `/ready` 返回非敏感 JSON：`service`、`status` 以及 `checks.storage`、`checks.static`、`checks.auth`；不会暴露数据库路径、静态目录路径、密钥或异常堆栈。
- readiness 当前检查：SQLite/JSON 持久化目录可写；配置了静态目录时必须存在 `index.html`；生产模式下认证必须启用。任一关键检查失败返回 HTTP 503 / `status=not_ready`。
- Dockerfile HEALTHCHECK 已从 `/health` 切换到 `/ready`，容器健康状态会反映存储/静态资源/认证就绪情况。
- TDD 验证：新增 readiness 成功与静态资源缺失失败两个测试；先确认 RED 为 `/ready` 被静态 HTML 接管或 404；实现后 GREEN。
- 验证通过：`npm run test:api` 58/58；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实 AI 凭据/供应商稳定调用验证、大规模性能/压测、真实用户可用性测试，以及更强的外部队列/worker 方案。

## 2026-06-10 Prometheus 请求指标

- 本轮推进生产可观测性缺口：后端新增 `GET /metrics`，输出 Prometheus 文本格式请求指标。
- 指标包括 `nursing_paper_http_requests_total` 和 `nursing_paper_http_request_duration_seconds_sum`，按 method、status 和模板化 route 聚合。
- route 标签会归一化动态段，例如 `/api/projects/review-001/snapshot?token=...` 记录为 `/api/projects/:id/snapshot`，`/api/tasks/task-secret/files/manuscript` 记录为 `/api/tasks/:id/files/:format`，避免项目 ID、任务 ID、查询串或 token 泄露到指标标签，也控制标签基数。
- TDD 验证：新增 “exports sanitized Prometheus request metrics” 测试，先确认 RED 为 `/metrics` 404；实现后 GREEN，并验证输出不包含 `review-001`、`task-secret`、`secret-token`。
- 验证通过：`npm run test:api` 59/59；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实 AI 凭据/供应商稳定调用验证、大规模性能/压测、真实用户可用性测试，以及更强的外部队列/worker 方案。
## 2026-06-10 Metrics bearer token 保护

- 本轮补齐 `/metrics` 的生产访问保护：未配置 `METRICS_BEARER_TOKEN` 时保持原有开放行为；配置后仅接受 `Authorization: Bearer <token>` 访问。
- 鉴权失败返回统一 JSON 错误信封，HTTP 401 / `METRICS_AUTH_REQUIRED`，不会回显传入 token 或配置 token；成功时仍返回 Prometheus text/plain 指标。
- `docker-compose.yml` 已加入 `METRICS_BEARER_TOKEN` 环境变量入口，生产部署可通过环境变量为监控抓取配置专用 token。
- TDD 验证：新增 “protects metrics with a dedicated bearer token when configured” 测试，先确认 RED 为未带 token 仍返回 Prometheus 文本；实现后 GREEN。
- 完整回归验证通过：`node --test tests/backend/api.test.mjs --test-name-pattern "dedicated bearer token"`；`npm run test:api` 60/60；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 OCR 服务部署验证、真实 AI 凭据/供应商稳定调用验证、大规模性能/压测、真实用户可用性测试，以及更强的外部队列/worker 方案。

## 2026-06-10 登录失败限流保护

- 本轮推进生产认证安全：后端登录接口新增失败次数限流，默认 `AUTH_LOGIN_MAX_ATTEMPTS=5`、`AUTH_LOGIN_WINDOW_MS=900000`，也可通过 `createApiServer({ loginRateLimit })` 在测试或嵌入场景覆盖。
- 限流按远端地址和提交用户名聚合；窗口内失败次数达到阈值后返回 HTTP 429 / `AUTH_RATE_LIMITED`，并带 `Retry-After` 响应头。
- 成功登录会清理对应失败计数；错误响应不会回显输入密码、真实密码或哈希内容。
- `docker-compose.yml` 已加入 `AUTH_LOGIN_MAX_ATTEMPTS` 和 `AUTH_LOGIN_WINDOW_MS` 环境变量入口。
- TDD 验证：新增 “rate limits repeated failed login attempts” 测试，先确认 RED 为第三次错误登录仍返回 401；实现后 GREEN。
- 完整回归验证通过：`node --test tests/backend/api.test.mjs --test-name-pattern "rate limits repeated failed login attempts"`；`npm run test:api` 61/61；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：限流为单进程内存态，尚未接 Redis/共享限流；真实 OCR 服务部署验证、真实 AI 凭据/供应商稳定调用验证、大规模性能/压测、真实用户可用性测试仍未完成。

## 2026-06-10 生产环境认证 Cookie Secure 属性

- 本轮继续推进生产认证安全：后端认证 cookie 生成逻辑集中为 `authCookieAttributes()`，当 `NODE_ENV=production` 时登录和退出登录的 `Set-Cookie` 都追加 `Secure`。
- 开发/测试环境仍保持非 Secure cookie，避免本地 HTTP 登录流程被浏览器拒绝。
- 登录 cookie 和清理 cookie 继续保留 `HttpOnly`、`SameSite=Lax`、`Max-Age`；测试验证响应中不包含明文密码。
- TDD 验证：新增 “marks authentication cookies secure in production” 测试，先确认 RED 为生产登录 cookie 缺少 `Secure`；实现后 GREEN。
- 完整回归验证通过：`node --test tests/backend/api.test.mjs --test-name-pattern "marks authentication cookies secure in production"`；`npm run test:api` 62/62；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 HTTPS/反向代理部署验证、共享限流/Redis、真实 OCR 服务部署验证、真实 AI 供应商稳定调用验证、大规模性能/压测和真实用户可用性测试仍未完成。

## 2026-06-10 生产 Session Secret 强度校验

- 本轮继续推进生产认证安全：`NODE_ENV=production` 下，后端现在要求 `APP_SESSION_SECRET` 至少 32 个字符；短 secret 会在 `createApiServer()` 启动阶段直接报错，避免用弱会话签名密钥上线。
- 开发/测试环境保持兼容，不强制长度；生产认证正例测试已改用 32 字符以上的 session secret。
- TDD 验证：新增 “requires a strong session secret in production” 测试，先确认 RED 为短 secret 未抛错；实现后 GREEN。
- 完整回归验证通过：`node --test tests/backend/api.test.mjs --test-name-pattern "requires a strong session secret in production"`；`npm run test:api` 63/63；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供 32 字符以上占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 HTTPS/反向代理部署验证、共享限流/Redis、真实 OCR 服务部署验证、真实 AI 供应商稳定调用验证、大规模性能/压测和真实用户可用性测试仍未完成。

## 2026-06-10 生产安全响应头

- 本轮推进生产浏览器安全基线：`NODE_ENV=production` 下所有经 `withCorsHeaders()` 输出的 API 与静态响应都会附加安全响应头。
- 当前生产安全头包括：`Content-Security-Policy`（限制 self、禁止 object、禁止被 frame 嵌入）、`Strict-Transport-Security`、`X-Content-Type-Options: nosniff`、`X-Frame-Options: DENY`、`Referrer-Policy: no-referrer`、`Permissions-Policy`（禁用 camera/microphone/geolocation）。
- 开发/测试环境默认不加这些生产安全头，避免影响本地开发和旧测试。
- TDD 验证：新增 “adds browser security headers in production” 测试，先确认 RED 为生产响应缺少 `x-content-type-options`；实现后 GREEN，并覆盖 `/` 静态响应和 `/health` API 响应。
- 完整回归验证通过：`node --test tests/backend/api.test.mjs --test-name-pattern "adds browser security headers in production"`；`npm run test:api` 64/64；`npm run test:client` 23/23；`npm run build`；`npx playwright test tests/e2e --reporter=line --workers=1` 6/6；提供 32 字符以上占位生产认证变量后 `docker compose config --quiet` 退出码 0（本机 Docker 仍有 config.json access denied 警告）。
- 当前仍未完成完整生产级目标：真实 HTTPS/反向代理部署验证、共享限流/Redis、真实 OCR 服务部署验证、真实 AI 供应商稳定调用验证、大规模性能/压测和真实用户可用性测试仍未完成。

## 2026-06-10 Gate A 前置校验与 CSV 确定性分析闭环

- 本轮按项目审查建议推进核心产品能力，而不是继续堆叠基础设施。
- 后端 Gate A 确认新增实质前置校验：空项目未导入任何题录时不能确认初筛抽查 Gate，返回 `PROJECT_STATUS_INVALID`。
- CSV 导入后新增确定性分析结果：后端基于真实 CSV 连续变量生成 Table 1 均值/标准差摘要，并提供 `GET /api/projects/{projectId}/analysis/results`。
- 前端 API client 和分析页同步接入分析结果；API 模式下同步项目、选择项目和上传 CSV 后都会刷新 Table 1。
- 测试已覆盖 Gate A 空项目阻断、CSV Table 1 结果映射，以及 API/e2e 主流程回归。
- 验证通过：后端 66 个用例、前端 client 24 个用例、`npm run build`、`npm run test:api-sync`、`npm run test:flow`。

## 2026-06-10 Gate B/D 实质前置校验

- 本轮继续按审查建议补强 Gate 质控，而不是继续扩展基础设施。
- 后端 Gate B 确认新增实质前置校验：项目必须先上传至少一份全文材料，否则返回 `PROJECT_STATUS_INVALID`，避免没有全文依据时锁定纳入清单。
- 后端 Gate D 确认新增实质前置校验：项目必须先有 CSV 导入产生的确定性分析结果，否则返回 `PROJECT_STATUS_INVALID`，避免没有分析依据时确认统计方案。
- 相关导出/worker/PRISMA/audit 测试的准备数据已调整为真实工作流前置数据：RIS 题录、全文材料和 CSV 分析结果。
- 验证通过：`npm run test:api` 68/68；`npm run test:client` 24/24；`npm run build`；`npm run test:api-sync`；`npm run test:flow`。

## 2026-06-10 Gate C 提取记录前置校验

- 为 Gate C 增加实质前置条件：项目必须至少存在一条结构化数据提取记录，否则确认 Gate C 返回 PROJECT_STATUS_INVALID。
- 新增 `/api/projects/{projectId}/extractions`：支持创建与读取手工提取记录，字段包括 study、sample_size、age、intervention、duration、outcome、confidence，并写入 timeline。
- SQLite 规范化存储新增 `extractions` 表、`idx_extractions_project_id` 索引与迁移 `20260610_006_extractions_table`，避免脱离 app_state 后丢失提取记录。
- 前端 `ExtractionWorkspace` 增加手工提取表单，`App.vue` 接入提取记录同步、本地保存与审计事件；API client 增加 `listExtractions`、`createExtraction`。
- 已验证：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-10 Gate E 初稿审查与审计导出闭环

- 为 Gate E 增加实质前置条件：项目必须至少存在一条初稿人工审查记录，否则确认 Gate E 返回 `PROJECT_STATUS_INVALID`，避免未经人工复核就进入最终导出。
- 新增 `/api/projects/{projectId}/draft-reviews`：支持创建与读取初稿审查记录，字段包括 section_id、title、content、reviewer_note，并写入 timeline；空草稿内容也允许记录审查，便于先标记人工审查事实。
- SQLite 规范化存储新增 `draft_reviews` 表、`idx_draft_reviews_project_id` 索引与迁移 `20260610_007_draft_reviews_table`。
- 前端写作段落“人工核查”在 API 模式下会先同步初稿审查记录；API client 增加 `listDraftReviews`、`createDraftReview`。
- audit JSON 导出已补齐 `extractions` 与 `draft_reviews`，让 Gate C/E 的通过依据进入可下载审计包。
- 已验证：`npm run test:api` 73/73、`npm run test:client` 26/26、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-10 XLSX 结构化提取表导出

- 本轮继续修正最终交付物与流程工作台之间的偏差：XLSX 导出不再只包含文献、Gate、全文、CSV、时间线和参考文献，也会追加 `Extractions` 工作表。
- `Extractions` 工作表导出手工提取记录字段：study、sample_size、age、intervention、duration、outcome、confidence、created_at，使 Gate C 的结构化证据能进入表格交付件。
- 新增专用后端测试，临时启动 API、种完整流程前置数据、确认 Gate A-E、导出 XLSX，并断言 `sheet8.xml`、`Extractions`、`Huang 2024` 和 `MMSE change` 存在。
- 已验证：`npm run test:api` 74/74、`npm run test:client` 26/26、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 DOCX 结构化提取记录导出

- 本轮继续修正最终 Word 交付物与流程工作台之间的偏差：manuscript DOCX 现在包含 `结构化提取记录` 章节。
- 该章节以表格导出 Gate C 的手工提取记录字段：研究、样本量、年龄、干预、时长、结局、可信度，使数据提取工作台产物进入 Word 论文交付件。
- 新增专用后端测试，临时启动 API、种完整流程前置数据、确认 Gate A-E、导出 manuscript，并断言 `结构化提取记录`、`Huang 2024`、`Structured music therapy` 和 `MMSE change` 存在。
- 已验证：`npm run test:api` 75/75、`npm run test:client` 26/26、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 XLSX 初稿审查记录导出

- 本轮继续修正 Gate E 审查证据与常规交付物之间的偏差：XLSX 导出现在追加 `DraftReviews` 工作表。
- `DraftReviews` 工作表导出初稿审查记录字段：section_id、title、content、reviewer_note、created_at，使导出前人工审查依据不仅存在于 audit JSON，也进入表格交付件。
- 新增专用后端测试，临时启动 API、种完整流程前置数据、确认 Gate A-E、导出 XLSX，并断言 `sheet9.xml`、`DraftReviews`、`abstract` 和审查内容存在。
- 已验证：`npm run test:api` 76/76、`npm run test:client` 26/26、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 DOCX 初稿审查记录导出

- 本轮继续修正 Gate E 审查证据与 Word 交付物之间的偏差：manuscript DOCX 现在包含 `初稿审查记录` 章节。
- 该章节以表格导出初稿审查字段：章节、标题、内容、审查备注，使导出前人工复核依据进入 Word 论文交付件。
- 新增专用后端测试，临时启动 API、种完整流程前置数据、确认 Gate A-E、导出 manuscript，并断言 `初稿审查记录`、`abstract`、`Abstract` 和审查内容存在。
- 已验证：`npm run test:api` 77/77、`npm run test:client` 26/26、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 Gate C 质量评价记录闭环

- 为护理综述平台补齐 Gate C 前置证据：新增 `qualityAssessments` 状态、`/api/projects/{projectId}/quality-assessments` GET/POST 接口、SQLite `quality_assessments` 表与迁移 `20260611_008_quality_assessments_table`。
- Gate C 后端确认现在要求同一项目至少存在一条质量评价记录，随后仍要求至少一条结构化提取记录；缺任一证据均返回 `PROJECT_STATUS_INVALID`。
- 前端 API client 增加 `listQualityAssessments` 与 `createQualityAssessment`，e2e API 同步流程在 Gate C 前补种质量评价记录。
- 已验证：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:flow`、`npm run test:api-sync` 全部通过。

## 2026-06-11 PubMed 检索式质量与检索记录追溯

- PubMed 检索式生成从裸 P/I/C/O 拼接升级为字段化查询：核心短语使用 `[Title/Abstract]`，并对 dementia、music therapy、cognitive、frailty、nursing、falls 等常见护理综述术语补充 MeSH Terms 线索。
- 新增 `searchRecords` 状态与 `GET /api/projects/{projectId}/search-records`，每次 PubMed 导入都会生成可追溯记录，包含 database、query、retmax、fetched_count、imported_count、duplicate_pairs、created_at。
- SQLite 规范化存储新增 `search_records` 表、`idx_search_records_project_id` 索引与迁移 `20260611_009_search_records_table`。
- 前端 API client 增加 `SearchRecord` 映射、`listSearchRecords`，`importPubMed` 响应会携带 `searchRecord`。
- API 同步 e2e 已更新为断言字段化 PubMed 检索式；纯前端本地演练仍保留原型检索式展示。
- 已验证：`npm run test:api`、`npm run test:client`、`npm run build`、`npm run test:flow`、`npm run test:api-sync` 全部通过。

## 2026-06-11 audit 证据包补齐 CSV/PubMed/质量评价

- audit JSON 导出新增 `csv_analysis`，直接包含 CSV 确定性分析结果（Table 1 / regression），使 Gate D 的分析依据随审计包下载。
- audit JSON 导出新增 `search_records`，包含 PubMed 检索记录 query、retmax、fetched/imported/duplicate 计数和时间，补齐检索追溯链路。
- audit JSON 导出新增 `quality_assessments`，让 Gate C 前置质量评价依据进入审计包，而不只存在于接口状态中。
- 已验证：`node --test tests\backend\api.test.mjs --test-name-pattern "downloads audit artifact"`、`npm run test:client`、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 均通过；聚焦后端命令实际执行了后端全套 79 个用例。

## 2026-06-11 Gate 通过后后端证据锁定

- 后端新增 Gate 通过后的证据锁定校验：已通过 Gate A 后锁定 RIS/PubMed 导入、人工初筛和 AI 初筛写入；Gate B 后锁定全文上传；Gate C 后锁定质量评价和结构化提取；Gate D 后锁定 CSV 分析数据导入；Gate E 后锁定初稿审查记录。
- 锁定后的写操作返回 HTTP 409 / `PROJECT_LOCKED`；无效请求仍优先走原有 400 校验，GET、导出和已生成文件下载不受影响。
- 新增后端测试 `locks reviewed evidence after each Gate is passed`，按 Gate A-E 顺序逐步确认后尝试修改对应证据，覆盖锁定矩阵。
- 已验证：`npm run test:api` 80/80、`npm run test:client` 27/27、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 对象存储 readiness 检查

- 在继续评估 MinIO/Redis 前，先增强当前本地对象存储方案的可观测性：`/ready` 现在会检查 `objectStoreDir` 是否可创建、可写入探针文件并可清理。
- readiness 响应新增 `checks.object_store`，包含 `configured`、`ok` 和简短 message；对象存储路径不可用时返回 HTTP 503 / `not_ready`。
- 新增后端测试覆盖正常对象存储目录与“对象存储路径实际是文件”的不可用场景，避免容器挂载或权限错误在上线后才暴露。
- 已验证：`npm run test:api` 81/81、`npm run test:client` 27/27、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 Redis 队列与 MinIO/S3 对象存储实现

- 护理论文平台从“暂缓引入 Redis/MinIO”推进为可选生产实现：默认仍保持 SQLite + 本地对象目录；配置外部服务时启用 Redis 队列与 MinIO/S3 兼容对象存储。
- 后端新增 S3 SigV4 PUT/GET 对象存储适配，无新增 npm 依赖；全文二进制上传可写入 `s3://bucket/fulltexts/...`，下载接口从对象服务读取。
- 后端新增 Redis RESP 最小客户端，无新增 npm 依赖；创建导出任务时 `RPUSH` 任务 ID，`worker-once` 配置 Redis 后通过 `LPOP` 消费任务并在任务仍 running 时重新入队。
- `docker-compose.yml` 新增 `redis`、`minio`、`minio-init` 服务，并将 API/worker 环境变量接入 `REDIS_URL`、`OBJECT_STORE_DRIVER=s3`、`OBJECT_STORE_ENDPOINT=http://minio:9000` 等配置。
- `docs/production-readiness.md` 已更新为当前生产拓扑、必填变量和可选变量说明。
- 已验证：`npm run test:api` 85/85、`npm run test:client` 27/27、`npm run test:deploy` 3/3、`npm run build`、`npm run test:api-sync`、`npm run test:flow` 全部通过。

## 2026-06-11 Docker 镜像打包与服务重启

- 新增 `deploy.ps1`，用于本机生成未提交的 `.env`、构建 `nursing-paper-platform:latest`、重启 Compose 服务，并检查 `/ready` 与 `/health`。
- `nursing-paper-worker` 已改为复用 `nursing-paper-platform:latest` 应用镜像，不再单独 build；worker 禁用镜像继承的 API 健康检查。
- MinIO 保持 Compose 内网访问，移除宿主机 9000/9001 端口发布，避免端口冲突并降低暴露面；`minio-init` 增加等待重试后再建 bucket。
- 本地已完成 Docker Compose 重启验证：API `/ready` 与 `/health` 均返回 200，Redis healthy，MinIO 与 worker 运行中。

## 2026-06-11 服务可用性检查

- Docker Compose 当前服务状态：`nursing-paper-platform` healthy，`nursing-paper-worker` running，`redis` healthy，`minio` running。
- 生产容器健康端点检查通过：`/ready` 200，`/health` 200。
- 实际 API 检查通过：登录 200，会话 200，项目列表 200。
- 实际 UI 冒烟通过：浏览器打开 `http://127.0.0.1:8787`，点击同步后进入登录，登录后项目接口与工作台恢复可用。
- 基础设施检查通过：Redis `PING` 返回 `PONG`；MinIO bucket 通过 `mc ls` 可访问。

## 2026-06-11 external worker 可用性修复

- 服务可用性复测时发现：Compose 使用 Redis worker 后，API 仍处于 `TASK_EXECUTOR=polling`，导出任务可能由 API GET 轮询推进，和 worker 形成 SQLite 并发写风险，worker 日志出现过 `database is locked`。
- 已新增 `TASK_EXECUTOR=external` 执行模式：API 只创建并入队任务，不在 GET `/api/tasks/:id` 时推进任务；Compose 已改为 external。
- 已修复 external 模式下 API 读取 worker 更新后的 SQLite 状态：API 的 GET `/api/*` 会在 external + SQLite 模式下刷新状态，确保任务完成状态和产物下载能被同一 API 进程看到。
- 验证通过：`npm run test:api` 87/87，通过；`npm run test:deploy` 4/4，通过；重建镜像并重启后，生产烟测创建 project-6、上传全文到 MinIO、Redis worker 完成 task-6、产物下载成功，Redis 队列长度为 0。

## 2026-06-11 生产烟测脚本沉淀

- 新增 `tests/deploy/production-smoke.mjs` 与 `npm run smoke:production`，用于对当前运行的生产服务做可重复端到端烟测。
- 烟测覆盖：登录、项目创建、RIS/CSV 导入、Gate 确认、MinIO 全文上传与下载、Redis external worker 导出任务、导出产物下载。
- 脚本默认读取本地 `.env` 的管理员初始账号信息，但不会输出密码或 token；也可通过 `SMOKE_USERNAME`、`SMOKE_PASSWORD`、`SMOKE_BASE_URL` 覆盖。
- 最新验证：`npm run smoke:production` 通过，创建 project-7，导出 task-7 succeeded；`npm run test:api` 87/87 通过，`npm run test:deploy` 4/4 通过，生产服务 `/ready` 与 `/health` 均为 200，Redis 队列长度为 0。

## 2026-06-11 统一部署烟测入口

- `deploy.ps1` 增加 `smoke` 命令：先检查 Compose 状态与 `/ready`、`/health`，再执行 `npm run smoke:production`。
- `tests/deploy/compose.test.mjs` 增加部署契约测试，锁定 `deploy.ps1 smoke` 入口。
- 最新验证：`npm run test:deploy` 5/5 通过；`.\deploy.ps1 smoke` 通过，创建 project-8，导出 task-8 succeeded，Redis 队列后续检查长度为 0。

## 2026-06-11 find-skills + 当前应用测试

- 使用 `find-skills` 搜索 `webapp testing`，结果包含 `sargupta/sahayakai@webapp-testing` 等低安装量技能；本机已有 `webapp-testing` 技能，直接用于当前运行应用测试。
- 当前应用 `http://127.0.0.1:8787/` 测试通过：Compose 健康，`/ready` 200，`/health` 200；浏览器打开页面、点击同步、登录后工作台可用。
- `deploy.ps1 smoke` 通过：创建 project-11，全文上传到 MinIO，导出 task-9 succeeded，Redis 队列长度 0。
- 待跟进：浏览器控制台出现 CSP 错误，data:image SVG 图标被 `default-src 'self'` 阻止；不影响主流程，但后续应调整 CSP `img-src` 或避免 data URL 图标。

## 2026-06-11 生产 CSP 与部署验证修复

- 修复生产静态页面 CSP 误拦截前端 `data:image/svg+xml` 图标的问题：`backend/api.mjs` 的 `Content-Security-Policy` 增加 `img-src 'self' data:`，仍保持脚本/对象/iframe 等安全限制。
- `tests/backend/api.test.mjs` 增加生产安全头断言，并补充外部 worker 模式下 SQLite 刷新后 API mutation 不应丢失的回归测试。
- 已重新构建并重启 Docker 服务，当前 compose 中 `nursing-paper-platform`、`nursing-paper-worker`、Redis、MinIO 均运行；`deploy.ps1 smoke` 通过，生产 smoke 完成 MinIO 上传/下载和导出任务。
- in-app Browser 验证 `http://127.0.0.1:8787/` 当前处于工作台，控制台无 CSP/data:image 错误。
- 验证结果：`npm run test:api` 88/88 通过；`deploy.ps1 smoke` 通过。

## 2026-06-11 完整设计文档 v2.1 完成度评估

- 按 `nursing_paper_platform_design.md` v2.1 的完整平台目标评估，当前项目达到“本地可运行 MVP / 生产烟测版”，尚未达到完整平台。
- 已完成核心骨架：Vue 工作台、Node API、SQLite 持久化、Gate A-E、RIS/PubMed/CSV/全文/质量评价/提取/初稿审查、DOCX/XLSX/PRISMA SVG/audit 导出、认证、安全头、readiness、metrics、Redis worker、MinIO/S3 对象存储、Docker Compose、部署 smoke。
- 主要缺口：未接 PostgreSQL/Celery/FastAPI 架构；DeepSeek V4 未做真实生产验收；Cochrane/CNKI/万方未接入；Meta 分析森林图/敏感性分析/发表偏倚未实现；数据分析论文模块仍是 CSV 摘要级；论文草稿不是完整 AI 写作闭环；PRISMA 2020 合规还缺完整 checklist 级验证；多用户/权限/备份/审计治理仍不足。
- 综合判断：按完整设计目标约 45%-55%；按本地 MVP/演示闭环约 80%-90%。下一阶段优先建议补真实 AI 与去标识化提示、PRISMA 2020 checklist 验证、Meta 统计核心、Cochrane/PubMed 检索追溯增强、PostgreSQL 迁移方案。

## 2026-06-11 学术追溯与 PRISMA 证据增强设计

- 用户确认按完整设计文档 v2.1 的方案 A 推进：先补真实学术产出可信度，而非 AI、Meta 统计或数据库迁移。
- 已写入设计 spec：`E:\product\nursing_paper_platform\docs\superpowers\specs\2026-06-11-academic-traceability-design.md`。
- 设计范围：项目 evidence summary、PRISMA 计数规则、audit `source_map`、manuscript/prisma/audit 导出前 traceability preflight、后端测试覆盖。
- 明确不做：DeepSeek 真实生产调用、Meta 统计/森林图、PostgreSQL 迁移、CNKI/万方/Cochrane 接入、前端重设计。
- 当前项目目录不是 Git 仓库，无法按 superpowers 流程提交 spec commit。

## 2026-06-11 学术追溯实现计划

- 已写入实现计划：`E:\product\nursing_paper_platform\docs\superpowers\plans\2026-06-11-academic-traceability.md`。
- 计划拆为 4 个任务：红测 PRISMA/audit、实现 evidence summary 与 artifact 输出、导出 traceability preflight、全量回归与部署验证。
- 计划明确使用现有 `backend/api.mjs` 单文件模式，不新增 npm 依赖，不扩展 AI/Meta/数据库迁移范围。
- 当前项目目录不是 Git 仓库，后续执行时不能提交 commit，只能记录无法提交原因。

## 2026-06-11 学术追溯与 PRISMA 证据增强实现
- 已完成方案 A：真实学术产出可信度。
- `projectEvidenceSummary` 统一汇总项目证据；PRISMA SVG 计数来自项目证据图，不再使用固定示例计数。
- audit JSON 新增 `prisma`、`source_map`、`traceability_status`，用于说明计数来源、证据 ID 和缺失项。
- `manuscript`、`prisma`、`audit` 导出创建前新增 traceability preflight；证据不足时返回 409 `EXPORT_TRACEABILITY_INCOMPLETE`，避免生成不可追溯产物。
- 已验证：`npm run test:api` 91/91 通过；`npm run test:deploy` 5/5 通过；`.\deploy.ps1 restart` 已重建并重启容器；`.\deploy.ps1 smoke` 通过，导出任务 succeeded。
- 项目目录当前不是 Git 仓库，未提交 commit。

## 2026-06-11 PRISMA 2020 checklist 合规增强
- 已在方案 A 的追溯基础上新增 PRISMA checklist 机器可验证子集。
- audit JSON 新增 `prisma_checklist`，包含 `version`、`status`、`required_complete`、`items`、`missing_required`。
- `manuscript`、`prisma`、`audit` 导出创建前新增 PRISMA checklist preflight；机器可验证必需项缺失时返回 409 `EXPORT_PRISMA_CHECKLIST_INCOMPLETE`。
- checklist 将文献独立检索记录或文献导入来源标记视为检索/导入证据；title、abstract、registration、funding 等人工写作项标记为 `manual_review_required` 且不阻断导出。
- 已验证：`npm run test:api` 94/94 通过；`npm run test:deploy` 5/5 通过；`.\deploy.ps1 restart` 已重建并重启容器；`.\deploy.ps1 smoke` 通过，导出任务 succeeded。
- 项目目录当前不是 Git 仓库，未提交 commit。

## 2026-06-11 Meta 分析 MVP 与森林图导出
- 已实现方案 A：内置确定性固定效应 Meta 分析最小闭环，不引入 AI、Python/R 或新依赖。
- 新增 `forest` 导出格式，使用 extraction rows 中的 `effect_size` 与 `standard_error` 做 inverse-variance fixed-effect pooling，并输出 SVG 森林图。
- audit JSON 新增 `meta_analysis` 与 `meta_source_map`，记录 pooled effect、95% CI、eligible study count、研究行和来源 extraction IDs。
- `forest` 导出创建前新增 meta preflight；少于两个有效 extraction rows 时返回 409 `EXPORT_META_ANALYSIS_INCOMPLETE`。
- 已验证：`npm run test:api` 97/97 通过；`npm run test:deploy` 5/5 通过；`.\deploy.ps1 restart` 首次因 Docker Hub TLS handshake timeout 失败，重试成功；`.\deploy.ps1 smoke` 通过，导出任务 succeeded。
- 项目目录当前不是 Git 仓库，未提交 commit。

## 2026-06-11 Meta 异质性与随机效应增强
- 已在 Meta MVP 基础上新增异质性指标与 DerSimonian-Laird 随机效应预览。
- `meta_analysis` 现在包含 `heterogeneity`（Q、df、I²、tau²）、`random_effects`（pooled effect、SE、95% CI）和小样本谨慎解释提示。
- forest SVG 现在同时显示 fixed-effect pooled、random-effects pooled、I² 与 tau²。
- `meta_source_map` 新增 `meta.heterogeneity`，将异质性指标追溯到 extraction IDs。
- 已验证：`npm run test:api` 97/97 通过；`npm run test:deploy` 5/5 通过；`.\deploy.ps1 restart` 已重建并重启容器；`.\deploy.ps1 smoke` 通过，导出任务 succeeded。
- 项目目录当前不是 Git 仓库，未提交 commit。

## 2026-06-11 质量评价覆盖与审计增强
- 新增 `qualityAppraisalSummary`，按纳入文献汇总质量评价覆盖、工具分布、judgment 分布、缺失文献和来源映射。
- audit JSON 新增 `quality_appraisal`，包含逐文献 assessment IDs、工具、judgments 和 `quality.coverage` source map。
- `manuscript`、`prisma`、`audit` 导出创建前新增质量评价覆盖 preflight；任一纳入文献缺少质量评价时返回 409 `EXPORT_QUALITY_APPRAISAL_INCOMPLETE`。
- 修正测试工作流中质量评价绑定虚构 literature ID 的旧夹具问题，改为绑定实际纳入文献。
- 已验证：`npm run test:api` 98/98 通过；`npm run test:deploy` 5/5 通过；`\.\deploy.ps1 restart` 已重建并重启容器；`\.\deploy.ps1 smoke` 通过，ready/health 均为 200，导出任务 succeeded；应用内浏览器页面可正常加载且无控制台 error/warn。
- 项目目录当前不是 Git 仓库，未提交 commit。

## 2026-06-11 Meta 留一法敏感性分析与 Git 管理
- 项目已初始化 Git，`main` 基线提交为 `eff13db`；当前功能分支为 `feat/meta-sensitivity-analysis`。
- 新增 Meta leave-one-out 敏感性分析：逐项排除研究后重新计算 DerSimonian-Laird 随机效应，输出 pooled effect、95% CI、相对完整模型变化量、最大绝对变化和对应 extraction ID。
- 新增 `sensitivity` SVG 导出及导出前置校验；有效研究少于 3 项时返回 409 `EXPORT_SENSITIVITY_ANALYSIS_INCOMPLETE`。
- audit JSON 新增 `sensitivity_analysis` 和 `meta.sensitivity` 来源映射；结果只提供诊断信息，不自动判定稳健性。
- 功能分支提交：`68e9f7c`（计划）、`2f50d1f`（测试）、`92218c9`（计算）、`1786673`（SVG 导出）。
- 已验证：`npm run test:api` 101/101 通过；`npm run test:deploy` 5/5 通过；容器重建重启及 smoke 通过；应用内浏览器加载正常且无 console error/warn。
- Git 收尾：功能分支已快进合并到 `main`（HEAD `1786673`），合并后 API 101/101、部署契约 5/5 通过，功能分支已删除，工作区干净；仓库尚未配置远程地址。

## 2026-06-12 发表偏倚诊断与漏斗图导出
- 新增功能分支 `feat/publication-bias-diagnostics`，提交：`c45ea47`（spec/plan）、`fbd8a3f`（红测）、`f271fb5`（实现）。
- 新增 `funnel` 导出格式，输出 SVG 漏斗图，包含 DerSimonian-Laird 随机效应参考线、95% pseudo-confidence funnel、研究点和小样本效应解释提示。
- audit JSON 新增 `publication_bias`：包含 `funnel_plot`、`egger_regression`、`source_map['meta.publication_bias']` 和解释说明。
- Egger 诊断采用透明的依赖内置实现：标准化效应 `effect_size / standard_error` 对精度 `1 / standard_error` 的 OLS 回归；少于 10 个有效研究时只输出 `not_performed / insufficient_studies_for_formal_test`，不做正式检验。
- `funnel` 导出前置校验：少于 2 个有效 extraction rows 时返回 409 `EXPORT_PUBLICATION_BIAS_INCOMPLETE`；其他导出格式不受该校验阻断。
- 已验证：红测先失败；目标测试 `npm run test:api -- --test-name-pattern funnel` 与 `--test-name-pattern Egger` 通过；全量 `npm run test:api` 105/105 通过；`npm run test:deploy` 5/5 通过；`./deploy.ps1 restart` 已重建镜像 `nursing-paper-platform:latest`（sha `c7b566...`）并重启；`./deploy.ps1 smoke` 通过，ready/health 均为 200，导出任务 succeeded；首页 `http://127.0.0.1:8787/` 返回 200。
- Git 收尾：`feat/publication-bias-diagnostics` 已快进合并到 `main`（HEAD `f271fb5`），合并后 `npm run test:api` 105/105、`npm run test:deploy` 5/5 通过，功能分支已删除，工作区干净；仓库仍未配置远程地址。

## 2026-06-12 GRADE Summary of Findings MVP
- 新增功能分支 `feat/grade-summary-of-findings`，提交：`7ba8e88`（spec/plan）、`cf8d918`（红测）、`804ebe6`（实现）。
- audit JSON 新增 `grade_summary`：按 outcome 汇总 eligible Meta rows、DerSimonian-Laird 随机效应、I²/tau²、质量评价覆盖、发表偏倚诊断状态、GRADE-style 机器初评 certainty、downgrade reasons 与 source_map。
- manuscript DOCX 新增 `Summary of Findings` 表，包含 Outcome、Studies、Random-effects effect、I-squared、Certainty、Downgrade reasons、Review note；所有结果标记 `requires_human_review: true`。
- 确定性规则：risk_of_bias、inconsistency、imprecision、publication_bias 分域降级；I² >=75% 计两级，I² >=50% 计一级；3 项及以下研究或随机效应 CI 跨 0 计 imprecision；Egger p<0.10 才自动 publication_bias 降级。
- 导出预检：manuscript/audit 在已录入定量 Meta 行但无任何 outcome 满足至少 2 条有效行时返回 409 `EXPORT_GRADE_SUMMARY_INCOMPLETE`；普通非定量结构化提取不被该预检阻断。
- 已验证：`npm run test:api -- --test-name-pattern GRADE` 通过（实际执行 108/108）；`node --check backend/api.mjs` 通过；`git diff --check` 通过；`npm run test:api` 108/108 通过；`npm run test:deploy` 5/5 通过；`./deploy.ps1 restart` 已重建镜像并重启；`./deploy.ps1 smoke` 通过，ready/health 均为 200，生产 smoke 导出任务 succeeded，artifactBytes=12995。
- Git 收尾：`feat/grade-summary-of-findings` 已快进合并到 `main`（HEAD `804ebe6`），合并后 `npm run test:api` 108/108、`npm run test:deploy` 5/5 通过，功能分支已删除；仓库仍未配置远程地址。

## 2026-06-12 可追溯 Meta 稿件草稿
- 新增确定性、证据驱动的 Meta 稿件草稿生成：DOCX 按 Abstract、Introduction、Methods、Results、Discussion、Conclusion 排列，并保留 Summary of Findings、证据附录和参考文献。
- Methods/Results 复用项目中的 PRISMA、质量评价、Meta、敏感性分析、发表偏倚和 GRADE 结果；Discussion/Conclusion 明确保留人工撰写与审校，不自动生成无证据的临床结论。
- audit JSON 新增 `manuscript_draft`，包含 19 个有序章节、生成方法、人工复核标记和段落级 `source_map`。
- 代码审查补齐研究筛选与质量评价段落的来源覆盖：检索记录、筛选文献、全文记录、纳入文献和质量评价记录均可追溯。
- 设计与计划：`docs/superpowers/specs/2026-06-12-manuscript-draft-design.md`、`docs/superpowers/plans/2026-06-12-manuscript-draft.md`。
- Git 提交：`a9c8459`、`5d2d9f8`、`fa47a9c`、`c14ccbf`、`da7c235`、`e1fcaca`；已快进合并到 `main`，HEAD 为 `e1fcaca`，功能分支已删除。
- 最终验证：合并后 `npm run test:api` 110/110、`npm run test:deploy` 5/5、`node --check backend/api.mjs`、`git diff --check` 均通过。
- 部署验证：镜像 `nursing-paper-platform:latest` 已重建并重启；`deploy.ps1 smoke` 通过，`/ready` 与 `/health` 均为 200，Redis worker 完成 `task-20`，MinIO 产物下载成功，artifactBytes=21462。


## 2026-06-12 量化效应量管线与分组 Meta 工作流
- 当前分支：`codex/meta-effect-size-pipeline`。已实现 RR/OR、MD/SMD 和预计算效应量的严格校验与计算，并对数值不稳定、双零事件、重复比较和共享对照进行阻断或标记。
- 量化 extraction 已持久化到 SQLite，支持创建、更新、删除；Gate C 通过后保持锁定。新增按 outcome + timepoint + effect measure 隔离的 Meta 分组 API，避免 MD/SMD、RR/OR 等不兼容证据混合。
- 分组详情提供 fixed/random effects、Q/I²/tau²、leave-one-out、漏斗图与 Egger 条件诊断；稿件、GRADE、审计和导出均可按 `group_key` 限定证据范围。
- 前端 API client、TypeScript 类型和 Vue 工作台已接入：支持描述性、二分类原始数据、连续变量原始数据、预计算效应量录入；分析页可查看 Meta 分组状态；导出页可选择分组。
- Git 提交包括：`a68063d`、`d36e984`、`72e6502`、`be55415`、`7c55698`、`0c43859`、`3fc78ef`、`b420411`、`a6b4168`、`88fc8af`、`e5eb477`。
- 验证：Meta 核心测试 39/39、API 115/115、client 30/30、`npm run build` 通过；`deploy.ps1 smoke` 通过，Redis worker 完成导出、MinIO 产物可下载；最终 `/ready` 与 `/health` 均为 200。
- Docker 镜像 `nursing-paper-platform:latest` 已重建；平台容器 healthy，worker/Redis/MinIO 正常运行。浏览器验证桌面与 390px 移动端无横向溢出，量化模式控件可访问，控制台无 error/warning。
- 下一批生产级重点：完善 extraction 编辑/删除 UI 与文献选择器；增加 RoB 2/ROBINS-I 域级质量评价和双人复核/冲突裁决；实现 Hartung-Knapp、REML/Paule-Mandel、亚组/Meta 回归与预测区间；补完整 PRISMA 2020 checklist、协议注册字段、引用核验和投稿前人工签核；增加备份恢复、迁移演练和并发/负载验证。

## 2026-06-12 Extraction CRUD 工作流计划
- 已确认方案 A：量化提取只从人工纳入文献中选择来源；复用顶部表单编辑；删除需要行内二次确认；Gate C 通过后禁用创建、编辑和删除。
- 设计文档：`docs/superpowers/specs/2026-06-12-extraction-crud-workflow-design.md`，提交 `6b902f2`。
- 实施计划：`docs/superpowers/plans/2026-06-12-extraction-crud-workflow.md`，提交 `2683db2`。
- 计划采用 Node 纯函数测试加 Playwright 真实 API/Vite 验收，不新增依赖；成功变更后统一刷新 extraction rows 和 Meta groups，失败时保留表单与确认状态。
- 当前尚未修改业务代码；下一步选择子代理逐任务执行或当前会话内联执行。

## 2026-06-12 Extraction CRUD 工作流实现
- 当前分支：`codex/meta-effect-size-pipeline`。已完成 Extraction CRUD 工作流：纳入文献来源选择、顶部表单编辑、行内删除二次确认、Gate C 锁定后禁用创建/编辑/删除。
- 新增纯函数模块 `src/features/extraction/extraction-form.mjs` 与类型声明，集中处理表单默认值、模式切换、included-only 文献选项、payload 映射和校验。
- 前端 `ExtractionWorkspace.vue` 与 `App.vue` 已接入 create/update/delete API；成功后刷新 extraction rows 与 Meta groups，失败时保留表单或确认状态。
- 修正 API 同步 E2E 中质量评价绑定虚构 literature ID 的旧夹具问题，改为绑定实际纳入文献。
- Git 提交：`7789fc4`、`1c12d4d`、`ea4f6d2`、`cc718a4`、`3f76630`、`812841e`。
- 验证：`npm run test:extraction-form` 14/14、`npm run test:extraction-crud` 1/1、`npm run test:api-sync` 1/1、`npm run test:api` 115/115、`npm run test:client` 30/30、`npm run build`、`deploy.ps1 smoke` 均通过。
- 部署：`deploy.ps1 restart` 已重建 `nursing-paper-platform:latest` 并重启；当前 compose 中 platform healthy，worker、Redis、MinIO 均运行；生产 smoke 完成 MinIO 对象存储与导出任务。
- 浏览器验证：`http://127.0.0.1:8787/` 中测试项目可登录、选择抽取步骤、只显示纳入文献、编辑保存生效、删除确认可打开/取消、Gate C 后锁定；桌面与 390px 移动端无横向溢出，登录后控制台无 error/warning。
- Git 收尾：`codex/meta-effect-size-pipeline` 已快进合并到 `main`，HEAD 为 `812841e`；合并后再次验证 `npm run test:api` 115/115、`npm run test:client` 30/30、`npm run test:extraction-form` 14/14、`npm run test:extraction-crud` 1/1、`npm run test:api-sync` 1/1 和 `npm run build` 均通过；功能分支已删除。

## 2026-06-12 Hartung-Knapp 与预测区间设计
- 用户确认方案 A：优先增强 Meta 统计不确定性表达，补 Hartung-Knapp 调整置信区间和 95% prediction interval。
- 新分支：`codex/meta-hk-prediction-interval`。
- 设计文档：`docs/superpowers/specs/2026-06-12-meta-hartung-knapp-prediction-interval-design.md`，提交 `a600026`。
- 设计范围：保留 DerSimonian-Laird pooled estimate，新增 modified Hartung-Knapp CI、prediction interval、小样本状态标记、audit/source map、manuscript、GRADE、forest SVG 和分析面板展示。
- 下一步：用户审核 spec 后，写 implementation plan，再按 TDD 实现。
