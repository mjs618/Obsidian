---
company:
location:
title:
email:
phone: 0
aliases: []
tags:
  - 领域/工作
  - 类型/人脉
  - 状态/进行中
  - contact
type: 人脉
template_type: contact
domain: 工作
status: 进行中
created: <% tp.file.creation_date() %>
---
# <% tp.file.title %>

## 基本信息

- Company: `INPUT[text:company]`
- Title: `INPUT[text:title]`
- Location: `INPUT[text:location]`
- Email: `INPUT[text:email]`
- Phone: `INPUT[number:phone]`

## 个人记录

````tabs
tab: Scheduled Meetings
```dataview
TABLE scheduled_date as "Scheduled Date", start_time as "Start Time", summary as "Summary"
from #contact/<% tp.file.title.split(" ").join("_").toLowerCase() %>
where contains(type,"meeting") OR template_type = "meeting" OR type = "会议"
sort meeting_status asc, scheduled_date asc
```
````
````tabs
tab: Ongoing Tasks

```tasks
not done
tags include #contact/<% tp.file.title.split(" ").join("_").toLowerCase() %>
path does not include "SYSTEM"
sort by due date
```
````
````tabs
tab: Completed Tasks
```tasks
done
tags include #contact/<% tp.file.title.split(" ").join("_").toLowerCase() %>
path does not include "SYSTEM"
sort by due date
```
````

## 关系维护

- 最近互动：
- 下次跟进：
- 相关项目：

<%* tp.hooks.on_all_templates_executed(async () => {
    const file = tp.file.find_tfile(tp.file.path(true));
    const contact_key = tp.file.title.toLowerCase().replace(/\s+/g, "_");
    await app.fileManager.processFrontMatter(file, (frontmatter) => {
        const current = frontmatter["tags"];
        const tags = Array.isArray(current) ? current : current ? [current] : [];
        frontmatter["tags"] = Array.from(new Set([...tags, "contact", `contact/${contact_key}`]));
    });
}); -%>
