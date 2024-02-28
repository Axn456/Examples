--Task_01
select user_id
      , extract(month from paid_at)
      , min(extract(month from paid_at)) over (partition by user_id)
from tools_shop.orders
where extract (year from paid_at) = 2020

--Task_02
with tmp as (
select user_id usr
, extract (month from paid_at) data
, min (extract(month from paid_at)) over (partition by user_id) ov
from tools_shop.orders
where extract (year from paid_at) = 2020)

select data
      , ov
      , count(distinct usr) cnt
from tmp
group by data, ov

--Task_03
with tmp as (
select user_id  usr
, extract (month from paid_at) data
, min (extract (month from paid_at)) over (partition by user_id) ov
from tools_shop.orders
where extract (year from paid_at) = 2020)
    
       
select ov
      , data
      , round (cnt::numeric/max (cnt) over (partition by ov)::numeric,4)*100
from (
select data
       , ov
       , count (distinct usr) as cnt
        from tmp
        group by data, ov) t1      
order by ov, data

--Task_04
select user_id
      , count(user_id) over ()
from tools_shop.users
where date_trunc('month', created_at)::date = '2020-01-01'

--Task_05
select *
from tools_shop.events
where platform like 'android'
 and date_trunc ('month', event_time)::date between '2020-01-01' and '2020-03-01'

--Task_06
with users as (
select user_id
,count (user_id) over ()
 from tools_shop.users
 where date_trunc ('month', created_at)::date = '2020-01-01')
, events as (
select *
from tools_shop.events
where platform like 'android'
and date_trunc('month', event_time)::date between '2020-01-01' and '2020-03-01')

select *
from users as u
join events as e on u.user_id=e.user_id

--Task_07
with users as (
select user_id
, count (user_id) over () cnt
  from tools_shop.users
  where date_trunc ('month', created_at)::date = '2020-01-01')
, events as (
select *
from tools_shop.events
where platform like 'android'
and date_trunc ('month', event_time)::date between '2020-01-01' and '2020-03-01')

select date_trunc ('month', event_time) data
       , u.cnt
       , count(distinct e.user_id)
from users u
join events e on u.user_id=e.user_id
group by u.cnt, data
order by data, u.cnt

--Task_08
with users as (
select user_id
, count (user_id) over () cnt
  from tools_shop.users
  where date_trunc ('month', created_at)::date = '2020-01-01')
, events as (
select *
from tools_shop.events
where platform like 'android'
and date_trunc ('month', event_time)::date between '2020-01-01' and '2020-03-01')

select date_trunc ('month', event_time) data
       , u.cnt
       , count(distinct e.user_id)/u.cnt::numeric
from users u
join events e on u.user_id=e.user_id
group by u.cnt, data
order by data, u.cnt

--Task_09
select distinct user_id
from tools_shop.orders
where paid_at is not null 

--Task_10
select o.user_id
,min(date_trunc ('month', event_time)::date) cgrt
from tools_shop.events e
join tools_shop.orders o on o.user_id=e.user_id
where o.paid_at is not null
group by o.user_id

--Task_11
with tmp as (
select o.user_id 
, min(date_trunc ('month', event_time)::date) cgrt
from tools_shop.events e
join tools_shop.orders o on o.user_id=e.user_id
where o.paid_at is not null
group by o.user_id)

select cgrt
       ,date_trunc ('month', event_time)::date data
       ,count (distinct ev.user_id)
from tools_shop.events ev
join tmp t as c on t.user_id=ev.user_id
where event_name is not null
group by cgrt, data

--Task_12
with tmp as (
select o.user_id as user_id
, min(date_trunc ('month', event_time)::date) cgrt
from tools_shop.events e
join tools_shop.orders o on o.user_id=e.user_id
where o.paid_at is not null
group by o.user_id)

select cgrt
, data
, usr
, lag(usr) over (partition by cgrt order by data)
from (
select cgrt
       ,date_trunc ('month', event_time)::date data
       ,count (distinct ev.user_id) usr
from tools_shop.events ev
join tmp t on t.user_id=ev.user_id
where event_name is not null
group by cgrt, data) t


--Task_13
with tmp as (
select o.user_id as user_id
, min(date_trunc ('month', event_time)::date) cgrt
from tools_shop.events e
join tools_shop.orders o on o.user_id=e.user_id
where o.paid_at is not null
group by o.user_id)

select cgrt
, data
, usr
, lag(usr) over (partition by cgrt order by data)
, round((1-usr::numeric/lag(usr) over (partition by cgrt order by data))*100,2) cr
from (
select cgrt
       ,date_trunc ('month', event_time)::date data
       ,count (distinct ev.user_id) usr
from tools_shop.events ev
join tmp t on t.user_id=ev.user_id
where event_name is not null
group by cgrt, data) t

--Task_14
select user_id
, date_trunc ('month', created_at)::date as start_date
, count(*) over (partition by date_trunc('month', created_at)::date) cnt_users
from tools_shop.users

--Task_15
with tmp as (
select user_id
, date_trunc ('month', created_at)::date as start_date
, count(*) over (partition by date_trunc('month', created_at)::date) cnt_users
from tools_shop.users)

select 
extract (month from age(date_trunc('month', o.created_at)::date, t.start_date)) lifetime
, date_trunc ('month', o.created_at)::date dt_zakaza
, t.start_date
, t.cnt_users
, o.total_amt total_revenue
from tmp t
join tools_shop.orders o on t.user_id = o.user_id

--Task_16
with tmp as (
select extract(month from age(date_trunc('month', o.created_at)::date, t.start_date)) lifetime
, date_trunc ('month', o.created_at)::date dt_zakaza
, t.start_date
, t.cnt_users
, o.total_amt total_revenue
from (select user_id
	 , date_trunc ('month', created_at)::date as start_date
	 , count(*) over (partition by date_trunc('month', created_at)::date) cnt_users
	 from tools_shop.users) t
join tools_shop.orders o on t.user_id = o.user_id)

select lifetime
      , start_date
      , cnt_users
      , sum (total_revenue) over (partition by start_date order by lifetime) / cnt_users ltv
from tmp

--Task_17
with tmp as (
select lifetime
      , start_date
      , cnt_users
      , sum (total_revenue) over (partition by start_date order by lifetime) / cnt_users ltv
from (select extract(month from age(date_trunc('month', o.created_at)::date, t.start_date)) lifetime
		, date_trunc ('month', o.created_at)::date dt_zakaza
		, t.start_date
		, t.cnt_users
		, o.total_amt total_revenue
		from (select user_id
			 , date_trunc ('month', created_at)::date as start_date
			 , count(*) over (partition by date_trunc('month', created_at)::date) cnt_users
			 from tools_shop.users) t
join tools_shop.orders o on t.user_id = o.user_id) t1)

select lifetime
       , start_date
       , ltv
from tmp
group by lifetime, start_date,ltv
having extract(year from start_date) = 2019 
order by start_date, lifetime
