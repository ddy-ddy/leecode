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







