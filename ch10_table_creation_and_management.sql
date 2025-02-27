# 第10章 创建和管理表

SELECT *
FROM `order`;

# 1. 创建和管理数据库

# 1.1 如何创建数据库
# 方式1:
# 创建的此数据库使用的是默认的字符集
CREATE DATABASE mytest1;

# 查看创建数据库的结构
SHOW CREATE DATABASE mytest1;

# 方式2: 显式指定了要创建的数据库的字符集
CREATE DATABASE mytest2 CHARACTER SET 'gbk';

SHOW CREATE DATABASE mytest2;

# 方式3 (推荐): 如果要创建的数据库已经存在，则创建不成功，但不会报错。
CREATE DATABASE IF NOT EXISTS mytest2 CHARACTER SET 'utf8';

# 如果要创建的数据库不存在，则创建成功。
CREATE DATABASE IF NOT EXISTS mytest3 CHARACTER SET 'utf8';

# 1.2 管理数据库
# 查看当前连接中的数据库有哪些
SHOW DATABASES;

# 切换数据库
USE atguigudb;

# 查看当前数据库中保存的数据表
SHOW TABLES;

# 查看当前使用的数据库
SELECT DATABASE()
FROM dual;

# 查看指定数据库下保存的数据表
SHOW TABLES FROM mysql;

# 1.3 修改数据库
# 更改数据库的字符集
SHOW CREATE DATABASE mytest2;

ALTER DATABASE mytest2 CHARACTER SET 'utf8';

# 1.4 删除数据库
# 方式1:
DROP DATABASE mytest1;

SHOW DATABASES;

# 方式2: 推荐。 如果要删除的数据库存在，则删除成功。如果不存在，则默默结束，不会报错。
DROP DATABASE IF EXISTS mytest1;
DROP DATABASE IF EXISTS mytest2;


# 2. 如何创建数据表
USE atguigudb;
SHOW CREATE DATABASE atguigudb;
SHOW TABLES;
# 方式1: "白手起家"的方式
CREATE TABLE IF NOT EXISTS myemp1 # 需要用户具备创建表的权限
(
    id        INT,
    emp_name  VARCHAR(15), # 使用VARCHAR来定义字符串，必须在使用VARCHAR时指明其长度
    hire_date DATE
);

DESC myemp1;

# 查看创建表的语句结构
SHOW CREATE TABLE myemp1;
# 如果创建表时没有指明使用的字符集，则默认使用表所在的数据库的字符集

# 查看表数据
SELECT *
FROM myemp1;

# 方式2: 基于现有的表，同时导入数据
CREATE TABLE myemp2
AS
SELECT employee_id, last_name, salary
FROM employees;

DESC myemp2;
DESC employees;

SELECT *
FROM myemp2;

# 说明1: 查询语句中字段的别名，可以作为新创建的表的字段的名称。
# 说明2: 此时的查询语句可以结构比较丰富，使用前面章节讲过的各种SELECT。
CREATE TABLE myemp3
AS
SELECT e.employee_id emp_id, e.last_name lname, d.department_name
FROM employees e
         JOIN departments d
              ON e.department_id = d.department_id;

SELECT *
FROM myemp3;

DESC myemp3;

# 练习1: 创建一个表employees_copy，实现对employees表的复制，包括表数据。
CREATE TABLE employees_copy
AS
SELECT *
FROM employees;

SELECT *
FROM employees_copy;

# 练习2: 创建一个表employees_blank，实现对employees表的复制，不包括表数据。
CREATE TABLE employees_blank
AS
SELECT *
FROM employees
# WHERE department_id > 10000;
WHERE 1 = 2; # 山无棱，天地合，乃敢与君绝。

SELECT *
FROM employees_blank;
