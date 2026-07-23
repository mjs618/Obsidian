# Codex Skills

## 已安装集合

- 2026-06-01：已从 `antfu/skills` 安装全量 Antfu Skills 到 `C:\Users\Administrator\.codex\skills`。包含 `antfu`、`vue`、`nuxt`、`pinia`、`vite`、`vitepress`、`vitest`、`unocss`、`pnpm`、`slidev`、`tsdown`、`turborepo`、`vueuse-functions`、`vue-best-practices`、`vue-router-best-practices`、`vue-testing-best-practices`、`web-design-guidelines`。安装后需要重启 Codex 才会被新会话自动发现。

- 2026-06-02：已创建并安装 storage-analyzer 到 C:\Users\Administrator\.codex\skills\storage-analyzer。用途：Windows/macOS 只读存储扫描、磁盘占用分级分析、生成 HTML 清理报告；包含 scripts/scan.py、scripts/build_report.py、scripts/server.py 和系统参考文件。已通过 quick_validate.py、只读语法检查和样例 HTML 构建验证；新会话可能需要重启 Codex 才能自动发现。

## 2026-06-11 Superpowers 更新

- 已将 `C:\Users\Administrator\.codex\superpowers` 通过 `git pull --ff-only` 更新到 `superpowers` 5.1.0 后续提交。
- 当前版本信息：`package.json` 为 `5.1.0`，`git describe --tags --always` 为 `v5.1.0-1-g6fd4507`。
- 工作区状态干净；Git 仍提示无法访问 `C:\Users\Administrator\.config\git\ignore`，但不影响本次更新。
- 2026-07-08：已从 `coreyhaines31/marketingskills` 安装全量 Marketing Skills 到 `C:\Users\Administrator\.codex\skills`，共 47 个：`ab-testing`、`ad-creative`、`ads`、`ai-seo`、`analytics`、`aso`、`churn-prevention`、`co-marketing`、`cold-email`、`community-marketing`、`competitor-profiling`、`competitors`、`content-strategy`、`copy-editing`、`copywriting`、`cro`、`customer-research`、`directory-submissions`、`emails`、`free-tools`、`image`、`launch`、`lead-magnets`、`marketing-council`、`marketing-ideas`、`marketing-loops`、`marketing-plan`、`marketing-psychology`、`offers`、`onboarding`、`paywalls`、`popups`、`pricing`、`product-marketing`、`programmatic-seo`、`prospecting`、`public-relations`、`referrals`、`revops`、`sales-enablement`、`schema`、`seo-audit`、`signup`、`site-architecture`、`sms`、`social`、`video`。安装后需要重启 Codex 才能在新会话自动发现。

- 2026-07-08：已安装 `dashiai-ppt` skill 到 `C:\Users\Administrator\.codex\skills\dashiai-ppt`。来源：`chuspeeism/dashiAI-ppt-skill` 仓库 `skills/dashiai-ppt`，审查提交 `e77c356 Publish skill v0.1.30`。安装前已检查 `SKILL.md`、`agents/openai.yaml`、脚本/依赖/本地服务/文件写入/凭证模式；未发现高风险恶意行为。已通过 `quick_validate.py`。注意：首次生成 PPT 会运行 `npm install`、可能下载 Playwright headless Chromium，并启动本地预览服务；安装后需要重启 Codex 才能在新会话自动发现。

- 2026-07-09：已基于 `ningzimu/codex-gpt-image` 改造 `codex-gpt-image` skill 副本，强化 `gpt-image-2` / `image-2` / Codex OAuth / 无 API key 生图场景的触发说明，并补充安全边界、`--dry-run` 校验、输出汇报和原生图片工具不能确认模型时的处理策略。已通过 `python -m py_compile skills\codex-gpt-image\scripts\codex_gpt_image.py`、`generate --dry-run` 和 `package_skill.py` 校验；打包产物位于 `C:\Users\Administrator\Documents\Codex\2026-07-09\ningzimu-codex-gpt-image\outputs\codex-gpt-image.skill`。尚未安装到全局 skills 目录。

