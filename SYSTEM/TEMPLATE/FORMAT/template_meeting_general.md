---
scheduled_date:
start_time:
end_time:
summary: ""
meeting_status: false
tags:
  - 领域/工作
  - 类型/会议
  - 状态/进行中
  - meeting
type: 会议
template_type: meeting
meeting_type: general
domain: 工作
status: 进行中
created: <% tp.file.creation_date() %>
cssclasses:
  - hide-properties_editing
  - hide-properties_reading
---
# <% tp.file.title %>

## 会议信息

Scheduled Date:  `INPUT[date(showcase):scheduled_date]`
Start Time: `INPUT[time:start_time]`  End Time:  `INPUT[time:end_time]`
Meeting Summary: `INPUT[text(limit(30)):summary]`
Meeting Status: `INPUT[toggle:meeting_status]` (`VIEW[{meeting_status} ? "Done" : "Not Done"]`)

## 参会人标签

-

## 主题标签

-

## 会议目的

- 本次会议要解决：
- 会前需要确认：

## 会议记录


## 会议结论

- 已决定：
- 未决定：
- 风险或阻塞：

## 行动项

- [ ]

## 会后回流

- [ ] 行动项已写入项目或任务入口
- [ ] 结论已链接到相关项目/领域
- [ ] 无价值临时记录已清理
