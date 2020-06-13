-- Write a SQL query to find the highest grade with its corresponding course for each student.
-- In case of a tie, you should find the course with the smallest course_id.
-- The output must be sorted by increasing student_id.

-- The query result format is in the following example:

-- Enrollments table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 2          | 2         | 95    |
-- | 2          | 3         | 95    |
-- | 1          | 1         | 90    |
-- | 1          | 2         | 99    |
-- | 3          | 1         | 80    |
-- | 3          | 2         | 75    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- Result table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 1          | 2         | 99    |
-- | 2          | 2         | 95    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+


select student_id, course_id, grade from
(select student_id, course_id, grade,
row_number() over(partition by student_id order by grade desc, course_id) ranking
from enrollments order by student_id, grade desc, course_id) x
where ranking = 1


---------- OR ------------


SELECT DISTINCT student_id,MIN(course_id) AS course_id,grade
FROM Enrollments
WHERE (student_id,grade) IN (SELECT DISTINCT student_id, max(grade) FROM Enrollments GROUP BY student_id)
GROUP BY student_id
ORDER BY student_id;

