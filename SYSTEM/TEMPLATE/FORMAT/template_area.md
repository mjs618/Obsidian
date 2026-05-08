---
area: <% tp.file.folder() %>
area_category:
summary:
tags:
  - 领域/工作
  - 类型/领域
  - 状态/进行中
  - area
type: 领域
template_type: area_family
domain: 工作
status: 进行中
created: <% tp.file.creation_date() %>
---
# <% tp.file.title %>

## 概览

<%tp.file.cursor()%>
````tabs
tab: Components
```dataview
table created AS "Created", summary AS "Summary"
from "<% tp.file.folder() %>"
where type != "area"
where template_type = "area_note" OR type = "area_note"
where template_type != "area_note_sub" AND type != "area_note_sub"
sort created DESC
```
tab: Projects
```dataview
table type AS "Type", Status AS "Status", Priority_Level AS "Priority_Level"
from "30-工作/项目"
where contains(connections, this.file.link)
where template_type = "project_family" OR template_type = "project_note" OR type = "project_family" OR type = "project_note" OR type = "项目"
sort Status ASC
```
tab: Other
```dataview
table type AS "Type"
from "70-数据资料" OR "30-工作/项目"
where contains(connections, this.file.link)
where template_type = "documentation_note" OR template_type = "workstation_note" OR type = "documentation_note" OR type = "workstation_note"
sort type ASC
```
````
````tabs
tab: Scheduled Meetings
```dataview
TABLE scheduled_date as "Scheduled Date", start_time as "Start Time", summary as "Summary"
from #area/<% tp.file.folder().split("/").pop().toLowerCase().replace(/\s+/g, "_") %>
where contains(type,"meeting") OR template_type = "meeting" OR type = "会议"
sort meeting_status asc, scheduled_date asc
```
````
````tabs
tab: Ongoing Task
```tasks
not done
tags include #area/<% tp.file.folder().split("/").pop().toLowerCase().replace(/\s+/g, "_") %>
path does not include "SYSTEM"
sort by due date
```
````
````tabs
tab: Completed Tasks
```tasks
done
tags include #area/<% tp.file.folder().split("/").pop().toLowerCase().replace(/\s+/g, "_") %>
path does not include "SYSTEM"
sort by due date
```
````

<%* tp.hooks.on_all_templates_executed(async () => {
    const file = tp.file.find_tfile(tp.file.path(true));
    const area_key = tp.file.folder().split("/").pop().toLowerCase().replace(/\s+/g, "_");
    await app.fileManager.processFrontMatter(file, (frontmatter) => {
        const current = frontmatter["tags"];
        const tags = Array.isArray(current) ? current : current ? [current] : [];
        frontmatter["tags"] = Array.from(new Set([...tags, "area", `area/${area_key}`]));
    });
}); -%>
