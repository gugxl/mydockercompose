
大模型微调服务
[官网地址](https://github.com/hiyouga/LLaMA-Factory)


## ⚠️ 系统要求

| 项 | 最低 | 推荐 |
| --- | --- | --- |
| **GPU** | NVIDIA，CC ≥ 6.1（Pascal 起） | RTX 30/40 系 |
| **显存** | **6GB**（推理 ≤ 1.5B 小模型） | 24GB+（LoRA 微调 7B） |
| **内存** | 16GB | 32GB+ |
| **磁盘** | 镜像 ~15GB；模型 + 数据集额外 50GB+ | — |
| **容器运行时** | 必须装 `nvidia-container-toolkit` | — |

### 本机适配性（GTX 1060 6GB）

| 任务 | 是否可行 |
| --- | --- |
| 推理 0.5B–1.5B 小模型（Qwen2-0.5B / TinyLlama-1.1B） | ✅ 可以 |
| 推理 7B 模型（4bit 量化） | ⚠️ 极限，容易 OOM |
| LoRA 微调 7B | ❌ 显存不够 |
| 全参数微调 | ❌ 不可能 |

> 想做严肃微调建议租云 GPU（如 AutoDL、Vast.ai）。

## 启动

前置：装 `nvidia-container-toolkit`（见 `../vllm/README.md`）。

```bash
docker compose up -d
docker compose logs -f llamafactory
```

## 访问

[http://localhost:7860](http://localhost:7860)

## 配置说明

* `HF_ENDPOINT=https://hf-mirror.com` — 国内镜像，加速 HuggingFace 模型下载
* `./data` — 数据集目录（已包含 `dataset_info.json` 和示例 `magic_conch.json`）
* `./hf_cache` — HF 模型缓存，避免每次重启重新下载
* `ipc: host` — 训练时多进程数据加载需要

## 参考

[博客地址](https://blog.csdn.net/zhazhagu/article/details/150978713)
