# Loki 分布式日志系统 (微服务架构)

本项目部署了一套生产级的 Grafana Loki 日志分析栈，采用读写分离架构，并使用 MinIO 作为后端对象存储。

## 📁 目录结构说明
* `docker-compose.yaml`: 定义了 9 个核心容器服务。
* `config/`:
* `loki-config.yaml`: Loki 集群的核心配置（S3 存储、索引策略）。
* `alloy-config.alloy`: Alloy 采集逻辑（Docker 监控、本地文件读取）。
* `nginx-gateway.conf`: Nginx 路由转发规则。

## 🚀 核心组件地址
| 组件 | 访问地址 | 备注 |
| :--- | :--- | :--- |
| **Grafana** | `http://localhost:3000` | 免密登录，查看日志仪表盘 |
| **MinIO Console** | `http://localhost:9005` | 账号 `loki` / `supersecret` |
| **Alloy UI** | `http://localhost:12345` | 查看日志采集拓扑图与错误 |
| **Loki Gateway** | `http://localhost:3100` | 日志推送与查询的总入口 |

## 🛠️ 快速操作指南

### 1. 启动与停止
```bash
# 启动
docker compose up -d

# 查看日志采集状态
docker compose logs -f alloy

# 停止并清理
docker compose down