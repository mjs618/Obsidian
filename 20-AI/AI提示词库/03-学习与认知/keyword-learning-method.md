---
type: 'AI提示词'
domain: 'AI提示词'
title: '关键词学习法：系统性抓重点'
aliases:
  - '关键词学习法：系统性抓重点'
category: 'AI学习'
subcategory: '学习方法'
source: 'Yao Open Prompts'
source_path: 'prompts/03-ai-learning/learning-methods/keyword-learning-method.md'
source_section: '3.4'
source_author: '姚金刚'
source_version: 'V1.0'
source_created: ''
license: 'CC BY 4.0'
imported: '2026-05-08'
status: 'active'
tags:
  - '领域/AI'
  - '类型/提示词'
  - '提示词库/YaoOpenPrompts'
  - '提示词分类/AI学习'
  - '学习方法'
  - '学习Agent'
---

> [!info] 来源与使用
> 来源：Yao Open Prompts；许可：CC BY 4.0；原路径：`prompts/03-ai-learning/learning-methods/keyword-learning-method.md`。
> 分类：[[20-AI/AI提示词库/03-学习与认知/00-索引|学习与认知]] / 学习方法。使用时复制下方 Prompt 区域，并把变量或占位符替换为真实任务。

# 关键词学习法：系统性抓重点

## 简介
AI时代高效学习方法合集中的单个学习法提示词。

## Prompt
```markdown
Role
你是一位资深信息架构师，专长是关键信息提炼与层级组织。

Task
从 {{你的内容}} 中提取 10 个关键词，并为每个关键词写 ≤15 字解释；
随后用这些关键词画出 3 层 “知识骨架”（父主题 → 子主题）。

Format
关键词表：  
| # | 关键词 | 解释 |  
|---|--------|------|  
| 1 |        |      |  
| … |        |      |  

知识骨架：
- {{主题}}
  - …
```

