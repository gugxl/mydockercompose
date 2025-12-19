
[pg_clickhouse官方文档](https://github.com/ClickHouse/pg_clickhouse?tab=readme-ov-file)
[clickhouse官方文档](https://clickhouse.com/docs)
[postgresql_fdw文档](https://www.postgresql.org/docs/18/fdw-helpers.html)

# 1. 启动 

```
docker compose up -d
```

# 2. clickhouse 数据库表创建,数据初始化

```
CREATE DATABASE IF NOT EXISTS taxi;

CREATE TABLE taxi.trips
(
    trip_id UInt32,
    vendor_id Enum8(
        '1'      =  1, '2'      =  2, '3'      =  3, '4'      =  4,
        'CMT'    =  5, 'VTS'    =  6, 'DDS'    =  7, 'B02512' = 10,
        'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14,
        ''       = 15
    ),
    pickup_date Date,
    pickup_datetime DateTime,
    dropoff_date Date,
    dropoff_datetime DateTime,
    store_and_fwd_flag UInt8,
    rate_code_id UInt8,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    passenger_count UInt8,
    trip_distance Float64,
    fare_amount Decimal(10, 2),
    extra Decimal(10, 2),
    mta_tax Decimal(10, 2),
    tip_amount Decimal(10, 2),
    tolls_amount Decimal(10, 2),
    ehail_fee Decimal(10, 2),
    improvement_surcharge Decimal(10, 2),
    total_amount Decimal(10, 2),
    payment_type Enum8('UNK' = 0, 'CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4),
    trip_type UInt8,
    pickup FixedString(25),
    dropoff FixedString(25),
    cab_type Enum8('yellow' = 1, 'green' = 2, 'uber' = 3),
    pickup_nyct2010_gid Int8,
    pickup_ctlabel Float32,
    pickup_borocode Int8,
    pickup_ct2010 String,
    pickup_boroct2010 String,
    pickup_cdeligibil String,
    pickup_ntacode FixedString(4),
    pickup_ntaname String,
    pickup_puma UInt16,
    dropoff_nyct2010_gid UInt8,
    dropoff_ctlabel Float32,
    dropoff_borocode UInt8,
    dropoff_ct2010 String,
    dropoff_boroct2010 String,
    dropoff_cdeligibil String,
    dropoff_ntacode FixedString(4),
    dropoff_ntaname String,
    dropoff_puma UInt16
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(pickup_date)
ORDER BY pickup_datetime;


-- 导入数据
INSERT INTO taxi.trips
SELECT * FROM s3(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz',
    'TabSeparatedWithNames', "
    trip_id UInt32,
    vendor_id Enum8(
        '1'      =  1, '2'      =  2, '3'      =  3, '4'      =  4,
        'CMT'    =  5, 'VTS'    =  6, 'DDS'    =  7, 'B02512' = 10,
        'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14,
        ''       = 15
    ),
    pickup_date Date,
    pickup_datetime DateTime,
    dropoff_date Date,
    dropoff_datetime DateTime,
    store_and_fwd_flag UInt8,
    rate_code_id UInt8,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    passenger_count UInt8,
    trip_distance Float64,
    fare_amount Decimal(10, 2),
    extra Decimal(10, 2),
    mta_tax Decimal(10, 2),
    tip_amount Decimal(10, 2),
    tolls_amount Decimal(10, 2),
    ehail_fee Decimal(10, 2),
    improvement_surcharge Decimal(10, 2),
    total_amount Decimal(10, 2),
    payment_type Enum8('UNK' = 0, 'CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4),
    trip_type UInt8,
    pickup FixedString(25),
    dropoff FixedString(25),
    cab_type Enum8('yellow' = 1, 'green' = 2, 'uber' = 3),
    pickup_nyct2010_gid Int8,
    pickup_ctlabel Float32,
    pickup_borocode Int8,
    pickup_ct2010 String,
    pickup_boroct2010 String,
    pickup_cdeligibil String,
    pickup_ntacode FixedString(4),
    pickup_ntaname String,
    pickup_puma UInt16,
    dropoff_nyct2010_gid UInt8,
    dropoff_ctlabel Float32,
    dropoff_borocode UInt8,
    dropoff_ct2010 String,
    dropoff_boroct2010 String,
    dropoff_cdeligibil String,
    dropoff_ntacode FixedString(4),
    dropoff_ntaname String,
    dropoff_puma UInt16
") SETTINGS input_format_try_infer_datetimes = 0;

```
# 3. 验证数据和服务正常

clickhouse查看表数量
```
SELECT count() FROM taxi.trips;
```

# 4. postgresql执行链接配置
```
-- 启用 pg_clickhouse 扩展
CREATE EXTENSION IF NOT EXISTS pg_clickhouse;
```
```
-- 创建 ClickHouse 外部服务器
CREATE SERVER IF NOT EXISTS taxi_srv
FOREIGN DATA WRAPPER clickhouse_fdw
OPTIONS (
host 'clickhouse',  -- ClickHouse 服务名（与 docker-compose.yml 一致）
port '8123'         -- ClickHouse HTTP 端口
);
```

```
-- 映射 PostgreSQL 用户到 ClickHouse 用户
CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER
SERVER taxi_srv
OPTIONS (
user 'default',     -- ClickHouse 用户名
password ''         -- 密码为空（如有密码请修改）
);
```
# 5. 创建 schema映射外部clickhouse表
```
-- 创建 schema
CREATE SCHEMA IF NOT EXISTS taxi;
```
```
-- 导入表
IMPORT FOREIGN SCHEMA taxi FROM SERVER taxi_srv INTO taxi;
```
# 6. 查询验证
```
SELECT round(avg(tip_amount), 2) FROM taxi.trips;
```