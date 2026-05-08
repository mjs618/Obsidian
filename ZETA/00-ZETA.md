---
type: MOC
domain: 知识管理
status: 进行中
cssclasses:
  - home-dashboard
tags:
  - 领域/知识
  - 类型/汇总
---

# ZETA

> [!home]+ Zettelkasten Flow
> ZETA 负责把临时输入变成可复用知识。不是所有记录都要变成永久笔记。

> [!info]+ 使用边界
> ZETA 是知识加工流程，不要求所有正文都搬进 `ZETA` 文件夹。主题正文可以继续留在 `20-AI`、`40-知识库`、`60-思维笔记` 等内容库目录。

> [!capture] Fleeting Notes
> [[ZETA/Fleeting Notes]]
>
> 临时想法、片段、未判断去向的内容。

> [!zeta] Literature Notes
> [[ZETA/Literature Notes]]
>
> 外部资料、来源、剪藏、学习材料。

> [!project] Permanent Notes
> [[ZETA/Permanent Notes]]
>
> 长期可复用的判断、主题地图和原则卡片。

## 加工路径

```mermaid
flowchart LR
    Fleeting["临时想法"] --> Literature["来源和资料"]
    Literature --> Permanent["可复用判断"]
    Permanent --> Reuse["项目/主题/复盘复用"]
```

## 三层输出标准

| 阶段 | 只需要做到 | 不应该做 |
| --- | --- | --- |
| Fleeting | 记录触发来源、一句话想法、一个下一步 | 在这里写长文或分类过细 |
| Literature | 保留来源、摘要、为什么值得收藏 | 把原文当成已经吸收的知识 |
| Permanent | 写出自己的判断、依据、边界和可复用场景 | 只搬运摘录或堆链接 |

## 复用去向

- 能推进项目：链接到 [[PARA/Projects]] 或具体项目页。
- 能解释主题：链接到 `20-AI`、`40-知识库` 或 `60-思维笔记` 的主题地图。
- 能指导行动：沉淀为原则卡片或加入复盘。
