-- 2.Which actors participated in the movie ‘Academy Dinosaur’? Print their first and last names.
select a.first_name as 'Actor firstName',a.last_name as 'Actor lastName' 
from film as f
inner join film_actor as fa
ON f.film_id=fa.film_id
inner join actor as a
ON fa.actor_id=a.actor_id
where f.title='Academy Dinosaur';

-- 4.What is the total amount paid by each customer for all their rentals? 
    -- For each customer print their name and the total amount paid.
select concat(c.first_name,' ',c.last_name) as 'Customer Name',sum(p.amount) as 'Total Amount Paid'
from customer as c
inner join payment as p
ON c.customer_id=p.customer_id
group by c.customer_id;
  
-- 5.How many films from each category each store has?
  -- Print the store id, category name and number of films. Order the results by store id and category name.  
select c.name as'Film_Category',count(i.film_id) as 'No Of films'
from category as c
inner join film_category as fc
ON c.category_id=fc.category_id
inner join inventory as i
ON fc.film_id=i.film_id
inner join store as s
ON i.store_id=s.store_id
group by c.name;

-- 6.Calculate the total revenue of each store.
select s.store_id as 'Store ID', sum(p.amount) as `Total Revenue` 
	from store as s 
	inner join inventory as i 
    ON i.store_id = s.store_id
	inner join rental as r 
    ON i.inventory_id = r.inventory_id
	inner join payment as p 
    ON p.rental_id = r.rental_id
	group by s.store_id;
    
-- 8.Find pairs of actors that participated together in the same movie and print their full names.
  -- Each such pair should appear only once in the result. (You should have 10,385 rows in the result)
select distinct concat(a1.first_name, ' ', a1.last_name) AS actor1,
				concat(a2.first_name, ' ', a2.last_name) AS actor2
from film_actor fa1
inner join film_actor fa2 
ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
inner join actor a1 
ON fa1.actor_id = a1.actor_id
inner join actor a2 
ON fa2.actor_id = a2.actor_id;

-- 9.Display the top five most popular films, i.e., films that were rented the highest number of times.
 -- For each film print its title and the number of times it was rented.
 select f.title,count(r.inventory_id) as 'Rental Times'
 from film as f
 inner join inventory as i
 ON f.film_id=i.film_id
 inner join rental as r
 ON i.inventory_id=r.inventory_id
 group by i.film_id
 order by count(r.inventory_id) desc
 limit 5;
 
 
 -- 10.Is the film ‘Academy Dinosaur’ available for rent from Store 1?
  -- You should check that the film exists as one of the items in the inventory of Store 1,
    -- and that there is no outstanding rental of that item with no return date.
select f.title as 'Film',s.store_id,count(i.inventory_id) as 'In Inventory',
                 count(r.rental_id) as 'On Rent',
                 (count(i.inventory_id)-count(r.rental_id)) as 'Avaliable For Rent '
from film as f
inner join 	inventory as i
ON f.film_id=i.film_id
inner join store as s
ON i.store_id=s.store_id
left join rental as r
ON i.inventory_id=r.inventory_id
where f.title='Academy Dinosaur'AND i.store_id=1 And r.return_date IS NULL
group by f.film_id;


-- ------------------------------------------------------------------another medium site questions
-- 7.Write a query to find the film which grossed the highest revenue for the video renting organization.
select f.title,sum(p.amount)
from film as f
inner join inventory as i using(film_id)
inner join rental as r using(inventory_id)
inner join payment as p using(rental_id)
group by f.title
order by sum(p.amount) desc
limit 1;

-- 8.Write a query to find the city which generated the maximum revenue for the organization.
select city,sum(amount)
from payment
inner join staff using(staff_id)
inner join address using(address_id)
inner join city using (city_id)
group by city
order by sum(amount) desc
limit 1;

-- 9.Write a query to find out how many times a particular movie category is rented. 
 -- Arrange these categories in the decreasing order of the number of times they are rented.
select name as 'Name',count(rental_id) as 'Rental_count'
from category
inner join film_category using(category_id)
inner join inventory using(film_id)
inner join rental using(inventory_id)
group by name
order by Rental_count desc;

-- 10.Write a query to find the full names of customers who have rented sci-fi movies more than 2 times. 
    -- Arrange these names in alphabetical order.
    select concat(first_name,' ',last_name) as 'Full_Name'
    from customer
    inner join rental using(customer_id)
    inner join inventory using(inventory_id)
    inner join film_category using(film_id)
    inner join category on category.category_id=film_category.category_id
    AND name='sci-fi'
    group by Full_Name
    having count(rental_id)>2
    order by Full_Name;
    
-- 11.Write a query to find the full names of those customers who have rented at least one movie and belong to the city Arlington.    
select concat(first_name,' ',last_name) as 'Full_Name'
from rental
join customer using (customer_id)
join address using (address_id)
join city on address.city_id=city.city_id AND city='Arlington'
group by customer_id
having count(rental_id)>=1;


-- 12.Write a query to find the number of movies rented across each country. 
  -- Display only those countries where at least one movie was rented. Arrange these countries in alphabetical order.
select country,count(rental_id) AS Rental_count
from rental 
join  customer using(customer_id)
join address using (address_id)
join city using(city_id)
join country using(country_id)
group by country
having Rental_count>=1
order by country;