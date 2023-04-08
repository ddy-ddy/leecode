--
-- @lc app=leetcode.cn id=182 lang=mysql
--
-- [182] 查找重复的电子邮箱
--
-- @lc code=start
# Write your MySQL query statement below
select
    email as email
from
    Person
group by
    email
having
    count(1) > 1 
-- @lc code=end