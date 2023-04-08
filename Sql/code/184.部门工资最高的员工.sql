--
-- @lc app=leetcode.cn id=184 lang=mysql
--
-- [184] 部门工资最高的员工
--
-- @lc code=start
# Write your MySQL query statement below
select
    Department,
    Employee,
    Salary
from
    (
        select
            d.name as Department,
            e.name as Employee,
            e.salary as Salary,
            rank() over(
                partition by d.name
                order by
                    e.salary desc
            ) as rnk
        from
            Employee e
            left join Department d on e.DepartmentId = d.Id
    ) as temp
where
    rnk = 1
    
 -- @lc code=end