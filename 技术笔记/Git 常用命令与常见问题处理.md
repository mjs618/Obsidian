
## 目录
- [基础操作](#📦基础操作)
- [分支管理](#🌿分支操作)
- [远程仓库](#🌍远程仓库)
- [撤销与回滚](#⏪撤销与回滚)
- [标签管理](#🏷标签管理)
- [ 冲突解决](#⚔️冲突解决)
- [Stash 临时保存](🎒Stash临时保存)
- [常见问题处理](#🔧常见问题处理)

---

## 📦基础操作

|操作|命令|
|---|---|
|初始化仓库|`git init`|
|克隆仓库|`git clone <地址>`|
|查看状态|`git status`|
|添加到暂存区|`git add <文件>` / `git add .`|
|提交到本地|`git commit -m "说明"`|
|查看日志|`git log` / `git log --oneline`|

## 🌿分支操作

|操作|命令|
|---|---|
|查看分支|`git branch`|
|新建分支|`git branch <分支名>`|
|切换分支|`git checkout <分支>` / `git switch <分支>`|
|新建并切换分支|`git checkout -b <分支>` / `git switch -c <分支>`|
|合并分支|`git merge <分支>`|
|删除分支|`git branch -d <分支>` / `git branch -D <分支>`|

## 🌍远程仓库
|操作|命令|
|---|---|
|查看远程仓库|`git remote -v`|
|添加远程仓库|`git remote add origin <地址>`|
|修改远程地址|`git remote set-url origin <新地址>`|
|推送分支|`git push` / `git push -u origin <分支>`|
|拉取远程代码|`git pull`|

## ⏪ 撤销与回滚
|操作|命令|
|---|---|
|撤销工作区修改|`git checkout -- <文件>`|
|撤销暂存区修改|`git reset HEAD <文件>`|
|回滚到某个提交|`git reset --hard <commit-id>`|
|回退最近一次提交|`git reset --soft HEAD~1`|
|清理未跟踪文件|`git clean -fd`|

## 🏷 标签管理

|操作|命令|
|---|---|
|创建标签|`git tag <标签>`|
|创建带说明标签|`git tag -a <标签> -m "说明"`|
|推送单个标签|`git push origin <标签>`|
|推送所有标签|`git push origin --tags`|

## ⚔️ 冲突解决

|场景|命令|
|---|---|
|出现冲突，手动修改后标记解决|`git add <文件>`|
|完成合并提交|`git commit`|
|放弃合并|`git merge --abort`|

## 🎒 Stash 临时保存

|操作|命令|
|---|---|
|保存当前修改|`git stash`|
|查看 stash 列表|`git stash list`|
|应用最新 stash|`git stash apply`|
|删除最新 stash|`git stash drop`|



## 🔧 常见问题处理

|问题|解决命令|
|---|---|
|配置用户名和邮箱|`git config --global user.name "名"``git config --global user.email "邮箱"`|
|push 提示非快进 (non-fast-forward)|`git pull --rebase` → `git push`|
|误删分支恢复|`git reflog` → `git checkout -b <分支> <commit-id>`|
|忽略文件|`.gitignore` 文件中添加规则|