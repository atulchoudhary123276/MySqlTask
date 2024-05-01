-- 1.Which actors have the first name ‘Scarlett’
select * from actor 
  where first_name='Scarlett';
  
  -- 2.Which actors have the last name ‘Johansson’
select * from actor 
  where last_name='Johansson';
  
  -- 3.How many distinct actors last names are there?
select count(distinct last_name) from actor;

-- 4.Which last names are not repeated?
select last_name from actor
 group by last_name
 having count(last_name)=1;
 
 -- 5.Which last names appear more than once?
 select last_name,count(last_name) from actor
 group by last_name
 having count(last_name)>1;
 
 -- 6.Which actor has appeared in the most films?
   -- WITH CTE
WITH count_cte AS(
    select concat(a.first_name,' ',a.last_name) as 'Actor_Name',count(f.actor_id) as 'Count_Of_Films'
    from actor as a
    inner join film_actor as f
    ON a.actor_id=f.actor_id
    group by a.actor_id
),
max_cte AS(
    select max(Count_Of_Films)as Max_Films from count_cte
)
select Actor_Name,Count_Of_Films from count_cte,max_cte
where Max_Films=Count_Of_Films;

 /*  --2nd way
 select concat(actor.first_name,' ',actor.last_name) as 'Actor Name',count(film_actor.actor_id) as countOfFilms 
 from actor
 inner join film_actor
 on actor.actor_id=film_actor.actor_id
 group by actor.actor_id
 order by countOfFilms desc
 limit 1;
 */
 
-- 7.Is ‘Academy Dinosaur’ available for rent from Store 1?
select f.title as 'Film',s.store_id,count(i.inventory_id) as 'In Inventory',
                 count(r.rental_id) as 'On Rent',
                 (count(i.inventory_id)-count(r.rental_id)) as 'Avaliable For Rent 'from film as f
inner join 	inventory as i
ON f.film_id=i.film_id
inner join store as s
ON i.store_id=s.store_id AND i.store_id=1
left join rental as r
ON i.inventory_id=r.inventory_id
where f.title='Academy Dinosaur' ;

-- 8.Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, return_date)
VALUES (
    now(),
    (SELECT i.inventory_id 
    FROM inventory i
    JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'Academy Dinosaur' AND i.store_id = 1
    limit 1),
    (SELECT customer_id FROM customer WHERE first_name = 'Mary' AND last_name = 'Smith'),
    (SELECT staff_id FROM staff WHERE first_name = 'Mike' AND last_name = 'Hillyer'),
    NULL
);

-- 9.When is ‘Academy Dinosaur’ due?
/*select rental_date,
rental_date + interval(select rental_duration from film where title ='Academy Dinosaur')day as dueDate
from rental 
where rental_id=(select rental_id from rental order by rental_id desc limit 1);  */
 
select rental_date, rental_date + interval(f.rental_duration)day as dueDate
from rental r 
inner join inventory i 
ON i.inventory_id = r.inventory_id 
inner join  film f ON f.film_id = i.film_id 
where f.title = 'Academy Dinosaur'
AND r.return_date is null;


-- 10.What is that average running time of all the films in the sakila DB?
select avg(length) as 'Avg Of AllFilms Running Time' from film;

-- 11.What is the average running time of films by category?
select c.name,avg(f.length) as 'Avg Of Running Time'
from film as f
inner join film_category as fc
ON f.film_id=fc.film_id
inner join category as c
ON fc.category_id=c.category_id
group by c.name;

-- 12.Why does this query return the empty set?
select * from film natural join inventory;   

-- using inner join
select * from film  as f
inner join inventory as i
ON i.film_id=f.film_id;


-- 13.find the country of that customer who paid higest amount?
select c.customer_id,cy.country,sum(p.amount) as 'Max_Sum'
from payment as p
join customer as c
ON c.customer_id=p.customer_id
join address as a
ON a.address_id=c.address_id
join city as ct
ON ct.city_id=a.city_id
join country as cy
ON cy.country_id=ct.country_id
group by c.customer_id
order by Max_Sum desc
limit 1;
