--
-- @lc app=leetcode.cn id=197 lang=mysql
--
-- [197] 上升的温度
--

-- @lc code=start
# Write your MySQL query statement below

select
    w2.id as id
from
    Weather w1
    left join Weather w2 on w1.Temperature < w2.Temperature
        and datediff(w2.recordDate, w1.recordDate) = 1

-- @lc code=end

