本地离线数据仓库搭建
 端口 7432  因为 5432 端口被postgresql占用
 数据库名 postgres
 用户名 gpadmin
 密码 gpadmin

跟 postgresql 一样

## ⚠️ 系统要求

| 项 | 最低 | 推荐 |
| --- | --- | --- |
| **CPU** | 2 核 | 4 核+ |
| **内存** | **4GB**（单节点容器内置 master + segment） | 8GB+ |
| **磁盘** | 20GB | 100GB+ |
| **架构** | x86_64 | x86_64（镜像不支持 ARM） |

> Greenplum 是 MPP 数据仓库，本镜像把多个角色塞进单容器仅供本地测试，**不要用于生产**。

启动
```shell
docker compose up -d
```

docker 日志出现 
```
--- GREENPLUM IS READY AND ACCESSIBLE ---
```
本地可以链接测试