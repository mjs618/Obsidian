---
type: 项目
template_type: project_note
domain: 工作
status: 进行中
Priority_Level:
Status:
Date_Created:
Due_Date:
connections: []
tags:
  - 领域/工作
  - 类型/项目
  - 状态/进行中
  - project
cssclasses:
  - hide-properties_editing
  - hide-properties_reading
---
# <% tp.file.title %>

## 项目控制

**Select Connection:** `INPUT[inlineListSuggester(optionQuery(#area)):connections]`
**Date Created:** `INPUT[dateTime(defaultValue(null)):Date_Created]`
**Due Date:** `INPUT[dateTime(defaultValue(null)):Due_Date]`
**Priority Level:** `INPUT[inlineSelect(option(1 Critical), option(2 High), option(3 Medium), option(4 Low)):Priority_Level]`
**Status:** `INPUT[inlineSelect(option(1 To Do), option(2 In Progress), option(3 Testing), option(4 Completed), option(5 Blocked)):Status]`

## 所属上下文

- 所属项目：
- 关联领域：
- 本记录要回答的问题：

## 记录目标

- 本次记录要推动什么：
- 预计输出：

## 决策与阻塞

- 已确认决策：
- 当前阻塞：
- 需要谁提供信息：

## 过程记录

-

## 结论或交付物

-

## 下一步

- [ ]

## 回流

- [ ] 已链接到项目页
- [ ] 已提炼到主题或 Permanent Note
- [ ] 已清理不再需要的临时内容

<%* tp.hooks.on_all_templates_executed(async () => {
    const file = tp.file.find_tfile(tp.file.path(true));
    const folder = tp.file.folder().split("/").pop();
    const base = folder === "项目" ? tp.file.title : folder;
    const project_key = base.toLowerCase().replace(/\s+/g, "_");
    await app.fileManager.processFrontMatter(file, (frontmatter) => {
        const current = frontmatter["tags"];
        const tags = Array.isArray(current) ? current : current ? [current] : [];
        frontmatter["tags"] = Array.from(new Set([...tags, "project", `project/${project_key}`]));
    });
}); -%>
