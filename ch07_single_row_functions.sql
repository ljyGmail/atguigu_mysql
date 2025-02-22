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

# 3. 日期和时间函数

# 3.1 获取日期、时间
SELECT CURDATE(), CURRENT_DATE(), CURTIME(), NOW(), SYSDATE(), UTC_DATE(), UTC_TIME()
FROM dual;

SELECT CURDATE(), CURDATE() + 0, CURTIME(), CURTIME() + 0, NOW() + 0
FROM dual;

# 3.2 日期与时间戳的转换
SELECT UNIX_TIMESTAMP()
     , UNIX_TIMESTAMP('2025-02-22 20:28:31')
     , FROM_UNIXTIME(1740223607)
     , FROM_UNIXTIME(1740223711)
FROM dual;

# 3.3 获取月份、星期、星期数、天数等函数
SELECT YEAR(CURDATE()),
       MONTH(CURDATE()),
       DAY(CURDATE()),
       HOUR(CURTIME()),
       MINUTE(NOW()),
       SECOND(SYSDATE())
FROM dual;

SELECT MONTHNAME('2021-10-26'),
       DAYNAME('2021-10-26'),
       WEEKDAY('2021-10-26'),
       QUARTER(CURDATE()),
       WEEK(CURDATE()),
       DAYOFYEAR(NOW()),
       DAYOFMONTH(NOW()),
       DAYOFWEEK(NOW())
FROM dual;

# 3.4 日期的操作函数
SELECT EXTRACT(SECOND FROM NOW()),
       EXTRACT(DAY FROM NOW()),
       EXTRACT(HOUR FROM NOW()),
       EXTRACT(QUARTER FROM '2025-05-12')
FROM dual;

# 3.5 时间和秒钟转换的函数
SELECT TIME_TO_SEC(CURTIME()), SEC_TO_TIME(74563)
FROM dual;

# 3.6 计算日期和时间的函数
SELECT NOW()
     , DATE_ADD(NOW(), INTERVAL 1 YEAR)
     , DATE_ADD(NOW(), INTERVAL -1 YEAR)
     , DATE_SUB(NOW(), INTERVAL 1 YEAR)
FROM dual;

SELECT DATE_ADD(NOW(), INTERVAL 1 DAY)                               AS col1,
       DATE_ADD('2025-02-22 20:48:30', INTERVAL 1 SECOND)            AS col2,
       ADDDATE('2025-02-22 20:48:40', INTERVAL 1 SECOND)             AS col3,
       DATE_ADD('2025-02-22 20:48:40', INTERVAL '1_1' MINUTE_SECOND) AS col4,
       DATE_ADD(NOW(), INTERVAL -1 YEAR)                             AS col5, # 可以是负数
       DATE_ADD(NOW(), INTERVAL '1_1' YEAR_MONTH)                    AS col6  # 需要单引号
FROM dual;

SELECT ADDTIME(NOW(), 20),
       SUBTIME(NOW(), '1:1:3'),
       DATEDIFF(NOW(), '2025-02-01'),
       TIMEDIFF(NOW(), '2025-02-21 08:02:10'),
       FROM_DAYS(366),
       TO_DAYS('0000-12-25'),
       LAST_DAY(NOW()),
       MAKEDATE(YEAR(NOW()), 12),
       MAKETIME(10, 21, 23),
       PERIOD_ADD(20200101010101, 10)
FROM dual;

# 3.7 日期的格式化与解析
# 格式化: 日期 --> 字符串
# 解析: 字符串 --> 日期

# 此时我们谈的是日期的显式格式化和解析

# 此前，我们接触过隐式的格式化或解析

SELECT *
FROM employees
WHERE hire_date = '1993-01-13';

# 格式化
SELECT DATE_FORMAT(CURDATE(), '%Y-%M-%D'),
       DATE_FORMAT(NOW(), '%Y-%m-%d'),
       TIME_FORMAT(CURTIME(), '%h:%i:%S'),
       DATE_FORMAT(NOW(), '%Y-%M-%D %h-%i:%S %W %w %T %r')
FROM dual;

# 解析: 格式化的逆过程
SELECT STR_TO_DATE('2025-February-22nd 09-25:56 Saturday 6', '%Y-%M-%D %h-%i:%S %W %w')
FROM dual;

SELECT GET_FORMAT(DATE, 'USA')
FROM dual;

SELECT DATE_FORMAT(CURDATE(), GET_FORMAT(DATE, 'USA'))
FROM dual;

