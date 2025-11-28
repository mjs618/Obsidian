所需准备素材：
- 源代码
- dockerdesktop
- 所需依赖包

```yaml
# 使用官方Python 3.12镜像作为基础镜像  
FROM python:3.12  
  
# 设置工作目录  
WORKDIR /app  
  
# 设置环境变量  
ENV PYTHONPATH=/app  
ENV PYTHONUNBUFFERED=1  
ENV UVICORN_RELOAD=false  
  
# 安装系统依赖  
RUN apt-get update && apt-get install -y \  
    gcc \  
    curl \  
    && rm -rf /var/lib/apt/lists/*  
  
# 复制依赖文件  
COPY requirements.txt .  
  
# 安装Python依赖  
RUN pip install --no-cache-dir -r requirements.txt  
  
# 复制应用代码  
COPY . .  
  
# 创建static目录  
RUN mkdir -p static  
  
# 暴露端口  
EXPOSE 9530  
  
# 使用uvicorn直接启动（推荐）  
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9530", "--log-level", "info"]
```
