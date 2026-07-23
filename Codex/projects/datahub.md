# datahub

## 项目概览

- GitHub 仓库：`https://github.com/mjs618/datahub.git`
- 本地路径：`E:\work\data-hub`
- 技术栈：Python 单目录服务，核心依赖为 `asyncua`、`requests`。
- 用途：监听 OPC UA 触发信号，按时间范围查询历史数据，再将结果回写到实时库或 OPC UA 目标点。

## 当前代码结构

- `main.py`：主入口，启动鉴权、OPC UA 连接、健康端点、Web UI，并根据 `TASK_MODE` 进入多任务或单触发循环。
- `tasks_config.py`：定义 12 个任务，包含 AC 触发点、FC 完成反馈点、开始/结束时间分量、历史点到目标点的映射。
- `web_ui.py`：基于标准库 `http.server` 的 Web 控制台，提供配置编辑、OPC UA 节点浏览、CSV 导入、手动同步和任务触发 API。
- `health_server.py`：健康检查与运行指标，暴露 `/health`、`/metrics`。
- `auth_client.py`：应用 token 获取、缓存和刷新。
- `history_api.py`：历史数据查询客户端，支持分页与脉冲时间识别。
- `rt_db_client.py`：实时库写入客户端，带重试和结果摘要。
- `opcua_client.py`：OPC UA 读写封装，带断线重连。
- `state_manager.py`：持久化去重状态和失败写入缓存。

## 运行与部署

- 默认入口：`python main.py`
- Docker 入口：`Dockerfile` 中 `CMD ["python", "main.py"]`
- Docker Compose 服务名：`data-hub`
- 健康端点默认端口：`8088`
- Web UI 默认端口：`8089`
- 支持多架构构建：`docker-bake.hcl` 和 `DEPLOY-ARM.md` 覆盖 `amd64`、`arm64`、`arm/v7`。

## 当前判断

- 仓库没有 `README.md`，主要说明分散在 `需求文档.md`、`DEPLOY-ARM.md` 和代码注释中。
- 默认 `TASK_MODE=multi`，即 12 任务轮询模式；`single` 为旧版单触发下降沿模式。
- 未运行测试，因为 `test_web_ui_tasks.py` 会通过配置 API 写入运行时配置文件；本次任务只要求拉取和理解代码。

## 2026-07-07 本地启动测试

- 已在项目内创建 `.venv` 并安装依赖。
- Windows 下直接 `pip install -r requirements.txt` 会因 `requirements.txt` 中文注释按 GBK 解码失败；可用 `python -X utf8 -m pip install -r requirements.txt`。
- 本地测试启动命令使用回环地址和短超时，避免依赖真实外部服务：`BASE_IP=http://127.0.0.1:6543`、`OPCUA_URL=opc.tcp://127.0.0.1:6810`。
- Web UI 可访问：`http://127.0.0.1:8089/`；`/api/tasks/status` 返回 12 个任务。
- 健康端点 `http://127.0.0.1:8088/health` 在无真实 OPC UA/token 服务时返回 503，原因是 `opcua disconnected` / `token_valid=false`，属于本地回环测试的预期结果。

## 2026-07-07 原始需求核对

- 用户确认原始链路：操作页面点击“计算”后 `AC_AGC01=1`，DataHub 监听 OPC UA 变化，读取 `YEAR/MON/DAY/HOUR/MIN/SEC_AGC01` 和 `YEAR/MON/DAY/HOUR/MIN/SEC_AGC11` 组装时间，查询 `AMI_JZ1_FHGD`、`JZ1_AI49`，分别回写 `AGC17`、`AGC18`，成功后置 `FC_AGC01=1`。
- 已对照 `D:\Backup\Downloads\通讯点.xlsx` 与 `tasks_config.py`：12 个任务的 AC、FC、起止时间分量、历史点和目标点全部一致。
- 用 mock 执行 `AGC01` 的 `_handle_task`：实际请求历史点 `['AMI_JZ1_FHGD', 'JZ1_AI49']`，写入 `ns=2;s=AGC17`、`ns=2;s=AGC18`，最后写 `ns=2;s=FC_AGC01=True`。
- 需要注意的潜在偏差不是映射，而是语义：当前轮询检测的是 `0 -> 1` 上升沿，首次读到 `AC=1` 不触发；默认通过 OPC UA 写回目标点，只有 `WRITE_BACK_VIA=rtdb` 时才通过实时库接口写目标点。

## 2026-07-07 RTDB 回放变更

- 用户明确要求多任务结果值通过实时库写值接口 `/api/hsm-db-rtserver/v1/rtdata/node/write` 回写，不再通过 OPC UA 写 `AGC17/AGC18` 等结果点。
- 回写语义改为“回放”：对开始/结束时间区间内的所有历史样本按时间排序后批量写入目标点，而不是只取最后一个值。
- `FC_*` 完成反馈仍通过 OPC UA 写回，且仅在 RTDB 批量写入整体成功后置 1。
- `RTDBClient` 成功判断需要同时满足总 `code=0` 和逐点 `data[]` 全部为 0，避免部分点失败时误置 FC。

## 2026-07-07 配置页开放

- 用户要求配置页尽量开放配置，重点是原先“连接信息（只读）”区域。
- 已开放 `BASE_IP`、`OPCUA_URL`、`TASK_MODE`、`WRITE_BACK_VIA` 的 Web UI 编辑和 `/api/config` 保存。
- 连接地址、运行模式和回写通道写入 runtime 配置文件；其中服务连接对象和主循环模式需要重启服务后完整生效。
- `WRITE_BACK_VIA` 当前只允许 `rtdb`，因为多任务结果值已明确要求通过实时库接口回放；`FC_*` 仍通过 OPC UA 写回。

## 2026-07-07 架构加固

- 按系统架构建议补强了三类现场交付能力：配置生效提示、RTDB 回放批次、任务阶段可观测。
- `/api/config` 保存响应会返回 `restart_required`、`restart_fields`、`hot_reload_fields`，用于区分连接/运行配置需要重启，调优配置可运行时生效。
- 新增 `RTDB_REPLAY_BATCH_SIZE`，默认 500，用于控制实时库回放批量写入的单次请求大小，避免长时间区间一次性请求过大。
- 任务状态新增 `current_stage`，阶段包括 `token`、`settle`、`read_time`、`history`、`build_replay`、`rtdb_replay`、`fc_feedback`、`completed`、`idle`，Web UI 任务管理页可显示当前阶段。
- `_handle_task` 现在会向调度层返回真实成功/失败结果，避免中途 abort 后仍被标记为 completed。

## 2026-07-07 配置页触发字段澄清

- 用户指出配置页 `TRIG_NODE_ID` 看起来像只有一个触发节点；实际 `multi` 模式下有 12 个触发节点，来自任务表中的 `AC_*`（如 `AC_AGC01`、`AC_AGC02`）。
- `TRIG_NODE_ID` 和 `TRIG_HISTORY_ID` 是旧版 `single` 单触发模式字段：前者监听单个 OPC UA 触发节点，后者用于从历史库回查触发脉冲区间。
- 已将配置页标题和提示改为“单触发模式配置（仅 TASK_MODE=single 使用）”，并说明 `multi` 模式不读取这两个字段，多任务触发点请看任务管理页。

## 2026-07-07 OPC UA 现场 NodeId 规则

- 现场 UAExpert 确认 OPC UA Endpoint 为 `opc.tcp://192.168.1.35:6810`，安全策略 `None`、匿名连接。
- 现场 NodeId 规则不是旧占位 `ns=2;s=<点名>`，而是命名空间 `10011`，开关量使用 `.DV`，模拟量使用 `.AV`；示例：`ns=10011;s=AC_AGC03.DV`、`ns=10011;s=YEAR_AGC01.AV`。
- `BadNodeIdUnknown` 表示点名不存在/规则不匹配，不代表 OPC UA 连接断开；客户端不应因此把连接状态置为断开并反复重连。

## 2026-07-07 OPC UA 节点手动绑定

- 用户确认现场仍无法连接/触发，原因倾向于部分任务 AC NodeId 不匹配；决定支持先直接浏览 OPC UA 服务端节点，再把选中的节点绑定到具体任务触发点。
- 已新增运行时配置 `TASK_NODE_OVERRIDES`，当前支持按任务 ID 覆盖 `ac_node`，例如 `{ "AGC01": { "ac_node": "ns=2;s=ManualAC" } }`。
- `tasks_config.effective_tasks()` 会在基础 12 任务上应用覆盖；多任务主循环和任务状态页使用生效后的 AC 节点。AC 节点变化时会重置该任务边沿基线，避免热更新瞬间误触发。
- Web UI 的 OPC UA 节点浏览详情保留旧 `single` 模式的“设为触发节点”，并新增“绑定到多任务触发点”：选择任务后将当前节点保存为该任务的 AC 触发点。
