-- In social network like Facebook or Twitter, people send friend requests
-- and accept others’ requests as well. Now given two tables as below:
 

-- Table: friend_request
-- | sender_id | send_to_id |request_date|
-- |-----------|------------|------------|
-- | 1         | 2          | 2016_06-01 |
-- | 1         | 3          | 2016_06-01 |
-- | 1         | 4          | 2016_06-01 |
-- | 2         | 3          | 2016_06-02 |
-- | 3         | 4          | 2016-06-09 |
 

-- Table: request_accepted
-- | requester_id | accepter_id |accept_date |
-- |--------------|-------------|------------|
-- | 1            | 2           | 2016_06-03 |
-- | 1            | 3           | 2016-06-08 |
-- | 2            | 3           | 2016-06-08 |
-- | 3            | 4           | 2016-06-09 |
-- | 3            | 4           | 2016-06-10 |
 

-- Write a query to find the overall acceptance rate of requests rounded to 2 decimals,
-- which is the number of acceptance divide the number of requests.
 

-- For the sample data above, your query should return the following result.
 

-- |accept_rate|
-- |-----------|
-- |       0.80|
 

-- Note:
-- The accepted requests are not necessarily from the table friend_request. In this case,
-- you just need to simply count the total accepted requests (no matter whether they are in the original requests),
-- and divide it by the number of requests to get the acceptance rate.
-- It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once.
-- In this case, the ‘duplicated’ requests or acceptances are only counted once.
-- If there is no requests at all, you should return 0.00 as the accept_rate.
 

-- Explanation: There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.
 

-- Follow-up:
-- Can you write a query to return the accept rate but for every month?
-- How about the cumulative accept rate for every day?

select
round(
    ifnull(
    (select count(*) from (select distinct requester_id, accepter_id from request_accepted) as A)
    /
    (select count(*) from (select distinct sender_id, send_to_id from friend_request) as B),
    0)
, 2) as accept_rate;


------------- OR ---------------

select
round(
    ifnull(

(select count(requester_id) from
(select requester_id, accepter_id from request_accepted
group by requester_id, accepter_id) y)
/
(select count(sender_id) from
(select sender_id, send_to_id from friend_request
group by sender_id, send_to_id) x), 0), 2) as accept_rate


------------- OR ---------------


select coalesce(round(count(distinct requester_id, accepter_id)/count(distinct sender_id, send_to_id),2),0) as accept_rate
from friend_request, request_accepted



------------- Follow-up 1 ---------------


##  create a subquery which contains count, month, join each other with month and group by month so we can get the finally result.
select if(d.req =0, 0.00, round(c.acp/d.req,2)) as accept_rate, c.month from 
(select count(distinct requester_id, accepter_id) as acp, Month(accept_date) as month from request_accepted) c, 
(select count(distinct sender_id, send_to_id) as req, Month(request_date) as month from friend_request) d 
where c.month = d.month 
group by c.month


------------- Follow-up 2 ---------------

-- Left Join using >=. This allows each date to be joined on every date before it which then can be used for cumulative summing.

## sum up the case when ind is 'a', which means it belongs to accept table, divided by sum of ind is 'r', which means it belong to request table
select s.date1, ifnull(round(sum(case when t.ind = 'a' then t.cnt else 0 end)/sum(case when t.ind = 'r' then t.cnt else 0 end),2),0) 
from
## get a table of all unique dates
(select distinct x.request_date as date1 from friend_request x
## The reason here use union sicne we don't want duplicate date
union 
 select distinct y.accept_date as date1 from request_accepted y 
) s
## left join to make sure all dates are in the final output
left join 
## get a table of all dates, count of each days, ind to indicate which table it comes from
(select v.request_date as date1, count(*) as cnt,'r' as ind from friend_request v group by v.request_date
## The reason here use union all sicne union all will be faster
union all
select w.accept_date as date1, count(*) as cnt,'a' as ind from request_accepted w group by w.accept_date) t
## s.date1 >= t.date1, which for each reacord in s, it will join with all records earlier than it in t
on s.date1 >= t.date1
# group by s.date1 then we can get a cumulative result to that day
group by s.date1
order by s.date1
;