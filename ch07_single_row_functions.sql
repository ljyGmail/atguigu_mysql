# 第07章 单行函数

# 1. 数值函数
# 基本操作
SELECT ABS(-123),
       ABS(32),
       SIGN(-23),
       SIGN(43),
       PI(),
       CEIL(32.32),
       CEILING(-43.23),
       FLOOR(32.32),
       FLOOR(-43.23),
       MOD(12, 5)
FROM dual;

# 取随机数
SELECT RAND(), RAND(), RAND(10), RAND(10), RAND(-1), RAND(-1)
FROM dual;

# 四舍五入，截断操作
SELECT ROUND(123.556),
       ROUND(123.456, 0),
       ROUND(123.456, 1),
       ROUND(123.456, 2),
       ROUND(123.456, -1),
       ROUND(153.456, -2)
FROM dual;

SELECT TRUNCATE(123.456, 0), TRUNCATE(123.496, 1), TRUNCATE(129.45, -1)
FROM dual;

# 单行函数可以嵌套
SELECT TRUNCATE(ROUND(123.456, 2), 0)
FROM dual;

# 角度与弧度的互换
SELECT RADIANS(30), RADIANS(45), RADIANS(60), RADIANS(90)
FROM dual;

SELECT DEGREES(2 * PI()), DEGREES(RADIANS(60))
FROM dual;

# 三角函数
SELECT SIN(RADIANS(30)), DEGREES(ASIN(1)), TAN(RADIANS(45)), DEGREES(ATAN(1))
FROM dual;

# 指数和对数
SELECT POW(2, 5), POW(2, 4), EXP(2)
FROM dual;

SELECT LN(EXP(2)), LOG(EXP(2)), LOG10(10), LOG2(4)
FROM dual;

# 进制间的转换
SELECT BIN(10), HEX(10), OCT(10), CONV(10, 10, 8)
FROM DUAL;

# 2. 字符串函数

SELECT ASCII('Abcdsfsdf'), CHAR_LENGTH('hello'), CHAR_LENGTH('我们'), LENGTH('hello'), LENGTH('我们')
FROM dual;

# xxx worked for yyy
SELECT CONCAT(emp.last_name, ' worked for ', mgr.last_name) "details"
FROM employees emp
         JOIN employees mgr
              ON emp.manager_id = mgr.employee_id;

SELECT CONCAT_WS('-', 'hello', 'world', 'hello', 'beijing')
FROM dual;

# 字符串的索引是从1开始的
SELECT INSERT('helloworld', 2, 3, 'aaaaa'), REPLACE('hello', 'll', 'mmm')
FROM dual;

SELECT UPPER('Hello'), LOWER('HeLLo')
FROM dual;

SELECT last_name, salary
FROM employees
WHERE LOWER(last_name) = 'King';

SELECT LEFT('hello', 2), RIGHT('hello', 3), RIGHT('hello', 13)
FROM dual;

# LPAD: 实现右对齐效果
# RPAD: 实现左对齐效果
SELECT employee_id, last_name, salary, LPAD(salary, 10, ' ')
FROM employees;

SELECT CONCAT('---', LTRIM('          he l  l o     '), '***'),
       TRIM('oo' FROM 'ooooheollo')
FROM dual;

SELECT REPEAT('hello', 4), LENGTH(SPACE(5)), STRCMP('abc', 'abd')
FROM dual;

SELECT SUBSTR('hello', 2, 2), LOCATE('lll', 'hello')
FROM dual;

SELECT ELT(2, 'a', 'b', 'c', 'd'),
       FIELD('mm', 'gg', 'jj', 'mm', 'dd', 'mm'),
       FIND_IN_SET('mm', 'gg,,jj,dd,mm,gg')
FROM dual;

SELECT employee_id, NULLIF(LENGTH(first_name), LENGTH(last_name)) "compare"
FROM employees;

