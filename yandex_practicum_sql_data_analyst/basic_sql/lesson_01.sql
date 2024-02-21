--Task_01
select email
	, first_name
	, last_name
from client;

--Task_02
select invoice_id
    , customer_id
    , invoice_date
    , billing_address
from invoice
limit 5;

--Task_03
select name
    , unit_price
from track
limit 20;

--Task_04
select *
from track
limit 3 offset 7;

--Task_05
select milliseconds::varchar
    , bytes::varchar
from track

--Task_06
select total::int
from invoice

--Task_07
select birth_date::date
from staff

--Task_08
select *
from invoice_line
where unit_price > 0.99

--Task_09
select first_name
       , last_name
       , city
from client
where country = 'Brazil';

--Task_10
select billing_address
      , invoice_date::date
from invoice
where total >= 8;

--Task_11
select invoice_id
   , billing_country
   , invoice_date::date
from invoice
where invoice_date >= '2009-01-06';

--Task_12
select total
      , customer_id
from invoice
where billing_city = 'Dublin'
    or billing_city = 'London'
    or billing_city = 'Paris';

--Task_13
select total
      , customer_id
from invoice
where total >= 5
    and (customer_id = 40 
    or customer_id = 46);

--Task_14
select total
    ,customer_id
from invoice
where (billing_city = 'Dublin' or billing_city = 'London' or billing_city = 'Paris')
    and (total >= 5 and (customer_id = 40 or customer_id = 46))

--Task_15
select last_name
    , phone
from client
where (country = 'Usa' or country = 'France')
    and support_rep_id = 3;

--Task_16
select title
from movie
where rental_rate <= 2
   and rental_duration > 6
   and rating not in ('pg', 'pg-13');

--Task_17
select billing_address
     , billing_city
from invoice
where billing_country not in ('Usa', 'Brazil')
    and total > 2
    and invoice_date >= '2009-09-01'
    and invoice_date <= '2009-09-31';

--Task_18
select name
from playlist
where name like '%Classic%';

--Task_19
select billing_address
     , billing_country
from invoice 
where billing_country in ('USA', 'India', 'Canada', 'Argentina', 'France');

--Task_20
select billing_address
     , billing_country
from invoice
where billing_country in ('USA','India','Canada','Argentina','France')
and billing_city not in ('Redmond','Lyon','Delhi');

--Task_21
select * 
from invoice
where invoice_date::date) between '2009-03-04' and '2012-02-09'
and total < 5
and billing_country not in ('Canada','Brazil','Finland');

--Task_22
select title
from movie
where description like '%Mexico'
    and (rental_rate < 2 or rating != 'PG-13');

--Task_23
select name
from track
where (milliseconds > 300000 and composer like '%Bono%'and genre_id in (7,8,9,10)) or bytes > 1000000000;

--Task_24
select customer_id
      , invoice_date
      , total
from invoice
where customer_id between 20 and 50

--Task_25
select customer_id
   , invoice_date
   , total
   , date_trunc ('month', invoice_date::timestamp)
   , extract (week from invoice_date::timestamp)
from invoice
where customer_id between 20 and 50;

--Task_26
select customer_id,
       invoice_date,
       total,
       date_trunc('month', invoice_date::timestamp),
       extract(week from invoice_date::timestamp)
from invoice
where customer_id between 20 and 50 
and extract(week from invoice_date::timestamp) in (5,7,10,33,48)

--Task_27
select *
from invoice
where extract(day from invoice_date::timestamp) = 1;

--Task_28
select email
from staff
where hire_date between '2002-01-01' and '2002-12-31'
and city = 'Calgary';

--Task_29
select billing_city
from invoice
where billing_postal_code is null;

--Task_30
select billing_city
from invoice
where billing_postal_code is null 
    and billing_state is not null
    and total >= 15;

--Task_31
select album_id
from track
where milliseconds > 250000 
    and name like '%Moon%'
    and composer is null;

--Task_32
select first_name
     , last_name
     , country
from client
where state is null 
    and company is null
    and phone is null
    and fax is null;

--Task_33
select last_name
    , first_name
    , title
    , case
          when title like '%Manager%' and title not like '%IT%' then 'отдел продаж'
          when title like '%IT%' then 'разработка'
          when title like '%Support%' then 'поддержка'
      end department
from staff;

--Task_34
select title
    ,  rental_rate
    ,  case
		  when rental_rate < 1 then 'категория 1'
		  when rental_rate >= 1 and rental_rate < 3 then 'категория 2'
		  when rental_rate >= 3 then 'категория 3'
       end category
from movie;

--Task_35
select fax
    , case
        when fax is not null then 'информация есть'
        when fax is null then 'информации нет'
      end info
from client;

