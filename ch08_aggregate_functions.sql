# 第08章 聚合函数

# 1. 常见的几个聚合函数
# 1.1 AVG / SUM: 只适用于数值类型的字段(或变量)
SELECT AVG(salary), SUM(salary), AVG(salary) * 107
FROM employees;

# 如下的操作没有意义
SELECT SUM(last_name), AVG(last_name), SUM(hire_date)
FROM employees;

# 1.2 MAX / MIN: 适用于数值类型、字符串类型、日期时间类型的字段(或变量)
SELECT MAX(salary), MIN(salary)
FROM employees;

SELECT MAX(last_name), MIN(last_name), MAX(hire_date), MIN(hire_date)
FROM employees;

# 1.3 COUNT:
# ① 作用: 计算指定字段在查询结果中出现的个数(不包含NULL值的)
SELECT COUNT(employee_id), COUNT(salary), COUNT(2 * salary), COUNT(1), COUNT(2), COUNT(*)
FROM employees;

SELECT *
FROM employees;

# 如果计算表中有多少条记录，如何实现？
# 方式1: COUNT(*)
# 方式2: COUNT(1)
# 方式3: COUNT(具体字段): 不一定对!

# ② 注意: 计算指定字段出现的个数时，是不计算NULL值的。
SELECT COUNT(commission_pct)
FROM employees;

SELECT commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

# ③ 公式: AVG = SUM / COUNT
SELECT AVG(salary),
       SUM(salary) / COUNT(salary),
       AVG(commission_pct),
       SUM(commission_pct) / COUNT(commission_pct),
       SUM(commission_pct) / 107
FROM employees;

# 问题: 查询公司中平均奖金率
# 错误的！
SELECT AVG(commission_pct)
FROM employees;

# 正确的
SELECT SUM(commission_pct) / COUNT(IFNULL(commission_pct, 0)),
       AVG(IFNULL(commission_pct, 0))
FROM employees;

# 如果需要统计表中的记录数，使用COUNT(*)、COUNT(1)、COUNT(具体字段)哪个效率更高呢？
# 如果使用的是MyISAM存储引擎，则三者效率相同，都是O(1)
# 如果使用的是InnoDB存储引擎，则三者效率: COUNT(*) = COUNT(1) > COUNT(字段)

# 其他: 方差、标准差、中位数

# 2. GROUP BY的使用
# 需求: 查询各个部门的平均工资，最高工资
SELECT department_id, AVG(salary), MAX(salary)
FROM employees
GROUP BY department_id;

# 需求: 查询各个job_id的平均工资
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id;

# 需求: 查询各个department_id，job_id的平均工资
# 方式1
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id;
# 方式2
SELECT job_id, department_id, AVG(salary)
FROM employees
GROUP BY job_id, department_id;

# 错误的！
/*
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id;
*/

# 结论1: SELECT中出现的非组函数的字段必须声明在GROUP BY中。
# 反之，GROUP BY中声明的字段可以不出现在SELECT中。

# 结论2: GROUP BY 声明在FROM后面、WHERE后面，ORDER BY前面、LIMIT前面

# 结论3: MYSQL中GROUP BY中使用WITH ROLLUP
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
WITH ROLLUP;

# 需求: 查询各个部门的平均工资，按照平均工资升序排列
SELECT department_id, AVG(salary) avg_sal
FROM employees
GROUP BY department_id
ORDER BY avg_sal;

# 说明: 当使用ROLLUP时，不能同时使用ORDER BY子句进行结果排序，即ROLLUP和ORDER BY是互相排斥的。
/*
# 错误的！
SELECT department_id, AVG(salary) avg_sal
FROM employees
GROUP BY department_id
WITH ROLLUP
 */

# 3. HAVING的使用 (作用: 用来过滤数据的)
# 练习: 查询各个部门中最高工资比10000高的部门信息
# 错误的写法
/*
SELECT department_id, MAX(salary)
FROM employees
WHERE MAX(salary) > 10000
GROUP BY department_id;
 */

# 要求1: 如果过滤条件中使用了聚合函数，则必须使用HAVING来替换WHERE。否则，报错。
# 要求2: HAVING必须声明在GROUP BY的后面。
# 正确的写法:
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000;

# 要求3: 开发中，我们使用HAVING的前提是SQL中使用了GROUP BY。

# 练习: 查询部门id为10, 20, 30, 40这4个部门中最高工资比10000高的部门信息
# 方式1: 推荐，执行效率高于方式2.
SELECT department_id, MAX(salary)
FROM employees
WHERE department_id IN (10, 20, 30, 40)
GROUP BY department_id
HAVING MAX(salary) > 10000;

# 方式2:
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000
   AND department_id IN (10, 20, 30, 40);

# 结论: 当过滤条件中有聚合函数时，则此过滤条件必须声明在HAVING中。
#      当过滤条件中没有聚合函数时，则此过滤条件声明在WHERE中或HAVING中都可以。但是，建议声明在WHERE中。

/*
WHERE 与 HAVING 的对比
1. 从适用范围上来讲， HAVING的使用范围更广。
2. 如果过滤条件中没有聚合函数: 这种情况下，WHERE的执行效率要高于HAVING。
 */

# 4. SQL底层执行原理
# 4.1 SELECT 语句的完整结构

/*
# SQL92语法:
SELECT ..., ..., ... (存在聚合函数)
FROM ..., ...
WHERE 多表的连接条件 AND 不包含聚合函数的过滤条件
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ..., ... (ASC / DESC)
LIMIT ..., ...

# SQL99语法:
SELECT ..., ..., ... (存在聚合函数)
FROM ... (LEFT / RIGHT) JOIN ... ON 多表的连接条件
JOIN ... ON ...
WHERE 不包含聚合函数的过滤条件
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ..., ... (ASC / DESC)
LIMIT ..., ...
 */

# 4.2 SQL语句的执行过程:
# FROM ..., ... -> ON -> (LEFT / RIGHT JOIN) -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT ->
# ORDER BY -> LIMIT

# 课后练习

# 1.where子句可否使用组函数进行过滤?
# No!

# 2.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary) mas_sal, MIN(salary) min_sal, AVG(salary) avg_sal, SUM(salary) sum_sal
FROM employees;

# 3.查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id;

# 4.选择具有各个job_id的员工人数
SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id;

# 5.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary), MIN(salary), MAX(salary) - MIN(salary) "DIFFERENCE"
FROM employees;

# 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

# 7.查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
SELECT d.department_name, d.location_id, COUNT(e.employee_id), AVG(e.salary)
FROM departments d
         LEFT JOIN employees e
                   ON d.department_id = e.department_id
GROUP BY d.department_name, d.location_id
ORDER BY AVG(e.salary) DESC;

SELECT e.employee_id, e.salary, d.department_name, d.location_id
FROM employees e
         RIGHT JOIN departments d ON d.department_id = e.department_id;

# 8.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT d.department_name, e.job_id, MIN(e.salary)
FROM departments d
         LEFT JOIN employees e
                   ON e.department_id = d.department_id
GROUP BY d.department_name, e.job_id;
