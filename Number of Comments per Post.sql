-- Write an SQL query to find number of comments per each post.

-- Result table should contain post_id and its corresponding number_of_comments, and must be sorted by post_id in ascending order.

-- Submissions may contain duplicate comments. You should count the number of unique comments per post.

-- Submissions may contain duplicate posts. You should treat them as one post.

-- The query result format is in the following example:

-- Submissions table:
-- +---------+------------+
-- | sub_id  | parent_id  |
-- +---------+------------+
-- | 1       | Null       |
-- | 2       | Null       |
-- | 1       | Null       |
-- | 12      | Null       |
-- | 3       | 1          |
-- | 5       | 2          |
-- | 3       | 1          |
-- | 4       | 1          |
-- | 9       | 1          |
-- | 10      | 2          |
-- | 6       | 7          |
-- +---------+------------+

-- Result table:
-- +---------+--------------------+
-- | post_id | number_of_comments |
-- +---------+--------------------+
-- | 1       | 3                  |
-- | 2       | 2                  |
-- | 12      | 0                  |
-- +---------+--------------------+

-- The post with id 1 has three comments in the table with id 3, 4 and 9. The comment with id 3 is repeated in the table, we counted it only once.
-- The post with id 2 has two comments in the table with id 5 and 10.
-- The post with id 12 has no comments in the table.
-- The comment with id 6 is a comment on a deleted post with id 7 so we ignored it.


SELECT s.sub_id AS post_id,
(SELECT COUNT(DISTINCT(s1.sub_id)) FROM Submissions s1 WHERE s1.parent_id = s.sub_id) 
AS number_of_comments
FROM Submissions s
WHERE s.parent_id IS null
GROUP BY s.sub_id
;



select distinct sub_id as post_id, coalesce(number_of_comments, 0) number_of_comments
from submissions s left join
(select parent_id, count(distinct(sub_id)) number_of_comments
from submissions where parent_id is not null
group by parent_id) x
on s.sub_id = x.parent_id
where s.parent_id is null
order by post_id;