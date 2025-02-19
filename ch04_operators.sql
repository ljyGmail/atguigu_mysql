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

# 2. 比较运算符
# 2.1 = <=> <> != < <= > >=

select 1 = 2, 1 != 2, 1 = '1', 1 = 'a', 0 = 'a' # 字符串存在隐式转换。如果转换数值不成功，则看作是0。
from dual;

select 'a' = 'a', 'ab' = 'ab', 'a' = 'b' # 两边都是字符串的话，则按照ANSI的比较规则进行比较。
from dual;

select 1 = null, null = null # 只有有null参与判断，结果就为null
from dual;

select last_name, salary, commission_pct
from employees
# where salary = 6000;
where commission_pct = null;
# 此时执行，不会有任何的结果

# <=>: 安全等于。记忆技巧：为NULL而生
select 1 <=> 2, 1 <=> '1', 1 <=> 'a', 0 <=> 'a'
from dual;

select 1 <=> null, null <=> null
from dual;

# 练习：查询表中commission_pct为null的数据有哪些
select last_name, salary, commission_pct
from employees
where commission_pct <=> null;

select 3 <> 2, '4' <> null, '' != null, null != null
from dual;

# 2.2
# ① IS NULL \ IS NOT NULL \ ISNULL

# 练习：查询表中commission_pct为null的数据有哪些
select last_name, salary, commission_pct
from employees
where commission_pct is null;
# 或
select last_name, salary, commission_pct
from employees
where isnull(commission_pct);

# 练习：查询表中commission_pct不为null的数据有哪些
select last_name, salary, commission_pct
from employees
where commission_pct is not null;
# 或
select last_name, salary, commission_pct
from employees
where not commission_pct <=> null;

# ② LEAST() \ GREATEST()
select least('g', 'b', 't', 'm'), greatest('g', 'b', 't', 'm')
from dual;

select first_name, last_name, least(first_name, last_name), least(length(first_name), length(last_name))
from employees;

# ③ BETWEEN 条件上界1 AND 条件下界2 (查询条件1和条件2范围内的数据，包含边界)
# 查询工资在6000到8000的员工信息
select employee_id, last_name, salary
from employees
# where salary between 6000 and 8000;
where salary >= 6000
  and salary <= 8000;

# 交换6000和8000之后，查询不到数据
select employee_id, last_name, salary
from employees
where salary between 8000 and 6000;

# 查询工资不在6000和8000的员工信息
select employee_id, last_name, salary
from employees
where not salary between 6000 and 8000;
# where salary < 6000
#    or salary > 8000;

# ④ in (set) \ not in (set)
# 练习: 查询部门为10，20，30的部门的员工信息
select last_name, salary, department_id
from employees
# where department_id = 10 or department_id = 20 or department_id = 30;
where department_id in (10, 20, 30);

# 练习: 查询工资不是6000，7000，8000的员工信息
select last_name, salary, department_id
from employees
where salary not in (6000, 7000, 8000);

# ⑤ LIKE: 模糊查询
# 练习: 查询last_name中包含字符'a'的员工信息
select last_name
from employees
where last_name like '%a%';

# 练习: 查询last_name中以字符'a'开头的员工信息
select last_name
from employees
where last_name like 'a%';

# 练习: 查询last_name中包含字符'a'并且包含字符'e'的员工信息
# 写法1:
select last_name
from employees
where last_name like '%a%'
  and last_name like '%e%';
# 写法2:
select last_name
from employees
where last_name like '%a%e%'
   or last_name like '%e%a%';

# 练习: 查询第3个字符是'a'的员工信息
select last_name
from employees
where last_name like '__a%';

# 练习: 查询第2个字符是_且第3个字符是'a'的员工信息
# 需要使用转义字符: \
select last_name
from employees
where last_name like '_\_a%';

# 或者(了解)
select last_name
from employees
where last_name like '_$_a%' escape '$';

# ⑥ REGEXP \ RLIKE: 正则表达式
select 'shkstart' regexp '^s', 'shkstart' regexp 't$', 'shkstart' regexp 'hk'
from dual;

select 'atguigu' regexp 'gu.gu','atguigu' regexp '[ab]'
from dual;

# 3. 逻辑运算符: OR || AND && NOT ! XOR
# OR AND
select last_name, salary, department_id
from employees
# where department_id = 10 or department_id = 20;
# where department_id = 10 and department_id = 20;
where department_id = 50
  and salary > 6000;

# NOT
select last_name, salary, department_id
from employees
# where salary not between 6000 and 8000;
# where commission_pct is not null;
where not commission_pct <=> null;

# XOR: 追求的"异"
select last_name, salary, department_id
from employees
where department_id = 50 xor salary > 6000;

# 注意: AND的优先级高于OR

# 4. 位运算符: & | ^ ~ >> <<
select 12 & 5, 12 | 5, 12 ^ 5
from dual;

select 10 & ~1
from dual;

# 在一定范围内满足: 每向左移动1位，相当于乘以2，每向右移动一位，相当于除以2
select 4 << 1, 8 >> 1
from dual;

# 课后练习
# 1.选择工资不在5000到12000的员工的姓名和工资
select last_name, salary
from employees
where salary not between 5000 and 12000;

# 2.选择在20或50号部门工作的员工姓名和部门号
select last_name, department_id
from employees
where department_id in (20, 50);

# 3.选择公司中没有管理者的员工姓名及job_id
select last_name, job_id
from employees
where manager_id is null;

select last_name, job_id
from employees
where manager_id <=> null;

# 4.选择公司中有奖金的员工姓名，工资和奖金级别
select last_name, salary, commission_pct
from employees
where commission_pct is not null;

select last_name, salary, commission_pct
from employees
where not commission_pct <=> null;

# 5.选择员工姓名的第三个字母是a的员工姓名
select last_name
from employees
where last_name like '__a%';

# 6.选择姓名中有字母a和k的员工姓名
select last_name
from employees
where last_name like '%a%'
  and last_name like '%k%';

select last_name
from employees
where last_name like '%a%k%'
   or last_name like '%k%a%';

# 7.显示出表 employees 表中 first_name 以 'e'结尾的员工信息
select first_name, last_name
from employees
where first_name like '%e';

select first_name, last_name
from employees
where first_name regexp 'e$';
# 以e开头的写法: '^e'

# 8.显示出表 employees 部门编号在 80-100 之间的姓名、工种
select last_name, job_id
from employees
# 方式1: 推荐
# where department_id between 80 and 100;
# 方式2: 推荐
where department_id >= 80
  and department_id <= 100;

select last_name, job_id
from employees
# 方式3: 仅适用于本题的方式
where department_id in (80, 90, 100);

# 9.显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、工资、管理者id
select last_name, salary, manager_id
from employees
where manager_id in (100, 101, 110);