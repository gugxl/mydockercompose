# 1. 拉取镜像，直接拉取可能会超时
选择稳定的兼容的版本,以及对应的镜像
```
docker pull apache/hive:3.1.3             
docker pull apache/hadoop:3.3.6             
docker pull zookeeper:3.6.3             
docker pull apache/spark:3.4.1
docker pull bitnami/postgresql:14.18.0           
docker pull openeuler/hbase:2.6.2-oe2403sp1   
```

修改镜像名称移除仓库地址
其中hbase的docker镜像找了好久，其他的好像很久都不更新了




# 2. 创建数据文件夹
```
mkdir -p /hadoop-data/zk-data /hadoop-data/zk-datalog /hadoop-data/spark-data
```

# 3. 启动



