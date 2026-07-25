# Elder Care Scoping Review Agent

## 状态

2026-05-31：在 `E:\learn\elder-care-scoping-review-agent` 初始化项目骨架。
2026-05-31：完成 M1 第一条可验证切片：后端创建项目返回 PCC、纳入/排除标准、PubMed/CINAHL/Web of Science 检索式草案，自动产物带 `status=agent_draft` 与 `trace`；前端首页展示工作台视图；验证为 `pytest` 3 passed、`npm run build` 通过。
2026-05-31：推进 M1 人工审核闭环：新增内存项目存储、`GET /review-projects/{id}`、`PATCH /review-projects/{id}/pcc`、`POST /review-projects/{id}/pcc/confirm`；PCC 可被人工修订并带 `human_revision` trace，确认后标记 `human_approved` 并进入 `search_strategy_review`；验证为 `pytest` 6 passed、`npm run build` 通过。
2026-05-31：将 M1 项目状态从内存推进到 SQLAlchemy 持久化层：新增 `services/api/app/repository.py`、`review_projects` schema、JSON payload 保存完整工作包与 trace，API 默认按 `DATABASE_URL` 使用 repository；测试覆盖 repository 重建后仍能取回项目；验证为 `pytest` 8 passed、`npm run build` 通过。
2026-06-01：补 Alembic 初始迁移 `20260531_0001_create_review_projects` 与迁移测试；SQLite 文件库验证 `alembic upgrade head` 可创建 `review_projects` 表；PostgreSQL 实机验证仍待处理（本地缺 `psycopg`，Redis 6379 端口占用导致 compose 中断）。
2026-06-01：启动 M2 文献导入与去重第一条切片：新增 `services/api/app/literature_intake.py`、`POST /review-projects/{id}/literature/import`、CSV 标准化字段、DOI 完全匹配和标题相似度重复候选；导入前要求 PCC 已确认，重复候选默认 `needs_human_review` 并保留 trace；验证为 `pytest` 13 passed、`npm run build` 通过。
2026-06-01：补齐 M2 去重人工审核闭环：新增 `PATCH /review-projects/{id}/duplicate-candidates/{candidate_id}`，支持把候选标记为 `confirmed_duplicate` 或 `not_duplicate` 并写入 `human_deduplication_review` trace；所有候选完成审核后阶段推进到 `deduplicated`，否则停留 `literature_imported`；验证为 `pytest` 15 passed、`npm run build` 通过。
2026-06-01：启动 M3 标题摘要筛选第一条切片：新增 `services/api/app/screening.py`、`POST /review-projects/{id}/screening/suggestions`、`PATCH /review-projects/{id}/screening-decisions/{record_id}`；筛选建议为 include/exclude/unsure 且带 `screening_rule` trace，人工最终决定带 `human_screening_review` trace，exclude 必须填写排除理由；所有记录完成人工决定后阶段推进到 `screening_reviewed`；验证为 `pytest` 19 passed、`npm run build` 通过。
2026-06-01：启动 M4 数据提取第一条切片：新增 `services/api/app/extraction.py`、`POST /review-projects/{id}/extraction/suggestions`；默认提取字段模板为 citation/population/concept/context/key_finding，仅对人工 include 题录生成 evidence items，默认 `agent_draft` 并通过 `screening_reviewed_record` trace 回链 record_id；验证为 `pytest` 22 passed、`npm run build` 通过。
2026-06-01：补齐 M4 evidence item 人工审核闭环：新增 `PATCH /review-projects/{id}/evidence-items/{item_id}`；研究者可批准或退回修改 evidence item，退回时必须提供 `review_note`，可同步修订 `value`，审核保留 `human_extraction_review` trace；全部 evidence items 批准后阶段推进到 `synthesis_review`；验证为 `pytest` 25 passed、`npm run build` 通过。
2026-06-01：启动 M5 主题归纳与 evidence matrix 第一条切片：新增 `services/api/app/synthesis.py`、`POST /review-projects/{id}/synthesis/suggestions`；仅使用 `human_approved` evidence items 生成 evidence matrix 和初步主题，matrix 保留 `approved_evidence_items` trace，主题保留 `synthesis_rule` trace 且状态为 `agent_draft`；验证为 `pytest` 28 passed、`npm run build` 通过。
2026-06-01：启动草稿生成与审计第一条切片：新增 `services/api/app/drafting.py`、`POST /review-projects/{id}/draft/suggestions`、`POST /review-projects/{id}/audit`；草稿包含 Methods / Results / Discussion 三节，核心论断用 `DraftClaim` 回链 `evidence_item_ids` 与 `theme_ids`，审计会把缺少 evidence item 回链的 claim 标记为 `missing_evidence_link` / `blocking`；验证为 `pytest` 33 passed、`npm run build` 通过。
2026-06-01：补齐草稿人工审核与导出准备闭环：新增 `DraftSectionReview`、`DraftClaimReview`、`PATCH /review-projects/{id}/draft-sections/{section_id}`、`PATCH /review-projects/{id}/draft-sections/{section_id}/claims/{claim_id}`；section / claim 可批准或退回修改，退回必须带 `review_note`，审核保留 `human_draft_review` trace；无 blocking audit 且全部 section / claim 批准后推进到 `ready_for_export` 并关闭 `review_required`；验证为 `pytest` 36 passed、`npm run build` 通过。
2026-06-01：补导出 artifact 第一条切片：新增 `services/api/app/export_package.py`、`ExportPackage`、`GET /review-projects/{id}/export/package`；仅 `ready_for_export` 项目可导出，返回 `markdown_report`、`evidence_csv`、`audit_csv`，并保留 `export_package` trace；验证为 `pytest` 39 passed、`npm run build` 通过。
2026-06-01：前端工作台接入 API 并完成浏览器验收：`apps/web/app/page.tsx` 改为 client-side workbench，支持从页面配置 API base、新建项目、跑通 PCC 确认、样例 CSV 导入、筛选/提取/归纳/草稿/审计、人工批准与导出包下载；FastAPI CORS 改为允许 `localhost` / `127.0.0.1` 本机端口；补 `icon.svg` 和本地验证产物忽略规则；验证为 `pytest` 40 passed、`npm run build` 通过，并用 Playwright 在 `127.0.0.1:4335` + 临时 SQLite API 端口跑到 `ready_for_export`，导出 Markdown/Evidence CSV/Audit CSV 可见。
2026-06-01：补前端真实研究流人工控件：PCC 可在页面编辑并保存，文献导入支持粘贴 CSV 和设置来源名，重复候选可确认重复或保留两条，evidence item 可单项编辑、批准或填写退回原因后退回，draft claim 也具备单项编辑/批准/退回控件；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 40 passed、`npm run build` 通过，并用 Playwright 跑通 PCC 修订 -> CSV 导入重复候选 -> 去重人工审核 -> 筛选/提取 -> 单项 evidence 退回，控制台 0 errors。
2026-06-01：继续补前端真实审核流：筛选队列支持单条 include / exclude / unsure，exclude 必须填写排除理由；草稿 section 支持整节 body 编辑、批准或填写退回原因后退回；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 40 passed、`npm run build` 通过，并用 Playwright 跑通三条题录筛选（exclude/include/unsure）-> 提取/归纳/草稿/审计 -> Methods section 退回，控制台 0 errors。
2026-06-01：补齐检索式人工审核闸门：新增 `PATCH /review-projects/{id}/search-strategies/{database}` 和 `POST /review-projects/{id}/search-strategies/confirm`，检索式可人工编辑、批准或退回，题录导入前必须全部 `human_approved`；前端 Search Strategy 面板支持编辑、保存批准、标记需修订和确认全部；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 42 passed、`npm run build` 通过，并用 Playwright 跑通 PCC 确认 -> PubMed 检索式编辑批准 -> 确认全部检索式 -> CSV 导入到 `deduplicated`，控制台 0 errors。
2026-06-01：补齐 synthesis theme 人工审核与合并闭环：新增 `SynthesisThemeReview`、`SynthesisThemeMerge`、`PATCH /review-projects/{id}/synthesis-themes/{theme_id}`、`POST /review-projects/{id}/synthesis-themes/merge`；主题可人工改名、改 summary、批准或退回，合并主题会保留 record/evidence item 回链；生成草稿前要求所有主题 `human_approved`。前端 Synthesis 面板支持主题编辑、批准/退回、选择多个主题并合并；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 46 passed、`npm run build` 通过，并用 Playwright 跑通生成主题 -> 人工改名批准 -> 生成草稿，控制台 0 errors。
2026-06-01：补全文获取与附件追踪闭环：新增 `full_text_review` 阶段、`FullTextItem` / `FullTextReview`、`POST /review-projects/{id}/full-text/review-queue`、`PATCH /review-projects/{id}/full-text/{record_id}`；标题摘要 include 后需记录全文/PDF URL 或文件名、不可得/全文排除理由，审核保留 `human_full_text_review` trace，只有 `retrieved` 全文进入数据提取。前端增加 Full Text 面板，支持 PDF/URL、文件名、备注、不可得或全文排除原因，并把生成提取表放到全文审核之后；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 50 passed、`npm run build` 通过，并用 Playwright 跑通筛选 -> 全文队列 -> PDF/URL 记录 -> 提取表生成，控制台 0 errors。

2026-06-01：补齐真实全文附件上传与校验追踪：新增 `FullTextAttachment`、`POST /review-projects/{id}/full-text/{record_id}/attachment`、`FULL_TEXT_STORAGE_DIR` 配置；上传 PDF 会落盘、记录 `storage_uri`、`sha256`、文件大小、content type 和 `human_full_text_upload` trace，并把全文条目标记为 `retrieved`。前端 Full Text 面板支持选择 PDF 上传并显示附件大小与 sha256 摘要；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 51 passed、`npm run build` 通过，并用 Playwright 在临时 SQLite API + Next dev server 跑通全文 PDF 上传，`human_full_text_upload` 与 `sha256` 可见，生成提取表按钮解锁。

2026-06-01：补服务器端导出归档：新增 `ExportArchive` / `ExportArchiveFile`、`EXPORT_STORAGE_DIR`、`POST /review-projects/{id}/export/archive` 和 `GET /review-projects/{id}/export/archives/{archive_id}/files/{file_name}`；归档会写入 Markdown、evidence CSV、audit CSV、manifest.json，每个文件记录 storage_uri、size、sha256，并保留 `export_archive` trace。前端 Export 面板支持生成服务端归档并显示文件下载链接；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 53 passed、`npm run build` 通过，并用 Playwright 跑通示例流程 -> 生成归档 -> manifest 链接 GET 成功，manifest trace 为 `export_archive`。

2026-06-01：补 PRISMA-ScR 风格流程计数：新增 `ReviewFlowSummary` 和 `GET /review-projects/{id}/flow-summary`，汇总识别题录、重复候选/确认重复、标题摘要筛选、全文获取状态、进入提取记录数、evidence item 与已批准提取项，并保留 `project_flow_summary` trace。前端新增 Flow Summary 面板，跑示例流程后自动显示流程计数；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 54 passed、`npm run build` 通过，并用 Playwright 跑通示例流程后确认 Flow Summary 显示 `project_flow_summary`、识别题录、标题摘要纳入、全文已取回、进入提取和已批准提取项计数。

2026-06-01：补长期项目恢复入口：新增 `ReviewProjectSummary`、repository `list()` 和 `GET /review-projects`，返回轻量项目列表；前端支持刷新项目列表并打开已有项目，打开后取回完整工作包并刷新 Flow Summary。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 55 passed、`npm run build` 通过，并用 Playwright 在临时 SQLite API + Next dev server 中创建两个项目、刷新列表、打开已推进到 `search_strategy_review` 的项目，确认标题、阶段和 `project_flow_summary` 正确显示。

2026-06-01：补集中证据追溯时间线：新增 `TraceTimelineEvent` / `TraceTimeline` 和 `GET /review-projects/{id}/trace-timeline`，将 PCC、纳排标准、检索式、题录、去重候选、筛选、全文、附件、提取、矩阵、主题、草稿、审计和导出归档中的 `trace` / `human_trace` 聚合为只读事件列表，标注 target/source/actor/status/rationale。前端新增 Trace Timeline 面板，示例流程后显示自动产物与人工审核来源追溯；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 56 passed、`npm run build` 通过，并用 Playwright 跑通示例流程后确认 `human_screening_review`、`human_full_text_review` 和 `screening_reviewed_record` 可见。

2026-06-01：补导出归档列表恢复入口：新增 `GET /review-projects/{id}/export/archives`，返回已有 `ExportArchive` 文件元数据，便于重新打开长期项目后恢复归档下载链接和 sha256 校验信息。前端打开项目、生成归档和手动刷新归档列表时会调用该接口；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 57 passed、`npm run build` 通过，并用 Playwright 跑通示例流程 -> 生成服务端归档 -> 打开已有项目 -> 刷新归档列表，确认返回 1 个归档和 Markdown/evidence CSV/audit CSV/manifest 四个文件。

2026-06-01：补 RIS 题录导入：`LiteratureImportRequest` 新增 `format=csv|ris`，后端新增 `import_literature_ris`，解析 RIS 的 `TI`/`T1`、`AU`、`PY`/`Y1`、`DO`、`AB`/`N2` 与 `ER` 记录边界，并复用 DOI/标题相似去重候选和导入来源 trace。前端 Literature 面板新增 CSV/RIS 格式选择，切换 RIS 时填入 `.ris` 示例并提交 `format=ris`；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 59 passed、`npm run build` 通过，并用 Playwright 跑通新建项目 -> 确认 PCC/检索式 -> 切换 RIS -> 导入题录，确认 `Falls prevention in older adults` 来自 `sample-pubmed.ris`。

2026-06-01：补 BibTeX 题录导入：`LiteratureImportRequest.format` 扩展为 `csv|ris|bibtex`，后端新增 `import_literature_bibtex`，解析 BibTeX 的 `title`、`author`、`year`、`doi`、`abstract`，作者用 `and` 拆分并复用 DOI/标题相似去重候选和导入来源 trace。前端 Literature 面板新增 BibTeX 选项与 `.bib` 示例；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 61 passed、`npm run build` 通过，并用 Playwright 跑通新建项目 -> 确认 PCC/检索式 -> 切换 BibTeX -> 导入题录，确认 `Falls prevention in older adults` 来自 `sample-wos.bib`。

2026-06-01：补检索日志闭环：新增 `SearchLogCreate` / `SearchLogEntry` 和 `POST /review-projects/{id}/search-logs`，在检索式 `human_approved` 后记录实际检索时间、命中数、备注和检索式快照，并保留 `human_search_log` trace；Trace Timeline 会聚合 `search_log` 事件。前端 Search Strategy 卡片新增检索时间、命中数、备注输入和历史日志显示；验证为 `D:\miniconda3\python.exe -m pytest tests -q` 62 passed、`npm run build` 通过，并用 Playwright 跑通新建项目 -> 确认 PCC/检索式 -> 记录 PubMed 128 条检索日志。

2026-06-01：补导出包检索日志输出：`generate_export_package` 接收 `search_logs`，Markdown 报告新增 `Search log` 小节，输出数据库、检索时间、命中数、检索式快照和备注；`GET /export/package` 与服务端归档都传入项目检索日志。验证为定向导出测试通过，随后全量验证。

2026-06-01：补临床建议越界审计：`audit_draft_sections` 新增 `clinical_guidance_language` / `blocking` finding，拦截明显 “clinicians/nurses/patients should ...” 或 “should be prescribed” 这类临床指导措辞；保留 `audit_rule` trace，确保范围综述草稿保持证据地图/研究者审核用途而非临床建议。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 63 passed、`npm run build` 通过。

2026-06-01：补弱证据主题审计：`audit_draft_sections` 对带 `theme_ids` 且少于 2 个 evidence item 回链的 claim 生成 `weak_theme_evidence` / `warning`，提醒研究者复核主题强度、限定表述或考虑合并；warning 不阻断导出，仍保留 `audit_rule` trace。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 64 passed、`npm run build` 通过。

2026-06-01：补 audit CSV 审计追溯字段：`generate_export_package` 的 `audit_csv` 新增 `trace_source` 与 `trace_rationale`，导出审计 finding 时保留审计规则来源与理由，避免最终 artifact 丢失规则级证据追溯。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 64 passed、`npm run build` 通过。

2026-06-01：补导出报告 Flow Summary：`generate_export_package` 支持接收 `ReviewFlowSummary`，Markdown 报告新增 `Flow summary` 小节，输出识别题录、去重、标题摘要筛选、全文获取、进入提取和 evidence item 审核计数；`GET /export/package` 与服务端归档均传入当前项目流程计数。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 64 passed、`npm run build` 通过。

2026-06-02：补纳入/排除标准人工审核闭环：新增 `EligibilityCriterionReview` 与 `PATCH /review-projects/{id}/eligibility-criteria/{label}`，研究者可修订、批准或退回纳排标准；保留原始 `pcc_framework` trace，并新增 `human_eligibility_review` human_trace。题录导入前新增纳排标准全批准闸门；前端增加 Eligibility Criteria 面板，导入按钮和样例流程均遵守该闸门。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 66 passed、`npm run build` 通过。

2026-06-02：补导出报告纳排标准小节：`generate_export_package` 支持接收 `eligibility_criteria`，Markdown 报告新增 `Eligibility criteria` 小节，输出已审核纳入/排除标准、状态和 human trace；`GET /export/package` 与服务端归档均传入项目纳排标准，避免最终报告丢失协议边界。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 66 passed、`npm run build` 通过。

2026-06-02：补 evidence CSV 行级追溯字段：`generate_export_package` 的 evidence CSV 新增 `trace_source` 与 `trace_rationale`，每个 evidence matrix row 导出 `approved_evidence_items` 等来源与生成理由，避免矩阵 CSV 只有 item id 而缺少行级证据来源说明。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 66 passed、`npm run build` 通过。

2026-06-02：补 screening CSV 导出：`ExportPackage` 新增 `screening_csv`，导出标题摘要筛选的 Agent 建议/理由、人工最终决定、排除理由、`screening_rule` trace 与 `human_screening_review` trace；服务端归档新增 `screening.csv`，前端 Export 面板新增 Screening CSV 下载按钮。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 66 passed、`npm run build` 通过。

2026-06-02：补 full-text CSV 导出：`ExportPackage` 新增 `full_text_csv`，导出全文获取/不可得/全文排除状态、来源 URI、文件名、附件 ID、备注、排除理由、`screening_inclusion` 等 Agent trace 与 `human_full_text_review` trace；服务端归档新增 `full-text.csv`，前端 Export 面板新增 Full Text CSV 下载按钮。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 66 passed、`npm run build` 通过。

2026-06-02：补 trace timeline CSV 导出：`ExportPackage` 新增 `trace_timeline_csv`，把项目 trace timeline 的 order、target、label、source、rationale、actor、status 导出为 CSV；服务端归档新增 `trace-timeline.csv`，前端 Export 面板新增 Trace CSV 下载按钮，便于离线审计证据来源。验证为 `D:\miniconda3\python.exe -m pytest tests -q` 66 passed、`npm run build` 通过。

2026-06-02：补齐 Docker 化运行：新增 API/Web Dockerfile 和 compose 中的 `api`、`worker`、`web` 服务；Postgres/Redis 仅走 Docker 内部网络，避免宿主机 5432/6379 冲突；API 默认映射到宿主机 `18001`，Web 默认映射到 `3000`，前端默认 API base 为 `http://localhost:18001`。验证为 `docker compose build` 通过、`docker compose up -d --force-recreate` 启动成功，`api`/`web`/`postgres`/`redis` healthy，`GET http://localhost:18001/health` 返回 `{"status":"ok"}`，`GET /review-projects` 返回 `[]`，Web 首页 `http://localhost:3000` 返回 200。

## 目标

面向老年护理领域的范围综述 Agent，先做半自动 scoping review 工作台，而不是全自动科研闭环。

核心流程：研究主题 -> PCC 框架 -> 检索式草案 -> 文献导入/去重 -> 标题摘要筛选建议 -> 数据提取表 -> 主题归纳 -> 范围综述大纲/初稿 -> 审计报告。

## 第一版技术栈

- Frontend：Next.js
- Backend：FastAPI
- Worker：Celery / Python worker
- Database：PostgreSQL
- Broker：Redis

## 当前产物

- 项目目录：`E:\learn\elder-care-scoping-review-agent`
- 设计文档：`docs/superpowers/specs/2026-05-31-elder-care-scoping-review-agent-design.md`
- 已有骨架：Next.js 入口、FastAPI health/create project、Celery 任务入口、Docker Compose PostgreSQL/Redis/API/worker/Web。
- M1 工作包：`services/api/app/project_setup.py` 生成可人工审核的 PCC、纳排标准和三库检索式；纳排标准可人工修订、批准或退回且保留 agent/human 双 trace，检索式批准后可记录实际检索日志；`apps/web/app/page.tsx` 展示项目、PCC、纳排、检索式和审核队列。
- M1 API 闭环：`services/api/app/main.py` 使用 repository 保存项目，支持取回项目、记录 PCC 人工修订、确认 PCC 后推进到检索策略审核；题录导入前要求检索式和纳入/排除标准均已 `human_approved`。
- 持久化层：`services/api/app/repository.py` 通过 SQLAlchemy `review_projects` 表保存完整工作包，支持按 id 取回和轻量列表；`services/api/migrations/versions/20260531_0001_create_review_projects.py` 提供初始迁移。
- M2 文献导入与去重：`services/api/app/literature_intake.py` 支持 CSV/RIS/BibTeX 导入、字段标准化、DOI/标题相似重复候选；API 支持人工确认/排除重复候选并推进 `deduplicated`。
- M3 标题摘要筛选：`services/api/app/screening.py` 根据题录标题/摘要和主题词生成 include/exclude/unsure 建议，API 支持人工最终决定、排除理由和阶段推进到 `screening_reviewed`；`GET /review-projects/{id}/flow-summary` 汇总题录流转计数并保留 `project_flow_summary` trace。
- M4 数据提取：新增全文获取与附件追踪闸门；`FullTextItem` 记录 PDF/URL、文件名、附件 id、不可得或全文排除理由，`FullTextAttachment` 记录上传文件的 storage_uri、sha256、大小和 trace，只有全文状态为 `retrieved` 的 include 题录进入 `services/api/app/extraction.py` 生成 evidence items。
- M5 主题归纳与 evidence matrix：`services/api/app/synthesis.py` 从已批准 evidence items 生成 evidence matrix 与初步主题；API 支持 synthesis theme 人工改名/解释、批准/退回和多主题合并，保留 record/evidence item 回链与人工 trace。
- 草稿与审计：`services/api/app/drafting.py` 从 synthesis package 生成 Methods / Results / Discussion 草稿，并审计 claim 到 evidence item 的追溯完整性；少量 evidence item 支撑的主题 claim 会提示 `weak_theme_evidence` / `warning`，明显越界为临床建议的 claim 会被标记为 `clinical_guidance_language` / `blocking`。
- 草稿人工审核：API 支持 section / claim 人工批准或退回修改；所有草稿内容批准且审计无 blocking 后进入 `ready_for_export`。
- 导出包：`services/api/app/export_package.py` 在 `ready_for_export` 后生成包含检索日志、已审核纳入/排除标准、PRISMA-ScR 风格流程计数、草稿正文和 traceable claims 的 Markdown 报告，以及 evidence CSV、screening CSV、full-text CSV、trace timeline CSV 和 audit CSV；evidence CSV 保留 evidence matrix row 的 `trace_source` 与 `trace_rationale`，screening CSV 保留 Agent 筛选建议、人工决定、排除理由和双 trace，full-text CSV 保留全文获取/排除状态、来源 URI、文件名、附件 ID、备注、排除理由和双 trace，trace timeline CSV 保留项目追溯事件的 order、target、label、source、rationale、actor 和 status，audit CSV 保留 finding 类型、严重级别、关联 claim、`trace_source` 与 `trace_rationale`；API 也支持服务端归档，写入 Markdown / CSV / manifest，并记录每个文件的 `storage_uri`、大小和 sha256；`GET /review-projects/{id}/export/archives` 可恢复既有归档列表。
- 前端 API 工作台：`apps/web/app/page.tsx` 支持配置 API base、刷新项目列表、打开已有项目、逐步执行审核流程、PCC 编辑保存、纳排标准编辑/批准/退回、检索式编辑与确认、检索日志记录、CSV/RIS/BibTeX 粘贴导入、重复候选人工审核、单条筛选 include/exclude/unsure 与排除理由、全文 PDF/URL、PDF 附件上传与不可得/全文排除原因记录、evidence item / synthesis theme / draft section / draft claim 单项批准或退回、合并 synthesis themes、查看 Flow Summary 流程计数和 Trace Timeline 追溯事件、跑通样例流程、下载 Markdown/evidence/screening/full-text/trace/audit 导出包、生成服务端归档并显示归档文件下载链接；`apps/web/app/icon.svg` 提供 favicon。

## 下一步

1. 增强导出 artifact：补归档删除/保留策略或更多导出格式。
2. 可选收敛 Docker 运行细节：为 Celery worker/API 增加非 root 运行用户，消除 Celery root warning。


























2026-06-03：基于优化后的 D:\Backup\Downloads\platform-design-v1.md，使用 Figma 连接器创建可编辑设计文件 AI Academic Writing Platform - A型综述MVP UI（file key: Rdqd70DSWjQlBNleXTPwV2，URL: https://www.figma.com/design/Rdqd70DSWjQlBNleXTPwV2）；画板包含设计说明封面、桌面三阶段工作台主屏、移动端定义阶段主屏、组件与状态板。因 Figma Starter MCP 调用限额，桌面截图验证未完成，移动端截图和页面元数据返回正常。

2026-06-03：基于 v1.1 设计文档与 Figma 草图优化前端工作台首屏：新增三阶段 phase rail、下一步/关键队列概览、中文化关键面板标题；新增 `apps/web/app/workbenchPhases.js` 与 `apps/web/app/workbenchPhases.test.mjs` 覆盖阶段映射；验证 `npm test` 与 `npm run build` 通过。后台 dev server 在当前 Codex 启动环境中无法稳定保活，已清理尝试启动的残留进程。

2026-06-03：继续优化前端工作台设计稿落地，新增 Review Queue 首屏队列卡片，把定义待确认、筛选待决策、全文待处理、证据待批准、草稿待批准、审计阻断统一成可扫描状态；新增 `apps/web/app/workbenchQueue.js` 与 `apps/web/app/workbenchQueue.test.mjs`，验证 `npm test` 3 项通过、`npm run build` 通过。

2026-06-04：完成 Docker 镜像构建与 compose 服务重启验证；`docker compose build --progress plain` 成功构建 `elder-care-scoping-review-api:local` 与 `elder-care-scoping-review-web:local`，Web 镜像内 Next 生产构建通过；`docker compose up -d` 后 postgres/redis/api/web healthy，worker ready。验证 `GET /health` 返回 200、Web 首页返回 200，HTML 包含“可审计 AI 综述工作台 / 当前队列 / 下一步”；API 创建验证项目并确认 PCC 后 stage 从 `pcc_review` 推进到 `search_strategy_review`。Chrome 插件诊断显示 Chrome 已安装，但 Codex Chrome Extension/native host 配置不可用，本轮未完成真实 Chrome 浏览器控制验证。

2026-06-04：收到“UI 并没有改进”反馈后，按 `frontend-design` 与 `design-taste-frontend` 重新做首屏视觉重设计：将顶部改为 `command-surface` 指挥台，标题改为“把 AI 输出锁进可追溯流程”，控制条改为 dock，三阶段 rail 改为连续流程条，下一步卡、Review Queue、Metric Cards、面板材质统一为冷灰纸面 + 深森林绿 + 单一琥珀强调的审计工具风格。验证 `npm test` 3 项通过、`npm run build` 通过、`docker compose build web` 通过并重启 web 容器，`GET /` HTML 已包含新结构与新文案。Playwright/Chrome 控制仍不可用，本轮无自动截图验证。

2026-06-04：基于用户截图和 `design-taste-frontend` 进一步做产品级 UI 优化：收敛首屏英雄区高度，桌面端改为 328px sticky 项目/操作侧栏 + 中间主任务列 + 390px 追溯/筛选/导出侧栏；新增“流程操作”标题，操作按钮改为双列紧凑布局，默认隐藏冗长禁用原因并在 hover/focus 显示；阶段轨压缩为工作台式流程条，Review Queue 改为 2 列，内容面板减少阴影和随机瀑布流感。验证 `npm test` 3 项通过、`npm run build` 通过、`docker compose build web` 通过、`docker compose up -d web` 后 web healthy，`GET /` HTML 包含 `流程操作` 与新结构。

2026-06-05：用户要求继续用 `@chrome` 验证；当前会话仍未暴露 Chrome 导航/截图控制工具。按 Chrome 插件诊断脚本复查：Chrome 已安装（149.0.7827.53），但 `C:\Users\Administrator\AppData\Local\Google\Chrome\User Data` 不存在，Codex Chrome Extension native host 注册缺失（`HKCU\Software\Google\Chrome\NativeMessagingHosts\com.openai.codexextension` 不存在），因此无法进行真实 Chrome 控制验证；需要从 Codex 插件 UI 重新安装/修复 Chrome 插件后再继续浏览器级验证。

2026-06-05：继续前端开发，优化左侧流程操作区的可用性。新增 `apps/web/app/workbenchActionPresentation.js` 与测试，把流程按钮分为 `ready`、`blocked`、`unavailable` 三种表现状态；`ActionButton` 输出 `data-state` 和统一原因文案，可执行动作置顶并使用主按钮样式，阻断/后续动作降噪显示。验证 `npm test` 6 项通过、`npm run build` 通过、`docker compose build web` 通过、`docker compose up -d web` 后 web healthy，`GET /` HTML 包含新的 `data-state` 动作结构。

2026-06-05：继续落实“真实可用、不使用 mock 数据”要求：前端移除运行时 `sampleCsv` / `sampleRis` / `sampleBibtex`、`importSamples`、`runSampleWorkflow`、“跑通示例流程”和“导入样例文献”等样例入口；新建项目改为用户填写题名/主题/领域后才可提交，题录导入改为空表单并要求来源名与真实 CSV/RIS/BibTeX 内容，全文批量已取回不再生成 `example.org` 地址，必须有来源链接、文件名或附件。新增 `apps/web/app/workbenchFormDefaults.js` 与测试固化空默认值和导入必填校验；验证 `npm test` 10 项通过、`npm run build` 通过、`python -m pytest` 66 项通过、`docker compose up --build -d` 成功，api/web/postgres/redis healthy，API smoke test 用请求体创建真实输入项目并返回 `pcc_review`。`agent-browser` 0.26.0 可用但本机 Chrome CDP 启动失败（`CDP response channel closed`），doctor 仅清理 stale daemon，无 fail；本轮浏览器控制验证未完成，已用 HTTP/HTML 断言确认运行时页面没有示例入口。
