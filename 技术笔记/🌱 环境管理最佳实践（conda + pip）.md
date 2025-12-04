
### 📦 1️⃣ 使用虚拟环境隔离项目

✅ **永远不要在 base 环境直接开发！**
- 创建专门的环境：
```bash
conda create -n myenv python=3.x
conda activate myenv
```
✅ 一个项目 → 一个环境。  
这样可以避免不同项目之间依赖冲突。

✅ **环境命名最佳实践：**
- 使用描述性的名称，如 `data-analysis-project` 或 `web-api-dev`
- 避免使用特殊字符和空格
- 可以包含项目版本信息，如 `myproject-v1.2`

✅ **环境位置管理：**
- 默认情况下，conda 将环境存储在 anaconda3/envs/ 目录下
- 可以通过 `-p` 参数指定自定义路径：
```bash
conda create -p /path/to/my/project/env python=3.x
```

✅ **环境克隆：**
- 当需要创建相似环境时，可以克隆现有环境：
```bash
conda create -n new_env --clone existing_env
```

### 🔍 2️⃣ 优先使用 conda 安装包

✅ **尽量用 conda 安装**，因为：

- conda 包管理器不仅管理 Python 包，还能管理 C 库、系统库（比如 `numpy`, `opencv` 等）。
    
- 对科学计算、机器学习项目，conda 更稳。
    
- conda 能更好地处理复杂的依赖关系和版本冲突。

✅ **Channels（通道）管理：**

- conda channels 是包的来源仓库，默认使用 `defaults` 通道
- 推荐使用 `conda-forge` 通道，它有更多社区维护的包：
```bash
conda config --add channels conda-forge
```
- 可以指定特定通道安装包：
```bash
conda install -c conda-forge numpy
```
- 通道优先级很重要，上面的通道优先级更高

⚠️ **pip 和 conda 混用时要小心顺序：**

- 先用 conda 安装能找到的包；
    
- 再用 pip 安装 conda 找不到的包。

⚠️ **避免在 conda 环境外使用 pip：**

- 确保在激活的 conda 环境中使用 pip
- 检查当前使用的 pip 路径：
```bash
which pip  # Linux/Mac
where pip   # Windows
```
  
  ### 📜 3️⃣ 保存和分享环境

✅ **导出完整环境：**
```bash
conda env export > environment.yml
```

✅ **导出简洁环境（仅导出手动安装的包）：**
```bash
conda env export --from-history > environment.yml
```

✅ **重建环境：**
```bash
conda env create -f environment.yml
```

✅ **更新现有环境：**
```bash
conda env update -f environment.yml
```

✅ **用 freeze（仅 pip 包）：**
```bash
pip freeze > requirements.txt
pip install -r requirements.txt
```

⚠️ 注意：`environment.yml` 比 `requirements.txt` 更全面，包含 Python 版本、conda 包、pip 包。

✅ **environment.yml 文件结构示例：**
```yaml
name: myproject
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.9
  - numpy
  - pandas
  - pip
  - pip:
    - some-pip-package
```

✅ **跨平台兼容的环境文件：**
- 使用 `--no-builds` 参数导出，避免平台特定的构建信息：
```bash
conda env export --no-builds > environment.yml
```

### 🧹 4️⃣ 定期清理和更新

✅ 清理缓存减少磁盘占用：

```bash
conda clean --all
```

✅ 清理特定缓存：
```bash
conda clean -i      # 清理索引缓存
conda clean -p      # 清理包缓存
conda clean -t      # 清理临时目录
```

✅ 更新 conda：

```bash
conda update -n base -c defaults conda
```

✅ 更新环境内包（小心兼容性）：

```bash
conda update --all
```

✅ 查看过时的包：
```bash
conda list --outdated
```

✅ 更新特定包：
```bash
conda update package_name
```

✅ 检查环境健康状态：
```bash
conda list        # 查看已安装的包
conda info        # 查看环境和系统信息
conda doctor      # 检查环境潜在问题
```

### 🚀 5️⃣ 配置国内源（加速下载）

✅ 临时使用国内源：

```bash
conda install -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main <包名>
```

✅ 永久配置清华源：

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
```

✅ 永久配置中科大源：

```bash
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
```

✅ 查看和管理已配置的源：

```bash
conda config --show channels     # 查看当前配置的channels
conda config --remove channels <channel_name>  # 删除特定channel
```

✅ 恢复默认源设置：

```bash
conda config --remove-key channels
```

### 🛡 6️⃣ 防止环境污染

✅ 如果用 pip 安装包：

- 确认已激活正确的 conda 环境；
    
- 用 `which pip`（Linux/Mac）或 `where pip`（Windows）检查当前环境绑定的 pip。
    
⚠️ 避免使用 `sudo pip install`，它会影响全局。

✅ **环境隔离最佳实践：**

- 不同项目使用不同的环境名称
- 定期检查当前激活的环境：`conda info --envs`
- 在项目根目录添加环境说明文件，告知团队成员如何创建环境

✅ **避免常见的环境问题：**

- 不要在 base 环境中安装项目特定的包
- 不要混用不同项目的环境
- 不要在环境中安装不必要的包

✅ **环境版本控制：**

- 将 `environment.yml` 添加到版本控制系统中
- 定期更新 `environment.yml` 文件以反映环境变化
- 在 README 中说明如何设置开发环境

### 🛠 7️⃣ 高级：用 mamba 加速

如果 conda 解决依赖太慢：

```bash
conda install mamba -n base -c conda-forge
```

使用 mamba 安装包：
```bash
mamba install <包名>
```

使用 mamba 创建环境：
```bash
mamba create -n myenv python=3.x
```

使用 mamba 箯理环境：
```bash
mamba env create -f environment.yml
mamba env update -f environment.yml
```

> mamba 是 conda 的快速替代，兼容命令几乎一样，但速度极快。
> 
> 优势：
> - 依赖解析速度提升 10-100 倍
> - 并行下载包
> - 更好的错误消息
> - 完全兼容现有的 conda 环境和命令

### 🗂 推荐文件结构

在项目根目录下：
```bash
/my_project
├── environment.yml          # conda 环境配置文件
├── requirements.txt         # pip 依赖文件（可选）
├── src/                     # 源代码目录
│   ├── __init__.py
│   ├── main.py
│   └── utils.py
├── data/                    # 数据目录
│   ├── raw/
│   └── processed/
├── notebooks/               # Jupyter Notebook 目录
├── tests/                   # 测试代码目录
├── docs/                    # 文档目录
├── scripts/                 # 脚本目录
├── .gitignore               # Git 忽略文件
└── README.md                # 项目说明文件
```

✅ **项目环境管理建议：**

- 在 README.md 中明确说明如何设置开发环境
- 提供环境安装命令：
```bash
# 创建环境
conda env create -f environment.yml

# 激活环境
conda activate myproject

# 更新环境
conda env update -f environment.yml
```

✅ **多环境管理：**

对于复杂项目，可能需要多个环境：
```bash
/project
├── environment.yml          # 开发环境
├── environment-test.yml     # 测试环境
├── environment-prod.yml     # 生产环境
└── ...other files
```

### ❓ 8️⃣ 常见问题排查

✅ **环境激活失败：**
```bash
# 检查conda是否正确初始化
conda init

# 重启终端或执行
source ~/.bashrc  # Linux/Mac
# 或
conda activate base
```

✅ **包安装冲突：**
```bash
# 使用conda-forge通道
conda install -c conda-forge package_name

# 或使用mamba解决依赖
mamba install package_name
```

✅ **环境创建缓慢：**
```bash
# 配置更快的通道
conda config --add channels conda-forge

# 或使用mamba创建环境
mamba create -n myenv python=3.x
```

✅ **磁盘空间不足：**
```bash
# 清理conda缓存
conda clean --all

# 清理特定内容
conda clean -p  # 清理包缓存
conda clean -i  # 清理索引
```

✅ **环境损坏修复：**
```bash
# 删除损坏的环境
conda remove -n env_name --all

# 重新创建环境
conda env create -f environment.yml
```

### 🏁 9️⃣ 最佳实践总结

1. **始终使用虚拟环境**：为每个项目创建独立的conda环境
2. **优先使用conda**：尽可能使用conda而不是pip安装包
3. **合理配置channels**：使用conda-forge等高质量通道
4. **定期维护环境**：清理缓存，更新包，检查环境健康
5. **版本控制环境配置**：将environment.yml纳入版本控制
6. **考虑使用mamba**：对于大型环境，使用mamba提高速度
7. **良好的命名规范**：使用清晰、一致的环境和包命名
8. **文档化环境设置**：在README中详细说明环境配置步骤
