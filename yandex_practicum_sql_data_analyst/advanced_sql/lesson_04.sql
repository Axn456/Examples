--Task_01
select paid_at
      , total_amt
      , sum(total_amt) over (order by paid_at)
from tools_shop.orders

--Task_02
select user_id
      , paid_at
      , total_amt
      , sum(total_amt) over (partition by user_id order by paid_at)
from tools_shop.orders

--Task_03
select date_trunc ('month', paid_at)::date
     , total_amt
     , sum(total_amt) over (order by date_trunc ('month', paid_at)::date)
from tools_shop.orders

--Task_04
select order_id
      , user_id
      , paid_at
      , lag(paid_at,1,'01.01.1980') over (partition by user_id order by paid_at)
from tools_shop.orders

--Task_05
select event_id
      , event_time
      , user_id
      , lead(event_time) over (partition by user_id order by event_time)
from tools_shop.events

--Task_06
select event_id
      , event_time
      , user_id
      , lead(event_time) over (partition by user_id order by event_time) - event_time
from tools_shop.events

--Task_07
select created_at::date
       , costs
       , row_number() over (order by costs desc)
from tools_shop.costs

--Task_08
select created_at::date
       , costs
       , dense_rank() over (order by costs desc)
from tools_shop.costs

--Task_09
with row as(
select user_id
, row_number() over (partition by user_id) row
 from tools_shop.orders)

select r.user_id
from row r
where row = 3

--Task_10
with row as(
select order_id
, row_number() over (partition by order_id) row
 from tools_shop.order_x_item)

select count(order_id)
from row r
where row = 4

--Task_11
with tmp as (
select date_trunc ('month', created_at)::date data
      , count(user_id) over (order by date_trunc ('month', created_at)::date) cnt
from tools_shop.users)

select *
from tmp t
group by data, cnt
order by data 

--Task_12
select distinct (date_trunc ('month', created_at)::date) data
      , sum(costs) over(order by date_trunc ('month', created_at)::date)
from tools_shop.costs
where extract(year from created_at) between 2017 and 2018
order by data

--Task_13
with tmp as (
select event_name
, date_trunc ('month', event_time)::date data
, count(event_name) over(order by date_trunc ('month', event_time)::date) ev
from tools_shop.events
where event_name like 'view_item' 
and user_id in (select distinct user_id
				 from tools_shop.orders  
				 where paid_at is not null)
order by data)

select data
      , count(event_name)
      , ev
from tmp 
group by data, ev
order by data

--Task_14
select order_id
      , (date_trunc ('month', paid_at))::date data
      , total_amt
      , count(order_id) over cnt
      , sum(total_amt) over sm
from tools_shop.orders
window cnt as (order by date_trunc ('month', paid_at)::date)
     , sm as (order by date_trunc ('month', paid_at)::date)
order by data

--Task_15
with c as (
select date_trunc ('month', created_at)::date data
, sum(costs) sm
from tools_shop.costs
group by data
order by data)

select *
, c.sm - lag(sm,1,sm) over (order by data) lg
from c

--Task_16
with c as (
select date_trunc('year', paid_at)::date data
, sum(total_amt) sm
from tools_shop.orders
group by data
order by data)

select *
, lead(sm,1,sm) over (order by data) - c.sm lg
from c

