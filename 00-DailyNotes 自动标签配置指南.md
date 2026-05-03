# 📅 Daily Notes 自动标签配置指南

> 让每日笔记、周记、月记自动添加智能标签

---

## 🎯 配置目标

通过 Templater 插件，实现：
- ✅ 每日笔记自动添加日期、星期标签
- ✅ 周记自动添加周数标签
- ✅ 月记自动添加月份、季度标签
- ✅ 特殊日期自动标记（月初、月末、周一等）

---

## 📦 前置要求

### 必装插件
1. **Templater** - 模板引擎
2. **Daily Notes** - 核心插件（已启用）
3. **Calendar** - 日历视图（可选，已安装）

### 模板文件
已创建以下模板：
- `Templates/Templater/DailyNotes 自动标签.md` - 每日笔记
- `Templates/Templater/周记自动标签.md` - 每周总结
- `Templates/Templater/月记自动标签.md` - 每月总结

---

## ⚙️ 配置步骤

### 第一步：配置 Templater

1. 打开 Obsidian 设置
2. 找到 **Templater** 插件设置
3. 配置以下选项：

```
Template folder location（模板文件夹）:
  Templates/Templater/

Trigger Templater on new file creation（新建文件时触发）:
  ✅ 开启

Template to trigger on new file creation（新建文件时触发的模板）:
  DailyNotes 自动标签

Auto-parse templates（自动解析模板）:
  ✅ 开启
```

---

### 第二步：配置 Daily Notes 插件

1. 打开设置 → **Daily Notes** 插件
2. 配置以下选项：

```
文件夹位置:
  生活/日记/  或  Daily Notes/

文件格式:
  YYYY-MM-DD

模板文件位置:
  Templates/Templater/DailyNotes 自动标签

周记开始日期:
  周一

月记开始日期:
  1 日
```

---

### 第三步：配置周期性笔记（周记/月记）

1. 打开设置 → **周期性笔记** 插件
2. 配置 **周记**：

```
文件夹位置:
  生活/周记/

文件格式:
  YYYY-ww-周总结

模板文件位置:
  Templates/Templater/周记自动标签
```

3. 配置 **月记**：

```
文件夹位置:
  生活/月记/

文件格式:
  YYYY-MM-月度总结

模板文件位置:
  Templates/Templater/月记自动标签
```

---

## 🏷️ 自动标签说明

### 每日笔记标签

```yaml
基础标签:
  - 领域/生活
  - 类型/汇总

时间标签:
  - 时间/2026          # 年份
  - 时间/2026-03       # 月份
  - 时间/工作日        # 工作日/休息日
  - 时间/月初          # 月初/月中/月末
  - 时间/Q1            # 季度

特殊标签（自动添加）:
  - 特殊/月初          # 每月 1 号
  - 特殊/月末          # 每月最后一天
  - 特殊/周一          # 每周一
  - 特殊/周五          # 每周五
```

### 周记标签

```yaml
基础标签:
  - 领域/生活
  - 类型/汇总

时间标签:
  - 时间/2026
  - 时间/2026-03
  - 时间/周记
  - 时间/W13           # 第几周
```

### 月记标签

```yaml
基础标签:
  - 领域/生活
  - 类型/汇总

时间标签:
  - 时间/2026
  - 时间/2026-03
  - 时间/月记
  - 时间/Q1            # 季度
```

---

## 🚀 使用方法

### 创建每日笔记

**方法 1：使用 Calendar 插件**
1. 在右侧边栏打开 Calendar 视图
2. 点击任意日期
3. 自动创建笔记并应用模板

**方法 2：使用命令面板**
1. `Ctrl/Cmd + P`
2. 输入 "Daily Notes"
3. 选择 "Open today's daily note"

**方法 3：快捷键**
- 设置快捷键后，一键创建

### 创建周记/月记

**方法 1：使用命令面板**
1. `Ctrl/Cmd + P`
2. 输入 "Weekly/Monthly"
3. 选择对应的笔记

**方法 2：周期性笔记插件**
- 在命令面板中搜索 "Periodic notes"

---

## 📊 标签效果展示

### 每日笔记示例

```markdown
---
created: 2026-03-29 10:30
tags:
  - 领域/生活
  - 类型/汇总
  - 时间/2026
  - 时间/2026-03
  - 时间/工作日
  - 时间/月初
  - 时间/Q1
  - 特殊/周一
aliases: ["2026 年 03 月 29 日"]
date: 2026-03-29
weekday: 星期一
---
```

### 查询示例

在 [[标签仪表盘]] 或其他笔记中查询：

```dataview
TABLE file.name, file.weekday
FROM #时间/工作日
WHERE file.day = date("today")
```

```dataview
LIST FROM #特殊/周一
SORT file.name DESC
```

```dataview
TABLE WITHOUT ID
    file.link AS "周记",
    file.week AS "周数"
FROM #时间/周记
SORT file.week DESC
LIMIT 5
```

---

## 🎨 自定义配置

### 修改标签体系

编辑 `Templates/Templater/DailyNotes 自动标签.md`：

```javascript
// 添加新的标签
tags.push("你的标签");

// 修改标签命名
const tags = [
    "领域/生活",      // 改为你喜欢的
    "类型/日记",      // 改为 "类型/汇总" 或其他
];
```

### 添加特殊日期

```javascript
// 添加节假日标签
const holidays = {
    "01-01": "元旦",
    "10-01": "国庆",
    // ...
};

const monthDay = now.format("MM-DD");
if (holidays[monthDay]) {
    tags.push(`特殊/节假日/${holidays[monthDay]}`);
}
```

### 添加个人习惯追踪

```javascript
// 在模板中添加
## 📊 习惯追踪
- [ ] 早起
- [ ] 运动
- [ ] 阅读
- [ ] 写作
```

---

## 💡 高级用法

### 1. 自动关联昨日和明日

模板中已包含：
```markdown
### 昨日笔记
[[<日期>]]

### 明日计划
[[<日期>]]
```

### 2. 自动汇总本周日记

周记模板中的查询：
```dataview
LIST FROM #类型/汇总
WHERE file.week = this.week
```

### 3. 月度数据自动统计

月记模板中的查询：
```dataview
TASK FROM #状态/已完成
WHERE completed >= this.month
```

---

## ⚠️ 常见问题

### Q1: 模板不生效怎么办？

**A**: 检查以下几点：
1. Templater 是否启用
2. 模板文件夹路径是否正确
3. "Trigger on new file creation" 是否开启
4. 选择的模板文件是否正确

### Q2: 标签没有自动添加？

**A**: 
1. 检查模板中的 JavaScript 代码是否完整
2. 确保使用了 `.md` 扩展名
3. 重启 Obsidian 后重试

### Q3: 如何修改已有笔记的标签？

**A**: 
1. 手动编辑 frontmatter
2. 使用 Tag Wrangler 批量修改
3. 运行批量处理脚本

### Q4: 可以禁用某些自动标签吗？

**A**: 可以，编辑模板文件：
```javascript
// 注释掉不需要的标签
// tags.push(`时间/${quarter}`);
```

---

## 🔗 相关文档

- [[00-标签体系使用指南]] - 标签体系说明
- [[00-标签增强插件配置指南]] - 插件配置
- [[标签仪表盘]] - 查看标签统计
- [[Templates/标签体系审查清单]] - 定期审查

---

## 📚 模板文件清单

```
Templates/Templater/
├── DailyNotes 自动标签.md      # 每日笔记
├── 周记自动标签.md             # 每周总结
├── 月记自动标签.md             # 每月总结
├── 自动标签模板.md             # 通用自动标签
└── 快速添加标签.md             # 快速插入标签
```

---

## 🎯 最佳实践

### 每日使用流程

```
早晨:
1. 打开今日笔记
2. 填写"今日意图"
3. 查看待办事项

白天:
1. 随时记录完成的任务
2. 记录遇到的问题和解决方案
3. 添加灵感和想法

晚上:
1. 填写数据统计
2. 完成晚间总结
3. 规划明日计划
```

### 每周回顾流程

```
周末:
1. 打开周记模板
2. 查看本周完成的日记
3. 填写周总结
4. 规划下周计划
```

### 每月回顾流程

```
月末:
1. 打开月记模板
2. 回顾本月所有笔记
3. 填写月总结
4. 规划下月目标
```

---

## 📈 效果追踪

使用 [[标签仪表盘]] 查看：
- 每日笔记创建情况
- 周记/月记完成情况
- 标签分布统计
- 习惯追踪数据

---

**配置完成后，立即创建一篇日记试试吧！** 🎉
