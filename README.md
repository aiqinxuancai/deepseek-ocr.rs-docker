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

#### 基础运行（默认配置）

```bash
docker run -d \
  --name deepseek-ocr \
  -p 8000:8000 \
  -v $(pwd)/data:/home/appuser \
  aiqinxuancai/deepseek-ocr-server:latest
```

#### 自定义启动参数

服务器支持多种命令行参数来自定义运行行为：

```bash
docker run -d \
  --name deepseek-ocr \
  -p 8000:8000 \
  -v $(pwd)/data:/home/appuser \
  aiqinxuancai/deepseek-ocr-server:latest \
  --host 0.0.0.0 --port 8000 \
  --device cpu --max-new-tokens 512
```

**常用参数说明**：

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--host` | 服务器监听地址 | 0.0.0.0 |
| `--port` | 服务器监听端口 | 8000 |
| `--device` | 计算设备 (cpu/cuda/metal) | cpu |
| `--dtype` | 数据类型 (f16/f32) | - |
| `--max-new-tokens` | 生成文本的最大 token 数 | 512 |
| `--do-sample` | 启用随机采样 | false |
| `--temperature` | 采样温度（0.0 为确定性） | 0.0 |
| `--top-p` | 核采样参数 | - |
| `--top-k` | 前 k 采样参数 | - |
| `--repetition-penalty` | 重复惩罚系数 | - |
| `--seed` | 随机种子 | - |

#### GPU 加速运行

如果宿主机有 NVIDIA GPU 且安装了 nvidia-docker：

```bash
docker run -d \
  --name deepseek-ocr \
  --gpus all \
  -p 8000:8000 \
  -v $(pwd)/data:/home/appuser \
  aiqinxuancai/deepseek-ocr-server:latest \
  --device cuda --dtype f16 --max-new-tokens 512
```

> 注意：当前镜像为 CPU 版本，GPU 加速需要使用支持 CUDA 的镜像。

### 使用 Docker Compose

#### 基础配置

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

#### 带自定义参数的配置

```yaml
version: '3.8'

services:
  deepseek-ocr:
    image: aiqinxuancai/deepseek-ocr-server:latest
    command:
      - "--host"
      - "0.0.0.0"
      - "--port"
      - "8000"
      - "--device"
      - "cpu"
      - "--max-new-tokens"
      - "512"
      - "--temperature"
      - "0.0"
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

## API 使用示例

服务器启动后，可以通过 HTTP API 进行 OCR 识别：

```bash
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": [
          {
            "type": "image_url",
            "image_url": {
              "url": "data:image/jpeg;base64,YOUR_BASE64_IMAGE"
            }
          },
          {
            "type": "text",
            "text": "请识别这张图片中的文字"
          }
        ]
      }
    ]
  }'
```

## 配置文件

容器内配置文件位置：`/home/appuser/.config/deepseek-ocr/config.toml`

如需持久化配置，可以挂载配置目录：

```bash
docker run -d \
  --name deepseek-ocr \
  -p 8000:8000 \
  -v $(pwd)/config:/home/appuser/.config/deepseek-ocr \
  -v $(pwd)/data:/home/appuser \
  aiqinxuancai/deepseek-ocr-server:latest
```

## 相关链接

- [原始项目](https://github.com/TimmyOVO/deepseek-ocr.rs)
- [Docker Hub](https://hub.docker.com/r/aiqinxuancai/deepseek-ocr-server)

## 许可证

本项目遵循原始项目的许可证。
