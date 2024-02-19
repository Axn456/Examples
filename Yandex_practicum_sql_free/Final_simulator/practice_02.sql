--Task_01
select date
, count(distinct(bracelet_id))
from pizza
where date between '2022-03-01' and '2022-03-31'
group by date
order by date

--Task_02
select extract(week from date) w
,count(distinct(bracelet_id)) wau
from pizza
group by w
order by w

--Task_03
select date_trunc('month', date)  m
,count(distinct(bracelet_id)) 
from pizza
where extract(month from date) in (1,2,3)
group by m
order by m

--Task_04
select extract(day from date)
, sum(price * quantity)/(count(distinct(bracelet_id)))
from pizza
where date between '2022-01-01' and '2022-01-31'
group by date