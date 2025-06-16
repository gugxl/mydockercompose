虽然只有一个镜像，但是为了统一管理也使用了docker compose


# 直接启动命令
```
docker run --name postgres17 -d -p 5432:5432 -e POSTGRES_PASSWORD=asd -e POSTGRES_USER=postgres -e POSTGRES_DB=postgres -v postgres17-data:/var/lib/postgresql/data postgres:17.5
```

