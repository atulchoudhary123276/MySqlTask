-- CTE (by WITH clause)   comes from MYSQL 8.0 version ,before this we use derived table (subquries)

-- single cte
WITH cte1 AS(
select first_name,last_name 
from actor
limit 5
)
select * from cte1;

-- multiple ctes by using one WITH 
WITH cte1 AS(
select actor_id
from film_actor
where actor_id <6
),
cte2 AS(
select actor_id,first_name,last_name
from actor
where actor_id<6
)
select distinct ct2.actor_id,ct2.first_name,ct2.last_name
from cte1 as ct1
inner join cte2 as ct2
ON ct1.actor_id=ct2.actor_id
order by ct2.actor_id;

-- WITH Recursive
WITH RECURSIVE cte_count (n) AS (
      select 1                    -- non recursive term 
      union all
      select n + 1 from cte_count    -- recursive term
      where n < 3                    -- termination condition
    )
select n from cte_count;

