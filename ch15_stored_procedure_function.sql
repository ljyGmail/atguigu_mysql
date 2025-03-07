# 第15章 存储过程与存储函数

# 准备工作
CREATE DATABASE dbtest15;

USE dbtest15;

CREATE TABLE employees
AS
SELECT *
FROM atguigudb.employees;

CREATE TABLE departments
AS
SELECT *
FROM atguigudb.departments;

SELECT *
FROM employees;

SELECT *
FROM departments;

# 1. 创建存储过程
# 类型1: 无参数无返回值

# 举例1: 创建存储过程select_all_data()，查看 employees 表的所有数据
DELIMITER $

CREATE PROCEDURE select_all_data()
BEGIN
    SELECT * FROM employees;
END $

DELIMITER ;

# 2. 存储过程的调用
CALL select_all_data();

# 举例2: 创建存储过程avg_employee_salary()，返回所有员工的平均工资
DELIMITER //

CREATE PROCEDURE avg_employee_salary()
BEGIN
    SELECT AVG(salary) FROM employees;
END //

DELIMITER ;

# 调用
CALL avg_employee_salary();

# 举例3: 创建存储过程show_max_salary()，用来查看"emps"表的最高薪资值
DELIMITER //

CREATE PROCEDURE show_max_salary()
BEGIN
    SELECT MAX(salary) FROM employees;
END //

DELIMITER ;

# 调用
CALL show_max_salary();

# 类型2: 带 OUT
# 举例4: 创建存储过程show_min_salary()，查看"emps"表的最低薪资值。并将最低薪资
# 通过OUT参数"ms"输出。
DESC employees;

DELIMITER //

CREATE PROCEDURE show_min_salary(OUT ms DOUBLE)
BEGIN
    SELECT MIN(salary)
    INTO ms
    FROM employees;
END //

DELIMITER ;

# 调用
CALL show_min_salary(@ms);

# 查看变量值
SELECT @ms;

# 类型3: 带 IN
# 举例5: 创建存储过程show_someone_salary()，查看"emps"表的某个员工的薪资，
# 并用IN参数empname输入员工姓名。
DELIMITER //

CREATE PROCEDURE show_someone_salary(IN empname VARCHAR(20))
BEGIN
    SELECT salary
    FROM employees
    WHERE last_name = empname;
END //

DELIMITER ;

# 调用方式1:
CALL show_someone_salary('Abel');

# 调用方式2:
SET @empname := 'Abel';
CALL show_someone_salary(@empname);

# 类型4: 带 IN 和 OUT
# 举例6: 创建存储过程show_someone_salary2()，查看"emps"表的某个员工的薪资，
# 并用IN参数empname输入员工姓名，用OUT参数empsalary输出员工薪资。
DELIMITER //

CREATE PROCEDURE show_someone_salary2(IN empname VARCHAR(20), OUT empsalary DECIMAL(10, 2))
BEGIN
    SELECT salary
    INTO empsalary
    FROM employees
    WHERE last_name = empname;
END //

DELIMITER ;

# 调用
SET @empname = 'Abel';
CALL show_someone_salary2(@empname, @empsalary);

SELECT @empsalary;

# 类型5: 带 INOUT
# 举例7: 创建存储过程show_mgr_name()，查询某个员工领导的姓名，并用INOUT参数"empname"输入员工的姓名。
# 输出领导的姓名。
DESC employees;

DELIMITER $

CREATE PROCEDURE show_mgr_name(INOUT empname VARCHAR(25))
BEGIN
    SELECT last_name
    INTO empname
    FROM employees
    WHERE employee_id = (SELECT manager_id
                         FROM employees
                         WHERE last_name = empname);
END $

DELIMITER ;

# 调用
SET @empname := 'Abel';
CALL show_mgr_name(@empname);

SELECT @empname;

SELECT last_name
FROM employees
WHERE employee_id = (SELECT manager_id
                     FROM employees
                     WHERE last_name = 'Abel');


# 2. 存储函数

# 举例1: 创建存储函数，名称为email_by_name()，参数定义为空，
# 该函数查询Abel的email，并返回，数据类型为字符串型。
DELIMITER //

CREATE FUNCTION email_by_name()
    RETURNS VARCHAR(25)
    DETERMINISTIC
    CONTAINS SQL
    READS SQL DATA
BEGIN
    RETURN (SELECT email FROM employees WHERE last_name = 'Abel');
END //

DELIMITER ;

# 调用
SELECT email_by_name();

SELECT email, last_name
FROM employees
WHERE last_name = 'Abel';

# 举例2: 创建存储函数，名称为email_by_id()，参数传入emp_id，该函数查询emp_id的email，
# 并返回，数据类型为字符串型。

# 创建函数前执行此语句，保证函数的创建会成功。
SET GLOBAL LOG_BIN_TRUST_FUNCTION_CREATORS = 1;

DELIMITER //

CREATE FUNCTION email_by_id(emp_id INT)
    RETURNS VARCHAR(25)
BEGIN
    RETURN (SELECT email FROM employees WHERE employee_id = emp_id);
END //

DELIMITER ;

# 调用
SELECT email_by_id(101);

SET @emp_id := 102;
SELECT email_by_id(@emp_id);

# 举例3: 创建存储函数count_by_id()，参数传入dept_id，该函数查询dept_id部门的
# 员工人数，并返回，数据类型为整型。
DELIMITER //

CREATE FUNCTION count_by_id(dept_id INT)
    RETURNS INT
BEGIN
    RETURN (SELECT COUNT(*) FROM employees WHERE department_id = dept_id);
END //

DELIMITER ;

# 调用
SET @dept_id := 50;
SELECT count_by_id(@dept_id);


# 3. 存储过程、存储函数的查看

# 方式① 使用SHOW CREATE语句查看存储过程和函数的创建信息
SHOW CREATE PROCEDURE show_mgr_name;

SHOW CREATE FUNCTION count_by_id;

# 方式② 使用SHOW STATUS语句查看存储过程和函数的状态信息
SHOW PROCEDURE STATUS;

SHOW PROCEDURE STATUS LIKE 'show_max_salary';

SHOW FUNCTION STATUS LIKE 'email_by_id';

# 方式③ 从information_schema.Routines表中查看存储过程和函数的信息
SELECT *
FROM information_schema.ROUTINES
WHERE ROUTINE_NAME = 'email_by_id'
  AND ROUTINE_TYPE = 'FUNCTION';

SELECT *
FROM information_schema.ROUTINES
WHERE ROUTINE_NAME = 'show_min_salary'
  AND ROUTINE_TYPE = 'PROCEDURE';

# 4. 存储过程、函数的修改
ALTER PROCEDURE show_max_salary
    SQL SECURITY INVOKER
    COMMENT '查询最高工资';

# 5. 存储过程、函数的删除
DROP FUNCTION IF EXISTS count_by_id;

DROP PROCEDURE IF EXISTS show_min_salary;


# 课后练习

# 存储过程练习
#0.准备工作
CREATE DATABASE test15_pro_func;

USE test15_pro_func;

#1. 创建存储过程insert_user(),实现传入用户名和密码，插入到admin表中
CREATE TABLE admin
(
    id        INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(15) NOT NULL,
    pwd       VARCHAR(25) NOT NULL
);

DELIMITER $

CREATE PROCEDURE insert_user(IN user_name VARCHAR(15), IN pwd VARCHAR(25))
BEGIN
    INSERT INTO admin (user_name, pwd)
    VALUES (user_name, pwd);
END $

DELIMITER ;

# 调用
CALL insert_user('Tom', 'abc123');

SELECT *
FROM admin;

#2. 创建存储过程get_phone(),实现传入女神编号，返回女神姓名和女神电话
CREATE TABLE beauty
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    NAME  VARCHAR(15) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    birth DATE
);

INSERT INTO beauty(NAME, phone, birth)
VALUES ('朱茵', '13201233453', '1982-02-12'),
       ('孙燕姿', '13501233653', '1980-12-09'),
       ('田馥甄', '13651238755', '1983-08-21'),
       ('邓紫棋', '17843283452', '1991-11-12'),
       ('刘若英', '18635575464', '1989-05-18'),
       ('杨超越', '13761238755', '1994-05-11');

SELECT *
FROM beauty;

DELIMITER //

CREATE PROCEDURE get_phone(IN id INT, OUT name VARCHAR(15), OUT phone VARCHAR(15))
BEGIN
    SELECT b.name, b.phone
    INTO name, phone
    FROM beauty b
    WHERE b.id = id;
END //

DELIMITER ;

CALL get_phone(3, @name, @phone);
SELECT @name, @phone;

#3. 创建存储过程date_diff()，实现传入两个女神生日，返回日期间隔大小
DELIMITER //

CREATE PROCEDURE date_diff(IN birth1 DATE, IN birth2 DATE, OUT sum_date INT)
BEGIN
    SELECT DATEDIFF(birth1, birth2) INTO sum_date;
END //

DELIMITER ;

# 调用
SET @birth1 = '1992-09-08';
SET @birth2 = '1992-10-30';
CALL date_diff(@birth1, @birth2, @sum_date);
SELECT @sum_date;

#4. 创建存储过程format_date(),实现传入一个日期，格式化成xx年xx月xx日并返回
DELIMITER //

CREATE PROCEDURE format_date(IN my_date DATE, OUT str_date VARCHAR(25))
BEGIN
    SELECT DATE_FORMAT(my_date, '%y年%m月%d日') INTO str_date;
END //

DELIMITER ;

# 调用
CALL format_date(CURDATE(), @str);
SELECT @str;

#5. 创建存储过程beauty_limit()，根据传入的起始索引和条目数，查询女神表的记录
DELIMITER //

CREATE PROCEDURE beauty_limit(IN startIndex INT, IN size INT)
BEGIN
    SELECT *
    FROM beauty
    LIMIT startIndex, size;
END //

DELIMITER ;

# 调用
CALL beauty_limit(1, 3);

#创建带inout模式参数的存储过程

#6. 传入a和b两个值，最终a和b都翻倍并返回
DELIMITER //

CREATE PROCEDURE add_double(INOUT a INT, INOUT b INT)
BEGIN
    SET a = a * 2;
    SET b = b * 2;
END //

DELIMITER ;

# 调用
SET @a = 3 ,@b = 5;
CALL add_double(@a, @b);
SELECT @a, @b;

#7. 删除题目5的存储过程
DROP PROCEDURE IF EXISTS beauty_limit;

#8. 查看题目6中存储过程的信息
SHOW CREATE PROCEDURE add_double;

SHOW PROCEDURE STATUS LIKE 'add_double';


# 存储函数练习

#0. 准备工作
USE test15_pro_func;

CREATE TABLE employees
AS
SELECT *
FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT *
FROM atguigudb.`departments`;

#无参有返回
#1. 创建函数get_count(),返回公司的员工个数
DELIMITER $

CREATE FUNCTION get_count()
    RETURNS INT

BEGIN
    RETURN (SELECT COUNT(*) FROM employees);
END $

DELIMITER ;

# 调用
SELECT get_count();

#有参有返回
#2. 创建函数ename_salary(),根据员工姓名，返回它的工资
DELIMITER $

CREATE FUNCTION ename_salary(emp_name VARCHAR(15))
    RETURNS DOUBLE
BEGIN
    RETURN (SELECT salary FROM employees WHERE last_name = emp_name);
END $

DELIMITER ;

# 调用
SELECT ename_salary('Abel');

#3. 创建函数dept_sal() ,根据部门名，返回该部门的平均工资
DELIMITER $

CREATE FUNCTION dept_sal(dept_name VARCHAR(30))
    RETURNS DOUBLE
BEGIN
    RETURN (SELECT AVG(salary)
            FROM employees e
                     JOIN departments d
                          ON e.department_id = d.department_id
            WHERE d.department_name = dept_name);
END $

DELIMITER ;

# 调用
SELECT *
FROM departments;

SELECT dept_sal('Marketing');

#4. 创建函数add_float()，实现传入两个float，返回二者之和
DELIMITER //

CREATE FUNCTION add_float(value1 FLOAT, value2 FLOAT)
    RETURNS FLOAT

BEGIN
    RETURN (SELECT value1 + value2);
END //

DELIMITER ;

# 调用
SET @v1 := 12.2;
SET @v2 := 2.3;
SELECT add_float(@v1, @v2);

