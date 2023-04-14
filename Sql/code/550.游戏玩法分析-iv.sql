--
-- @lc app=leetcode.cn id=550 lang=mysql
--
-- [550] 游戏玩法分析 IV
--
-- @lc code=start
# Write your MySQL query statement below
select
    ifnull(
        round(
            count(distinct player_id) / (
                select
                    count(distinct player_id)
                from
                    Activity
            ),
            2
        ),
        0
    ) as fraction
from
    Activity
where
    (player_id, event_date) in (
        select
            player_id,
            date(min(event_date) + 1)
        from
            Activity
        group by
            player_id
    )
-- @lc code=end