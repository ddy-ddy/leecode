--
-- @lc app=leetcode.cn id=262 lang=mysql
--
-- [262] 行程和用户
--
-- @lc code=start
# Write your MySQL query statement below
select
    t.request_at as 'Day',
    round(
        sum(
            if(t.status != 'completed', 1, 0)
        ) / count(t.status),
        2
    ) as 'Cancellation Rate'
from
    Trips t
    join Users u1 on (
        t.client_id = u1.users_id
        and u1.banned = 'No'
    )
    join Users u2 on (
        t.driver_id = u2.users_id
        and u2.banned = 'No'
    ) 
where
    t.request_at between '2013-10-01' and '2013-10-03'
group by
    t.request_at
-- @lc code=end