## [第二高的薪水](https://leetcode.cn/problems/second-highest-salary/)

**题目:** 获取并返回 `Employee` 表中第二高的薪水 。如果不存在第二高的薪水，查询应该返回 `null` 

**解题思路1:** 首先用子查询查出薪水最高的记为a，然后查询比a小的薪水中的最高的即为整个数据第二高的

```sql
select
    max(salary) as SecondHighestSalary
from
    Employee
where
    salary < (
        select
            max(salary)
        from
            Employee
    )
```

**解题思路2:** 使用**limit**和**offset**语句以及**ifnull**函数。降序排列再返回第二条数据。

- `limit n`表示查询结果返回前n条数据
- `offset n`表示跳过n条数据
- `limit y offset x ` 表示查询结果跳过x条数据后再查询前y条数据
- `ifnull(a,b) `表示如果a数据为空的话则显示b数据

```sql
select
    ifnull(
        (
            select
                distinct salary
            from
                Employee
            order by
                salary desc
            limit 1 offset 1
        ), null
    ) as SecondHighestSalary
```



## [第N高的薪水](https://leetcode.cn/problems/nth-highest-salary/description/)

**题目:** 编写一个SQL查询来报告 `Employee` 表中第 `n` 高的工资。如果没有第 `n` 个最高工资，查询应该报告为 `null` 。

**解题思路1:** `limit`不支持运算，需要提前声明一个`INT`变量m，然后赋值m为N-1

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT 
BEGIN 
declare m INT;
set m = N -1;
RETURN (
    select
        ifnull (
            (
                select
                    distinct salary
                from
                    Employee
                order by
                    salary desc
                limit
                    1 offset m
            ),
            null
        )
);
END
```

**解题思路2:** 使用窗口函数，mysql中内置了四种排名函数

- `row_number()`: 同薪不同名，相当于行号，例如3000、2000、2000、1000排名后为1、2、3、4
- `rank()`: 同薪同名，有跳级，例如3000、2000、2000、1000排名后为1、2、2、4
- `dense_rank()`: 同薪同名，无跳级，例如3000、2000、2000、1000排名后为1、2、2、3
- `ntile()`: 分桶排名，即首先按桶的个数分出第一二三桶，然后各桶内从1排名，实际不是很常用

这四种函数常与`over()`搭配使用，参数有两个：

- `partition by`: 按某字段切分

- `order by `: 与常规order by用法一致

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT 
BEGIN 
RETURN (
    select
        distinct salary
    from
        (
            select
                salary,
                dense_rank() over (
                    order by
                        salary desc
                ) as rnk
            from
                Employee
        ) temp
    where
        rnk = N
);
END
```



## [连续出现的数据](https://leetcode.cn/problems/consecutive-numbers/)

**题目:** 编写一个 SQL 查询，查找所有至少连续出现三次的数字

**解题思路1:** 三表连接，根据ID去判断是否连续

```sql
select distinct
    l1.Num as ConsecutiveNums
from
    Logs l1,
    Logs l2,
    Logs l3
where
    l1.ID = l2.ID - 1
    and l2.ID = l3.ID - 1
    and l1.Num = l2.Num
    and l2.Num = l3.Num
```

**解题思路2:** 如果一个num连续出现时，那么它出现的`真实序列`-`它出现的次数`一定是个定值

```sql
select
    distinct Num as ConsecutiveNums
from
    (
        select
            Num,
            count(1) as SerialCount
        from
            (
                select
                    ID,
                    Num,
                    row_number() over(
                        order by
                            Id
                    ) - row_number() over(
                        partition by Num
                        order by
                            Id
                    ) as SerialNumberSubGroup -- 两列相减为0则表示是连续的
                from
                    Logs
            ) as Sub
        group by
            Num,
            SerialNumberSubGroup
        having
            count(1) >= 3  -- 取连续3次的，如果是连续n次就把3改成n
    ) as reuslt
```



## [超过经理收入的员工](https://leetcode.cn/problems/employees-earning-more-than-their-managers/description/)

**题目:** 编写一个SQL查询来查找收入比经理高的员工。以任意顺序返回结果表。

**解题思路1:** 多表查询，采用自连接的方式，一张表当两张表用

```sql
select
    e1.name as Employee
from
    Employee e1,
    Employee e2
where
    e1.managerId = e2.id
    and e1.salary > e2.salary
```



## [查找重复的电子邮箱](https://leetcode.cn/problems/duplicate-emails/description/)

**题目:** 编写一个 SQL 查询来报告所有重复的电子邮件。 请注意，可以保证电子邮件字段不为 NULL

**解题思路1:** 使用group by和having条件。通过group by对email分组，再使用having将重复的email筛选出来

- 注意优先级`where > group by > having > order by`

```sql
select
    email as email
from
    Person
group by
    email
having
    count(email) > 1
```



## [从不定购的客户](https://leetcode.cn/problems/customers-who-never-order/description/)

**题目:** 某网站包含两个表，`Customers` 表和 `Orders` 表。编写一个 SQL 查询，找出所有从不订购任何东西的客户

**解题思路1:** 使用左连接，然后用id为null去判断

```sql
select
    c.Name as Customers
from
    Customers c
    left join Orders o on c.Id = o.CustomerId
where
    o.id is null
```



## [部门工资最高的员工](https://leetcode.cn/problems/department-highest-salary/description/)

**题目:** 编写SQL查询以查找每个部门中薪资最高的员工。

**解题思路1:** 使用rank()窗口函数根据分组去给每个数据排名，然后选取排名为1的数据

```sql
select
    Department,
    Employee,
    Salary
from
    (
        select
            d.Name as Department,
            e.Name as Employee,
            e.Salary,
            rank() over (
                partition by d.Name
                order by
                    e.salary desc
            ) as rnk
        from
            Department d
            join Employee e on d.id = e.DepartmentId
    ) a
where
    a.rnk = 1
```



## [上升的问题](https://leetcode.cn/problems/rising-temperature/description/)

**题目:** 编写一个 SQL 查询，来查找与之前（昨天的）日期相比温度更高的所有日期的 `id` 。

**解题思路1:** 用`datediff`函数来判断两个日期是否相隔1天

```sql
select
    w2.id as id
from
    Weather w1,
    Weather w2
where
     w1.Temperature < w2.Temperature
     and datediff(w2.recordDate, w1.recordDate) = 1
```



## [行程和用户](https://leetcode.cn/problems/trips-and-users/solutions/)

**题目:** 取消率 的计算方式如下：(被司机或乘客取消的非禁止用户生成的订单数量) / (非禁止用户生成的订单总数)。写一段 SQL 语句查出 `"2013-10-01"` 至 `"2013-10-03"` 期间非禁止用户（**乘客和司机都必须未被禁止**）的取消率。非禁止用户即 banned 为 No 的用户，禁止用户即 banned 为 Yes 的用户。返回结果表中的数据可以按任意顺序组织。其中取消率 `Cancellation Rate` 需要四舍五入保留 **两位小数** 。

**解题思路1:** 首先确定被禁止用户的行程记录，再剔除这些行程记录。注意要对 `client_id` 和 `driver_id` 各自关联的 `users_id`，同时检测是否被禁止。

```sql
select
    t.request_at as 'Day',
    round(
        sum(
            if(t.status != 'completed', 1, 0)
        ) / count(t.status),
        2
    ) as 'Cancellation Rate'
from
    Trips t
    join Users u1 on (
        t.client_id = u1.users_id
        and u1.banned = 'No'
    )
    join Users u2 on (
        t.driver_id = u2.users_id
        and u2.banned = 'No'
    ) 
where
    t.request_at between '2013-10-01' and '2013-10-03'
group by
    t.request_at
```



## [游戏玩法分析](https://leetcode.cn/problems/game-play-analysis-iv/)

**题目:** 编写一个 SQL 查询，报告在首次登录的第二天再次登录的玩家的比率，四舍五入到小数点后两位。换句话说，您需要计算从首次登录日期开始至少连续两天登录的玩家的数量，然后除以玩家总数。

解题思路1: 首先在子查询中找到第二天登录的用户，然后再到外面一层进行筛选和计算

```sql
select
    ifnull(
        round(
            count(distinct player_id) / (
                select
                    count(distinct player_id)
                from
                    Activity
            ),
            2
        ),
        0
    ) as fraction
from
    Activity
where
    (player_id, event_date) in (
        select
            player_id,
            date(min(event_date) + 1)
        from
            Activity
        group by
            player_id
    )
```



## [2016年的投资](https://leetcode.cn/problems/investments-in-2016/description/)

**题目:** 写一个查询语句，将 2016 年 (TIV_2016) 所有成功投资的金额加起来，保留 2 位小数。

对于一个投保人，他在 2016 年成功投资的条件是：

- 他在 2015 年的投保额 (TIV_2015) 至少跟一个其他投保人在 2015 年的投保额相同。

- 他所在的城市必须与其他投保人都不同（也就是说维度和经度不能跟其他任何一个投保人完全相同）

**解题思路1:** 用临时表，这个方法过程很清晰

```sql
with location_info as (
    select
        LAT,
        LON
    from
        insurance
    group by
        LAT,
        LON
    having
        count(*) = 1
),
tiv_info as (
    select
        TIV_2015
    from
        insurance
    group by
        TIV_2015
    having
        count(*) > 1
)
select
    round(sum(i.TIV_2016), 2) as tiv_2016
from
    insurance i
    left join location_info on i.LAT = location_info.LAT
    and i.LON = location_info.LON
    left join tiv_info on i.TIV_2015 = tiv_info.TIV_2015
where
    location_info.LAT is not null
    and location_info.LON is not null
    and tiv_info.TIV_2015 is not null
```

**解题思路2:** 用窗口函数去统计数量，并且给排名新增两列，最后在筛选即可

```sql
with location_info as (
    select
        LAT,
        LON
    from
        insurance
    group by
        LAT,
        LON
    having
        count(*) = 1
),
tiv_info as (
    select
        TIV_2015
    from
        insurance
    group by
        TIV_2015
    having
        count(*) > 1
)
select
    round(sum(i.TIV_2016), 2) as tiv_2016
from
    insurance i
    left join location_info on i.LAT = location_info.LAT
    and i.LON = location_info.LON
    left join tiv_info on i.TIV_2015 = tiv_info.TIV_2015
where
    location_info.LAT is not null
    and location_info.LON is not null
    and tiv_info.TIV_2015 is not null
```



