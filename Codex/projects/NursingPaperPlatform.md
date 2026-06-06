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
