# DeepSeek OCR Docker

基于 [deepseek-ocr.rs](https://github.com/TimmyOVO/deepseek-ocr.rs) 的 Docker 镜像构建项目。

## 项目简介

本项目提供了一个轻量级的 Docker 镜像，用于运行 DeepSeek OCR 服务器。镜像基于 Alpine Linux 构建，体积小巧，适合快速部署。

## 快速开始

### 拉取镜像

```bash
docker pull aiqinxuancai/deepseek-ocr-server:latest
```

### 运行容器

```bash
docker run -d \
  --name deepseek-ocr \
  -p 8000:8000 \
  -v $(pwd)/data:/home/appuser \
  aiqinxuancai/deepseek-ocr-server:latest
```

### 使用 Docker Compose

创建 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  deepseek-ocr:
    image: aiqinxuancai/deepseek-ocr-server:latest
    ports:
      - "8000:8000"
    volumes:
      - ./data:/home/appuser
    restart: unless-stopped
```

运行：

```bash
docker-compose up -d
```

## 技术细节

- **基础镜像**: Alpine Linux
- **应用端口**: 8000
- **运行用户**: appuser (非 root)
- **数据卷**: `/home/appuser`
- **上游版本**: v0.3.7

## 相关链接

- [原始项目](https://github.com/TimmyOVO/deepseek-ocr.rs)
- [Docker Hub](https://hub.docker.com/)

## 许可证

本项目遵循原始项目的许可证。
