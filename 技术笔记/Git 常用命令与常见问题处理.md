
# 🌟 Git 常用命令与常见问题处理

> 🚀 一份全面的 Git 使用指南，助你成为 Git 高手！

## 📚 目录
- [📦 基础操作](#📦-基础操作)
- [🌿 分支管理](#🌿-分支管理)
- [🌐 远程仓库](#🌐-远程仓库)
- [↩️ 撤销与回滚](#↩️-撤销与回滚)
- [🏷️ 标签管理](#🏷️-标签管理)
- [⚔️ 冲突解决](#⚔️-冲突解决)
- [🎒 Stash 临时保存](#🎒-stash-临时保存)
- [🚀 高级 Git 命令](#🚀-高级-git-命令)
- [⚙️ 配置最佳实践](#⚙️-配置最佳实践)
- [🔧 常见问题处理](#🔧-常见问题处理)

---

> 💡 **小贴士**：点击目录中的链接可以直接跳转到相应章节！

---

## 📦 基础操作

|操作|命令|
|---|---|
|初始化仓库|`git init`|
|克隆仓库|`git clone <地址>`|
|查看状态|`git status`|
|添加到暂存区|`git add <文件>` / `git add .`|
|提交到本地|`git commit -m "说明"`|
|查看日志|`git log` / `git log --oneline`|

> 🎯 **新手必会**：这些是最常用的 Git 命令，掌握它们就能开始使用 Git 了！

### 🔧 高级基础操作

|操作|命令|
|---|---|
|查看详细状态|`git status -s`|
|添加并提交|`git commit -am "说明"`|
|修改最后一次提交|`git commit --amend`|
|查看提交差异|`git diff` / `git diff HEAD`|
|查看暂存区差异|`git diff --cached`|
|查看文件修改历史|`git blame <文件>`|
|查看引用日志|`git reflog`|

> 💡 **专业技巧**：`git reflog` 是你的后悔药，可以找回误删的提交！

---

## 🌿 分支管理

|操作|命令|
|---|---|
|查看分支|`git branch`|
|新建分支|`git branch <分支名>`|
|切换分支|`git checkout <分支>` / `git switch <分支>`|
|新建并切换分支|`git checkout -b <分支>` / `git switch -c <分支>`|
|合并分支|`git merge <分支>`|
|删除分支|`git branch -d <分支>` / `git branch -D <分支>`|

> 🌳 **分支策略**：合理的分支管理是团队协作的关键！

### 🔧 高级分支操作

|操作|命令|
|---|---|
|查看远程分支|`git branch -r`|
|查看所有分支|`git branch -a`|
|重命名分支|`git branch -m <旧名> <新名>`|
|推送并设置上游|`git push -u origin <分支>`|
|删除远程分支|`git push origin --delete <分支>`|
|跟踪远程分支|`git branch --track <分支> origin/<分支>`|
|查看分支图|`git log --graph --oneline`|

> 🔄 **最佳实践**：使用 `git switch` 替代 `git checkout` 来切换分支，语义更清晰！

---

## 🌐 远程仓库

|操作|命令|
|---|---|
|查看远程仓库|`git remote -v`|
|添加远程仓库|`git remote add origin <地址>`|
|修改远程地址|`git remote set-url origin <新地址>`|
|推送分支|`git push` / `git push -u origin <分支>`|
|拉取远程代码|`git pull`|

> ☁️ **云端协作**：远程仓库让团队协作变得简单高效！

### 🔧 高级远程操作

|操作|命令|
|---|---|
|获取远程更新|`git fetch`|
|获取所有远程|`git fetch --all`|
|推送到多个远程|`git push --all origin`|
|查看远程分支|`git branch -r`|
|查看远程信息|`git remote show origin`|
|重命名远程|`git remote rename <旧名> <新名>`|
|删除远程|`git remote remove <远程名>`|

> ⚡ **效率提示**：`git fetch` 比 `git pull` 更安全，它只下载不合并！

---

## ↩️ 撤销与回滚

|操作|命令|
|---|---|
|撤销工作区修改|`git checkout -- <文件>`|
|撤销暂存区修改|`git reset HEAD <文件>`|
|回滚到某个提交|`git reset --hard <commit-id>`|
|回退最近一次提交|`git reset --soft HEAD~1`|
|清理未跟踪文件|`git clean -fd`|

> 🛑 **救命稻草**：写代码时犯错？别担心，Git 有很多撤销方法！

### 🔧 高级撤销操作

|操作|命令|
|---|---|
|软回滚（保留工作区）|`git reset --soft <commit-id>`|
|混合回滚（保留工作区，清空暂存区）|`git reset --mixed <commit-id>`|
|硬回滚（清空所有）|`git reset --hard <commit-id>`|
|撤销某次提交|`git revert <commit-id>`|
|查看引用日志|`git reflog`|
|从引用日志恢复|`git reset --hard HEAD@{n}`|

> 🔁 **区别说明**：`reset` 改写历史，`revert` 创建新提交来撤销更改，更安全！

---

## 🏷️ 标签管理

|操作|命令|
|---|---|
|创建标签|`git tag <标签>`|
|创建带说明标签|`git tag -a <标签> -m "说明"`|
|推送单个标签|`git push origin <标签>`|
|推送所有标签|`git push origin --tags`|

> 🎯 **版本标记**：用标签标记重要的发布版本！

### 🔧 高级标签操作

|操作|命令|
|---|---|
|查看标签|`git tag`|
|查看标签详情|`git show <标签>`|
|删除标签|`git tag -d <标签>`|
|删除远程标签|`git push origin --delete <标签>`|
|检出标签|`git checkout <标签>`|
|从标签创建分支|`git checkout -b <分支> <标签>`|

> 📦 **最佳实践**：使用带注释的标签（annotated tags）而不是轻量级标签！

---

## ⚔️ 冲突解决

|场景|命令|
|---|---|
|出现冲突，手动修改后标记解决|`git add <文件>`|
|完成合并提交|`git commit`|
|放弃合并|`git merge --abort`|

> 💥 **团队协作**：多人修改同一文件时可能会产生冲突，学会解决冲突很重要！

### 🔧 高级冲突解决

|场景|命令|
|---|---|
|使用工具解决冲突|`git mergetool`|
|查看冲突文件|`git diff --check`|
|取消冲突标记|`git checkout --ours <文件>`|
|使用对方版本|`git checkout --theirs <文件>`|
|查看冲突详情|`git log --merge`|

> 🛠️ **神器推荐**：配置好用的合并工具（如 VS Code、Beyond Compare）能让解决冲突更轻松！

---

## 🎒 Stash 临时保存

|操作|命令|
|---|---|
|保存当前修改|`git stash`|
|查看 stash 列表|`git stash list`|
|应用最新 stash|`git stash apply`|
|删除最新 stash|`git stash drop`|

> 🚀 **临时切换**：当你需要临时切换分支但不想提交未完成的工作时，Stash 是你的救星！

### 🔧 高级 Stash 操作

|操作|命令|
|---|---|
|保存并命名|`git stash save "说明"`|
|应用指定 stash|`git stash apply stash@{n}`|
|删除指定 stash|`git stash drop stash@{n}`|
|创建分支应用 stash|`git stash branch <分支名>`|
|查看 stash 内容|`git stash show stash@{n}`|
|查看 stash 差异|`git stash show -p stash@{n}`|
|清除所有 stash|`git stash clear`|

> 📝 **贴心提醒**：给 stash 命名会让你更容易找到需要的内容！

---

## 🚀 高级 Git 命令

> 🧠 **高手进阶**：掌握这些高级命令，让你在 Git 世界里游刃有余！

### 🔧 变基操作

|操作|命令|
|---|---|
|交互式变基|`git rebase -i HEAD~n`|
|变基到主分支|`git rebase main`|
|继续变基|`git rebase --continue`|
|中止变基|`git rebase --abort`|
|自动储藏变基|`git rebase --autostash`|

> 🔄 **黄金法则**：只对自己本地的提交进行变基，永远不要对已经推送到远程的提交进行变基！

### 🔧 樱桃挑选

|操作|命令|
|---|---|
|挑选提交|`git cherry-pick <commit-id>`|
|挑选多个提交|`git cherry-pick <commit1>..<commit2>`|
|继续挑选|`git cherry-pick --continue`|
|中止挑选|`git cherry-pick --abort`|

> 🍒 **精准选择**：cherry-pick 让你可以精确选择需要的提交，而不需要合并整个分支！

### 🔧 二分查找

|操作|命令|
|---|---|
|开始二分查找|`git bisect start`|
|标记坏提交|`git bisect bad`|
|标记好提交|`git bisect good <commit-id>`|
|结束二分查找|`git bisect reset`|

> 🔍 **侦探工具**：当你要找出是哪个提交引入了 bug 时，bisect 就像一个二分查找的侦探！

---

## ⚙️ 配置最佳实践

> ⚡ **个性化定制**：合适的配置能让你的 Git 使用体验更顺畅！

### 🔧 用户配置

|操作|命令|
|---|---|
|设置用户名|`git config --global user.name "姓名"`|
|设置邮箱|`git config --global user.email "邮箱"`|
|查看配置|`git config --list`|
|查看全局配置|`git config --global --list`|
|设置默认编辑器|`git config --global core.editor "vim"`|

### 🔧 别名配置

|别名|命令|
|---|---|
|`git st`|`git config --global alias.st status`|
|`git co`|`git config --global alias.co checkout`|
|`git br`|`git config --global alias.br branch`|
|`git cm`|`git config --global alias.cm "commit -m"`|
|`git lg`|`git config --global alias.lg "log --oneline --graph"`|

> 🚀 **效率提升**：设置别名能大幅提升你的工作效率！

### 🔧 实用配置

|配置|说明|
|---|---|
|`git config --global color.ui auto`|启用颜色输出|
|`git config --global push.default simple`|简化推送行为|
|`git config --global pull.rebase true`|默认使用 rebase 拉取|
|`git config --global core.autocrlf true`|Windows 换行符处理|
|`git config --global core.autocrlf input`|Linux/Mac 换行符处理|

> 🎯 **跨平台协作**：正确的换行符配置能避免团队成员间的兼容性问题！

---

## 🔧 常见问题处理

> ❓ **疑难解答**：遇到问题不要慌，这里有一份常见问题的解决方案！

|问题|解决命令|
|---|---|
|配置用户名和邮箱|`git config --global user.name "名"` `git config --global user.email "邮箱"`|
|push 提示非快进 (non-fast-forward)|`git pull --rebase` → `git push`|
|误删分支恢复|`git reflog` → `git checkout -b <分支> <commit-id>`|
|忽略文件|`.gitignore` 文件中添加规则|

### 🔧 其他常见问题

| 问题         | 解决命令                          |     |
| ---------- | ----------------------------- | --- |
| 修改最后一次提交信息 | `git commit --amend -m "新信息"` |     |
| 撤销已推送提交    | `git revert <commit-id>`      |     |
| 合并多个提交     | `git rebase -i HEAD~n`        |     |
| 查看谁修改了文件   | `git blame <文件>`              |     |
| 清理工作区      | `git clean -fd`               |     |
| 恢复删除的文件    | `git checkout HEAD -- <文件>`   |     |

> 🆘 **紧急救援**：遇到严重问题时，记得 `git reflog` 是你的救命稻草！

---

## 🎉 结语

> 🌈 **掌握 Git，畅游代码世界**：Git 是现代开发者的必备技能，希望这份指南能帮助你在 Git 的世界里游刃有余！
>
> 📚 **持续学习**：技术在不断进步，保持学习的心态才能跟上时代的步伐！
>
> 💪 **实践出真知**：多动手练习，熟能生巧！