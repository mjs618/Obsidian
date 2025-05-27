

---

## 📦 镜像（Image）

- 列出镜像  
  `docker images`

- 拉取镜像  
  `docker pull <image>:<tag>`

- 删除镜像  
  `docker rmi <image>:<tag>`

- 构建镜像（当前目录 Dockerfile）  
  `docker build -t <image>:<tag> .`

- 保存镜像为 tar  
  `docker save -o <file>.tar <image>:<tag>`

- 从 tar 导入镜像  
  `docker load -i <file>.tar`

---

## 🏃‍♂️ 容器（Container）

- 列出运行中容器  
  `docker ps`

- 列出所有容器（包括停止）  
  `docker ps -a`

- 启动容器  
  `docker start <container>`

- 停止容器  
  `docker stop <container>`

- 重启容器  
  `docker restart <container>`

- 删除容器  
  `docker rm <container>`

- 运行容器（后台）  
  `docker run -d --name <name> <image>:<tag>`

- 运行容器（交互模式）  
  `docker run -it --name <name> <image>:<tag> /bin/bash`

- 查看容器日志  
  `docker logs <container>`

- 进入正在运行的容器  
  `docker exec -it <container> /bin/bash`

---

## 🛠️ 网络与端口

- 查看网络  
  `docker network ls`

- 创建网络  
  `docker network create <network>`

- 运行容器并绑定端口  
  `docker run -d -p <host_port>:<container_port> <image>:<tag>`

---

## 📂 挂载卷

- 创建卷  
  `docker volume create <volume>`

- 查看卷  
  `docker volume ls`

- 挂载卷到容器  
  `docker run -v <volume>:/path/in/container <image>:<tag>`

- 挂载宿主机目录到容器  
  `docker run -v /host/path:/container/path <image>:<tag>`

---

## 🧹 清理

- 删除停止的容器  
  `docker container prune`

- 删除未使用的镜像  
  `docker image prune`

- 删除未使用的卷  
  `docker volume prune`

- 一键全清（慎用！）  
  `docker system prune -a`

---

## 🏗️ Docker Compose

- 启动  
  `docker-compose up -d`

- 停止  
  `docker-compose down`

- 查看服务状态  
  `docker-compose ps`

- 查看 logs  
  `docker-compose logs -f`

- 重建（重新 build）  
  `docker-compose up -d --build`

---

## 📄 常用 Dockerfile 指令

- `FROM <base-image>` → 指定基础镜像  
- `RUN <command>` → 容器内执行命令  
- `COPY <src> <dest>` → 拷贝文件  
- `ADD <src> <dest>` → 拷贝文件/解压归档  
- `WORKDIR <dir>` → 设置工作目录  
- `CMD ["cmd"]` → 容器启动时默认执行  
- `EXPOSE <port>` → 暴露端口  
- `ENV <key> <value>` → 设置环境变量  
- `VOLUME <dir>` → 声明卷挂载  
