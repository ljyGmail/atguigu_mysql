# 第5章 排序与分页

# 1. 排序
# 如果没有使用排序操作，默认情况下查询返回的数据是按照添加数据的顺序显示的。
select *
from employees;

# 1.1 基本使用
# 使用ORDER BY对查询的数据进行排序操作
# 升序: ASC(ascending)
# 降序: DESC(descending)

# 练习: 按照salary从高到低的顺序显示员工信息
select employee_id, last_name, salary
from employees
order by salary desc;

# 练习: 按照salary从低到高的顺序显示员工信息
select employee_id, last_name, salary
from employees
order by salary asc;

select employee_id, last_name, salary
from employees
order by salary;
# 如果在ORDER BY后没有显示指定排序方式的话，则默认按照升序排列。

# 2. 可以使用列的别名，进行排序
select employee_id, salary, salary * 12 annual_sal
from employees
order by annual_sal;

# 列的别名只能在ORDER BY中使用，不能在WHERE中使用。
# 如下操作报错！
# select employee_id, salary, salary * 12 annual_sal
# from employees
# where annual_sal > 81600;

# 3. 强调格式: WHERE需要声明在FROM后，ORDER BY之前。
select employee_id, salary, department_id
from employees
where department_id in (50, 60, 70)
order by department_id desc;

# 4. 二级排序

# 练习: 显示员工信息，按照department_id的降序排列，salary的升序排序
select employee_id, salary, department_id
from employees
order by department_id desc, salary asc;

# 2. 分页
# 2.1 mysql使用limit实现数据的分页显示

# 需求1: 每页显示20条记录，此时显示第1页
select employee_id, last_name
from employees
limit 0, 20;

# 需求2: 每页显示20条记录，此时显示第2页
select employee_id, last_name
from employees
limit 20, 20;

# 需求3: 每页显示20条记录，此时显示第3页
select employee_id, last_name
from employees
limit 40, 20;

# 需求: 每页显示pageSize条记录，此时显示第pageNo页:
# 公式: LIMIT (pageNo - 1) * pageSize, pageSize;

# 2.2 WHERE ... ORDER BY ... LIMIT 声明顺序如下:

# LIMIT的格式: 严格来说，LIMIT 位置偏移量, 条目数
# 结构"LIMIT 0, 条目数"等价于"LIMIT 条目数"
select employee_id, last_name, salary
from employees
where salary > 6000
order by salary desc
# limit 0, 10;
limit 10;

# 练习: 表里有107条数据，只想要显示第32、33条数据怎么办？
select employee_id, last_name
from employees
limit 31, 2;

# 2.3 MySQL8.0新特性: LIMIT ... OFFSET ...
select employee_id, last_name
from employees
limit 2 offset 31;

# 练习: 查询员工表中工资最高的员工信息
select employee_id, last_name, salary
from employees
order by salary desc
# limit 0, 1;
limit 1;

# 2.4 LIMIT 可以使用在MySQL、PGSQL、MariaDB、SQLite 等数据库中使用，表示分页。
# 不能使用在SQL Server、DB2、Oracle。