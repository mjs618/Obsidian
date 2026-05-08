---
connections: []
tags:
  - 领域/工作
  - 类型/笔记
  - 状态/进行中
  - workstation_note
type: 笔记
template_type: workstation_note
domain: 工作
status: 进行中
created: <% tp.file.creation_date() %>
---

# <% tp.file.title %>

## 关联

**Select Connection:** `INPUT[inlineListSuggester(optionQuery(#project), optionQuery(#area), optionQuery(#workstation_note), optionQuery(#documentation_note)):connections]`

## 记录

<%tp.file.cursor()%>

## 结论

-

## 下一步

- [ ]
