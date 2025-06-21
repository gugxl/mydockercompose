虽然只有一个镜像，但是为了统一管理也使用了docker compose



# 直接启动命令

```
docker run -d --name clickhouse-server   -p 8123:8123   -p 9000:9000   clickhouse/clickhouse-server:24.8.9.95
```

默认用户： default
密码是空