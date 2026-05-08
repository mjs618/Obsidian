---
type: 项目
template_type: project_family
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

## 目标与范围


## 背景


## 关键里程碑

- [ ]

## 项目笔记

-

## 完成定义

-

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
