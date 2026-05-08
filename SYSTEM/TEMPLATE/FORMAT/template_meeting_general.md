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

## 会议记录


## 行动项

- [ ]
