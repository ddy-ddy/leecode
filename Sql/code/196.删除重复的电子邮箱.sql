--
-- @lc app=leetcode.cn id=196 lang=mysql
--
-- [196] 删除重复的电子邮箱
--

-- @lc code=start
# Please write a DELETE statement and DO NOT write a SELECT statement.
# Write your MySQL query statement below
delete
    p1
from 
    Person p1
    left join Person p2 on p1.email = p2.email
where
    p1.id > p2.id
-- @lc code=end

