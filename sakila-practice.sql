USE SAKILA;
-- Easy --

-- 1. How many records are there in the actor table--
SELECT COUNT(*) AS num_recs FROM actor;
-- ANS: 200--

-- 2. What are the columns in the address table --
SHOW columns FROM address;
-- ANS: postal_code, location, last_update, district, city_id, address_id, address2, address --

-- 3. How many different categories are there in the `category` table? --
SELECT COUNT(DISTINCT name) FROM category;
-- ANS: 16 --

-- 4. How many films are there? --
SELECT COUNT(DISTINCT film_id) FROM film;
-- ANS: 1000 --

-- 5. How many customers have a last name starting with the letter 'S' --
SELECT * FROM customer WHERE last_name LIKE 'S%';
SELECT COUNT(*) FROM customer WHERE last_name LIKE 'S%';
-- ANS: There are 54 customers whose last names start with S --

-- 6. How many distinct languages are associated with the films in the database --
SELECT COUNT(DISTINCT language_id) AS num_distinct_lang FROM film;
-- ANS: 1. Guess there is only English --

-- 7. What is the primary key of the film_actor table --
SHOW KEYS from film_actor WHERE KEY_NAME = 'Primary';
-- ANS: actor_id, film_id --

-- 8. How many records are there in the film_category table --
SELECT COUNT(*) AS num_records FROM film_category;
-- ANS: 1000 --

-- 9. What is the name of the longest film in the database and how long it is in minutes--
SELECT title, length FROM film ORDER BY length DESC LIMIT 1;
-- ANS: Chicago North --

-- 10. How many records are there in the inventory table? --
SELECT COUNT(*) FROM inventory;
-- ANS: 4581 --

-- Medium --

-- 11. How many unique languages are there in the language table? --
SELECT COUNT(DISTINCT language_id) FROM language;
-- ANS: 6 --

-- 12. How many different payment amounts are recorded in the payment table? --
SELECT COUNT(DISTINCT amount) AS unique_payment_amount FROM payment;
-- ANS: 19 --

-- 13. How many films have been rented at least once? --
SELECT COUNT(DISTINCT i.film_id) AS count_films
FROM rental AS r
LEFT JOIN inventory AS I
USING(inventory_id);
-- ANS: 958 --

-- 14. Which film has the most actos associated with it? --
SELECT COUNT(fa.actor_id) AS num_actors, f.title FROM film_actor AS fa
LEFT JOIN film AS f
USING(film_id)
GROUP BY film_id ORDER BY num_actors DESC LIMIT 1;
-- ANS: Lambs Cincinatti --

-- 15. How many customers are there in the database who have made payments? --
SELECT COUNT(DISTINCT customer_id) as num_payments FROM payment;
-- ANS: 599 --

-- 16. How many distinct rental dates are there in the database who have made payments? --
SELECT COUNT(DISTINCT DATE(rental_date)) AS unique_dates FROM rental;
-- ANS: 41 --

-- 17. Which store has the highest inventory count? --
SELECT COUNT(inventory_id) AS inv_count, store_id FROM inventory GROUP BY store_id ORDER BY inv_count desc LIMIT 1;
-- ANS: store_id = 2 --

-- 18. How many films are categorized as 'Family' genre? --
SELECT COUNT(film_id) AS count_fam_films, name
FROM film_category
LEFT JOIN category
USING(category_id)
GROUP BY name
HAVING name = 'Family';
-- ANS: 69 --

-- 19. How many distinct rental durations are there in the 'rental' table? --
SELECT COUNT(DISTINCT(DATEDIFF(return_date, rental_date))) AS rental_duration FROM rental;
-- ANS: 11 --

-- 20. What is the avaerage lenght of films in the 'film' table? --
SELECT AVG(length) AS avg_length FROM film;
-- ANS: 115.2720 --

-- HARD --

-- 21. Which actor has appeared in the most films according to the film_actor table? --
SELECT COUNT(fa.film_id) AS count_films, fa.actor_id, a.first_name, a.last_name
FROM film_actor AS fa
LEFT JOIN actor AS a
USING(actor_id)
GROUP BY actor_id
ORDER BY count_films DESC
LIMIT 1;
-- ANS: 42 - Gina Degeneres (You would be shocked if you knew how many films Brahmanandam acted in)--

-- 22. How many films have more than one category associated with them? -- 
SELECT COUNT(*) AS count_movies
FROM (
    SELECT film_id
    FROM film_category
    GROUP BY film_id
    HAVING COUNT(*) > 1
) AS subquery;
-- ANS: 0 --

-- 23. How many different cities are recorded in the 'city' table? --
SELECT COUNT(DISTINCT city_id) AS unique_cities FROM city;
-- ANS: 600 --

-- 24. Which customer has made the highest total payment? --
SELECT SUM(amount) AS total_amt, customer_id FROM payment GROUP BY customer_id;
SELECT SUM(p.amount) AS total_amt, CONCAT(c.first_name,' ', c.last_name) AS full_name
FROM payment AS p
LEFT JOIN customer AS c
USING(customer_id)
GROUP BY full_name
ORDER BY total_amt DESC
LIMIT 1;
-- ANS: 221.55 by Karl Seal --

-- 25. How many films have a description containing the word 'action'? --
SELECT COUNT(sub.film_id) AS action_movies FROM 
	(SELECT film_id, description FROM film WHERE description LIKE '%action%') AS sub;
-- ANS: 44 --

-- 26. What is the total number of available inventory items for each film in the inventory table? --
SELECT COUNT(inventory_id) as inventory_count, film_id FROM inventory GROUP BY film_id; 
-- ANS: A table of two columns with each film's inventory count --

-- 27. What is the average length of films in each category, ordered from highest to lowest average length? --
SELECT AVG(f.length) AS avg_length, c.name FROM film AS f
LEFT JOIN film_category AS fc
USING(film_id)
LEFT JOIN category AS c
USING(category_id)
GROUP BY c.name
ORDER BY avg_length DESC;
-- Highest average length: Sports, Lowest: Sci-Fi --

-- 28. How many customers have rented films from both stores? --
SELECT COUNT(sub.customer_id) FROM 
(SELECT SUM(DISTINCT staff_id), customer_id
FROM rental
GROUP BY customer_id
HAVING SUM(DISTINCT staff_id) = 3) AS sub;
-- ANS: 599 --

-- 29. How many distict addresses are recorded in the 'address' table? --
SELECT COUNT(address_id) from address;
-- ANS: 603 --

-- 30. What is the average rental rate of films in the 'films' table? --
SELECT AVG(rental_rate) as avg_rental FROM film;
-- ANS: 2.98 --

-- 31. Which films have been rented the most according to the 'rental' table? --
SELECT COUNT(DISTINCT r.rental_id) AS num_rentals, f.title FROM rental AS r
LEFT JOIN inventory AS i
USING(inventory_id)
LEFT JOIN film AS f
USING(film_id)
GROUP BY f.title
ORDER BY num_rentals DESC
LIMIT 1;
-- ANS: Bucket Brotherhood (34) --

-- 32. Which film category has the highest average rental duration in minutes? -- 
SELECT TIMESTAMPDIFF(minute, rental_date, return_date) FROM rental;
SELECT AVG(TIMESTAMPDIFF(minute, r.rental_date, r.return_date)) AS avg_rental, c.name FROM RENTAL AS r
LEFT JOIN inventory AS i
USING(inventory_id)
LEFT JOIN film_category AS fc
USING(film_id)
LEFT JOIN category AS c
USING(category_id)
GROUP BY c.name
ORDER BY avg_rental DESC
LIMIT 1;
-- ANS: Sports (7483.8153) --

/* 33. Which actor has appeared in the most films in a single category? 
If there are multiple actors with the same highest count, list all of them. */
WITH actor_category_mapping AS(
SELECT fa.actor_id, COUNT(DISTINCT fa.film_id) AS each_cat_count, fc.category_id 
FROM film_actor AS fa
LEFT JOIN film_category AS fc
USING(film_id)
GROUP BY fa.actor_id, fc.category_id)

SELECT MAX(acm.each_cat_count) AS max_cat_actor, CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM actor_category_mapping AS acm
LEFT JOIN actor AS a
USING(actor_id)
GROUP BY actor_id
ORDER BY max_cat_actor DESC LIMIT 1;
-- ANS: Ben Willis (9) --

-- 34. How many films have a rental duration of less than 5 days? --
SELECT TIMESTAMPDIFF(minute, rental_date, return_date) AS rental_duration_days 
FROM rental
WHERE TIMESTAMPDIFF(minute, rental_date, return_date) < 5;
-- Ans: No film is rented for less than 5 days --

-- 35. How many rentals have been made by each customer? --
SELECT COUNT(rental_id)AS num_rentals, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM rental
LEFT JOIN customer AS c
USING(customer_id)
GROUP BY customer_id
ORDER BY num_rentals DESC;
-- ANS: Two columns are returned --

-- 36. What is the total rental revenue generated from each film category?--
SELECT SUM(p.amount) as rental_revenue, c.name AS category_name
FROM payment AS p
LEFT JOIN rental 
USING(rental_id)
LEFT JOIN inventory
USING(inventory_id) 
LEFT JOIN film AS f
USING(film_id)
LEFT JOIN film_category
USING(film_id)
LEFT JOIN category AS c
USING(category_id)
GROUP BY category_name;

-- ANS: Rental revenue of each category is returned --

-- 37. How many films are in the 'Comedy' category? --
SELECT COUNT(film_id) AS comedy_films
FROM film
LEFT JOIN film_category
USING(film_id)
LEFT JOIN category AS c
USING(category_id)
WHERE c.name = 'Comedy';
-- Ans: 58 --

-- 38. Which customer has the highest average rental duration? --
SELECT AVG(TIMESTAMPDIFF(day, rental_date, return_date)) AS avg_rental_duration, CONCAT(first_name, ' ', last_name) AS customer_name 
FROM rental
LEFT JOIN customer
USING(customer_id)
GROUP BY customer_name
ORDER BY avg_rental_duration DESC
LIMIT 1;
-- Ans: Kenneth Gooden, 6.125 days --

-- 39. Which category has been the most rented? --
SELECT COUNT(r.rental_id) AS num_rentals, c.name AS category_name
FROM rental AS r
LEFT JOIN inventory
USING(inventory_id)
LEFT JOIN film
USING(film_id)
LEFT JOIN film_category
USING(film_id)
LEFT JOIN category AS c
USING(category_id)
GROUP BY category_name
ORDER BY num_rentals DESC
LIMIT 1;
-- Ans: Sports 1179 --

-- 40. Which film has the highest cumulative rental duration across all rentals? --
SELECT SUM(TIMESTAMPDIFF(day, rental_date, return_date)) AS rental_duration, f.title
FROM rental
LEFT JOIN inventory
USING(inventory_id)
LEFT JOIN film AS f
USING(film_id)
GROUP BY f.title
ORDER BY rental_duration DESC;
-- Ans: Ridgemont Submarine, 173 days --

-- 41. Which film category has the highest replacement cost? --
SELECT SUM(replacement_cost) AS cum_replacement_cost, c.name AS category_name
FROM film 
LEFT JOIN film_category
USING(film_id)
LEFT JOIN category AS c
USING(category_id)
GROUP BY category_name
ORDER BY cum_replacement_cost DESC
LIMIT 1;
-- Ans: Sports, 1509.26 -- 

-- 42. How many different films have been rented by each customer? --
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(rental_id) AS num_rentals FROM customer AS c
LEFT JOIN rental
USING(customer_id)
GROUP BY customer_name
ORDER BY num_rentals DESC;
-- Ans: Two columns are returned --

-- 43. Which customer has the highest number of rentals? --
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(rental_id) AS num_rentals FROM customer AS c
LEFT JOIN rental
USING(customer_id)
GROUP BY customer_name
ORDER BY num_rentals DESC
LIMIT 1;
-- Ans: Eleanor Hunt (46) --

-- 44. What is the average length of films in the 'Action' category? --
SELECT AVG(length) AS action_avg_length
FROM film
LEFT JOIN film_category
USING(film_id)
LEFT JOIN category
USING(category_id)
WHERE name = 'Action';
-- Ans: 111.6094 --

-- 45. How many films have not been rented by any customer? --
SELECT COUNT(DISTINCT film_id) from film 
WHERE film_id NOT IN (
SELECT film_id FROM rental
LEFT JOIN inventory
USING(inventory_id)
LEFT JOIN film
USING(film_id));
-- Ans: 42 --

-- 46. How many customers have rented films from all categories? -- 
SELECT COUNT(*) AS num_customers_all_categories FROM (
	SELECT COUNT(DISTINCT category_id), customer_id FROM rental
	LEFT JOIN inventory
	USING(inventory_id)
	LEFT JOIN film
	USING(film_id)
	LEFT JOIN film_category
	USING(film_id)
	LEFT JOIN category
	USING(category_id)
	GROUP BY customer_id
	HAVING COUNT(DISTINCT category_id) = (SELECT COUNT(category_id) FROM category)) AS sub;
-- Ans: 19 --

-- 47. Which film category has the highest number of films that have never been rented? --
WITH sub AS( SELECT COUNT(DISTINCT film_id) AS films_not_rented, name from film 
LEFT JOIN film_category
USING(film_id)
LEFT JOIN category
USING(category_id)
WHERE film_id NOT IN (
SELECT film_id FROM rental
LEFT JOIN inventory
USING(inventory_id)
LEFT JOIN film
USING(film_id))
GROUP BY name) 
SELECT name, sub.films_not_rented AS max_films_not_rented FROM sub
WHERE sub.films_not_rented = (SELECT MAX(sub.films_not_rented) FROM sub);
-- Ans: Foreign (6) --

-- 48. How many films have a rental rate higher than the average rental rate? --
SELECT COUNT(film_id) AS num_films_greater_avg FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);
-- Ans: 659 --









