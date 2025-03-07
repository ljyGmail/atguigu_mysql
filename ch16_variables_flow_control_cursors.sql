# 第16章 变量、流程控制与游标

# 1. 变量
# 1.1 变量: 系统变量(全局系统变量、会话系统变量) vs 用户自定义变量

# 1.2 查看系统变量
# 查询全局系统变量
SHOW GLOBAL VARIABLES;
# 617

# 查询会话系统变量
SHOW SESSION VARIABLES; # 640

SHOW VARIABLES;
# 默认查询的是会话系统变量

# 查询部分系统变量
SHOW GLOBAL VARIABLES LIKE 'admin_%';

SHOW VARIABLES LIKE 'character_%';

# 1.3 查看指定系统变量
SELECT @@global.max_connections;
SELECT @@global.character_set_client;

# 错误:
# SELECT @@global.pseudo_thread_id;

# 错误:
# SELECT @@session.max_connections;

SELECT @@session.character_set_client;
SELECT @@session.pseudo_thread_id;

SELECT @@character_set_client;
# 先查询会话系统变量，再查询全局系统变量

# 1.4 修改系统变量的值
# 全局系统变量
# 方式1:
SET @@global.max_connections = 161;
# 方式2:
SET GLOBAL max_connections = 171;

# 针对有当前的数据库实例是有效的，一旦重启mysql服务，就失效了。

# 会话系统变量
# 方式1:
SET @@session.character_set_client = 'gbk';
# 方式2:
SET SESSION character_set_client = 'gbk';

# 针对于当前会话是有效的，一旦结束会话，重新建立起新的会话，就失效了。


# 1.5 用户变量
/*
① 用户变量: 会话用户变量 vs 局部变量

② 会话用户变量: 使用"@"开头，作用域为当前会话。
③ 局部变量: 只能使用在存储过程和存储函数中。
 */

# 1.6 会话用户变量
/*
变量的声明和赋值:
# 方式1: "="或":="
SET @用户变量 = 值
SET @用户变量 := 值

# 方式2: ":="或 INTO关键字
SELECT @用户变量 := 表达式 [FROM 等字句];
SELECT 表达式 INTO @用户变量 [FROM 等字句];

② 使用
SELECT @变量名;
*/

# 准备工作
CREATE DATABASE dbtest16;

USE dbtest16;

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

# 测试:
# 方式1:
SET @m1 = 1;
SET @m2 := 2;
SET @sum := @m1 + @m2;

SELECT @sum;

# 方式2:
SELECT @count := COUNT(*)
FROM employees;

SELECT @count;

SELECT AVG(salary)
INTO @avg_sal
FROM employees;

SELECT @avg_sal;

# 1.7 局部变量
/*
1. 局部变量必须
① 使用declare声明
② 声明并使用在BEGIN ... END中 (使用在存储过程、函数中)
③ DECLARE的方式声明的局部变量必须声明在BEGIN中的首行位置。

2. 声明格式
DECLARE 变量名 类型 [default 值];  # 如果没有DEFAULT子句，初始值为NULL

3. 赋值
方式1:
SET 变量名=值
SET 变量名:=值

方式2:
SELECT 字段名或表达式 INTO 变量名 FROM 表;

4. 使用
SELECT 局部变量名;
 */

# 举例:
DELIMITER //

CREATE PROCEDURE test_var()
BEGIN
    # 声明局部变量
    DECLARE a INT DEFAULT 0;
    DECLARE b INT;

    # DECLARE A, B INT DEFAULT 0;
    DECLARE emp_name VARCHAR(25);

    # 赋值
    SET a = 1;
    SET b := 2;

    SELECT last_name
    INTO emp_name
    FROM employees
    WHERE employee_id = 101;

    # 使用
    SELECT a, b, emp_name;
END //

DELIMITER ;

# 调用存储过程
CALL test_var();

# 举例1: 声明局部变量，并分别赋值为employees表中employee_id为102的last_name和salary。
DELIMITER //

CREATE PROCEDURE test_pro()
BEGIN
    DECLARE emp_name VARCHAR(25);
    DECLARE sal DOUBLE(10, 2) DEFAULT 0.0;
    # 赋值
    SELECT last_name, salary
    INTO emp_name,sal
    FROM employees
    WHERE employee_id = 102;

    # 使用
    SELECT emp_name, sal;
END //

DELIMITER ;

# 调用存储过程
CALL test_pro();

SELECT last_name, salary
FROM employees
WHERE employee_id = 102;

# 举例2: 声明两个变量，求和并打印(分别使用会话用户变量、局部变量的方式实现)

# 方式1: 使用会话用户变量
SET @v1 = 10;
SET @v2 := 20;
SET @result := @v1 + @v2;

# 查看
SELECT @result;

# 方式2: 使用局部变量
DELIMITER //

CREATE PROCEDURE add_value()
BEGIN
    # 声明
    DECLARE value1,value2,sum_val INT;
    # 赋值
    SET value1 = 10;
    SET value2 := 100;

    SET sum_val = value1 + value2;
    # 使用
    SELECT sum_val;
END //

DELIMITER ;

# 调用存储过程
CALL add_value();

# 举例3: 创建存储过程"different_salary"查询某员工和他领导的薪资差距，
# 并用IN参数emp_id接收员工id，用OUT参数dif_salary输出薪资差距结果。
DELIMITER //

CREATE PROCEDURE different_salary(IN emp_id INT, OUT dif_salary DOUBLE)
BEGIN
    # 分析: 查询出emp_id员工的工资; 查询出emp_id员工的管理者id的工资; 计算两个工资的差值

    # 声明变量
    DECLARE emp_sal DOUBLE DEFAULT 0.0; # 记录员工的工资
    DECLARE mgr_sal DOUBLE DEFAULT 0.0;
    # 记录管理者的工资

    DECLARE mgr_id INT DEFAULT 0;
    # 记录管理者的id

    # 赋值
    SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;

    SELECT manager_id INTO mgr_id FROM employees WHERE employee_id = emp_id;
    SELECT salary INTO mgr_sal FROM employees WHERE employee_id = mgr_id;

    SET dif_salary = mgr_sal - emp_sal;
END //

DELIMITER ;

# 调用存储过程
SET @emp_id := 103;
SET @dif_sal := 0;
CALL different_salary(@emp_id, @dif_sal);

SELECT @dif_sal;


# 2. 定义条件和处理程序
# 2.1 错误演示:
# 错误代码: [1364]
# Field 'email' doesn't have a default value
INSERT INTO employees(last_name)
VALUES ('Tom');

DESC employees;

# 错误演示
DELIMITER //

CREATE PROCEDURE UpdateDataNoCondition()
BEGIN
    SET @x = 1;
    UPDATE employees SET email=NULL WHERE last_name = 'Abel';
    SET @x = 2;
    UPDATE employees SET email='aabbel' WHERE last_name = 'Abel';
    SET @x = 3;
END //

DELIMITER ;

# 调用存储过程
# 错误代码: 1048
# Column 'email' cannot be null
CALL UpdateDataNoCondition();

SELECT @x;

# 2.2 定义条件
# 格式: DECLARE 错误名称 CONDITION FOR 错误码(或错误条件)

# 举例1: 定义"Field_Not_Be_NULL"错误名与MySQL中违反非空约束的错误类型是"Error 1048 (23000)"对应。

# 方式1: 使用MySQL_error_code
# DECLARE Field_Not_Be_NULL CONDITION FOR 1048;

# 方式2: 使用sqlstate_value
# DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';

# 举例2: 定义"ERROR 1148 (42000)"错误，名称为command_not_allowed。
# 方式1: 使用MySQL_error_code
# DECLARE command_not_allowed CONDITION FOR 1148;

# 方式2: 使用sqlstate_value
# DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000';

# 2.3 定义处理程序
# 格式: DECLARE 处理方式 HANDLER FOR 错误类型 处理语句

#方法1：捕获sqlstate_value
# DECLARE CONTINUE
# HANDLER FOR SQLSTATE '42S02' SET @info = 'NO_SUCH_TABLE';

#方法2：捕获mysql_error_value
# DECLARE CONTINUE
# HANDLER FOR 1146 SET @info = 'NO_SUCH_TABLE';

#方法3：先定义条件，再调用
# DECLARE no_such_table CONDITION FOR 1146;
# DECLARE CONTINUE
# HANDLER FOR NO_SUCH_TABLE SET @info = 'NO_SUCH_TABLE';

#方法4：使用SQLWARNING
# DECLARE EXIT
# HANDLER FOR SQLWARNING SET @info = 'ERROR';

#方法5：使用NOT FOUND
# DECLARE EXIT
# HANDLER FOR NOT FOUND SET @info = 'NO_SUCH_TABLE';

#方法6：使用SQLEXCEPTION
# DECLARE EXIT
# HANDLER FOR SQLEXCEPTION SET @info = 'ERROR';

# 2.4 案例的处理
DROP PROCEDURE UpdateDataNoCondition;

# 重新定义存储过程，体现错误的错误程序
DELIMITER //

CREATE PROCEDURE UpdateDataNoCondition()
BEGIN
    # 声明处理程序
    # 处理方式1:
    DECLARE CONTINUE HANDLER FOR 1048 SET @prc_value = -1;

    # 处理方式2:
    # DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @prc_value = -1;

    SET @x = 1;
    UPDATE employees SET email=NULL WHERE last_name = 'Abel';
    SET @x = 2;
    UPDATE employees SET email='aabbel' WHERE last_name = 'Abel';
    SET @x = 3;
END //

DELIMITER ;

# 调用存储过程
CALL UpdateDataNoCondition();

SELECT @x, @prc_value;

# 2.5 再举一个例子:
# 创建一个名称为“InsertDataWithCondition”的存储过程
# ① 准备工作
CREATE TABLE departments
AS
SELECT *
FROM atguigudb.`departments`;

DESC departments;

ALTER TABLE departments
    ADD CONSTRAINT uk_dept_name UNIQUE (department_id);

# ② 定义存储过程:
DELIMITER //
CREATE PROCEDURE InsertDataWithCondition()
BEGIN
    SET @x = 1;
    INSERT INTO departments(department_name) VALUES ('测试');
    SET @x = 2;
    INSERT INTO departments(department_name) VALUES ('测试');
    SET @x = 3;
END //
DELIMITER ;

# ③ 调用
CALL InsertDataWithCondition();

SELECT @x;
# 2

# ④ 删除此存储过程
DROP PROCEDURE IF EXISTS InsertDataWithCondition;

# ⑤ 重新定义存储过程(考虑到错误的处理程序)
DELIMITER //
CREATE PROCEDURE InsertDataWithCondition()
BEGIN
    # 处理程序
    # 方式1:
    # DECLARE EXIT HANDLER FOR 1062 SET @pro_value = -1;
    # 方式2:
    # DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET @pro_value = -1;
    # 方式3:
    # 定义条件
    DECLARE duplicate_entry CONDITION FOR 1062;
    DECLARE EXIT HANDLER FOR duplicate_entry SET @pro_value = -1;

    SET @x = 1;
    INSERT INTO departments(department_name) VALUES ('测试');
    SET @x = 2;
    INSERT INTO departments(department_name) VALUES ('测试');
    SET @x = 3;
END //
DELIMITER ;

# 调用
CALL InsertDataWithCondition();

SELECT @x, @pro_value;

