-- Table my_numbers contains many numbers in column num including duplicated ones.
-- Can you write a SQL query to find the biggest number, which only appears once.

-- +---+
-- |num|
-- +---+
-- | 8 |
-- | 8 |
-- | 3 |
-- | 3 |
-- | 1 |
-- | 4 |
-- | 5 |
-- | 6 | 
-- For the sample data above, your query should return the following result:
-- +---+
-- |num|
-- +---+
-- | 6 |
-- Note:
-- If there is no such number, just output null.


select ifnull(
(select num
from my_numbers
group by num
having count(*) = 1
order by num desc
limit 1), null) as num


---------------- OR --------------

select max(a.num) as num
from (select num from number group by num having count(*)=1) as a

---------------- OR --------------

select if(count(*) =1, num, null) as num from number 
group by num order by count(*), num desc limit 1