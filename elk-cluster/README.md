# 前置条件
安装好docker和 docker compose
集群部署

## ⚠️ 系统要求

| 项 | 最低 | 推荐 |
| --- | --- | --- |
| **CPU** | 2 核 | 4 核+ |
| **内存** | **8GB**（3 节点 × 1GB heap + Kibana 1GB + OS 余量） | 16GB+ |
| **磁盘** | 20GB | 100GB+（生产数据） |
| **vm.max_map_count** | **必须 ≥ 262144**（见下） | — |

### 必做：调高 `vm.max_map_count`

ES 启动会做内存映射，Linux 默认值（65536）过低会导致启动失败。

```bash
# 临时生效
sudo sysctl -w vm.max_map_count=262144

# 永久生效
echo 'vm.max_map_count=262144' | sudo tee /etc/sysctl.d/99-elasticsearch.conf
sudo sysctl --system
```

### 调整 Heap 大小

compose 中默认 `ES_JAVA_OPTS=-Xms1g -Xmx1g`，如果宿主机内存紧张可以改小，例如 `-Xms512m -Xmx512m`，但**不要超过物理内存的 50%，且单节点不超过 31GB**。

# 1. compose环境文件夹

```
mkdir elk-cluster && cd elk-cluster
```

# 2. 创建compose文件

```
vim docker-compose.yaml
```

内容如下
```

services:
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:9.0.4
    container_name: es01
    environment:
      - node.name=es01
      - cluster.name=es-cluster-dev
      - discovery.seed_hosts=es01,es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - node.roles=master,data
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - xpack.security.transport.ssl.enabled=false
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
      - 9300:9300
    networks:
      - elastic

  es02:
    image: docker.elastic.co/elasticsearch/elasticsearch:9.0.4
    container_name: es02
    environment:
      - node.name=es02
      - cluster.name=es-cluster-dev
      - discovery.seed_hosts=es01,es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - node.roles=master,data
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - xpack.security.transport.ssl.enabled=false
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data02:/usr/share/elasticsearch/data
    networks:
      - elastic
    depends_on:
      - es01

  es03:
    image: docker.elastic.co/elasticsearch/elasticsearch:9.0.4
    container_name: es03
    environment:
      - node.name=es03
      - cluster.name=es-cluster-dev
      - discovery.seed_hosts=es01,es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - node.roles=master,data,ingest
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - xpack.security.transport.ssl.enabled=false
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data03:/usr/share/elasticsearch/data
    networks:
      - elastic
    depends_on:
      - es01

  kibana:
    image: docker.elastic.co/kibana/kibana:9.0.4
    container_name: kibana
    environment:
      - SERVER_NAME=kibana
      - ELASTICSEARCH_HOSTS=http://es01:9200
      - xpack.security.enabled=false
    ports:
      - 5601:5601
    networks:
      - elastic
    depends_on:
      - es01

volumes:
  data01:
    driver: local
  data02:
    driver: local
  data03:
    driver: local

networks:
  elastic:
    driver: bridge

```

# 3. 启动

```
docker compose up -d
```

# 4. 访问验证

elasticsearch
```
http://localhost:9200/
```

kanaba
```
http://localhost:5601/
```