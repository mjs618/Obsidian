# codex-gpt-image

## 2026-07-09

- 本地工作区：`C:\Users\Administrator\Documents\Codex\2026-07-09\ningzimu-codex-gpt-image\codex-gpt-image`
- 来源仓库：`https://github.com/ningzimu/codex-gpt-image`
- 本次改造目标：让 `codex-gpt-image` skill 更适合本地 Codex/agent 使用，重点补强 Codex OAuth 安全边界、登录确认、输出路径规划和防覆盖行为。
- 已改动：
  - `skills/codex-gpt-image/SKILL.md`：增加 native image tool fallback、敏感 token 禁止输出、登录/覆盖需确认、dry-run 工作流、参数选择规则和失败处理。
  - `skills/codex-gpt-image/scripts/codex_gpt_image.py`：新增输出后缀校验、无后缀自动补后缀、默认拒绝覆盖已有输出、`--overwrite` 显式覆盖开关、dry-run 输出计划路径。
  - `skills/codex-gpt-image/references/openai-images-api-parameters.md`：记录本地 CLI-only 控制项。
  - `CHANGELOG.md`：记录用户可见改动。
- 验证：
  - `python -m py_compile skills\codex-gpt-image\scripts\codex_gpt_image.py`
  - `generate --dry-run` 验证默认 png、后缀不匹配报错、无后缀补 `.png`、`--count 2` 输出编号。
  - 临时目录测试确认默认拒绝覆盖已有输出。
- 注意：未执行真实生图请求，未读取或打印 `~/.codex/auth.json` token。

## 2026-07-09 真实生图测试

- 用户确认后执行了一次真实 Codex OAuth 生图请求。
- 输出文件：`C:\Users\Administrator\Documents\Codex\2026-07-09\019f4553-3842-7c63-bf0a-12e71cb569b5-ningzimu\outputs\real-codex-gpt-image-test.png`
- 结果：成功生成 1 张图片，耗时约 32.5 秒，文件大小约 794 KB。
- 目视检查：白底、蓝色圆角矩形、文字 `Codex GPT Image OK`，符合测试提示。
- 额外验证：同名输出再次运行时被默认防覆盖逻辑拦截，未发起新的真实生图请求。

## 2026-07-09 安装状态

- 已把本地改造后的 skill 安装到：`C:\Users\Administrator\.codex\skills\codex-gpt-image`
- 安装后验证：
  - `SKILL.md` frontmatter 名称为 `codex-gpt-image`
  - 从全局 skill 路径运行 `generate --dry-run` 成功
- 注意：当前会话启动时尚未加载该 skill；需要重启 Codex 或新开会话后，才会出现在可用技能列表中。触发方式应使用自然语言，例如“使用 codex-gpt-image 生成一张图片”，不是 `/codex-gpt-image` slash command。
