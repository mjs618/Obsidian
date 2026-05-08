---
connections: []
reference:
tags:
  - 领域/数据资料
  - 类型/资源
  - 状态/进行中
  - documentation_note
type: 资源
template_type: documentation_note
domain: 数据资料
status: 进行中
created: <% tp.file.creation_date() %>
---

# <% tp.file.title %>

## 关联

**Select Connection:** `INPUT[inlineListSuggester(optionQuery(#project), optionQuery(#area)):connections]`

## 来源

- Reference: `INPUT[text:reference]`
- 获取方式：
- 使用场景：

## 摘要

<%tp.file.cursor()%>

## 关键数据

-

## 后续动作

- [ ] 链接到相关项目或主题
