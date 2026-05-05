---
type: MOC
domain: 收集箱
status: 进行中
cssclasses:
  - home-dashboard
tags:
  - 待整理
  - 类型/汇总
---

# Fleeting Notes

> [!capture]+ Fleeting Notes
> 临时想法、片段、未判断去向的内容。这里的目标是快速捕捉，不是长期保存。

> [!info]+ 边界
> Fleeting Notes 只负责低摩擦捕获。超过一周仍有价值的内容，应转入项目、主题或资料区。

> [!capture] Inbox
> [[HUB/Inbox]]
>
> 新想法和不确定去向的内容先进入这里。

> [!task] 未分类
> [[未分类/00-索引]]
>
> 每周清空或明确下一步。

> [!zeta] 灵感卡片模板
> [[Templates/原生模板/💡 灵感卡片模板]]
>
> 适合快速记录一个想法。

## 快速捕获

- 使用命令面板运行 `QuickAdd: Create Fleeting Note`。
- 标题用一句话命名，例如 `AI 是认知训练器`。
- 新笔记会保存到 `ZETA/FLEETING`。
- 正文只写原始想法、触发来源和一个下一步，不在这里展开长文。

## 每日记录建议

- 当天一闪而过的想法：先写进今日笔记。
- 超过 3 句话或值得回看的想法：新建一条 Fleeting Note。
- 已经能行动：转入项目。
- 已经形成判断：转入 Permanent Note。

## 已捕获想法

```dataview
table dateformat(file.mtime, "yyyy-MM-dd HH:mm") as "更新", status as "状态"
from "ZETA/FLEETING"
sort file.mtime desc
limit 20
```

## 分拣动作

- 能推进项目：移到 [[PARA/Projects]] 或项目页。
- 是长期问题：链接到 [[ZETA/Permanent Notes]] 或主题地图。
- 只是来源：移到 [[ZETA/Literature Notes]]。
- 无价值：删除或记录后清理。
