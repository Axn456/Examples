--Task_01
select min(ingredients)
, max(ingredients)
from hotdog;

--Task_02
select avg(price)
from hotdog
where vegan_sausage = 1

--Task_03
select count(name_hotdog)
from hotdog
where name_hotdog = 'Карибский Потоп'
and date between '2022-02-01' and '2022-02-28'

--Task_04
select  avg(price*quantity)
from hotdog
where 1 = 1
and bracelet_id = 145863
and (mayonnaise = 1 and ketchup = 1 or vegan_sausage = 0)

--Task_05
SELECT count(distinct(bracelet_id))/count(bracelet_id)::numeric 
FROM hotdog;

--Task_06
select bracelet_id
, bracelet_id - 145000 as dis
from buyer
limit 5;

--Task_07
select order_id
, price
, quantity
, price * quantity as cost
from hotdog
limit 10;

--Task_08
select ketchup
 , sum(quantity)
from hotdog
group by ketchup

--Task_09
select 
name_hotdog
, count(order_id)
, avg(ingredients)
from hotdog
group by name_hotdog, ingredients

--Task_10
select name_hotdog
, avg(mustard)
from hotdog
where ingredients = 5
and extract(week from date) =2
group by name_hotdog

--Task_11
select extract(day from date) 
, count(quantity)
from hotdog
where 1=1
and vegan_sausage = 1
and extract(day from date) >= 1 and extract(day from date) <= 5
and extract(month from date) = 1
group by  date

--Task_12
select bracelet_id
, sum(price *quantity)
from hotdog
where bracelet_id in (145900, 145783, 145866)
and mustard =1 and ketchup =1 and mayonnaise = 1
group by bracelet_id

--Task_13
select count(order_id) as cnt
, ingredients
from hotdog
where  vegan_sausage = 1
group by ingredients, vegan_sausage
having count(vegan_sausage) <= 76

--Task_14
select ingredients
      , count(ingredients)
from hotdog
where vegan_sausage = 1 
group by ingredients 
having count(ingredients) <=76 and sum(mustard) > 30

--Task_15
select name_hotdog
from hotdog
where 1=1
and mustard = 1
or ketchup = 1
or mayonnaise = 1
group by name_hotdog
having avg(price * quantity) >= 30.5

--Task_16
select *
from hotdog
order by bracelet_id 
limit 5

--Task_17
select name_hotdog
, price
from hotdog
order by price desc
limit 1

--Task_18
select connection_area
, avg(percent_of_discount) dis
from buyer
group by connection_area
order by dis desc
limit 3

--Task_19
select extract(month from date) as mon
, name_hotdog
, sum(price * quantity)
from hotdog
group by mon, name_hotdog

--Task_20
select extract(month from date) as mon
, name_hotdog
, sum(price * quantity)
from hotdog
group by mon, name_hotdog
order by name_hotdog desc, mon

--Task_21
select max(radius)
, min(radius)
from pizza
where date = '2022-03-13'

--Task_22
select date
, max(radius)
, min(radius)
from pizza
where date between '2022-03-01' and '2022-03-31'
group by date
order by date desc

--Task_23
select avg(price)
,vegan_marker
from pizza
group by vegan_marker

--Task_24
select date_trunc('month', date) AS first_day_of_month
,avg(price)
,vegan_marker
from pizza
group by first_day_of_month, vegan_marker
order by first_day_of_month, vegan_marker

--Task_25
select 
name
,count(distinct(bracelet_id))
from pizza
group by name

--Task_26
select bracelet_id
from pizza
where extract(week from date) = 3
group by bracelet_id
order by sum(price*quantity) desc
limit 3

--Task_27
select count(gender)
, gender
from buyer
where bracelet_id in (145773, 145779, 145855)
group by gender

--Task_28
select connection_area
, gender
, avg(age) ae
from buyer
where age < 30
group by connection_area, gender
having avg(age) <23
order by connection_area, gender