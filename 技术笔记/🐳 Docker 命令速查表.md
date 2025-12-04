

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

### 🔧 高级镜像命令

- 查看镜像详细信息  
  `docker inspect <image>:<tag>`

- 给镜像打标签  
  `docker tag <source_image>:<tag> <target_image>:<tag>`

- 推送镜像到仓库  
  `docker push <image>:<tag>`

- 查看镜像构建历史  
  `docker history <image>:<tag>`

- 清理悬空镜像（无标签的镜像）  
  `docker image prune`

- 清理所有未使用的镜像  
  `docker image prune -a`

- 构建镜像时不使用缓存  
  `docker build --no-cache -t <image>:<tag> .`

- 构建镜像时指定构建参数  
  `docker build --build-arg <key>=<value> -t <image>:<tag> .`

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

### 🔧 高级容器命令

- 查看容器详细信息  
  `docker inspect <container>`

- 查看容器资源使用情况  
  `docker stats <container>`

- 查看容器资源使用情况（所有容器）  
  `docker stats`

- 复制文件到容器  
  `docker cp <file> <container>:<path>`

- 从容器复制文件  
  `docker cp <container>:<path> <file>`

- 在容器中执行命令  
  `docker exec <container> <command>`

- 强制停止容器  
  `docker kill <container>`

- 重命名容器  
  `docker rename <old_name> <new_name>`

- 暂停容器  
  `docker pause <container>`

- 恢复容器  
  `docker unpause <container>`

- 查看容器进程  
  `docker top <container>`

- 导出容器为 tar 文件  
  `docker export <container> > <file>.tar`

- 从 tar 文件导入容器  
  `docker import <file>.tar <image>:<tag>`

---

## 🛠️ 网络与端口

- 查看网络  
  `docker network ls`

- 创建网络  
  `docker network create <network>`

- 运行容器并绑定端口  
  `docker run -d -p <host_port>:<container_port> <image>:<tag>`

### 🔧 高级网络命令

- 查看网络详细信息  
  `docker network inspect <network>`

- 删除网络  
  `docker network rm <network>`

- 连接容器到网络  
  `docker network connect <network> <container>`

- 断开容器与网络的连接  
  `docker network disconnect <network> <container>`

- 创建自定义网络  
  `docker network create --driver bridge <network>`

- 创建网络并指定子网  
  `docker network create --subnet=<subnet> <network>`

- 运行容器并指定网络  
  `docker run -d --network <network> <image>:<tag>`

- 查看容器网络设置  
  `docker inspect <container> | grep Network`

- 端口映射（多个端口）  
  `docker run -d -p <host_port1>:<container_port1> -p <host_port2>:<container_port2> <image>:<tag>`

- 随机端口映射  
  `docker run -d -P <image>:<tag>`

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

### 🔧 高级卷管理命令

- 查看卷详细信息  
  `docker volume inspect <volume>`

- 删除卷  
  `docker volume rm <volume>`

- 清理未使用的卷  
  `docker volume prune`

- 挂载卷并指定读写权限  
  `docker run -v <volume>:/path/in/container:rw <image>:<tag>`

- 挂载卷并指定只读权限  
  `docker run -v <volume>:/path/in/container:ro <image>:<tag>`

- 挂载临时卷  
  `docker run --tmpfs /tmp <image>:<tag>`

- 挂载宿主机文件到容器  
  `docker run -v /host/file:/container/file <image>:<tag>`

- 指定卷驱动  
  `docker volume create --driver local <volume>`

- 创建卷并指定选项  
  `docker volume create --opt <option> <volume>`

---

## 🔍 容器检查与监控

- 查看容器详细信息  
  `docker inspect <container>`

- 查看容器资源使用情况  
  `docker stats <container>`

- 查看所有容器资源使用情况  
  `docker stats`

- 查看容器日志（实时）  
  `docker logs -f <container>`

- 查看容器日志（最近100行）  
  `docker logs --tail 100 <container>`

- 查看容器日志（带时间戳）  
  `docker logs -t <container>`

- 查看容器进程  
  `docker top <container>`

- 查看容器变更文件  
  `docker diff <container>`

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

### 🔧 高级清理命令

- 删除所有停止的容器  
  `docker container prune -f`

- 删除所有未使用的镜像  
  `docker image prune -a`

- 删除所有未使用的网络  
  `docker network prune`

- 删除所有未使用的构建缓存  
  `docker builder prune`

- 删除所有未使用的数据  
  `docker system prune`

- 查看磁盘使用情况  
  `docker system df`

- 查看详细磁盘使用情况  
  `docker system df -v`

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

### 🔧 高级 Docker Compose 命令

- 启动特定服务  
  `docker-compose up -d <service>`

- 停止特定服务  
  `docker-compose stop <service>`

- 重启特定服务  
  `docker-compose restart <service>`

- 在服务中执行命令  
  `docker-compose exec <service> <command>`

- 进入服务容器  
  `docker-compose exec <service> /bin/bash`

- 查看服务日志（特定服务）  
  `docker-compose logs -f <service>`

- 构建服务镜像  
  `docker-compose build <service>`

- 拉取服务镜像  
  `docker-compose pull <service>`

- 推送服务镜像  
  `docker-compose push <service>`

- 验证并查看 compose 文件  
  `docker-compose config`

- 扩展服务实例  
  `docker-compose up -d --scale <service>=<count>`

- 指定 compose 文件  
  `docker-compose -f <file> up -d`

- 使用多个 compose 文件  
  `docker-compose -f <file1> -f <file2> up -d`

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

### 🔧 高级 Dockerfile 指令

- `ARG <key> <value>` → 定义构建时变量  
- `LABEL <key>=<value>` → 为镜像添加元数据  
- `USER <user>` → 指定运行容器的用户  
- `ENTRYPOINT ["cmd"]` → 容器启动时执行命令（不可覆盖）  
- `HEALTHCHECK <options> <command>` → 配置容器健康检查  
- `ONBUILD <instruction>` → 添加触发器指令  

### 🏗️ 多阶段构建示例

```dockerfile
# 构建阶段
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 生产阶段
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## ✅ Docker 最佳实践

### 📦 镜像优化

- 使用轻量级基础镜像（如 alpine）
- 使用多阶段构建减少最终镜像大小
- 合理安排 Dockerfile 指令顺序以利用缓存
- 删除不必要文件和清理包管理器缓存

### 🏃‍♂️ 容器安全

- 避免以 root 用户运行容器
- 使用只读文件系统 `--read-only`
- 限制容器资源使用（内存、CPU）
- 禁用特权模式 `--privileged=false`

### 🛠️ 网络与存储

- 使用用户自定义网络而非默认桥接网络
- 明确声明端口暴露
- 使用卷管理持久化数据

### 📄 Dockerfile 编写

- 使用具体标签而非 latest
- 合并 RUN 命令减少层数
- 使用 .dockerignore 忽略不必要文件
- 添加健康检查 HEALTHCHECK

### 🏗️ Compose 配置

- 为不同环境使用多个 compose 文件
- 明确定义服务依赖关系
- 使用环境变量管理配置

---