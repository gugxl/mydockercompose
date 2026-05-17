# vLLM (OpenAI 兼容 API 推理服务)

基于 [vLLM](https://github.com/vllm-project/vllm) 的本地大模型推理服务，对外暴露 OpenAI 兼容 API。

## ⚠️ 系统要求（重要）

| 项 | 要求 |
| --- | --- |
| **GPU 架构** | **Compute Capability ≥ 7.0**（Volta / Turing / Ampere / Ada / Hopper） |
| **显存** | 7B 模型 FP16 ≥ 16GB；4bit 量化 ≥ 8GB |
| **驱动** | NVIDIA Driver ≥ 525；CUDA ≥ 12.1 |
| **容器运行时** | 必须安装 `nvidia-container-toolkit` |

> ❌ **GTX 10 系（Pascal, CC 6.1）跑不了 vLLM**：vLLM 的 kernel 用了 Volta 之后才有的特性，启动会直接报错退出。
>
> 本机的 **GTX 1060 6GB** 不满足要求。

### 替代方案（Pascal / 低显存 GPU）

* **Ollama**：在宿主机直接装，对老 GPU 兼容性最好，配合 `openwebui/` 使用 → 见 `../openwebui/README.md`
* **llama.cpp**：CPU + 部分 GPU offload，灵活
* **LLamaFactory**：仅做小模型（≤ 1.5B）推理或 LoRA 实验 → 见 `../llamafactory/README.md`

## 启动（仅在满足要求的机器上）

前置：先装 `nvidia-container-toolkit`

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sudo sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

启动：

```bash
docker compose up -d
docker compose logs -f vllm-qwen
```

## 访问

OpenAI 兼容 API：`http://localhost:8001/v1`

```bash
# 模型列表
curl http://localhost:8001/v1/models

# Chat completion
curl http://localhost:8001/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen2.5-7B-Instruct",
    "messages": [{"role": "user", "content": "你好"}]
  }'
```

## 配置项

| 参数 | 值 | 说明 |
| --- | --- | --- |
| 默认模型 | `Qwen/Qwen2.5-7B-Instruct` | 在 `command` 里改 |
| 显存利用率 | `0.6` | `--gpu-memory-utilization` |
| 端口映射 | `8001:8000` | 宿主机 8001 → 容器 8000 |
| 模型缓存 | `./models` | 首次拉模型会下载到这里 |

如需多卡或多模型，参考文件末尾被注释掉的 `vllm-deepseek` 段。
