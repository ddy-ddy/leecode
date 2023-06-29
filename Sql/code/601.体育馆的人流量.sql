--
-- @lc app=leetcode.cn id=601 lang=mysql
--
-- [601] 体育馆的人流量
--
-- @lc code=start
# Write your MySQL query statement below
with temp as (
    select
        *,
        id - row_number() over(
            order by
                id
        ) as rk
    from
        stadium
    where
        people >= 100
)
select
    id,
    visit_date,
    people 
from    
    temp
where rk in (
    select rk from temp group by rk having count(*) >=3
)
    
    -- @lc code=end