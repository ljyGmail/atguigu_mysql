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

