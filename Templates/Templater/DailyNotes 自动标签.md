<%*
// ========================================
// Daily Notes 自动标签模板
// 根据日期自动添加合适的标签
// ========================================

const moment = require('moment');
const now = moment();
const dateStr = tp.date.now("YYYY-MM-DD");
const weekday = tp.date.now("dddd", 0, dateStr, "YYYY-MM-DD");

// 判断是工作日还是周末
const dayOfWeek = now.day(); // 0 = Sunday, 6 = Saturday
const isWeekend = (dayOfWeek === 0 || dayOfWeek === 6);
const dayType = isWeekend ? "休息日" : "工作日";

// 判断月初、月中、月末
const date = now.date();
let monthPhase = "";
if (date <= 5) {
    monthPhase = "月初";
} else if (date <= 15) {
    monthPhase = "月中";
} else if (date <= 25) {
    monthPhase = "月中后";
} else {
    monthPhase = "月末";
}

// 判断季度
const month = now.month() + 1;
let quarter = "";
if (month <= 3) {
    quarter = "Q1";
} else if (month <= 6) {
    quarter = "Q2";
} else if (month <= 9) {
    quarter = "Q3";
} else {
    quarter = "Q4";
}

// 定义标签
const tags = [
    "领域/生活",
    "类型/汇总",
    `时间/${now.format("YYYY")}`,
    `时间/${now.format("YYYY-MM")}`,
    `时间/${dayType}`,
    `时间/${monthPhase}`,
    `时间/${quarter}`
];

// 特殊日期标签
if (date === 1) {
    tags.push("特殊/月初");
}
if (date === now.daysInMonth()) {
    tags.push("特殊/月末");
}
if (weekday.includes("星期一") || weekday.includes("周一")) {
    tags.push("特殊/周一");
}
if (weekday.includes("星期五") || weekday.includes("周五")) {
    tags.push("特殊/周五");
}

// 生成 frontmatter
tR += `---
created: ${tp.date.now("YYYY-MM-DD HH:mm")}
tags:
`;

tags.forEach(tag => {
    tR += `  - ${tag}\n`;
});

tR += `aliases: ["${tp.date.now("YYYY 年 MM 月 DD 日")}"]
date: ${tp.date.now("YYYY-MM-DD")}
weekday: ${weekday}
---

`;
%>

# 📔 <%= tp.date.now("YYYY 年 MM 月 DD 日") %> · <%= weekday %>

> **今日意图**：今天最重要的三件事是什么？
> 1. 
> 2. 
> 3. 

---

## 🌅 晨间准备

### 今日焦点
```dataview
TASK FROM #状态/进行中 
WHERE !completed 
LIMIT 5
```

### 日历视图
- **日期**: <%= tp.date.now("YYYY-MM-DD") %>
- **星期**: <%= weekday %>
- **阶段**: <%= monthPhase %> / <%= quarter %>

---

## 📝 今日待办

### 🔴 重要且紧急
- [ ] 

### 🟡 重要不紧急
- [ ] 
- [ ] 

### 🟢 日常事务
- [ ] 
- [ ] 

---

## 📚 学习与输入

### 阅读/文章
- 

### 视频/课程
- 

### AI 学习摘要
```dataview
LIST FROM #领域/AI 
WHERE file.day = date("<%= tp.date.now("YYYY-MM-DD") %>")
```

---

## 💻 工作与产出

### 完成的任务
- [x] 

### 遇到的问题
> 

### 解决方案
> 

### 技术记录
```code
// 今天学到的技术点/代码片段

```

---

## 🤝 人际互动

### 会议/沟通
- 

### 感谢的人/事
- 

---

## 🎯 今日反思

### 做得好的地方 ✨


### 可以改进的地方 🔄


### 学到的教训 💡


### 新想法/灵感
> 

---

## 📊 数据统计

| 项目 | 目标 | 实际 | 完成度 |
|------|------|------|--------|
| 专注时长 | 4h | ___h | ⭐⭐⭐⭐⭐ |
| 运动 | 30min | ___min | ⭐⭐⭐⭐⭐ |
| 阅读 | 30min | ___min | ⭐⭐⭐⭐⭐ |
| 喝水 | 8 杯 | ___杯 | ⭐⭐⭐⭐⭐ |

---

## 🌙 晚间总结

### 今日高光时刻 🌟


### 感恩的三件事 🙏
1. 
2. 
3. 

### 明日计划 📅
1. 
2. 
3. 

---

## 🏷️ 快速标签

<%*
// 快速添加标签的快捷方式
const quickTags = [
    { label: " productive", value: "#状态/高效" },
    { label: " 创意", value: "#灵感" },
    { label: " 学习", value: "#待复习" },
    { label: " 问题", value: "#问题" },
];

const selectedTag = await tp.system.prompt("添加额外标签", quickTags.map(t => t.label), "", false);
if (selectedTag && selectedTag !== "") {
    const tag = quickTags.find(t => t.label === selectedTag);
    if (tag) {
        tR += `\n${tag.value}`;
    }
}
%>

---

**情绪状态**: 😊 😐 😔 (圈选)  
**能量水平**: ⚡⚡⚡⚡⚡ (1-5 级)

> "今日总结：_______"

---

## 🔗 相关链接

### 昨日笔记
[[<%= tp.date.now("YYYY-MM-DD", -1) %>]]

### 明日计划
[[<%= tp.date.now("YYYY-MM-DD", 1) %>]]

### 本周总结
[[<%= tp.date.weekday(0, "YYYY-MM-DD") %>|周一]] | [[<%= tp.date.weekday(6, "YYYY-MM-DD") %>|周日]]

### 本月总结
[[<%= tp.date.now("YYYY-MM", 0) %>-月度总结]]
