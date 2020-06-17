-- Table: Student

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | student_id          | int     |
-- | student_name        | varchar |
-- +---------------------+---------+
-- student_id is the primary key for this table.
-- student_name is the name of the student.
 

-- Table: Exam

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | exam_id       | int     |
-- | student_id    | int     |
-- | score         | int     |
-- +---------------+---------+
-- (exam_id, student_id) is the primary key for this table.
-- Student with student_id got score points in exam with id exam_id.
 

-- A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score.

-- Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

-- Don't return the student who has never taken any exam. Return the result table ordered by student_id.

-- The query result format is in the following example.

 

-- Student table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Jade          |
-- | 3           | Stella        |
-- | 4           | Jonathan      |
-- | 5           | Will          |
-- +-------------+---------------+

-- Exam table:
-- +------------+--------------+-----------+
-- | exam_id    | student_id   | score     |
-- +------------+--------------+-----------+
-- | 10         |     1        |    70     |
-- | 10         |     2        |    80     |
-- | 10         |     3        |    90     |
-- | 20         |     1        |    80     |
-- | 30         |     1        |    70     |
-- | 30         |     3        |    80     |
-- | 30         |     4        |    90     |
-- | 40         |     1        |    60     |
-- | 40         |     2        |    70     |
-- | 40         |     4        |    80     |
-- +------------+--------------+-----------+

-- Result table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 2           | Jade          |
-- +-------------+---------------+

-- For exam 1: Student 1 and 3 hold the lowest and high score respectively.
-- For exam 2: Student 1 hold both highest and lowest score.
-- For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
-- Student 2 and 5 have never got the highest or lowest in any of the exam.
-- Since student 5 is not taking any exam, he is excluded from the result.
-- So, we only return the information of Student 2.


select distinct e.student_id, student_name from
exam e join student s on e.student_id = s.student_id
where e.student_id not in
(select student_id
from exam e join (select exam_id, max(score) mx, min(score) mn from exam group by exam_id) x
on e.exam_id=x.exam_id
where score = mx or score = mn)
order by student_id


---------------------- OR ----------------------


with cte_students as (
select exam_id, min(score) as min_score, max(score) as max_score
    from Exam group by exam_id
)

select A.student_id, s.student_name from
(
select distinct student_id 
from Exam 
where student_id not in (select student_id from Exam 
    where (exam_id,score) in (select exam_id, min_score from cte_students)
) AND
student_id not in (select student_id from Exam 
    where (exam_id,score) in (select exam_id, max_score from cte_students)
) ) A
inner join Student s
on A.student_id = s.student_id
order by 1



--------------------- Using Window Function ----------------------


WITH tmp AS(
    SELECT exam_id, student_id, score,
    RANK() OVER (PARTITION BY exam_id ORDER BY score ASC) AS rank_1,
    RANK() OVER (PARTITION BY exam_id ORDER BY score DESC) AS rank_2
    FROM exam)
SELECT DISTINCT tmp.student_id, s.student_name
FROM tmp
JOIN student s
ON tmp.student_id = s.student_id
WHERE tmp.student_id NOT IN (SELECT student_id
                             FROM tmp
                             WHERE rank_1 = 1 OR rank_2 = 1)

