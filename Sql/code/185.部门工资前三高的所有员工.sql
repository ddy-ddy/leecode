--
-- @lc app=leetcode.cn id=185 lang=mysql
--
-- [185] 部门工资前三高的所有员工
--
-- @lc code=start
# Write your MySQL query statement below
select
    Employee,
    Department,
    Salary
from
    (
        select
            e.name as Employee,
            d.name as Department,
            e.salary as Salary,
            dense_rank() over(
                partition by d.name
                order by
                    e.salary desc
            ) as rnk
        from
            Employee e
            left join Department d on e.DepartmentId = d.Id
    ) temp
where
    rnk <= 3
-- @lc code=end