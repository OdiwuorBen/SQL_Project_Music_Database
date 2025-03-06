# Introduction
This project focuses on analyzing a music database to extract insights into song trends, artist popularity, genre distribution, and other key metrics. Using data analysis techniques, we explore patterns in streaming counts, album releases, and listener preferences. The goal is to provide actionable insights for music industry professionals, researchers, and enthusiasts. The analysis is performed using PostgreSQL.
Find the SQL queries here: [Easy Queries](/1_Easy_practice_questions.sql),[Moderate Queries](/2_Moderate_practice_questions.sql) & [Advanced Queries](/3_Advance_practice_questions.sql)

# Background
The music industry generates vast amounts of data from streaming platforms, digital downloads, and social media interactions. Understanding this data can help artists, record labels, and marketers make informed decisions about music production, promotion, and distribution. This project leverages data analytics to explore trends in music consumption, artist popularity, and genre evolution, providing valuable insights into the ever-changing landscape of the industry.
The data hails from [Data Source](https://drive.google.com/file/d/1eOw8GZ7-T25-8OWQf5DNroI8m6kzyq3G/view)
## The questions I wanted to answer through my SQL queries were:
### Easy Questions  
1. Who is the senior most employee based on job title?   
2. Which countries have the most invoices?  
3. What are top 3 values of total invoice?  
4. Which city has the best customers? Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name and sum of all invoice totals.  
5. Who is the best customer? The customer who has spent
the most money will be declared the best customer. Write a query that
returns the person who has spent the most money?
### Moderate Questions  
1. Write query to return the email, first name, last name 
& genre of all Rock music listeners. Return your list ordered 
alphabetically by email starting with A.  
2. Let's invite the artist who have have written the most Rock music in our dataset. Write a query that returns the artist name and total track count of the top 10 Rock bands.   
3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.   
### Advanced Questions
1. Find the total amount spent by each customer on artists? 
Write a query to return customer name, artist name and and total spent.  
2. We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns 
each country along with the top genre. For countries where the maximum number of purchases is shared
return all genres.   
3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
# Tools I used
- **SQL :** The backbone of my analysis, allowing me to query the database and and unearth critical insights.  
- **PostgreSQL :** The chosen database management system, ideal for handling the job posting data.  
- **Visual Studio Code :** My go-to for database management and executing SQL queries.  
- **Git & GitHub :** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Here is how I approached each question:  
### Easy Questions
1. Who is the senior most employee based on job title?
```sql  
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;
```
**Finding:** The senior most employee is Madan Mohan, employee_id 9, who is 
a Senior General Manager  

2. Which countries have the most invoices?
```sql
SELECT COUNT(*) AS invoice_count, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC
LIMIT 5;
```


3. What are top 3 values of total invoice?
```sql  
SELECT *
FROM invoice
ORDER BY total DESC
LIMIT 3;
```
4. Which city has the best customers? Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name and sum of all invoice totals. 
```sql
SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;
```
5. Who is the best customer? The customer who has spent
the most money will be declared the best customer. Write a query that returns the person who has spent the most money?
```sql
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total
FROM customer AS c
JOIN invoice AS i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total DESC
LIMIT 1;
```
### Moderate Questions
1. Write query to return the email, first name, last name 
& genre of all Rock music listeners. Return your list ordered 
alphabetically by email starting with A.
```sql
SELECT DISTINCT email, first_name, last_name
FROM customer AS c
JOIN invoice AS i
ON c.customer_id = i.customer_id
JOIN invoice_line AS il
ON il.invoice_id = i.invoice_id
WHERE track_id IN (
    SELECT track_id
    FROM track AS t
    JOIN genre AS g 
    ON t.genre_id = g.genre_id
    WHERE g.name LIKE 'Rock'
)
ORDER BY email;
```
2. Let's invite the artist who have have written the most Rock music in our dataset. Write a query that returns the artist name and total track count of the top 10 Rock bands.
```sql
SELECT a.artist_id, a.name, COUNT(a.artist_id) AS number_of_songs
FROM track AS t
JOIN album AS al ON al.album_id = t.album_id
JOIN artist AS a ON a.artist_id = al.album_id
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock' 
GROUP BY a.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;
```
3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. 
```sql
SELECT name, milliseconds
FROM track
WHERE milliseconds >(
    SELECT AVG(milliseconds) AS avg_track_length
    FROM track
)
ORDER BY milliseconds DESC;
```
### Advanced Questions
1. Find the total amount spent by each customer on artists? 
Write a query to return customer name, artist name and and total spent. 
```sql
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
``` 
2. We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns 
each country along with the top genre. For countries where the maximum number of purchases is shared return all genres.
```sql
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
```   
3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
```sql
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
```
# What I learned
1. **Using Joins for Comprehensive Analysis** – By utilizing SQL joins, I was able to combine multiple tables (e.g., albums, artists, and customers data) to gain a more holistic view of the dataset. This allowed me to analyze relationships between artists and their most streamed songs efficiently.

2. **Leveraging Window Functions for Advanced Insights** – Window functions proved essential in ranking songs by popularity within each genre and calculating running totals of streams over time. This helped in identifying trends and understanding how certain songs performed relative to others within the same category.

3. **Simplifying Queries with Common Table Expressions (CTEs)** – Using CTEs improved query readability and maintainability by breaking down complex queries into smaller, manageable steps. This was particularly useful when performing multi-step calculations, such as filtering top-performing songs before applying additional aggregations.
# Conclusion
This analysis provided valuable insights into music trends, artist popularity, and genre performance using SQL and data analysis techniques. By leveraging joins, window functions, and CTEs, we efficiently explored and extracted meaningful patterns from the dataset. These techniques not only enhanced query performance but also improved data interpretation, making it easier to derive actionable insights for the music industry. Future work could involve incorporating machine learning models to predict emerging trends and listener preferences.
