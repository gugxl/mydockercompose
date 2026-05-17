# Open WebUI

[Open WebUI](https://github.com/open-webui/open-webui) — 接入 Ollama / OpenAI 兼容 API 的本地聊天前端。

## ⚠️ 系统要求

| 项 | 要求 |
| --- | --- |
| **GPU** | ❌ 不需要（仅是前端，推理由后端 Ollama / vLLM 提供） |
| **内存** | ≥ 1GB |
| **磁盘** | 镜像 ~1GB；用户数据看使用量 |
| **依赖服务** | 需要一个 LLM 后端，本 compose 默认指向宿主机 Ollama |

## 配置说明

当前 compose 通过 `host.docker.internal` 连接宿主机的 **Ollama**：

```yaml
environment:
  - OLLAMA_BASE_URL=http://host.docker.internal:11434
extra_hosts:
  - "host.docker.internal:host-gateway"
```

> `host-gateway` 是 Docker 在 Linux 上访问宿主机的标准方式，**无需改 IP**。

### 前置：宿主机装 Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh

# 默认监听 127.0.0.1，需改为监听所有接口才能让容器访问
sudo systemctl edit ollama
# 加入：
# [Service]
# Environment="OLLAMA_HOST=0.0.0.0:11434"

sudo systemctl daemon-reload
sudo systemctl restart ollama

# 拉一个模型试试
ollama pull qwen2.5:7b
```

## 启动

```bash
docker compose up -d
docker compose logs -f open-webui
```

> 注意 `restart: "no"`：**不会自动启动**，重启系统后需手动 `docker compose up -d`。

## 访问

[http://localhost:3001](http://localhost:3001)

首次访问需注册管理员账号（仅本地存储，不联网）。

## 切换后端

如果想接 vLLM / OpenAI 兼容 API，把 `OLLAMA_BASE_URL` 改成对应地址，或在 WebUI 设置里加 OpenAI 兼容连接。

## 数据持久化

用户、聊天记录、设置存在命名卷 `open-webui-data` 里：

```bash
# 备份
docker run --rm -v open-webui-data:/data -v $PWD:/backup alpine \
  tar czf /backup/open-webui-backup.tgz -C /data .
```
