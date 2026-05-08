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

## 项目一句话

- 为了：
- 交付：
- 截止或节奏：

## 目标与范围

- 目标：
- 不做：
- 成功标准：

## 背景

- 为什么现在做：
- 已知约束：
- 相关领域或资源：

## 关键里程碑

- [ ]

## 当前状态

- 本周下一步：
- 当前阻塞：
- 需要决策：

## 项目笔记

-

## 完成定义

-

## 复盘出口

- 经验进入：
- 可复用资料进入：
- 归档位置：

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
