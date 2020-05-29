The Employee table holds the salary information in a year.

-- Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

-- The result should be displayed by 'Id' ascending, and then by 'Month' descending.

-- Example
-- Input

-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 1  | 2     | 30     |
-- | 2  | 2     | 30     |
-- | 3  | 2     | 40     |
-- | 1  | 3     | 40     |
-- | 3  | 3     | 60     |
-- | 1  | 4     | 60     |
-- | 3  | 4     | 70     |
-- Output

-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 3     | 90     |
-- | 1  | 2     | 50     |
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 3  | 3     | 100    |
-- | 3  | 2     | 40     |

-- Special case - Only Calculate running total for 3 most recent months
-- {"headers": {"Employee": ["Id", "Month", "Salary"]},
-- "rows": {"Employee": [[1, 1, 20], [2, 1, 20], [1, 2, 30], [2, 2, 30],
--                      [3,2,40],[1,3,40], [3,3,60],[1,4,60],[3,4,70]]}}


# Write your MySQL query statement below
select Id, Month, Sum(Salary) over(partition by Id order by Id, Month rows 2 preceding) Salary
from
(select Id, Month, Salary
from Employee
group by Id, Month order by Id, Month) x
where (Id, Month) not in (select Id, max(Month) from Employee group by Id)
Order by Id, Month Desc;