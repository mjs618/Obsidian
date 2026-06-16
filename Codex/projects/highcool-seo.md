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

- 建立 SERP 采集表。
- 按 30 个英文核心关键词抓取前 10 个自然结果。
- 将竞对按品牌、供应商、分销商、安装店、平台页分类。
- 输出 HighCool 页面机会、内容机会和外链机会优先级。

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

- 将 Web UI 的 `Run Mock Research` 扩展为可选择 `mock` / `serpapi`。
- 接入真实 SerpAPI / DataForSEO Key 后跑真实全球英文 SERP。
- 后续再接 Ahrefs / Semrush / GSC 的关键词量、外链和真实表现数据。
