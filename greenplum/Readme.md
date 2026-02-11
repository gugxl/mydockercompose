本地离线数据仓库搭建
 端口 7432  因为 5432 端口被postgresql占用
 数据库名 postgres
 用户名 gpadmin
 密码 gpadmin

跟 postgresql 一样

启动
```shell
docker compose up -d
```

docker 日志出现 
```
--- GREENPLUM IS READY AND ACCESSIBLE ---
```
本地可以链接测试