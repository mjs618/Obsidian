# HighCool SEO

## 背景

HighCool 官网：https://highcool.com/

项目方向：外贸独立站 SEO，产品重点为汽车车衣膜 / TPU Paint Protection Film，并延伸到 Window Tint、Vinyl Wrap、Color PPF、Dealer / Distributor 招商。

## 当前决策

- 先做全球英文粗筛，不按国家细分。
- 先用公开搜索结果和公开网页信息建立 v1 工作流。
- 付费工具如 Ahrefs、Semrush、Similarweb、GSC 在需要精确关键词量、排名国家分布、外链数量和竞对关键词时再接入。
- SEO 对标对象不只限于中国工厂站，应同时观察国际品牌、新兴 PPF 品牌、中国/亚洲供应商、安装店内容站和 B2B 平台。
- 计划开发 SEO Agent 系统，形态为自动化 Agent 型；第一版采用混合触发，先支持手动触发，预留定时任务。
- SERP 数据源第一版使用搜索 API（DataForSEO 或 SerpAPI）；Ahrefs / Semrush / Similarweb / GSC 第一版只预留 provider 接口，不实现接入。
- MVP 重点是自动采集、半自动分析、可复查报告，不做自动发文、自动外链或 Shopify 写入。

## 工作流文件

- `E:\project\SEO\highcool-global-english-seo-workflow.md`
- `E:\project\SEO\docs\superpowers\specs\2026-06-16-highcool-seo-agent-design.md`

## 下一步

- 配置真实 SerpAPI Key 后运行 30 个英文核心关键词的全球英文 SERP。
- 复查真实抓取生成的报告和 CSV，确认竞对分类、页面缺口、内容机会和外链机会优先级。
- 后续再接 Ahrefs / Semrush / GSC 的关键词量、外链和真实表现数据。

## 2026-06-16 交付状态

已在 `E:\project\SEO` 开发本地 HighCool SEO Agent MVP。

当前能力：

- 本地 Web UI：`python -m seo_agent.web` 后访问 `http://127.0.0.1:8765`。
- 支持一键导入 30 个 HighCool 英文种子关键词。
- mock SERP 每个关键词 10 条结果，可生成 300 条 SERP 记录和 300 条页面分析。
- 输出 Markdown 报告、`serp-results.csv`、`page-analysis.csv`、`errors.csv`。
- 报告包含关键词优先级、HighCool 页面缺口、竞对深挖、外链/信任机会。
- 已预留 SerpAPI provider；Web 演示按钮当前固定 mock，避免客户演示依赖外部 API Key。
- 错误隔离：单关键词失败、单页面失败不会中断整批任务。
- artifact 路径读取限制在报告目录内。

验证：

- `python -B -m unittest discover -v`，15 个测试全部通过。

下一步：

- 接入真实 SerpAPI / DataForSEO Key 后跑真实全球英文 SERP。
- 后续再接 Ahrefs / Semrush / GSC 的关键词量、外链和真实表现数据。

## 2026-06-17 状态更新

已将 `E:\project\SEO` 的运行路径改为真实 SerpAPI：

- 默认 `SERP_PROVIDER` 为 `serpapi`，不再默认 mock。
- Web UI 的运行按钮改为 `Run Live Research`，按配置调用真实 provider。
- 生产代码删除 `MockSerpProvider`、mock SERP fixture 和 mock 页面生成分支。
- 缺少 `SERPAPI_KEY` 时，任务会创建 failed run，Web 请求返回项目页而不是断开。
- 测试改为使用测试内 stub 隔离外部网络，不再依赖生产 mock provider。
- Web UI 已中文化：页面语言为 `zh-CN`，按钮、表头、运行状态、错误提示改为中文。
- Markdown 报告模板已中文化：报告标题、章节、表头、静态建议和说明改为中文；英文关键词本身保留原文。

验证：

- `python -B -m unittest discover -v`，22 个测试全部通过。
- Web 模块导入通过，`127.0.0.1:8765` 端口绑定 smoke 通过。
- 本地页面 smoke 确认包含 `HighCool SEO 研究系统` 和 `运行真实研究`，且不再包含旧按钮 `Run Live Research`。

下一步：

- 设置 `SERPAPI_KEY` 后执行真实 30 词采集，并复查 `data\reports\run-*` 报告与 CSV。

## 2026-06-17 客户目标补强

根据客户目标“先按目标品类和地区找排名竞对，再分析竞对为什么排名好、做了哪些外链，并反推关键词和动作”，已继续增强 `E:\project\SEO`：

- Web UI 新增项目设置：目标网站、目标品类、目标地区、默认语言。
- 支持多地区关键词导入；SerpAPI 按 keyword 的 `region` 传 `gl`。
- 报告新增地区竞对分布。
- 从 SerpAPI `related_searches` 提取关键词扩展建议，输出 `keyword-suggestions.csv`。
- 基于 SERP 排名、关键词匹配、页面意图、信任信号和 CTA 增加启发式排名原因评分，写入报告和 `page-analysis.csv`。
- 新增外链状态模块：未配置 Ahrefs / Semrush / DataForSEO Backlinks 等真实外链 API 时，明确显示“未配置真实外链 API”，不伪造 backlink、DR/DA、anchor text。
- 报告表格增加基础转义，避免真实数据中的 `|` 破坏 Markdown 表格。

验证：

- `python -B -m unittest discover -v`，26 个测试全部通过。
- 本地页面 smoke 确认包含 `项目设置`、`目标网站`、`目标品类`、`目标地区`、`运行真实研究`。

仍需后续接入：

- 真实外链 provider（Ahrefs / Semrush / DataForSEO Backlinks 任选其一）后，才能回答“竞对具体有哪些反向外链、引用域、锚文本和权重”。
- 当前排名原因评分是启发式分析，不是 Google 排名因子证明；报告中需保持人工复查口径。
