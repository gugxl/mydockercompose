图数据库  Nebula Graph  单机版本

# 启动服务

docker-compose up -d

# 验证状态
查看所有容器是否都在运行：
```
docker-compose ps
```
# 访问与登录
```
http://localhost:7001
```

| 参数 | 填写内容 | 说明 |
| :--- | :--- | :--- |
| Host | nebula-graphd | 注意： 必须填写容器服务名，不能写 localhost |
| Port | 3699 | 默认 Graph 端口 |
| Username | root | 默认用户名 |
| Password | nebula | 默认密码 |


# 添加 host
在 console 中执行
```
ADD HOSTS "nebula-storaged":44500;
```
查看主机是否加入成功
```
SHOW HOSTS;
```
创建图空间 (Space)
```
CREATE SPACE IF NOT EXISTS nba(partition_num=10, replica_factor=1, vid_type=FIXED_STRING(30));
```
创建一个名为 nba 的空间，设置副本数为 1（单机版），分区数为 10：

使用该空间
```
USE nba;
```
创建完可能有一定延迟

好了开始学习之旅