/*Question 1: Write query to return the email, first name, last name 
& genre of all Rock music listeners. Return your list ordered 
alphabetically by email starting with A.
*/

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
--This query returns 59 records of Rock music listeners.

/* Question 2: Let's invite the artist who have have written the most Rock music
in our dataset. Write a query that returns the artist name and
total track count of the top 10 Rock bands.
*/

SELECT a.artist_id, a.name, COUNT(a.artist_id) AS number_of_songs
FROM track AS t
JOIN album AS al ON al.album_id = t.album_id
JOIN artist AS a ON a.artist_id = al.album_id
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock' 
GROUP BY a.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;
/*The Police has the highest number of songs (30), followed by David
Coverdale, Green Day, Ed Motta, and Sir Georg Solti & Wiener Philharmoniker at 20 songs.
One artist had 18 songs and the rest in the top 10 had 17 songs*/

/* Question 3: Return all the track names that have a song length longer than the 
average song length. Return the Name and Milliseconds for each track.
Order by the song length with the longest songs listed first.
*/

SELECT name, milliseconds
FROM track
WHERE milliseconds >(
    SELECT AVG(milliseconds) AS avg_track_length
    FROM track
)
ORDER BY milliseconds DESC;
--The are 494 songs with song length longer than the song length which is 393599.21 milliseconds.


