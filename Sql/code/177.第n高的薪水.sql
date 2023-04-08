--
-- @lc app=leetcode.cn id=177 lang=mysql
--
-- [177] 第N高的薪水
--

-- @lc code=start
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
declare m INT;
set m = N - 1;
  RETURN (
      # Write your MySQL query statement below.
      select
          distinct salary
      from
          Employee
      order by salary desc
      limit 1 offset m
  );
END
-- @lc code=end

