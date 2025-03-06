# 第14章 视图(View)
/*
1. 视图的理解

① 视图，可以看作是一个虚拟表，本身是不存储数据的。
    视图的本质，就可以看作是存储起来的SELECT语句。

② 视图中SELECT语句中涉及到的表，称为基表。

③ 针对视图做DML操作，会影响到对应的基表中的数据。反之亦然。

④ 视图本身的删除，不会导致基表中数据的删除。

⑤ 视图的应用场景: 针对与小型项目，不推荐使用视图。针对于大型项目，可以考虑使用视图。

⑥ 视图的优点: 简化查询; 控制数据的访问
 */

# 2. 如何创建视图
# 准备工作
CREATE DATABASE dbtest14;

USE dbtest14;

CREATE TABLE emps
AS
SELECT *
FROM atguigudb.employees;

CREATE TABLE depts
AS
SELECT *
FROM atguigudb.departments;

SELECT *
FROM emps;

SELECT *
FROM depts;

DESC emps;

DESC atguigudb.employees;

# 针对于单表
# 情况1: 视图中的字段与基表的字段有对应关系
CREATE VIEW vu_emp1
AS
SELECT employee_id, last_name, salary
FROM emps;

SELECT *
FROM vu_emp1;

# 确定视图中字段名的方式1:
CREATE VIEW vu_emp2
AS
SELECT employee_id emp_id, last_name lname, salary # 查询语句中字段的别名会作为视图中字段的名称出现
FROM emps
WHERE salary > 8000;

SELECT *
FROM vu_emp2;


# 确定视图中字段名的方式2:
CREATE VIEW vu_emp3(emp_id, name, monthly_sal) # 小括号内字段个数于SELECT中字段个数相同
AS
SELECT employee_id, last_name, salary # 查询语句中字段的别名会作为视图中字段的名称出现
FROM emps
WHERE salary > 8000;

SELECT *
FROM vu_emp3;

# 情况2: 视图中的字段在基表中可能没有对应的字段
CREATE VIEW vu_emp_sal
AS
SELECT department_id, AVG(salary) avg_sal
FROM emps
WHERE department_id IS NOT NULL
GROUP BY department_id;

SELECT *
FROM vu_emp_sal;

# 2.2 针对于多表
CREATE VIEW vu_emp_dept
AS
SELECT e.employee_id, e.department_id, d.department_name
FROM emps e
         JOIN depts d
              ON e.department_id = d.department_id;

SELECT *
FROM vu_emp_dept;

# 利用视图对数据进行格式化
CREATE VIEW vu_emp_dept1
AS
SELECT CONCAT(e.last_name, '(', d.department_name, ')') emp_info
FROM emps e
         JOIN depts d
              ON e.department_id = d.department_id;

SELECT *
FROM vu_emp_dept1;

# 2.3 基于视图创建视图
CREATE VIEW vu_emp4
AS
SELECT employee_id, last_name
FROM vu_emp1;

SELECT *
FROM vu_emp4;

# 3. 查看视图
# 语法1: 查看数据库的表对象、视图对象
SHOW TABLES;

# 语法2: 查看视图的结构
DESC vu_emp1;

# 语法3: 查看视图的属性信息
SHOW TABLE STATUS LIKE 'vu_emp1';

# 语法3: 查看视图的详细定义信息
SHOW CREATE VIEW vu_emp1;

