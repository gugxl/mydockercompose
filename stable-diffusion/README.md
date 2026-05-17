# Stable Diffusion WebUI

基于 [siutin/stable-diffusion-webui-docker](https://github.com/siutin/stable-diffusion-webui-docker) 的 AUTOMATIC1111 容器化部署，开箱即用。

## ⚠️ 系统要求

| 项 | 最低 | 推荐 |
| --- | --- | --- |
| **GPU** | NVIDIA，CC ≥ 6.1（Pascal 也支持） | RTX 系列 |
| **显存** | **4GB**（开 `--medvram-v2` / `--lowvram`） | 8GB+ |
| **驱动** | NVIDIA Driver ≥ 525 | — |
| **磁盘** | 镜像约 12GB，模型每个 2–7GB | 单独留 50GB+ |
| **容器运行时** | 必须装 `nvidia-container-toolkit` | — |

### 本机适配性

✅ **GTX 1060 6GB 可以跑**：
* SD 1.5 (512×512)：约 10–20 秒/张 → **流畅**
* SDXL (1024×1024)：勉强能跑，建议加 `--lowvram`，慢且容易 OOM

当前 compose 已开启 `--medvram-v2`，针对中等显存优化。

## 启动

前置：装 `nvidia-container-toolkit`（见 `../vllm/README.md` 的安装命令）。

```bash
# 准备目录（首次启动）
mkdir -p stable-diffusion/{models,outputs,extensions,embeddings,config}

# 启动
docker compose up -d
docker compose logs -f sd-webui
```

> 首次启动会下载默认模型，可能耗时 5–10 分钟。

## 访问

WebUI：[http://localhost:7861](http://localhost:7861)

API（已开启 `--api`）：[http://localhost:7861/docs](http://localhost:7861/docs)

## 目录结构

```text
stable-diffusion/
├── models/         # 放 .safetensors / .ckpt 主模型
├── outputs/        # 生成的图片
├── extensions/     # WebUI 扩展
├── embeddings/     # Textual Inversion
└── config/         # WebUI 配置持久化
```

## 常用启动参数（`CLI_ARGS`）

| 参数 | 用途 |
| --- | --- |
| `--xformers` | 加速 + 省显存（已开） |
| `--medvram-v2` | 中等显存优化（已开） |
| `--lowvram` | 低显存模式（4GB 以下用） |
| `--listen` | 允许外部访问（已开） |
| `--api` | 开启 API 端点（已开） |
| `--enable-insecure-extension-access` | 允许安装扩展（已开，**仅本地使用**） |

## ⚠️ 安全提醒

`--enable-insecure-extension-access` + `--listen` **不要暴露到公网**，扩展可执行任意代码。
