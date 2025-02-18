# 第4章 运算符
# 1. 算术运算符: + - * / div % mod

select 100, 100 + 0, 100 - 0, 100 + 50, 100 + 50 - 30, 100 + 35.5, 100 - 35.5
from dual;
# 在SQL中，+没有连接的作用，就表示加法运算。此时，会将字符串转换为数值(隐式转换)
select 100 + '1' # 在Java语言中，结果是: 1001。
from dual;

select 100 + 'ab' # 此时将'a'看作0处理
from dual;

select 100 + NULL # null值参与运算，结果为null
from dual;

# 如果分母为0，则结果为null
select 100,
       100 * 1,
       100 * 1.0,
       100 / 1.0,
       100 / 2,
       100 + 2 * 5 / 2,
       100 / 3,
       100 div 0
from dual;

# 取模运算: % mod
select 12 % 3, 12 % 5, 12 mod -5, -12 % -5
from dual;

# 练习：查询员工id为偶数的员工信息。
select employee_id, last_name, salary
from employees
where employee_id % 2 = 0;
