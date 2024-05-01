-- 1a. Display the first and last names of all actors from the table actor.
select first_name,last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select  upper(concat(first_name,' ',last_name)) as Actor_name from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, “Joe.” What is one query would you use to obtain this information?
select actor_id,first_name,last_name from actor where first_name='Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%LI%' order by last_name,first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country from country where country in ('Afghanistan','Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name
alter table actor 
add middle_name varchar(100)
after first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
alter table actor
modify middle_name blob;

-- 3c. Now delete the middle_name column.
alter table actor 
drop middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name,count(last_name)as 'last Name Count' from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,count(last_name) as 'last Name Count' from actor
group by last_name
having count(last_name)>1;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo’s second cousin’s husband’s yoga teacher. Write a query to fix the record.
update actor
set first_name='HARPO'
where first_name='GROUCHO' and last_name='WILLIAMS';

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
 It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
 Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
 BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! */
update actor
	set first_name = case
		when first_name = 'Harpo' AND last_name = 'Williams' THEN 'GROUCHO'
    	when first_name = 'Groucho' AND last_name = 'Williams' THEN 'MUCHO GROUCHO'
    	else first_name
	END
    where last_name='Williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
create table address_new (
		address_id integer(11) NOT NULL primary key,
    		address varchar(30) NOT NULL,
    		adress2 varchar(30) NOT NULL,
    		district varchar(30) NOT NULL,
    		city_id integer(11) NOT NULL,
    		postal_code integer(11) NOT NULL,
    		phone integer(10) NOT NULL,
    		location varchar(30) NOT NULL,
    		last_update datetime
	);
    
 -- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
   select s.first_name,s.last_name,a.address
   from staff as s
   join address as a
   ON s.address_id=a.address_id;
   
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select concat(first_name,s.last_name) as 'Name',sum(p.amount)as 'Total Amount'
from payment as p
join staff as s
ON s.staff_id=p.staff_id
where payment_date like '2005-08%'
group by p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title as 'Film',count(fa.actor_id) as 'Actors Count'
from film_actor as fa
join film as f
ON f.film_id=fa.film_id
group by fa.film_id;

-- 6d. How many copies of the film 'Hunchback Impossible' exist in the inventory system?
select f.title 'Film',count(i.inventory_id) as 'Inventory Count'
from film as f
join inventory as i
ON f.film_id=i.film_id
where f.title='Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select concat(c.first_name,' ',c.last_name) as 'Name' ,sum(p.amount) as 'Total Amount'
from customer as c
inner join payment as p
ON c.customer_id=p.customer_id
group by p.customer_id
order by c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
   -- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
     -- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film
where language_id = (select language_id from language where name='English') 
AND title Like 'K%' 
OR title Like 'Q%' ;     

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name,' ',last_name) as 'Actor Name'from actor
where actor_id in (select actor_id from film_actor
where film_id=(select film_id from film where title ='Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select 	concat(c.first_name,' ',c.last_name),c.email 
from customer as c
inner join address as a
ON a.address_id=c.address_id
inner join city as ci
ON ci.city_id=a.city_id
inner join country as ct
ON ct.country_id=ci.country_id
where ct.country='Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
  -- Identify all movies categorized as famiy films.
select f.title as 'Film Title'
	from film as f
	inner join film_category as fc 
    ON fc.film_id = f.film_id
	inner join category as c 
    ON c.category_id = fc.category_id
	where c.name = 'Family';


-- 7e. Display the most frequently rented movies in descending order.
select f.title as 'Film', count(r.rental_date) as 'Times Rented'
	from film as f
	inner join inventory as i on i.film_id = f.film_id
	inner join rental as r on r.inventory_id = i.inventory_id
	group by f.title
	order by count(r.rental_date) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select sum(payment.amount)as 'Store Revenue',st.store_id as 'Store Id'
    from payment
    left join staff as st 
    ON (payment.staff_id=st.staff_id)
	group by st.store_id;
/*  -- 2nd way  
select s.store_id as 'Store ID', sum(p.amount) as `Store  Revenue` 
	from store as s 
	inner join inventory as i 
    ON i.store_id = s.store_id
	inner join rental as r 
    ON i.inventory_id = r.inventory_id
	inner join payment as p 
    ON p.rental_id = r.rental_id
	group by s.store_id;     
*/     

-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id as 'Store Id', c.city as 'City', cy.country as 'Country'
	from store as s
	inner join address as a on a.address_id = s.address_id
	inner join city as c on c.city_id = a.city_id
	inner join country as cy on cy.country_id = c.country_id
	order by s.store_id;

-- 7h. List the top five genres in gross revenue in descending order.
select c.name as 'Film' ,sum(p.amount) as 'Revenue'
from category as c
inner join film_category as fc
ON c.category_id=fc.category_id
inner join inventory as i
ON fc.film_id=i.film_id
inner join rental as r
ON i.inventory_id=r.inventory_id
inner join payment as p
ON r.rental_id=p.rental_id
group by Film
order by Revenue desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
  -- Use the solution from the problem above to create a view. If you haven’t solved 7h, you can substitute another query to create a view.
create view top_5_genre_revenue as
select c.name as 'Film' ,sum(p.amount) as 'Revenue'
from category as c
inner join film_category as fc
ON c.category_id=fc.category_id
inner join inventory as i
ON fc.film_id=i.film_id
inner join rental as r
ON i.inventory_id=r.inventory_id
inner join payment as p
ON r.rental_id=p.rental_id
group by Film
order by Revenue desc
limit 5;

-- 8b. How would you display the view that you created in 8a?
select  * from top_5_genre_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_5_genre_revenue;
