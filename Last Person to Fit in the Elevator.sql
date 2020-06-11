-- The maximum weight the elevator can hold is 1000.

-- Write an SQL query to find the person_name of the last person who will fit in the elevator without
-- exceeding the weight limit. It is guaranteed that the person who is first in the queue can fit in the elevator.

-- The query result format is in the following example:

-- Queue table
-- +-----------+-------------------+--------+------+
-- | person_id | person_name       | weight | turn |
-- +-----------+-------------------+--------+------+
-- | 5         | George Washington | 250    | 1    |
-- | 3         | John Adams        | 350    | 2    |
-- | 6         | Thomas Jefferson  | 400    | 3    |
-- | 2         | Will Johnliams    | 200    | 4    |
-- | 4         | Thomas Jefferson  | 175    | 5    |
-- | 1         | James Elephant    | 500    | 6    |
-- +-----------+-------------------+--------+------+

-- Result table
-- +-------------------+
-- | person_name       |
-- +-------------------+
-- | Thomas Jefferson  |
-- +-------------------+

-- Queue table is ordered by turn in the example for simplicity.
-- In the example George Washington(id 5), John Adams(id 3) and Thomas Jefferson(id 6) will enter
-- the elevator as their weight sum is 250 + 350 + 400 = 1000.
-- Thomas Jefferson(id 6) is the last person to fit in the elevator because he has the last turn in these three people.

---------- Cool method of cumulative sum using join -------------
-- The steps:
-- (1) Get cumulative sum weight using Join with condition q1.turn >= q2.turn and Group By q1.turn
-- (2) Filter the groups with cum sum <=1000
-- (3) Order by cum sum with Desc order, select the 1st.

SELECT q1.person_name
FROM Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1


-------------- Similar technique -----------

SELECT person_name FROM Queue as a
WHERE
(
    SELECT SUM(weight) FROM Queue as b
    WHERE b.turn<=a.turn
    ORDER By turn
)<=1000
ORDER BY a.turn DESC limit 1;


------------ OR (My Solution) ---------------

select person_name from
(select person_name, weight, turn, sum(weight) over(order by turn) as cum_sum
from queue) x
where cum_sum <= 1000
order by turn desc limit 1