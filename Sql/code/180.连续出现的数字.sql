--
-- @lc app=leetcode.cn id=180 lang=mysql
--
-- [180] 连续出现的数字
--
-- @lc code=start
# Write your MySQL query statement below
select
    distinct Num as ConsecutiveNums
from
    (
        select
            Num,
            count(1) as SerialCount
        from
            (
                select
                    Id,
                    Num,
                    row_number() over(
                        order by
                            Id
                    ) - row_number() over(
                        partition by Num
                        order by
                            Id
                    ) as rnk
                from
                    Logs
            ) as temp
        group by
            Num,
            rnk
        having
            count(1) >= 3
    ) as result 
    
-- @lc code=end