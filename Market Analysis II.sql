-- Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

-- It is guaranteed that no seller sold more than one item on a day.

-- The query result format is in the following example:

-- Users table:
-- +---------+------------+----------------+
-- | user_id | join_date  | favorite_brand |
-- +---------+------------+----------------+
-- | 1       | 2019-01-01 | Lenovo         |
-- | 2       | 2019-02-09 | Samsung        |
-- | 3       | 2019-01-19 | LG             |
-- | 4       | 2019-05-21 | HP             |
-- +---------+------------+----------------+

-- Orders table:
-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2019-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2019-08-04 | 1       | 4        | 2         |
-- | 5        | 2019-08-04 | 1       | 3        | 4         |
-- | 6        | 2019-08-05 | 2       | 2        | 4         |
-- +----------+------------+---------+----------+-----------+

-- Items table:
-- +---------+------------+
-- | item_id | item_brand |
-- +---------+------------+
-- | 1       | Samsung    |
-- | 2       | Lenovo     |
-- | 3       | LG         |
-- | 4       | HP         |
-- +---------+------------+

-- Result table:
-- +-----------+--------------------+
-- | seller_id | 2nd_item_fav_brand |
-- +-----------+--------------------+
-- | 1         | no                 |
-- | 2         | yes                |
-- | 3         | yes                |
-- | 4         | no                 |
-- +-----------+--------------------+

-- The answer for the user with id 1 is no because they sold nothing.
-- The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
-- The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand.

select user_id as seller_id,
case when favorite_brand = item_brand then 'yes' else 'no' end as 2nd_item_fav_brand
from users u left join
(select * from 
 (select seller_id, item_brand, row_number() over(partition by seller_id order by order_date) ranking
 from orders o join items i
 on o.item_id = i.item_id
 group by seller_id, order_date) x1
where ranking = 2) x
on u.user_id = x.seller_id



-- Same solution 

WITH t AS
(
    SELECT *
    FROM
    (
        SELECT seller_id, item_brand,
        ROW_NUMBER() OVER(PARTITION BY seller_id ORDER BY order_date) row
        FROM Orders o, Items i
        WHERE o.item_id = i.item_id      
    ) oi
    WHERE row = 2
)

SELECT user_id AS seller_id, '2nd_item_fav_brand' = 
    CASE 
        WHEN item_brand = favorite_brand  THEN 'yes' 
        ELSE 'no' 
    END  
FROM Users u
LEFT JOIN t
ON u.user_id = t.seller_id



--------------------------


select user_id as seller_id, 
        (case 
            when favorite_brand = (
                            select i.item_brand
                            from Orders o left join Items i
                            on o.item_id = i.item_id
                            where o.seller_id = u.user_id 
                            order by o.order_date
                            limit 1 offset 1
                                  ) then "yes" else "no" end
         ) as "2nd_item_fav_brand"   
from Users u  