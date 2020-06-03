-- Several friends at a cinema ticket office would like to reserve consecutive available seats.
-- Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?
-- | seat_id | free |
-- |---------|------|
-- | 1       | 1    |
-- | 2       | 0    |
-- | 3       | 1    |
-- | 4       | 1    |
-- | 5       | 1    |
 

-- Your query should return the following result for the sample case above.
 

-- | seat_id |
-- |---------|
-- | 3       |
-- | 4       |
-- | 5       |
-- Note:
-- The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
-- Consecutive available seats are more than 2(inclusive) seats consecutively available.

select distinct a.seat_id from
    cinema a join cinema b on a.seat_id = b.seat_id + 1 
             or a.seat_id = b.seat_id-1
    where a.free = 1 and b.free = 1
   order by a.seat_id;



select distinct a.seat_id
from cinema a
join cinema b
on abs(a.seat_id - b.seat_id) = 1
and a.free=true and b.free=true
order by a.seat_id;




SELECT
    seat_id
FROM
    (SELECT
        seat_id,
        free,
        LAG(free,1) OVER (ORDER BY seat_id) as free_lag,
        LEAD(free,1) OVER (ORDER BY seat_id) as free_lead
    FROM cinema ) as t
WHERE (free=1 AND free_lag=1)
OR (free=1 AND free_lead=1)
order by seat_id;


-- Writen in MS SQL Server because it has LAG and LEAD function. I think it is more intuitive and easier to understand than Cartesian product answer


-- seat_id	free	free_lag	free_lead
-- 1		1		NULL		0
-- 2		0		1			1
-- 3		1		0			1
-- 4		1		1			1
-- 5		1		1			NULL


-- (free=1 AND free_lag=1) can choose consecutive seats without first one
-- (free=1 AND free_lead=1) can choose consecutive seats without last one
-- Use OR to combine these two to get correct result.
-- This code does not involved with JOIN so I think it is faster when TABLE is big