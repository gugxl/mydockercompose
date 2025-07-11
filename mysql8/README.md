虽然只有一个镜像，但是为了统一管理也使用了docker compose


# 直接启动命令
```
docker run --restart=always --name mysql8.0 -p 3306:3306 -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:8.0.22           
```

#这个参数是是设置用户名为root  密码为root