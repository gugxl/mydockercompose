这是为你整合了 **Loki 日志、Prometheus 指标、Kafka 消息队列以及 Alloy 采集器** 的完整全栈监控平台 `README.md`。

---

# 🚀 全栈可观测性监控平台 (Loki + Prometheus + Kafka)

本项目集成了一套基于 **Grafana 生态** 的全栈监控方案，实现了“指标 (Metrics) + 日志 (Logs)”的一体化观测，并包含高性能消息队列 Kafka 基础设施。

## 🏗️ 架构概览

* **日志栈 (Loki)**: 采用 Simple Scalable 读写分离架构，使用 **MinIO** 对象存储。
* **指标栈 (Prometheus)**: 采集业务指标与组件运行状态。
* **采集层 (Alloy)**: 统一流式采集器，实时抓取 Docker 容器日志、本地文件及系统指标。
* **中间件 (Kafka)**: 基于 KRaft 模式的 Kafka 4.2 集群，包含可视化管理界面 **Kafka-UI**。
* **网关层 (Nginx)**: 统一处理 Loki 的读写分流。

## 📁 目录结构

```text
.
├── docker-compose.yaml    # 整体编排文件
├── .data/                 # 持久化数据存储 (MinIO, Kafka)
└── config/                # 配置文件存放区 (核心)
    ├── loki-config.yaml   # Loki 集群与 S3 存储配置
    ├── alloy-config.alloy # Alloy 采集拓扑配置
    ├── nginx-gateway.conf # Nginx 七层路由规则
    └── prometheus.yml     # Prometheus 抓取任务配置

```

## 🚀 组件访问清单

| 组件 | 访问地址 | 默认凭据 | 作用 |
| --- | --- | --- | --- |
| **Grafana** | `http://localhost:3000` | `admin` / `admin` | 可视化看板 (总入口) |
| **MinIO Console** | `http://localhost:9001` | `loki` / `supersecret` | 对象存储后台 |
| **Alloy UI** | `http://localhost:12345` | 查看拓扑图 | 采集链路健康度检查 |
| **Prometheus** | `http://localhost:9090` | 无 | 指标数据查询 |
| **Loki Gateway** | `http://localhost:3100` | 无 | 日志推送/查询入口 |

## 🛠️ 快速上手

### 1. 检查本地环境

请确保宿主机以下端口未被占用：`3000, 3100, 9001, 9005, 9090, 10010, 12345, 9092, 9094`。

### 2. 启动系统

```bash
docker compose up -d

```

### 3. 配置 Grafana 数据源

首次进入 Grafana (`http://localhost:3000`) 后，请手动添加以下数据源：

#### **A. 添加 Loki (日志)**

* **URL**: `http://gateway:3100`
* **Custom HTTP Headers**:
* Header: `X-Scope-OrgID`
* Value: `tenant1`



#### **B. 添加 Prometheus (指标)**

* **URL**: `http://prometheus:9090`

## 🔍 验证数据流

### 日志验证 (LogQL)

在 Grafana **Explore** 页面，选择 **Loki** 数据源，输入以下语句：

* **查看模拟日志**: `{container="flog"}`
* **查看后端日志**: `{job="springboot"}`

### 指标验证 (PromQL)

选择 **Prometheus** 数据源，输入以下语句：

* **查看组件存活**: `up`
* **查看 JVM 堆内存**: `jvm_memory_used_bytes` (需 SpringBoot 开启 prometheus 端点)

## ⚠️ 注意事项

1. **Windows 路径**: 在 `docker-compose.yaml` 中，Alloy 的日志挂载路径 `D:/applicationfile/...` 需根据你的实际代码目录进行修改。
2. **Spring Boot 接入**:
* **日志**: 确保应用将日志输出到映射的文件夹下。
* **指标**: 在应用中引入 `micrometer-registry-prometheus` 依赖。


3. **内存占用**: 本套系统启动了 10 个左右的容器，建议宿主机保留至少 **4GB** 可用内存。

---

**Powered by Grafana Labs & Open Source Community**

---

**你想让我帮你把 Grafana 的数据源预配置脚本写出来吗？这样你下次 `docker compose up` 之后，连手动添加数据源的步骤都可以省掉。**