
### 📦 基础操作

|操作|命令|
|---|---|
|查看 conda 版本|`conda --version`|
|查看帮助|`conda --help`|
|查看命令帮助|`conda <command> --help`|

### 🌱 环境管理

|操作|命令|
|---|---|
|查看所有环境|`conda env list` / `conda info --envs`|
|创建新环境|`conda create -n <env名> python=3.x`|
|激活环境|`conda activate <env名>`|
|退出环境|`conda deactivate`|
|删除环境|`conda remove -n <env名> --all`|
|克隆环境|`conda create -n <新env名> --clone <旧env名>`|

### 📋 包管理

|操作|命令|
|---|---|
|查看环境中的包|`conda list`|
|安装包|`conda install <包名>`|
|安装指定版本|`conda install <包名>=1.2.3`|
|更新包|`conda update <包名>`|
|更新所有包|`conda update --all`|
|卸载包|`conda remove <包名>`|
|搜索包|`conda search <包名>`|

### 📂 导出与导入环境

|操作|命令|
|---|---|
|导出环境到文件|`conda env export > environment.yml`|
|从文件创建环境|`conda env create -f environment.yml`|
|更新环境（基于 yml 文件）|`conda env update -f environment.yml`|

### 🔧 配置与源管理

|操作|命令|
|---|---|
|查看当前配置|`conda config --show`|
|添加国内镜像源（如清华）|`conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free`|
|设置默认显示时间和进度条|`conda config --set show_channel_urls yes`|
|清理索引缓存|`conda clean -i`|
|清理包缓存|`conda clean -p`|
|清理全部缓存|`conda clean --all`|

### 🛡 常见问题解决

|问题|解决方式|
|---|---|
|安装慢或超时|配置国内镜像源|
|环境不稳定或损坏|`conda clean --all` → 重建环境|
|激活 conda 无效 (特别是 Linux/Mac)|确认 `.bashrc` 或 `.zshrc` 中加入 `conda initialize`|
|升级 conda|`conda update -n base -c defaults conda`|