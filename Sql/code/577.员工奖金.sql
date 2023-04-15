--
-- @lc app=leetcode.cn id=577 lang=mysql
--
-- [577] 员工奖金
--

-- @lc code=start
# Write your MySQL query statement below

select
    e.name as name,
    b.bonus as bonus
from
    Employee e
    left join Bonus b on e.empId = b.empId
where
    b.bonus < 1000 or b.bonus is null
-- @lc code=end

