--Task_01
select title
     , rental_rate
     , length
     , rating
from movie
where rental_rate > 2
order by length desc
limit 40;

--Task_02
select t.rating  rt
     , min (t.length)  min_length
     , max (t.length)  max_length
     , avg (t.length)  avg_length
     , min (t.rental_rate)  min_rental_rate
     , max (t.rental_rate)  max_rental_rate
     , avg (t.rental_rate)  avg_rental_rate
from (select title
       ,rental_rate
	   ,length
	   ,rating
from movie
where rental_rate > 2
order by length desc
limit 40) t
group by rt
order by avg_length asc;

--Task_03
select avg(min_length) min
    , avg(max_length) max
from 
    (select t.rating
      , min(t.length)  min_length
      , max(t.length)  max_length
      , avg(t.length)  avg_length
      , min(t.rental_rate)  min_rental_rate
      , max(t.rental_rate)  max_rental_rate
      , avg(t.rental_rate)  avg_rental_rate
from
  (select title
         , rental_rate
         , length
         , rating
   from movie
   where rental_rate > 2
   order by length desc
   limit 40) t
group by t.rating
order by avg_length) top_rating

--Task_04
select avg(t.cnt)
from
(select a.title
    ,count(t.track_id) cnt 
	from album a
	join track t on a.album_id=t.album_id
	where a.title like '%rock%'
	group by a.title
	having count(t.track_id) >= 8) t

--Task_05
select t.billing_country
from
    (select billing_country
    , extract (month from invoice_date::date)
    , avg(total)  avg
from invoice
where extract (month from invoice_date::date) in (2, 5, 7, 10)
and extract (year from invoice_date::date) = '2009'
group by billing_country, extract (month from invoice_date::date)) t
group by t.billing_country
having sum(t.avg) > 10

--Task_06
select invoice_id
from invoice_line 
group by invoice_id
having count(track_id) > 5

--Task_07
select avg(unit_price)
from invoice_line

--Task_08
select billing_country
     , min(total) min_total
     , max(total) max_total
     , avg(total) avg_total
from invoice
where invoice_id in (select invoice_id
                    from invoice_line 
                    group by invoice_id
                    having count(track_id) > 5)
and total > (select avg (unit_price) from invoice_line)
group by billing_country
order by avg_total desc, billing_country;

--Task_09
select name
from genre
where genre_id in (select genre_id
					 from track
					 order by milliseconds
					 limit 2)

--Task_10
select distinct billing_city
from invoice
where total > (select max(total)
                from invoice 
                where extract (year from invoice_date::date) = '2009')

--Task_11
select c.name
    , avg(m.length)
from movie as m
left join film_category fc on m.film_id=fc.film_id
left join category c on fc.category_id=c.category_id
where rating = (select rating
                from movie
                group by rating
                order by avg(rental_rate) desc
                limit 1)
group by c.name

--Task_12
select i.month_invoice
       ,y11.year_2011
       ,y12.year_2012
       ,y13.year_2013
from       
(select extract (month from invoice_date::date)  month_invoice
from invoice
group by month_invoice) i
join (select extract (month from invoice_date::date) month_invoice
           ,count(total) year_2011
           from invoice
           where extract (year from invoice_date::date) = '2011'
           group by month_invoice) y11 on i.month_invoice = y11.month_invoice
join (select extract (month from invoice_date::date) month_invoice
           ,count(total) year_2012
           from invoice
           where extract (year from invoice_date::date) = '2012'
           group by month_invoice) y12 on i.month_invoice = y12.month_invoice
join (select extract (month from invoice_date::date)  month_invoice
           ,count(total) year_2013
           from invoice
           where extract (year from invoice_date::date) = '2013'
           group by month_invoice) y13 on i.month_invoice = y13.month_invoice
order by i.month_invoice

--Task_13
select c.last_name
from 
(select distinct customer_id fd
 from invoice
 where date_trunc('month', invoice_date::timestamp) between '2013-02-01' and '2013-12-01') fevdec13
join (select distinct customer_id yan from invoice where date_trunc ('month', invoice_date::timestamp) = '2013-01-01') yan13 on fevdec13.fd = yan13.yan
join client c on yan13.yan = c.customer_id 

--Task_14
select c.name  name_category
       , count(distinct m.film_id)  total_films
from category c
join film_category fc on c.category_id=fc.category_id
join film_actor fa on fc.film_id=fa.film_id
join movie m on fa.film_id=m.film_id
where fa.actor_id in (select actor_id 
                        from film_actor fa
                        join movie m on fa.film_id=m.film_id
                        where m.release_year > '2013'
                        group by actor_id
                        having count(distinct fa.film_id) > 7)
group by name_category
order by total_films desc, name_category

--Task_15
select i.billing_country  country
      , i.cnti total_invoice
      , cid.cntc total_customer
from (select  billing_country
			, count(invoice_id) cnti
		from invoice
		where extract (year from invoice_date::date) in (select extract (year from invoice_date::date) date        
		from invoice
		where extract (month from invoice_date::date) in ('6', '7', '8')
		group by date
		order by sum(total) desc
		limit 1)
		group by billing_country) i
join (select country, count (customer_id) cntc from client group by country) cid on i.billing_country=cid.country 
group by i.billing_country, total_invoice, total_customer
order by total_invoice desc, i.billing_country

--Task_16
with mov as (select film_id
			, rating
			, length
			, rental_rate
			from movie
			where rental_rate > 2
			order by length desc
			limit 40)

select mov.rating  rating
      , min (mov.length)  min_length
      , max (mov.length)  max_length
      , avg (mov.length)  avg_length
      , min (mov.rental_rate)  min_rental_rate
      , max (mov.rental_rate)  max_rental_rate
      , avg (mov.rental_rate)  avg_rental_rate
from mov
group by rating
order by avg_length;

--Task_17
with y11 as (select extract (month from invoice_date::date) month_invoice,
           count(total) year_2011
           from invoice
           where extract (year from invoice_date::date) = '2011'
           group by month_invoice)
, y12 as (select extract (month from invoice_date::date) month_invoice,
           count(total) year_2012
           from invoice
           where extract (year from invoice_date::date) = '2012'
           group by month_invoice)
, y13 as (select extract (month from invoice_date::date) month_invoice,
           count(total) year_2013
           from invoice
           where extract (year from invoice_date::date) = '2013'
           group by month_invoice)
, inv as (select extract (month from invoice_date::date) month_invoice
           from invoice
           group by month_invoice)

select inv.month_invoice,
       y11.year_2011,
       y12.year_2012,
       y13.year_2013
from inv 
join y11 on inv.month_invoice=y11.month_invoice
join y12 on inv.month_invoice=y12.month_invoice
join y13 on inv.month_invoice=y13.month_invoice
group by inv.month_invoice, y11.year_2011, y12.year_2012, y13.year_2013

--Task_18
with y12 as (select extract (month from invoice_date::date) as month
		 , sum(total) total
		 from invoice
		 where extract (year from invoice_date::date) = '2012'
		 group by month)
, y13 as (select extract (month from invoice_date::date) as month
        , sum(total) total
        from invoice
        where extract (year from invoice_date::date) = '2013'
        group by month)
, inv as (select extract (month from invoice_date::date) as month
      from invoice)

select inv.month as month
       ,y12.total sum_total_2012
       ,y13.total sum_total_2013
       ,round((y13.total/y12.total-1)*100) perc 
from inv
join y12 on inv.month=y12.month
join y13 on inv.month=y13.month
group by inv.month, sum_total_2012, sum_total_2013 

--Task_19
select length(email)
from client;

--Task_20
select upper(title),
       lower(replace(rating,'-',' '))
from movie;

--Task_21
select concat (first_name, ', ', last_name, ', ', address, ', ', phone)
from client 
where country = 'czech republic'

--Task_22
select title
      , rtrim (replace(description, 'Saga', 'Myth'), 'in A MySQL Convention')
from movie
where release_year <= '2006'
and description like '%Saga%'

