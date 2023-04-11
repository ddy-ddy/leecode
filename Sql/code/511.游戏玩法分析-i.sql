--
-- @lc app=leetcode.cn id=511 lang=mysql
--
-- [511] 游戏玩法分析 I
--
-- @lc code=start
# Write your MySQL query statement below
select
    player_id,
    event_date as first_login
from
    (
        select
            player_id,
            event_date,
            rank() over(
                partition by player_id
                order by
                    event_date
            ) as rnk
        from
            Activity
    ) as tmp
where tmp.rnk=1
     -- @lc code=end