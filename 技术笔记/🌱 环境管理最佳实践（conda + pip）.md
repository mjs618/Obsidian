
### 📦 1️⃣ 使用虚拟环境隔离项目

✅ **永远不要在 base 环境直接开发！**
- 创建专门的环境：
```bash
conda create -n myenv python=3.x
conda activate myenv
```
✅ 一个项目 → 一个环境。  
这样可以避免不同项目之间依赖冲突。

### 🔍 2️⃣ 优先使用 conda 安装包

✅ **尽量用 conda 安装**，因为：

- conda 包管理器不仅管理 Python 包，还能管理 C 库、系统库（比如 `numpy`, `opencv` 等）。
    
- 对科学计算、机器学习项目，conda 更稳。
    

⚠️ **pip 和 conda 混用时要小心顺序：**

- 先用 conda 安装能找到的包；
    
- 再用 pip 安装 conda 找不到的包。
  
  ### 📜 3️⃣ 保存和分享环境

✅ **导出完整环境：**
```bash
	conda env export > environment.yml
```

✅ **重建环境：**
```bash
	conda env create -f environment.yml
```

✅ **用 freeze（仅 pip 包）：**
```bash
	pip freeze > requirements.txt
	pip install -r requirements.txt
```

⚠️ 注意：`environment.yml` 比 `requirements.txt` 更全面，包含 Python 版本、conda 包、pip 包。

### 🧹 4️⃣ 定期清理和更新

✅ 清理缓存减少磁盘占用：

```bash
	conda clean --all
```
✅ 更新 conda：

```bash
	conda update -n base -c defaults conda
```
✅ 更新环境内包（小心兼容性）：

```bash
	conda update --all
```

### 🚀 5️⃣ 配置国内源（加速下载）

✅ 临时使用国内源：

```bash
conda install -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free <包名>
```

✅ 永久配置：

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free conda config --set show_channel_urls yes
```

### 🛡 6️⃣ 防止环境污染

✅ 如果用 pip 安装包：

- 确认已激活正确的 conda 环境；
    
- 用 `which pip`（Linux/Mac）或 `where pip`（Windows）检查当前环境绑定的 pip。
    
⚠️ 避免使用 `sudo pip install`，它会影响全局。

### 🛠 7️⃣ 高级：用 mamba 加速

如果 conda 解决依赖太慢：

```bash
conda install mamba -n base -c 
conda-forge mamba install <包名>
```
> mamba 是 conda 的快速替代，兼容命令几乎一样，但速度极快。

### 🗂 推荐文件结构

在项目根目录下：
```bash
/my_project
├── environment.yml
├── requirements.txt (可选)
├── src/
├── data/
├── notebooks/
└── README.md
```

