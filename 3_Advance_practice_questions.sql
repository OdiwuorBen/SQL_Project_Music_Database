/* Question 1: Find the total amount spent by each customer on artists? 
Write a query to return customer name, artist name and and total spent.
*/

WITH best_selling_artist AS (
    SELECT a.artist_id AS artist_id, a.name AS artist_name, SUM(il.unit_price * il.quantity) AS amount_spent 
    FROM invoice_line AS il
    JOIN track AS t ON t.track_id = il.track_id
    JOIN album AS alb ON alb.album_id = t.album_id
    JOIN artist AS a ON a.artist_id = alb.artist_id
    GROUP BY 1
    ORDER BY 3 DESC
    LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice AS i
JOIN customer AS c ON c.customer_id = i.customer_id
JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
JOIN track AS t ON t.track_id = il.track_id
JOIN album AS alb ON alb.album_id = t.album_id
JOIN best_selling_artist AS bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC;
/*The highest spender was Hugh O'Reilly with a total spending of 27.72
while the least spenders spent a total of 0.99 each*/

/* Question 2: We want to find out the most popular music genre for each country. We determine
the most popular genre as the genre with the highest amount of purchases. Write a query that returns 
each country along with the top genre. For countries where the maximum number of purchases is shared
return all genres.
*/

WITH popular_genre AS (
    SELECT COUNT(il.quantity) AS purchases, c.country, g.name, g.genre_id,
        ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS row_num
    FROM invoice_line AS il
    JOIN invoice AS i ON i.invoice_id = il.invoice_id
    JOIN customer AS c ON c.customer_id = i.customer_id
    JOIN track AS t ON t.track_id = il.track_id
    JOIN genre AS g ON g.genre_id = t.genre_id
    GROUP BY 2, 3, 4
    ORDER BY 2 ASC, 1 DESC
)
SELECT *
FROM popular_genre 
WHERE row_num <= 1;
/* Argentine Alternative & Punk had the highest purchases while in the
rest of the countries Rock appeared to be the most popular genre.*/

/* Question 3: Write a query that determines the customer that has spent the most on
music for each country. Write a query that returns the country along with the top 
customer and how much they spent. For countries where the top amount spent is shared, 
provide all customers who spent this amount.
*/

WITH customer_with_country AS (
    SELECT c.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
        ROW_NUMBER () OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) AS row_num
    FROM invoice AS i
    JOIN customer AS c ON c.customer_id = i.customer_id
    GROUP BY 1, 2, 3, 4
    ORDER BY 4 ASC, 5 DESC
)
SELECT *
FROM customer_with_country
WHERE row_num <= 1
/*R. Madhav from Czech Republic was the highest spender with a total
spending of 144.54, followed by Hugh from Ireland (114.84), then India, Brazil, Portugal and so on.*/ 




