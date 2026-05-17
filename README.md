# mydockercompose

平时常用的 Docker Compose 环境集合。

> 即使只是一行 `docker run`，也建议沉淀成 `docker-compose.yml`，避免下次重建环境时命令遗忘；同时方便版本管理与团队复用。

## 使用说明

每个子目录都是一个独立的环境，互不影响。进入对应目录直接启动即可：

```bash
cd <服务目录>
docker compose up -d        # 启动
docker compose ps           # 查看状态
docker compose logs -f      # 查看日志
docker compose down         # 停止并清理
```

部分子目录提供了 `README.md`，包含端口、默认账号、初始化等信息，使用前建议先看一眼。

## 服务清单

### 数据库 / 存储
| 目录 | 说明 |
|---|---|
| [`mysql8`](./mysql8) | MySQL 8 |
| [`postgresql`](./postgresql) | PostgreSQL |
| [`mongodb`](./mongodb) | MongoDB |
| [`redis`](./redis) | Redis |
| [`clickhouse`](./clickhouse) | ClickHouse |
| [`pg_clickhouse`](./pg_clickhouse) | PostgreSQL + ClickHouse 组合环境 |
| [`greenplum`](./greenplum) | Greenplum 分布式数据库 |
| [`nebula-grap`](./nebula-grap) | NebulaGraph 图数据库 |

### 消息队列
| 目录 | 说明 |
|---|---|
| [`kafka`](./kafka) | Kafka |
| [`rocketmq`](./rocketmq) | RocketMQ |

### 日志 / 监控
| 目录 | 说明 |
|---|---|
| [`elk`](./elk) | Elasticsearch + Logstash + Kibana 单机版 |
| [`elk-cluster`](./elk-cluster) | ELK 集群版 |
| [`loki`](./loki) | Grafana Loki 日志方案 |

### 调度 / 中间件
| 目录 | 说明 |
|---|---|
| [`xxl-job`](./xxl-job) | XXL-JOB 分布式任务调度 |
| [`nacos`](./nacos) | Nacos 配置中心 / 注册中心 |
| [`nexus`](./nexus) | Nexus 私服 |
| [`jenkins`](./jenkins) | Jenkins CI |
| [`datax`](./datax) | DataX 数据同步 |

### AI / 大模型
| 目录 | 说明 |
|---|---|
| [`vllm`](./vllm) | vLLM 推理服务 |
| [`llamafactory`](./llamafactory) | LLaMA-Factory 训练/微调 |
| [`openwebui`](./openwebui) | Open WebUI 前端 |
| [`stable-diffusion`](./stable-diffusion) | Stable Diffusion |

### 其他
| 目录 | 说明 |
|---|---|
| [`n8n`](./n8n) | n8n 自动化工作流 |

## 约定

- 所有服务尽量使用固定版本镜像，避免 `latest` 带来的不可重现问题。
- 数据卷统一映射到子目录下，便于备份与清理。
- 端口冲突时请就地修改 `docker-compose.yml`，不要在多个环境间共享端口。

## 环境要求

- Docker Engine ≥ 20.10（推荐 OrbStack / Docker Desktop）
- Docker Compose v2（`docker compose` 子命令形式）
