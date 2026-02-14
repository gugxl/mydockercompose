-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS datax
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 创建用户（如果不存在），使用 mysql_native_password 认证
CREATE USER IF NOT EXISTS 'datax'@'%'
IDENTIFIED WITH mysql_native_password BY 'datax123';

-- 授权
GRANT ALL PRIVILEGES ON datax.* TO 'datax'@'%';

-- 刷新权限
FLUSH PRIVILEGES;