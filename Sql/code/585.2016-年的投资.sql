--
-- @lc app=leetcode.cn id=585 lang=mysql
--
-- [585] 2016年的投资
--
-- @lc code=start
# Write your MySQL query statement below
with temp as (
    select
        *,
        count(PID) over(partition by TIV_2015) as rank1,
        count(PID) over(partition by concat(LAT,LON)) as rank2
    from
        insurance
)
select
    round(sum(TIV_2016),2) as TIV_2016
from
    temp
where
    rank1 > 1 and rank2 = 1


 -- @lc code=end