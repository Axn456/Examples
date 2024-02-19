--Task_01
select min(price*quantity)
, max(price*quantity)
, avg(price*quantity)
from pizza

--Task_02
select name
, avg(price*quantity)
from pizza
group by name
order by avg(price*quantity) desc

--Task_03
select vegan_marker
, avg(price*quantity)
from pizza
where cheese_side = 0
group by vegan_marker

--Task_04
select name
, cheese_side
, avg(price*quantity)
from pizza
group by name, cheese_side
order by name, cheese_side

--Task_05
select count(distinct(bracelet_id)) / 1000::numeric  as res
from pizza

--Task_06
select count(distinct(bracelet_id)) / 1000::numeric  as res
, date_trunc('month', date)
from pizza
where bracelet_id not in (145738, 145759, 145773, 145807, 145815, 145821, 145873, 145880)
group by date_trunc('month', date)

--Task_07
select name
, radius
, count(distinct(bracelet_id)) / 1000::numeric  as res
from pizza
where bracelet_id not in (145738, 145759, 145773, 145807, 145815, 145821, 145873, 145880)
group by name, radius
having count(distinct(bracelet_id)) / 1000::numeric > '0.03'