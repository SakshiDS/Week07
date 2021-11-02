-- 1.	Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time. 

	/*  Added a new column 'status' using ALTER TABLE 
	Then updated the table with the value by usinng case when to identify the early, ontime and late returns.
	 */
alter table rental
add column status varchar;

update rental 
set status = s.status
from (select r.inventory_id,
	  CASE WHEN (r.rental_date + INTERVAL'1 day'*f.rental_duration) < r.return_date THEN 'Early'
	WHEN (r.rental_date + INTERVAL'1 day'*f.rental_duration) = r.return_date THEN 'On Time'
	ELSE 'LATE' END as status
from rental as r
left join inventory as i
on r.inventory_id = i.inventory_id
left join film as f
on i.film_id = f.film_id) as s
where rental.inventory_id = s.inventory_id

-- 2.	Show the total payment amounts for people who live in Kansas City or Saint Louis. 

	/* Identified the city_id for Kansas City and Saint Louis.
	Filtered the city_id in where clause and joined the appropriate tables to get customers with the specific city_id 
	and then in turn the amount spent by them from payments table grouped by city. 
	*/

select  city_id from city where city in ('Kansas City','Saint Louis') 

	-- STL code 441 kc code 262

select c2.city, sum(amount)
from payment as p
join customer as c1
ON p.customer_id = c1.customer_id
join address as a
on c1.address_id = a.address_id
join city as c2
on a.city_id = c2.city_id
where c2.city_id in (262,441)
group by c2.city


-- 3.	How many films are in each category? Why do you think there is a table for category and a table for film category?

	/* 
	Joined category and film_category on category_id to get the count of films in each category
	*/

select c.name, count(fc.film_id)
from category as c
left join film_category as fc
on c.category_id = fc.category_id
group by c.name

/*
There is a seperate table for category and film_category as it is possible that database does not have films in all the category.
Hence to avoid null values the category information is store in seperate table as category tableand films in each category is stored in film_category table.
*/

-- 4.	Show a roster for the staff that includes their email, address, city, and country (not ids)

	/* Joined staff, address, city and country table on left to get the staff details
	*/
	
SELECT concat(s.first_name,' ',s.last_name) as name,
s.email,
a.address,
c1.city,
c2.country
from staff as s
left join address as a
on s.address_id = a.address_id
left join city as c1
on a.city_id = c1.city_id
left join country as c2
on c1.country_id = c2.country_id


-- 5.	Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005

	/* Joined film, inventory and rental tables to get the film id, name and length of the film.
	Filtered the result in where clause for the specified return dates
	*/

select f.film_id, f.title, f.length
from film as f
right join inventory as i
on f.film_id = i.film_id
right join rental as r
on i.inventory_id = r.inventory_id
where r.return_date BETWEEN '2005-05-15' and '2005-06-01'

-- 6.	Write a subquery to show which movies are rented below the average price for all movies. 

	/*Wrote a subwuery to calculate the average rental_rate.
	In the main query called title and rental_rate while checking the condition in where clause with subquery.
	*/
select title, rental_rate
from film
where rental_rate <
(select avg(rental_rate) from film)

-- 7.	Write a join statement to show which movies are rented below the average price for all movies.

	/*Using a self join on distinct film_id compared rental_rate in each column in one table instance with the avg rental_rate on another table instance
	*/

select f1.title, f1.rental_rate
from film f1
join film f2
on f1.film_id <> f2.film_id
group by f1.title, f1.rental_rate
having f1.rental_rate < avg(f2.rental_rate)

-- 8.	Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.

	/* Using EXPLAIN for the whole query deducing the cost foe each of them
	*/

EXPLAIN (FORMAT JSON)
select title, rental_rate
from film
where rental_rate <
(select avg(rental_rate) from film)

/*
QUERY PLAN

1.	Seq Scan on film as film (cost=66.51..133.01 rows=333 width=21)
Filter: (rental_rate < $0)
333
2.	Aggregate (cost=66.5..66.51 rows=1 width=32)	1
3.	Seq Scan on film as film_1 (cost=0..64 rows=1000 width=6)
*/

EXPLAIN (FORMAT JSON)
select f1.title, f1.rental_rate
from film f1
join film f2
on f1.film_id <> f2.film_id
group by f1.title, f1.rental_rate
having f1.rental_rate < avg(f2.rental_rate)

/*
QUERY PLAN

1.	Aggregate (cost=22623..22638 rows=333 width=21)
Filter: (f1.rental_rate < avg(f2.rental_rate))
333
2.	Nested Loop Inner Join (cost=0..15130.5 rows=999000 width=27)
Join Filter: (f1.film_id <> f2.film_id)
999000
3.	Seq Scan on film as f1 (cost=0..64 rows=1000 width=25)	1000
4.	Materialize (cost=0..69 rows=1000 width=10)	1000
5.	Seq Scan on film as f2 (cost=0..64 rows=1000 width=10)

*/

/*
OBSERVATION :

It is expensive to write this query with join as it checks for each row it aggregate average rate and then compares.
With subquery the average is calculated once and then scans and compare for each row, making the quer much more efficient.
*/

-- 9.	With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank 

	/* Using the NTILE window function on the length column in asceding order to calculate the percentile of film duration from least being 1percentile to max length being 100 percentile
	*/

select title, length as duration,
	NTILE(100) over (order by length)
	as duration_percentile
from film 

-- 10.	In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are. 
	/* Procedural programming like Python uses a step by step instruction to achieve results. The interpreter iterates in the order the code is written to parse and produce results.
	procedural programming needs step by step instructions coded to achieve the result. 

	Set based programming like SQL uses set properties to achieve results. It requires us to declare what is required while providing minimum steps on how to achieve the result.
	*/
-- Bonus: Find the relationship that is wrong in the data model. Explain why it’s wrong. 
	/* category and film_category relationship is incorrect. 
	Diagram depicts one to one relation between category and film_category. But it should be one to many relationship as many films can be linked to one category.  
	*/
