
---
type: 笔记
domain: 技术
status: 进行中
tags:
  - 领域/技术
  - 类型/笔记
  - pip
  - 命令速查
---

## 📦 基础操作

|操作|命令|
|---|---|
|查看 pip 版本|`pip --version`|
|查看帮助|`pip --help`|
|查看命令帮助|`pip <command> --help`|


## 🔍 查找与安装包

|操作|命令|
|---|---|
|搜索包|`pip search <包名>` (注意：已弃用)|
|安装包|`pip install <包名>`|
|指定版本安装|`pip install <包名>==1.2.3`|
|安装大于某版本|`pip install <包名>>=1.2.3`|
|从文件安装|`pip install -r requirements.txt`|
|从本地文件安装|`pip install ./some_package.whl`|
|升级包|`pip install --upgrade <包名>`|

## 📋 查看与管理包

|操作|命令|
|---|---|
|查看已安装包|`pip list`|
|查看指定包信息|`pip show <包名>`|
|查看可升级的包|`pip list --outdated`|
|卸载包|`pip uninstall <包名>`|

## 💾 导出与环境同步

|操作|命令|
|---|---|
|导出当前环境包清单|`pip freeze > requirements.txt`|
|从 requirements.txt 安装|`pip install -r requirements.txt`|

## 🛡 常见问题解决

|问题|解决方式|
|---|---|
|安装过慢或超时|使用国内源 (清华、阿里、豆瓣等)|
|权限不足 (Permission denied)|用 `--user` 安装 或 使用 `sudo` (Linux/macOS)|
|升级 pip|`python -m pip install --upgrade pip`|
|pip 与 python 不对应|明确用 `python3 -m pip` 或 `python -m pip`|
