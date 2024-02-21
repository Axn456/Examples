--Task_01
select billing_country
     , count (invoice_id) total_purchases
     , sum (total) total_revenue
     , round(sum(total) / count(invoice_id), 2) average_revenue
from invoice
group by billing_country
order by average_revenue desc
limit 10;

--Task_02
select rating  rating_of_epic
     , release_year  year_of_epic
     , avg(rental_duration)  average_rental
from movie
where description like '%Epic%'
group by rating_of_epic, year_of_epic;

--Task_03
select sum(rental_rate) taxa,
    case
        when rating like 'G' then 'без ограничений'
        else 'с ограничениями'
    end  new_rating
from movie
group by new_rating

--Task_04
select t.name
	 , sum(i.quantity)
from track t
join invoice_line i on t.track_id = i.track_id
group by t.name
limit 20;

--Task_05
select t.name
       , sum(i.quantity)
       , p.playlist_id
from track t
join invoice_line i on t.track_id=i.track_id
join playlist_track p on t.track_id=p.track_id
group by t.name, p.playlist_id
limit 20;

--Task_06
select t.name
      ,  sum(i.quantity)
      ,  pt.playlist_id
      ,  p.name
from track t
join invoice_line i on t.track_id=i.track_id
join playlist_track pt on t.track_id=pt.track_id
join playlist p on pt.playlist_id=p.playlist_id
group by t.name, pt.playlist_id, p.name
limit 20;

--Task_07
select p.name  playlist_name
    , sum(t.unit_price) total_revenue
from track t
join invoice_line i on t.track_id=i.track_id
join playlist_track pl on t.track_id=pl.track_id
join playlist p on pl.playlist_id = p.playlist_id
group by playlist_name
order by total_revenue desc;

--Task_08
select g.name genre
    , sum(i.quantity) kolvo
from track t
join genre g on t.genre_id=g.genre_id
join invoice_line i on t.track_id=i.track_id
group by genre
order by kolvo desc;

--Task_09
select distinct(c.name)
from film_actor fa
join film_category fc on fa.film_id=fc.film_id
join category c on fc.category_id=c.category_id
join actor a on fa.actor_id=a.actor_id
where a.first_name like 'Uma' and a.last_name like 'Wood'

--Task_10
select t.name
      , i.invoice_date::date
from track  t
left join invoice_line il on t.track_id=il.track_id
left join invoice i on il.invoice_id=i.invoice_id

--Task_11
select extract (year from i.invoice_date::date) year_of_invoice
       ,count(distinct(t.name))
from invoice i
left join invoice_line il on i.invoice_id=il.invoice_id
left join track t on il.track_id=t.track_id
group by year_of_invoice;

--Task_12
select s.last_name emloyee_last_name
    ,count(c.customer_id) all_customers
from staff s
left join client  c on s.employee_id=c.support_rep_id
group by employee_id
order by all_customers desc, emloyee_last_name;

--Task_13
select s.last_name emloyee_last_name
     , st.last_name manager_last_name
from staff s
left join staff st on st.employee_id=s.reports_to

--Task_14
select m.title
from movie m
left join film_actor fa on m.film_id=fa.film_id
where fa.actor_id is null;

--Task_15
select a.name
from artist  a
left join album  al on a.artist_id=al.artist_id
where al.title is null

