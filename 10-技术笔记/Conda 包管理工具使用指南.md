---
tags:
  - 技术文档
  - Conda
---

## 1. 简介

Conda 是一个开源的包管理和环境管理系统，用于安装多个版本的软件包及其依赖关系，并在它们之间轻松切换。

主要功能包括：
- ✅ 跨平台支持（Windows/macOS/Linux）
- ✅ 管理 Python 环境与包依赖
- ✅ 支持非 Python 包的安装
- ✅ 便捷的环境隔离功能

## 2. 安装与配置

### 2.1 基础安装

推荐通过 Miniconda 安装精简版本：

```bash
# Linux/macOS
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Windows
# 下载 Miniconda3-latest-Windows-x86_64.exe 并运行
```

### 2.2 配置镜像源（国内用户）

修改 `~/.condarc` 文件提高下载速度：

```yaml
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

## 3. 常用命令速查

### 环境管理

| 命令 | 描述 | 示例 |
|------|------|------|
| `conda create` | 创建新环境 | `conda create -n py39 python=3.9` |
| `conda activate` | 激活环境 | `conda activate py39` |
| `conda deactivate` | 退出环境 | `conda deactivate` |
| `conda env list` | 列出所有环境 | `conda env list` |

### 包管理

```bash
# 安装包
conda install numpy pandas

# 指定版本安装
conda install tensorflow=2.6.0

# 更新包
conda update --all

# 搜索包
conda search "scikit-*"
```

## 4. 高级用法

### 4.1 环境导出与恢复

导出当前环境配置：

```bash
conda env export > environment.yml
```

从 YAML 文件恢复环境：

```bash
conda env create -f environment.yml
```

### 4.2 多平台兼容配置

使用 `no-builds` 参数生成跨平台环境文件：

```bash
conda env export --no-builds > environment-no-builds.yml
```

## 5. 常见问题解答

### ❓ Conda 和 Pip 有什么区别？

| 特性        | Conda           | Pip            |
|------------|----------------|----------------|
| 管理范围    | 跨语言          | 仅 Python      |
| 依赖解析    | 更严格          | 相对宽松       |
| 环境隔离    | 内置支持        | 需借助 virtualenv |

### ❓ 如何清理 Conda 缓存？

```bash
conda clean --all
```

## 6. 延伸阅读

- [官方文档](https://docs.conda.io/en/latest/)
- [Conda Cheat Sheet](https://docs.conda.io/projects/conda/en/latest/user-guide/cheatsheet.html)
- [Miniconda vs Anaconda](https://conda.io/projects/conda/en/latest/user-guide/install/download.html)