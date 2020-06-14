-- Table: UserActivity

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | username      | varchar |
-- | activity      | varchar |
-- | startDate     | Date    |
-- | endDate       | Date    |
-- +---------------+---------+
-- This table does not contain primary key.
-- This table contain information about the activity performed of each user in a period of time.
-- A person with username performed a activity from startDate to endDate.

-- Write an SQL query to show the second most recent activity of each user.

-- If the user only has one activity, return that one. 

-- A user can't perform more than one activity at the same time. Return the result table in any order.

-- The query result format is in the following example:

-- UserActivity table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- Result table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
-- Bob only has one record, we just take that one.



select username, activity, startDate, endDate from
(select username, activity, startDate, endDate,
rank() over(partition by username order by endDate desc) ranking
from useractivity) x
where ranking = 2

union all

select username, activity, startDate, endDate
from useractivity
group by username
having count(*) = 1


------------- Similar ----------------

select username, activity, startDate, endDate
from (
select *, count(activity) over(partition by username)cnt, 
ROW_NUMBER() over(partition by username order by startdate desc) n from UserActivity) tbl
where n=2 or cnt<2


------------------- Using join -------------------


SELECT * 
FROM UserActivity 
GROUP BY username 
HAVING COUNT(*) = 1

UNION ALL

SELECT u1.*
FROM UserActivity u1 
LEFT JOIN UserActivity u2 
    ON u1.username = u2.username AND u1.endDate < u2.endDate
GROUP BY u1.username, u1.endDate
HAVING COUNT(u2.endDate) = 1