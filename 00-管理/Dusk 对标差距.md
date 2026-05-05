---
type: 管理
domain: 知识管理
status: 进行中
tags:
  - 领域/知识
  - 类型/清单
  - 待整理
---

# Dusk 对标差距

参照 [Dusk Obsidian Vault](https://github.com/DuskWasHere/dusk-obsidian-vault) 的公开 README。该仓库说明 GitHub 版本是 legacy，当前版本已迁移到 Discord；因此这里只对标公开仓库中明确写出的能力。

## 差距总览

| Dusk 能力 | 公开描述 | 当前库状态 | 下一步 |
| --- | --- | --- | --- |
| HUB | homepage、map、inbox、task tracking | 已有 [[HUB/Home]]、[[HUB/Map]]、[[HUB/Inbox]]、[[HUB/Tasks]] | 后续可增加 Dataview/Datacore 自动视图 |
| PARA | Projects、Areas、Resources、Archive | 已有 [[PARA/00-PARA]]、[[PARA/Projects]]、[[PARA/Areas]]、[[PARA/Resources]]、[[PARA/Archive]] | 需要在工作台中持续强化行动状态 |
| Zettelkasten | Permanent、Literature、Fleeting | 已有 [[ZETA/00-ZETA]]、[[ZETA/Fleeting Notes]]、[[ZETA/Literature Notes]]、[[ZETA/Permanent Notes]] | 需要真正提炼永久笔记，而不只是建模板 |
| DAILY | daily、weekly、monthly reflections | 已有 [[DAILY/00-DAILY]]、[[DAILY/Daily Notes]]、[[DAILY/Weekly Notes]]、[[DAILY/Monthly Notes]] | 生活/复盘区仍薄弱 |
| STICKY | temporary brainstorming notes | 已有 [[STICKY/00-STICKY]] | 可补灵感/草稿专用流程 |
| SYSTEM | media、templates、configurations | 已有 [[SYSTEM/00-SYSTEM]] | 可进一步整理附件和插件配置 |
| Dynamic navigation | Datacore/动态查询 | 目前主要是静态 MOC，标签仪表盘依赖 Dataview | 插件启用后再自动化 |
| Page Task | 页面级任务 | 已新增 [[00-管理/任务邮箱]] | 需要每周维护，未来可接 Dataview |
| Focus tools | Focus Mode、Pomodoro、FAB、hotkeys | 未实现 | 暂不建议做，除非明确需要插件化工作流 |
| QuickAdd | 模板和宏命令 | 仅有原生模板和 Templater 参考 | 可在插件确认后再做 |

## 现实判断

当前库已经开始接近 Dusk 的信息架构，但还没有达到 Dusk 的“交互系统”程度。现在补上的只是：

- 静态 HUB
- 静态 MOC
- 页面级任务清单
- 收件箱分拣规则
- 核心模板

真正的差距在两点：

1. 自动化不足：Dusk 使用 Datacore/QuickAdd/宏/快捷键等形成动态导航和快速录入。
2. 内容提炼不足：你的库有结构，但永久笔记、项目复盘、剪藏摘要还不够多。

## 下一步优先级

1. 先用静态系统跑一周，确认入口是否顺手。
2. 处理 [[00-管理/任务邮箱]] 中 1-2 个页面级任务。
3. 如果确认需要自动化，再决定是否启用 Dataview/Datacore/QuickAdd。
4. 不建议马上复制 Dusk 的全部插件体系，否则会增加维护成本。
