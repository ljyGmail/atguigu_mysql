# 第12章 MySQL数据类型精讲
# 本章的内容测试建议使用MySQL5.7进行测试

# 1. 关于属性: character set name

SHOW VARIABLES LIKE 'character_%';

# 创建数据库时指定字符集
CREATE DATABASE IF NOT EXISTS dbtest12 CHARACTER SET 'utf8';

SHOW CREATE DATABASE dbtest12;

USE dbtest12;

# 创建表的时候，指明表的字符集
CREATE TABLE temp
(
    id INT
) CHARACTER SET 'utf8';

SHOW CREATE TABLE temp;

# 创建表，指明表中的字段时，可以指定字段的字符集
CREATE TABLE temp1
(
    id   INT,
    name VARCHAR(15) CHARACTER SET 'gbk'
);

SHOW CREATE TABLE temp1;

# 2. 整形数据类型

CREATE TABLE test_int1
(
    f1 TINYINT,
    f2 SMALLINT,
    f3 MEDIUMINT,
    f4 INTEGER,
    f5 BIGINT
);

DESC test_int1;

INSERT INTO test_int1(f1)
VALUES (12),
       (-12),
       (-128),
       (127);

SELECT *
FROM test_int1;

# Out of range value for column 'f1' at row 1
INSERT INTO test_int1(f1)
VALUES (128);

CREATE TABLE test_int2
(
    f1 INT,
    f2 INT(5),
    f3 INT(5) ZEROFILL # ① 显示宽度为5.当insert的值不足5位时，使用0填充。 ② 当使用ZEROFILL时，自动会添加UNSIGNED。
);

INSERT INTO test_int2(f1, f2)
VALUES (123, 123),
       (123456, 123456);

SELECT *
FROM test_int2;

INSERT INTO test_int2(f3)
VALUES (123),
       (123456);

SHOW CREATE TABLE test_int2;

CREATE TABLE test_int3
(
    f1 INT UNSIGNED
);

DESC test_int3;

INSERT INTO test_int3
VALUES (2412321);

# Out of range value for column 'f1' at row 1
INSERT INTO test_int3
VALUES (4294967296);


# 3. 浮点类型
CREATE TABLE test_double1
(
    f1 FLOAT,
    f2 FLOAT(5, 2),
    f3 DOUBLE,
    f4 DOUBLE(5, 2)
);

DESC test_double1;

INSERT INTO test_double1(f1, f2)
VALUES (123.45, 123.45);

SELECT *
FROM test_double1;

INSERT INTO test_double1(f3, f4)
VALUES (123.45, 123.456);
# 存在四舍五入

# Out of range value for column 'f4' at row 1
INSERT INTO test_double1(f3, f4)
VALUES (123.45, 1234.456);

# Out of range value for column 'f4' at row 1
INSERT INTO test_double1(f3, f4)
VALUES (123.45, 999.995);

# 测试FLOAT和DOUBLE的精度问题
CREATE TABLE test_double2
(
    f1 DOUBLE
);

INSERT INTO test_double2
VALUES (0.47),
       (0.44),
       (0.19);

SELECT *
FROM test_double2;

SELECT SUM(f1)
FROM test_double2;

SELECT SUM(f1) = 1.1, 1.1 = 1.1
FROM test_double2;

# 4. 定点数类型
CREATE TABLE test_decimal1
(
    f1 DECIMAL,
    f2 DECIMAL(5, 2)
);

DESC test_decimal1;

INSERT INTO test_decimal1(f1)
VALUES (123),
       (123.45);

SELECT *
FROM test_decimal1;

INSERT INTO test_decimal1(f2)
VALUES (999.99);

INSERT INTO test_decimal1(f2)
VALUES (67.567);
# 存在四舍五入

# Out of range value for column 'f2' at row 1
INSERT INTO test_decimal1(f2)
VALUES (1267.567);

# Out of range value for column 'f2' at row 1
INSERT INTO test_decimal1(f2)
VALUES (999.995);

# 演示DECIMAL替换DOUBLE。体现精度。
ALTER TABLE test_double2
    MODIFY f1 decimal(5, 2);

DESC test_double2;

SELECT SUM(f1)
FROM test_double2;

SELECT SUM(f1) = 1.1, 1.1 = 1.1
FROM test_double2;

# 5. 位类型: BIT
CREATE TABLE test_bit1
(
    f1 BIT,
    f2 BIT(5),
    f3 BIT(64)
);

DESC test_bit1;

INSERT INTO test_bit1(f1)
VALUES (0),
       (1);

SELECT *
FROM test_bit1;

# Out of range value for column 'f1' at row 1
INSERT INTO test_bit1(f1)
VALUES (2);

INSERT INTO test_bit1(f2)
VALUES (31);

# Out of range value for column 'f2' at row 1
INSERT INTO test_bit1(f2)
VALUES (32);

SELECT BIN(f1), BIN(f2), HEX(f1), HEX(f2)
FROM test_bit1;

# 此时+0以后，可以以十进制的方式显示数据
SELECT f1 + 0, f2 + 0
FROM test_bit1;

