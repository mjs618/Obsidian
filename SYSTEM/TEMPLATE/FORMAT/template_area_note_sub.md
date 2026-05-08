---
area: <% tp.file.folder() %>
tags:
  - 领域/工作
  - 类型/领域
  - 状态/进行中
  - area
type: 领域
template_type: area_note_sub
domain: 工作
status: 进行中
created: <% tp.file.creation_date() %>
---
# <% tp.file.title %>

## 概览

<%tp.file.cursor()%>

## 关联

- 上级领域：[[<% tp.file.folder().split("/").pop() %>]]
- 相关项目：

<%* tp.hooks.on_all_templates_executed(async () => {
    const file = tp.file.find_tfile(tp.file.path(true));
    const area_key = tp.file.folder().split("/").pop().toLowerCase().replace(/\s+/g, "_");
    const note_key = tp.file.title.toLowerCase().replace(/\s+/g, "_");
    await app.fileManager.processFrontMatter(file, (frontmatter) => {
        const current = frontmatter["tags"];
        const tags = Array.isArray(current) ? current : current ? [current] : [];
        frontmatter["tags"] = Array.from(new Set([...tags, "area", `area/${area_key}`, `area/${area_key}/${note_key}`]));
    });
}); -%>
