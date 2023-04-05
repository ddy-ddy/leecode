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
                    ID,
                    Num,
                    row_number() over(
                        order by
                            Id
                    ) - row_number() over(
                        partition by Num
                        order by
                            Id
                    ) as SerialNumberSubGroup -- 两列相减为0则表示是连续的
                from
                    Logs
            ) as Sub
        group by
            Num,
            SerialNumberSubGroup
        having
            count(1) >= 3  -- 取连续3次的，如果是连续n次就把3改成n
    ) as reuslt