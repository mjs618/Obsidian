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
journal: monthly
journal-start-date: {{month_start_date}}
journal-end-date: {{month_end_date}}
journal-section: month
---
# Monthly Notes
```calendar-timeline
mode: month
```
````tabs
tab: Overview
```dataviewjs
let startDate = dv.current().file.frontmatter["journal-start-date"];
let endDate = dv.current().file.frontmatter["journal-end-date"];

let tasks = dv.pages().file.tasks
    .where(t => !t.completed && t.due && t.due >= dv.date(startDate) && t.due <= dv.date(endDate))
    .sort(t => t.priority);

let completedTasks = dv.pages().file.tasks
    .where(t => t.completed && t.completion && t.completion >= dv.date(startDate) && t.completion <= dv.date(endDate));

function cleanTaskText(text) {
    return text
        .replace(/#task\s+/, '')
        .replace(/📅\s*\d{4}-\d{2}-\d{2}/, '')
        .replace(/✅\s*\d{4}-\d{2}-\d{2}/, '')
        .replace(/#[\w\/]+\s*/g, '')
        .trim();
}

function createLink(path) {
    if (!path) return "-";
    const fileName = path.split('/').pop();
    return `[[${fileName}]]`;
}

dv.table(
    ["Source", "Date Due", "Task Description"],
    tasks.map(t => [
        createLink(t.path),
        t.due ? dv.date(t.due).toFormat("MM-dd") : "-",
        cleanTaskText(t.text)
    ])
);

dv.paragraph('<br><strong>Completed Tasks</strong><br>');

dv.table(
    ["Source", "Date Done", "Task Description"],
    completedTasks.map(t => [
        createLink(t.path),
        t.completion ? dv.date(t.completion).toFormat("MM-dd") : "-",
        cleanTaskText(t.text)
    ])
);
```
tab: Meetings
```dataviewjs
let startDate = dv.current().file.frontmatter["journal-start-date"];
let endDate = dv.current().file.frontmatter["journal-end-date"];

let meetings = dv.pages('"30-工作/会议记录"')
    .where(m => m.meeting_status === false
        && (m.type === "meeting" || m.type === "会议" || m.template_type === "meeting")
        && m.scheduled_date >= dv.date(startDate)
        && m.scheduled_date <= dv.date(endDate));

let withDates = meetings.where(m => m.scheduled_date);
let withoutDates = meetings.where(m => !m.scheduled_date);

withDates = withDates.sort(m => m.scheduled_date);

let allMeetings = withDates.concat(withoutDates);

dv.table(
    ["Days", "Meeting", "Scheduled Date", "Start Time", "End Time"],
    allMeetings.map(m => [
        m.scheduled_date ? Math.floor(dv.date(m.scheduled_date).diff(dv.date("today"), 'days').days) : "-",
        m.file.link,
        m.scheduled_date ? dv.date(m.scheduled_date).toFormat("MM-dd") : "-",
        m.start_time || "-",
        m.end_time || "-"
    ])
);
```
tab: Projects
```dataviewjs
let startDate = dv.current().file.frontmatter["journal-start-date"];
let endDate = dv.current().file.frontmatter["journal-end-date"];

const isProject = p => p.type == "project_note" || p.type == "project_family" || p.type == "项目" || p.template_type == "project_note" || p.template_type == "project_family";
const isCompleted = p => p.Status == "4 Completed" || p.status == "已完成";

let pages = dv.pages('"30-工作/项目"')
    .where(p => isProject(p)
            && !isCompleted(p)
            && (p.Due_Date >= dv.date(startDate) || p.Due_Date == null)
            && (p.Due_Date <= dv.date(endDate) || p.Due_Date == null));

let withDueDates = pages.where(p => p.Due_Date != null);
let withoutDueDates = pages.where(p => p.Due_Date == null);

withDueDates = withDueDates.sort(p => p.Due_Date)
    .sort(p => p.Priority_Level)
    .sort(p => p.Status, 'desc');

withoutDueDates = withoutDueDates.sort(p => p.Priority_Level)
    .sort(p => p.Status, 'desc');

let allPages = withDueDates.concat(withoutDueDates);

dv.table(
    ["Days", "Project", "Priority Level", "Status", "Due Date"],
    allPages.map(p => [
        p.Due_Date ? Math.floor(dv.date(p.Due_Date).diff(dv.date("today"), 'days').days) : "-",
        p.file.link,
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
# Monthly Goals
<%tp.file.cursor()%>

- 本月最重要的主题：
- 本月必须交付或完成：
- 本月要减少投入的方向：

# Summary of the Month

- 主要成果：
- 关键失误：
- 系统性变化：


# Reflections & Learnings

- 可复用经验：
- 需要写入主题地图或 Permanent Note：
- 下个月应停止的做法：


# Plan for Next Month

- 下月第一优先级：
- 需要拆成项目：
- 需要维护的领域：
