---
type: 日记
domain: 生活
status: 草稿
tags:
  - 领域/生活
  - 类型/日记
  - 状态/草稿
cssclasses:
  - hide-properties_editing
  - hide-properties_reading
---
# Daily Note
```calendar-nav
```
````tabs
tab: Due Today
```tasks
not done
due <% tp.file.title %>
sort by priority
hide due date
limit 10
```
tab: Overdue
```tasks
not done
due before <% tp.file.title %>
sort by priority
hide due date
limit 10
```
tab: Completed
```tasks
done <% tp.file.title %>
hide done date
hide due date
limit 10
```
````
# New Tasks

- [ ] 今日最重要推进：
- [ ] 必须处理：
- [ ] 可以放弃或延后：

# Daily Notes

<%tp.file.cursor()%>

# Evening Close

- 今天完成了什么：
- 需要回流到项目/主题/资料的内容：
- 明天第一步：

# Overview

````tabs
tab: Meetings
```dataviewjs
let meetings = dv.pages('"30-工作/会议记录"')
    .where(m => m.meeting_status === false && (m.type === "meeting" || m.type === "会议" || m.template_type === "meeting"));

// Separate meetings with and without scheduled dates
let withDates = meetings.where(m => m.scheduled_date);
let withoutDates = meetings.where(m => !m.scheduled_date);

// Sort meetings with dates by scheduled date
withDates = withDates.sort(m => m.scheduled_date);

// Combine both lists, with meetings having dates first
let allMeetings = withDates.concat(withoutDates);

// Render the table with clickable meeting links
dv.table(
    ["Days", "Meeting", "Scheduled Date", "Start Time", "End Time"],
    allMeetings.map(m => [
        m.scheduled_date ? Math.floor(dv.date(m.scheduled_date).diff(dv.date("today"), 'days').days) : "-", // Calculate days until the meeting
        m.file.link, // Use m.file.link to render the meeting name as a clickable link
        m.scheduled_date ? dv.date(m.scheduled_date).toFormat("MM-dd") : "-",
        m.start_time || "-",
        m.end_time || "-"
    ])
);
```
tab: Projects
```dataviewjs
const isProject = p => p.type == "project_note" || p.type == "project_family" || p.type == "项目" || p.template_type == "project_note" || p.template_type == "project_family";
const isCompleted = p => p.Status == "4 Completed" || p.status == "已完成";

let pages = dv.pages('"30-工作/项目"')
    .where(p => isProject(p) && !isCompleted(p));

// Separate pages with and without due dates
let withDueDates = pages.where(p => p.Due_Date != null);
let withoutDueDates = pages.where(p => p.Due_Date == null);

// Sort pages with due dates by: Due Date -> Priority Level (A-Z) -> Status (Z-A)
withDueDates = withDueDates.sort(p => p.Due_Date)
    .sort(p => p.Priority_Level)
    .sort(p => p.Status, 'desc');

// Sort pages without due dates by: Priority Level (A-Z) -> Status (Z-A)
withoutDueDates = withoutDueDates.sort(p => p.Priority_Level)
    .sort(p => p.Status, 'desc');

// Combine both lists
let allPages = withDueDates.concat(withoutDueDates);

// Render the table with clickable project links
dv.table(
    ["Days", "Project", "Priority Level", "Status", "Due Date"],
    allPages.map(p => [
        p.Due_Date ? Math.floor(dv.date(p.Due_Date).diff(dv.date("today"), 'days').days) : "-", // Display whole number of days
        p.file.link, // Use p.file.link to render the project name as a clickable link
        p.Priority_Level || "-",
        p.Status || "-",
        p.Due_Date ? dv.date(p.Due_Date).toFormat("MM-dd") : "-"
    ])
);
```
tab: Areas
```dataview
table area_category as "Area Category", created as "Date Created" from "PARA/AREAS"
WHERE type = "area_family" OR template_type = "area_family"
```
````
