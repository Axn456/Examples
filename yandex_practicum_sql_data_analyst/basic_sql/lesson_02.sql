--Task_01
select *
from invoice
where extract (month from invoice_date::timestamp) = 9 

--Task_02
select customer_id
   , invoice_date::date
   , total
from invoice
where extract(month from invoice_date::timestamp) = 9
    and customer_id in (11,13,44,36,48,52,54,56);

--Task_03
select min (total)
     , max (total)
from invoice
where extract(month from invoice_date::timestamp) = 9
  and customer_id in (11, 13, 44, 36, 48, 52, 54, 56);

--Task_04
select min(total)
      , max(total)
      , round (avg (total))
      , count (distinct (customer_id))
      , sum (total)
from invoice
where extract(month from invoice_date::timestamp) = 9
  and customer_id in (11, 13, 44, 36, 48, 52, 54, 56);

--Task_05
select count(customer_id)
from client
where fax is null;

--Task_06
select avg(total)
from invoice
where extract(dow from invoice_date::date) = 1

--Task_07
select sum(total)
from invoice
where billing_country = 'USA';

--Task_08
select billing_city
     , sum (total)
     , count (total)
     , avg (total)
from invoice
where billing_country = 'USA'
group by billing_city;

--Task_09
select sum (total)
    , count (distinct (customer_id))
    , sum (total)/count (distinct customer_id)
from invoice
where billing_country = 'USA';

--Task_10
select date_trunc('week', invoice_date::timestamp) week
       , sum(total)
	   , count(distinct customer_id)
	   , sum(total)/count(distinct customer_id)
from invoice
where billing_country = 'USA'
group by week;

--Task_11
select support_rep_id
     , count(customer_id)
from client
where email like '%yahoo%' or email like '%gmail%'
group by support_rep_id;

--Task_12
select sum(total)
       , case
            when total < 1 then 'low cost'
            when total > 1 then 'high cost'
         end cat
from invoice
where billing_postal_code is not null
group by case 
            when total < 1 then 'low cost'
            when total > 1 then 'high cost'
          end;

--Task_13
select *
from invoice
order by total desc
limit 5;

--Task_14
select customer_id
     , count(customer_id) cnt
from invoice
where invoice_date::date between '2011-05-25' and '2011-09-25'
    and billing_country = 'USA'
group by customer_id
order by cnt desc, customer_id
limit 5;

--Task_15
select extract (year from invoice_date::date) date
    , min (total)
    , max (total)
    , sum (total)
    , count (distinct (invoice_id))
    , round (sum(total)/count(distinct(customer_id)))
from invoice
where billing_country in ('USA', 'United Kingdom', 'Germany')
group by date
order by date desc;

--Task_16
select rating
    , avg(rental_rate)
from movie
group by rating
having avg(rental_rate) > 3;

--Task_17
select invoice_date::date
    , sum (total)
from invoice
where invoice_date::date between '2011-09-01' and '2011-09-30'
group by invoice_date::date
having sum(total) > 1 and sum(total) < 10;

--Task_18
select billing_country
    ,count(billing_country)
from invoice
where billing_address not like '%Street%'
and billing_address not like '%Way%'
and billing_address not like '%Road5'
and billing_address not like '%Drive%'
and billing_postal_code is null
group by billing_country
having count(billing_country) > 10;

