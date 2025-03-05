# 第13章 约束

/*
1. 基础知识
1.1 为什么需要约束？  为了保证数据的完整性

1.2 什么叫约束？  对表中字段的限制

1.3 约束的分类:
角度1: 约束的字段的个数
单列约束 vs 多列约束

角度2: 约束的作用范围

列级约束: 将此约束声明在对应字段的后面
表级约束: 在表中所有字段都声明完，在所有字段的后面声明的约束

角度3: 约束的作用(或功能)

① NOT NULL(非空约束)
② UNIQUE(唯一性约束)
③ PRIMARY KEY(主键约束)
④ FOREIGN KEY(外键约束)
⑤ CHECK(检查约束)
⑥ DEFAULT(默认值约束)

1.4 如何添加/删除约束？

CREATE TABLE时添加约束

ALTER TABLE时增加约束、删除约束
 */

# 2. 如何查看表中的约束
SELECT *
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'employees';

CREATE DATABASE dbtest13;

USE dbtest13;

# 3. NOT NULL(非空约束)
# 3.1 在CREATE TABLE时添加约束
CREATE TABLE test1
(
    id        INT         NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    email     VARCHAR(25),
    salary    DECIMAL(10, 2)
);

DESC test1;

INSERT INTO test1(id, last_name, email, salary)
VALUES (1, 'Tom', 'tom@126.com', 3400);

# 错误: Column 'last_name' cannot be null
INSERT INTO test1(id, last_name, email, salary)
VALUES (2, NULL, 'tom@126.com', 3400);

# 错误: Column 'id' cannot be null
INSERT INTO test1(id, last_name, email, salary)
VALUES (NULL, 'Jerry', 'jerry@126.com', 3400);

# 错误: Field 'last_name‘ doesn't have a default vaule
INSERT INTO test1(id, email)
VALUES (2, 'abc@126.com');

# 错误: Column 'last_name' cannot be null
UPDATE test1
SET email=NULL
WHERE id = 1;

SELECT *
FROM test1;

UPDATE test1
SET email='tom@126.com'
WHERE id = 1;

# 3.2 在ALTER TABLE时添加约束
DESC test1;

ALTER TABLE test1
    MODIFY email VARCHAR(25) NOT NULL;

# 3.3 在ALTER TABLE时删除约束
ALTER TABLE test1
    MODIFY email VARCHAR(25) NULL;


# 4. UNIQUE(唯一性约束)
# 4.1 在CREATE TABLE时添加约束
CREATE TABLE test2
(
    id        INT UNIQUE, # 列级约束
    last_name VARCHAR(15),
    email     VARCHAR(25),
    salary    DECIMAL(10, 2),
    # 表级约束
    CONSTRAINT uk_test2_email UNIQUE (email)
);

DESC test2;

SELECT *
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'test2';

# 在创建唯一约束的时候，如果不给唯一约束命名，就默认和列明相同。

INSERT INTO test2(id, last_name, email, salary)
VALUES (1, 'Tom', 'tom@126.com', 4500);

# 错误: Duplicate entry '1' for key 'test2.id'
INSERT INTO test2(id, last_name, email, salary)
VALUES (1, 'Tom1', 'tom1@126.com', 4600);

# 错误: Duplicate entry 'tom@126.com' for key 'test2.uk_test2_email'
INSERT INTO test2(id, last_name, email, salary)
VALUES (2, 'Tom1', 'tom@126.com', 4600);

# 可以向声明为UNIQUE的字段上添加NULL值。而且可以多次添加NULL值。
INSERT INTO test2(id, last_name, email, salary)
VALUES (2, 'Tom1', NULL, 4600);

INSERT INTO test2(id, last_name, email, salary)
VALUES (3, 'Tom2', NULL, 4600);

SELECT *
FROM test2;

# 4.2 在ALTER TABLE时添加约束
DESC test2;

UPDATE test2
SET salary=5000
WHERE id = 3;

# 方式1:
ALTER TABLE test2
    ADD CONSTRAINT uk_test2_sal UNIQUE (salary);

# 方式2:
ALTER TABLE test2
    MODIFY last_name VARCHAR(15) UNIQUE;

# 4.3 复合的唯一性约束
CREATE TABLE user
(
    id         INT,
    `name`     VARCHAR(15),
    `password` VARCHAR(25),
    # 表级约束
    CONSTRAINT uk_user_name_pwd UNIQUE (`name`, `password`)
);

INSERT INTO user
VALUES (1, 'Tom', 'abc');

# 可以成功的:
INSERT INTO user
VALUES (1, 'Tom1', 'abc');

SELECT *
FROM user;

# 案例: 复合唯一性约束的案例
# 学生表
CREATE TABLE student
(
    sid    INT,                 # 学号
    sname  VARCHAR(20),         # 姓名
    tel    CHAR(11) UNIQUE KEY, # 电话
    cardid CHAR(18) UNIQUE KEY  # 身份证号
);

# 课程表
CREATE TABLE course
(
    cid   INT,        # 课程编号
    cname VARCHAR(20) # 课程名称
);

# 选课表
CREATE TABLE student_course
(
    id    INT,
    sid   INT,            # 学号
    cid   INT,            # 课程编号
    score INT,
    UNIQUE KEY (sid, cid) # 复合唯一
);

INSERT INTO student
VALUES (1, '张三', '1371001002', '101223199012015623'); # 成功
INSERT INTO student
VALUES (2, '李四', '1371001003', '101223199012015624'); # 成功
INSERT INTO course
VALUES (1001, 'Java'),
       (1002, 'MySQL'); # 成功

SELECT *
FROM student;

SELECT *
FROM course;

INSERT INTO student_course
VALUES (1, 1, 1001, 89),
       (2, 1, 1002, 90),
       (3, 2, 1001, 88),
       (4, 2, 1002, 56);
# 成功


# 错误的: Duplicate entry '2-1002' for key 'student_course.sid'
INSERT INTO student_course
VALUES (5, 2, 1002, 67);

# 4.4 删除唯一性约束
-- 添加唯一性约束的列上也会自动创建唯一索引。
-- 删除唯一性约束只能通过删除唯一索引的方式删除。
-- 删除时需要指定唯一索引名，唯一索引名就和唯一约束名一样。
-- 如果创建唯一约束时未指定名称，如果是单列，就默认和列名相同; 如果是组合列，那么默认和()中排在第一个的列明相同。也可以自定义唯一性约束名。


SELECT *
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'student_course';

DESC test2;

SELECT *
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'test2';

# 如何删除唯一性索引
SHOW INDEX FROM test2;

ALTER TABLE test2
    DROP INDEX last_name;

ALTER TABLE test2
    DROP INDEX uk_test2_sal;

# 5. PRIMARY KEY(主键约束)
# 5.1 在CREATE TABLE时添加约束

# 一个表中最多只有一个主键约束
# 错误: Multiple primary key defined
CREATE TABLE test3
(
    id        INT PRIMARY KEY, # 列级约束
    last_name VARCHAR(15) PRIMARY KEY,
    salary    DECIMAL(10, 2),
    email     VARCHAR(25)
);

# 主键约束特征: 非空且唯一，用于唯一地标识表中的一条记录。
CREATE TABLE TEST4
(
    id        INT PRIMARY KEY, # 列级约束
    last_name VARCHAR(15),
    salary    DECIMAL(10, 2),
    email     VARCHAR(25)
);

# MySQL的主键名总是PRIMARY，就算自己命名了主键约束名也没用。
CREATE TABLE TEST5
(
    id        INT,
    last_name VARCHAR(15),
    salary    DECIMAL(10, 2),
    email     VARCHAR(25),
    # 表级约束
    CONSTRAINT pk_test5_id PRIMARY KEY (id) # 没有必要起名字。
);

SELECT *
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'test5';

INSERT INTO test4(id, last_name, salary, email)
VALUES (1, 'Tom', 4500, 'tom@126.com');

# 错误: Duplicate entry '1' for key 'test4.PRIMARY'
INSERT INTO test4(id, last_name, salary, email)
VALUES (1, 'Tom', 4500, 'tom@126.com');

# 错误: Column 'id' cannot be null
INSERT INTO test4(id, last_name, salary, email)
VALUES (NULL, 'Tom', 4500, 'tom@126.com');

SELECT *
FROM test4;

CREATE TABLE user1
(
    id       INT,
    name     VARCHAR(15),
    password VARCHAR(25),
    PRIMARY KEY (name, password)
);

# 如果是多列组合的复合主键约束，那么这些列都不允许为空值，并且组合的值不允许重复。
INSERT INTO user1
VALUES (1, 'Tom', 'abc');

INSERT INTO user1
VALUES (1, 'Tom1', 'abc');

# 错误: Column 'name' cannot be null
INSERT INTO user1
VALUES (1, NULL, 'abc');

# 5.2 在ALTER TABLE时添加约束
CREATE TABLE test6
(
    id        INT,
    last_name VARCHAR(15),
    salary    DECIMAL(10, 2),
    email     VARCHAR(25)
);

DESC test6;

ALTER TABLE test6
    ADD PRIMARY KEY (id);

# 4.3 如何删除主键约束(在实际开发中，不会去删除表中的主键约束！)
ALTER TABLE test6
    DROP PRIMARY KEY;


# 6. 自增长列: AUTO_INCREMENT
# 6.1 在CREATE TABLE时添加
CREATE TABLE test7
(
    id        INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(15)
);

# 开发中，一旦主键作用的字段上声明有auto_increment，则我们在添加数据时，
# 就不要给主键对应的字段去赋值了。
INSERT INTO test7(last_name)
VALUES ('Tom');

SELECT *
FROM test7;

# 当我们向主键(含AUTO_INCREMENT)的字段添加0或NULL时，实际上会自动地往上添加指定的字段的数值
INSERT INTO test7 (id, last_name)
VALUES (0, 'Tom');

INSERT INTO test7 (id, last_name)
VALUES (NULL, 'Tom');

INSERT INTO test7 (id, last_name)
VALUES (10, 'Tom');

INSERT INTO test7 (id, last_name)
VALUES (-10, 'Tom');

# 6.2 在ALTER TABLE时添加
CREATE TABLE test8
(
    id        INT PRIMARY KEY,
    last_name VARCHAR(15)
);

DESC test8;

ALTER TABLE test8
    MODIFY id INT AUTO_INCREMENT;

# 6.3 在ALTER TABLE时删除
ALTER TABLE test8
    MODIFY id INT;

# 6.4 MySQL 8.0新特性 - 自增变量的持久化
# 在MySQL 5.7中演示
CREATE DATABASE dbtest13;
USE dbtest13;

CREATE TABLE test9
(
    id INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO test9
VALUES (0),
       (0),
       (0),
       (0);

SELECT *
FROM test9;

DELETE
FROM test9
WHERE id = 4;

INSERT INTO test9
VALUES (0);

DELETE
FROM test9
WHERE id = 5;

# 重启服务器
SELECT *
FROM test9;

INSERT INTO test9
VALUES (0);

# 在MySQL 8.0中演示
CREATE TABLE test9
(
    id INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO test9
VALUES (0),
       (0),
       (0),
       (0);

SELECT *
FROM test9;

DELETE
FROM test9
WHERE id = 4;

INSERT INTO test9
VALUES (0);

DELETE
FROM test9
WHERE id = 5;

# 重启服务器
SELECT *
FROM test9;

INSERT INTO test9
VALUES (0);

