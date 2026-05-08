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

## 使用场景

- 这条记录服务于：
- 需要解决的问题：
- 不需要继续跟进的部分：

## 结论

-

## 下一步

- [ ]

## 回流

- [ ] 已链接到项目、领域或资料入口
- [ ] 已提炼可复用结论
- [ ] 已清理临时内容
