## 第二高的薪水

**题目：**获取并返回 `Employee` 表中第二高的薪水 。如果不存在第二高的薪水，查询应该返回 `null` 

**解题思路1：**首先用子查询查出薪水最高的记为a，然后查询比a小的薪水中的最高的即为整个数据第二高的

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

**解题思路2：**使用**limit**和**offset**语句以及**ifnull**函数。降序排列再返回第二条数据。

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



