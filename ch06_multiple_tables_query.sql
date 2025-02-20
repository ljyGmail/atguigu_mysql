# 第6章 多表查询

/*
 SELECT ..., .., ...
 FROM ...
 WHERE ... AND / OR / NOT ...
 ORDER BY ... (ASC/DESC), ..., ...
 LIMIT ..., ...
 */

# 1. 熟悉常见的几个表
DESC employees;

DESC departments;

DESC locations;

# 查询一个员工名为"Abel"的人在哪个城市工作？
SELECT *
FROM employees
WHERE last_name = 'Abel';

SELECT *
FROM departments
WHERE department_id = 80;

SELECT *
FROM locations
WHERE location_id = 2500;
