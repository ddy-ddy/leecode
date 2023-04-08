
--
-- @lc app=leetcode.cn id=175 lang=mysql
--
-- [175] 组合两个表
--

-- @lc code=start
# Write your MySQL query statement below
select
    p.firstName as firstName,
    p.lastName as lastName,
    a.city as city,
    a.state as state
from
    Person p
    left join Address a on p.PersonId = a.PersonId
-- @lc code=end

