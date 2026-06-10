FROM node:alpine3.22

# 1. 核心修复：将工作目录切换到独立的应用目录，彻底远离系统的 /tmp 临时区
WORKDIR /app

# 2. 复制项目文件到容器内的 /app 目录
COPY index.js index.html package.json ./

# 3. 声明端口
EXPOSE 3000/tcp

# 4. 优化：合并层级并清理缓存，有效缩减镜像体积
RUN apk update && apk upgrade && \
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash && \
    chmod +x index.js && \
    npm install && \
    rm -rf /root/.npm /var/cache/apk/*

# 5. 核心修复：显式指定启动当前目录下的入口文件
CMD ["node", "index.js"]
