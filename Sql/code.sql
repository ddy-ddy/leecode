with manager as(
    select
        id name,
        salary
    from
        Employee
    where
        managerId is null
)
select
    name
from
    Employee e
    left join manager m on e.managerId = m.id
where
    e.salary > m.salary