--
-- @lc app=leetcode.cn id=602 lang=mysql
--
-- [602] 好友申请 II ：谁有最多的好友
--
-- @lc code=start
# Write your MySQL query statement below
select
    id,count(*) as Num
from
    (
        select
            requester_id as id
        from
            RequestAccepted
        union
        all
        select
            accepter_id as id
        from
            RequestAccepted
    ) t 
group by id
order by count(*) desc
limit 1

    
    
    -- @lc code=end