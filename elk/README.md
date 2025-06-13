# 前置条件
安装好docker和 docker compose

# 1. compose环境文件夹

```
mkdir elk && cd elk
```

# 2. 创建compose文件

```
vim docker-compose.yaml
```

内容如下
```

version: '3.7'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.6.2  # 官方镜像 
    container_name: elasticsearch
    environment:
      - discovery.type=single-node  # 单节点模式 
      - xpack.security.enabled=false  # 禁用安全认证（测试用）
      - bootstrap.memory_lock=true
      - ES_JAVA_OPTS=-Xms1g -Xmx1g  # JVM 内存分配
    volumes:
      - es_data:/usr/share/elasticsearch/data  # 数据持久化 
    ports:
      - "9200:9200"
    networks:
      - elk

  kibana:
    image: docker.elastic.co/kibana/kibana:8.6.2  # 版本需与 ES 一致 
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    networks:
      - elk
    depends_on:
      - elasticsearch

  logstash:
    image: docker.elastic.co/logstash/logstash:8.6.2
    container_name: logstash
    volumes:
      - ./logstash/config/logstash.conf:/usr/share/logstash/pipeline/logstash.conf  # 挂载配置文件 
    environment:
      - LS_JAVA_OPTS=-Xms512m -Xmx512m
    ports:7157
      - "5044:5044"  # Filebeat 输入端口
    networks:
      - elk
    depends_on:
      - elasticsearch

volumes:
  es_data:  # Elasticsearch 数据卷
    driver: local

networks:
  elk:  # 自定义网络确保服务互通
    driver: bridge

```

# 3. 创建logstash文件夹及配置
```
mkdir -p logstash/config

echo 'input { beats { port => 5044 } } output { elasticsearch { hosts => ["http://elasticsearch:9200"] } }' > logstash/config/logstash.conf
```


# 4. 启动

```
docker compose up -d
```

# 5. 访问验证

elasticsearch
```
http://localhost:9200/
```
账号：elastic
密码：elastic

kanaba
```
http://localhost:5601/
```