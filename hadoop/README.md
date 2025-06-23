1.

第一次启动时，Hive Metastore 会尝试初始化数据库 schema。此步骤只做一次

docker compose up -d zookeeper namenode datanode resourcemanager nodemanager mysql hive-metastore


2. 初始化成功

docker compose stop hive-metastore

3. 编辑
编辑 docker-compose.yml： 将 hive-metastore 服务中的 command 行注释掉或删除

docker exec -it hive-metastore bash
schematool -dbType postgres -initSchema


4. Spark History Server创建HDFS目录

docker exec -it namenode hdfs dfs -mkdir -p /spark-events
docker exec -it namenode hdfs dfs -chmod 777 /spark-events # Or appropriate permissions
docker exec -it namenode hdfs dfs -mkdir -p /user/hive/warehouse # For Hive
docker exec -it namenode hdfs dfs -chmod 777 /user/hive/warehouse # For Hive

启动所有服务：
docker compose up -d

查看服务状态

docker compose ps

HDFS NameNode UI: http://localhost:9870
YARN ResourceManager UI: http://localhost:8088
Spark Master UI: http://localhost:8080
Spark History Server UI: http://localhost:18080
HBase Master UI: http://localhost:16010

命令行访问：

HDFS Shell (在 namenode 容器内):


docker exec -it namenode bash
hdfs dfs -ls /
hdfs dfs -mkdir /user/test
exit

Hive Beeline (在 hive-server 容器内):


docker exec -it hive-server bash
/opt/hive/bin/beeline -u "jdbc:hive2://hive-server:10000" -n user -p password # user/password are placeholders, not actual auth
# 在beeline中：
# show databases;
# create database my_test_db;
# use my_test_db;
# create table if not exists sample_table (id int, name string);
# exit;
exit

HBase Shell (在 hbase-master 容器内):


docker exec -it hbase-master bash
/opt/hbase/bin/hbase shell
# 在hbase shell中：
# status 'summary'
# create 'test_table', 'cf1'
# list
# disable 'test_table'
# drop 'test_table'
# exit
exit


Spark Shell (在 spark-master 容器内):
docker exec -it spark-master bash
# 使用 spark-shell 连接到 Spark Master (Standalone模式)
/opt/spark/bin/spark-shell --master spark://spark-master:7077
# 或者连接到 YARN (如果需要，Spark可以配置为YARN模式)
# /opt/spark/bin/spark-shell --master yarn --deploy-mode client
# 简单的Spark代码：
# val data = 1 to 100
# val distData = sc.parallelize(data)
# distData.count()
# :quit
exit


停止所有服务：
docker compose stop



停止并删除容器、网络，但保留数据卷：
docker compose down


停止并删除容器、网络，并删除所有数据卷 (会丢失所有HDFS数据、Hive元数据、MySQL数据等)：
docker compose down -v

容器日志： 如果服务启动失败或行为异常，请使用 docker logs <container_name> (例如 docker logs namenode) 来查看日志进行故障排除。

Hive Metastore初始化： 再次强调，hive-metastore 的 command 行只在第一次部署时需要，成功后务必注释掉或删除，否则下次 docker compose up 会失败。
