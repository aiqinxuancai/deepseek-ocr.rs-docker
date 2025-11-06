# --- 阶段 1: "builder" ---
# 使用轻量的 alpine 作为基础镜像来下载和解压
FROM alpine:latest AS builder

# 安装下载和解压所需的工具
RUN apk add --no-cache curl tar

# 设置工作目录
WORKDIR /app

# 下载指定的文件
# -L: 允许 curl 跟随重定向 (GitHub Releases 常用)
# -o: 将下载的文件重命名为 app.tar.gz
RUN curl -L "https://github.com/TimmyOVO/deepseek-ocr.rs/releases/download/v0.3.7/deepseek-ocr-alpine-linux.tar.gz" -o app.tar.gz

# 解压
RUN tar -xzf app.tar.gz

# --- 阶段 2: "final" ---
# 再次使用 alpine 作为最终的运行环境
FROM alpine:latest

# 创建一个非 root 用户来运行程序，更安全
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app

# 从 "builder" 阶段复制解压后的可执行文件到当前阶段
COPY --from=builder /app/deepseek-ocr-server .

RUN chown appuser:appgroup deepseek-ocr-server

VOLUME /home/appuser

# 切换到非 root 用户
USER appuser

# 暴露端口
EXPOSE 8000

# 容器启动时执行的命令
CMD ["./deepseek-ocr-server"]
