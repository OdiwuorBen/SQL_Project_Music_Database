-- Question 1: Who is the senior most employee based on job title? 
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;
/* The senior most employee is Madan Mohan, employee_id 9, who is 
a Senior General Manager*/ 

--Question 2: Which countries have the most invoices?
SELECT COUNT(*) AS invoice_count, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC
LIMIT 5;
/*The countries with the most invoices include USA (131), Canada (76)
Brazil(61), France(50) and Germany (41) */

--Question 3: What are top 3 values of total invoice?
SELECT *
FROM invoice
ORDER BY total DESC
LIMIT 3;
/*The top 3 values of total invoice are invoice_id 183 (23.76),
invoice_id 92(19.8) & invoice_id 31 (with a total of 19.8)*/

/* Question 4: Which city has the best customers?
Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name and sum of all invoice totals.
*/

SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;
--Prague has the best customers with an invoice total of 273.24.

/* Question 5: Who is the best customer? The customer who has spent
the most money will be declared the best customer. Write a query that
returns the person who has spent the most money?
*/

SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total
FROM customer AS c
JOIN invoice AS i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total DESC
LIMIT 1;
--The best customer is R. Madhav with a total of 144.54