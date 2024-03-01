use music_store;

-- 1.Who is the senior most employee based on job title?
select * from employee order by levels desc limit 1;

-- 2.Which countries have the most Invoices
select * from invoice;
select billing_country, count(*) as Total_Invoice from invoice group by billing_country order by count(*) desc limit 1;

-- 3. What are top 3 values of total invoice?
select * from invoice order by total desc limit 3;

/* Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals*/
select billing_city,sum(total) as 'Sum_Invoice' from invoice group by billing_city order by sum(total) desc limit 1;

/* Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/
select c.customer_id, c.first_name, c.last_name, sum(i.total) as 'sum' from customer as c
inner join invoice as i
on c.customer_id = i.customer_id
group by c.customer_id,c.first_name, c.last_name
order by sum(i.total) desc limit 1;

/*Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A
*/
SELECT * FROM customer;
select * from track;

select distinct c.first_name, c.last_name, c.email from customer as c
inner join invoice as i 
on c.customer_id  = i.customer_id
inner join invoice_line as iv on i.invoice_id = iv.invoice_id
where iv.track_id in(
select t.track_id from genre as g
inner join track as t
on t.genre_id = g.genre_id
where g.name like 'Rock')
order by email;

/* Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/

select * from genre;
select * from album2;
select * from artist;
select * from album2;

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id,artist.name
ORDER BY number_of_songs DESC
LIMIT 10;


/*. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/

select * from track;

select name, milliseconds from track 
where milliseconds >(
select avg(milliseconds) from track)
order by milliseconds desc;

/*Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent*/

select a.name as 'artist_name',concat(c.first_name,' ',c.last_name) as 'Full_name',round(sum(i.total)) as 'total_amount' from customer as c
inner join invoice as i on c.customer_id= i.customer_id
inner join invoice_line as il on il.invoice_id = i.invoice_id
inner join track as t on t.track_id = il.track_id
inner join album2 as al on al.album_id = t.album_id
join artist as a on a.artist_id = al.artist_id
group by  a.name,concat(c.first_name,' ',c.last_name),i.total
order by i.total desc;
 


/*We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres*/


select * from(select g.name, count(iv.quantity) as 'total_sales',i.billing_country , row_number() 
over(partition by i.billing_country order by (iv.quantity)  desc) as 'Country_Rank' 
from genre as g 
inner join track as t on t.genre_id = g.genre_id
inner join invoice_line as iv on iv.track_id = t.track_id
inner join invoice as i on i.invoice_id = iv.invoice_id
group by i.billing_country, g.name,iv.quantity ) t
where t.Country_Rank =1
order by t.total_sales desc limit 10;

/*Write a query that determines the customer that has spent the most on music for each 
country.*/ 

SELECT * from customer;
select * from invoice;
select * from invoice_line;

select * from(select c.customer_id,c.first_name ,c.last_name,i.total,i.billing_country,
rank() over(partition by i.billing_country order by i.total desc) as 'totrank' from customer as c
inner join invoice as i
on c.customer_id = i.customer_id) t
where t.totrank=1 ;

