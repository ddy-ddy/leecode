--
-- @lc app=leetcode.cn id=585 lang=mysql
--
-- [585] 2016年的投资
--
-- @lc code=start
# Write your MySQL query statement below
with location_info as (
    select
        LAT,
        LON
    from
        insurance
    group by
        LAT,
        LON
    having
        count(*) = 1
),
tiv_info as (
    select
        TIV_2015
    from
        insurance
    group by
        TIV_2015
    having
        count(*) > 1
)
select
    round(sum(i.TIV_2016), 2) as tiv_2016
from
    insurance i
    left join location_info on i.LAT = location_info.LAT
    and i.LON = location_info.LON
    left join tiv_info on i.TIV_2015 = tiv_info.TIV_2015
where
    location_info.LAT is not null
    and location_info.LON is not null
    and tiv_info.TIV_2015 is not null
 -- @lc code=end