--Task_01
select round (count (distinct o.user_id)*100.0/count (distinct u.user_id), 1)
from tools_shop.users  u
left join tools_shop.orders o on u.user_id=o.user_id

--Task_02
select sum(total_amt)/count (distinct user_id) ltv
from tools_shop.orders 

--Task_03
select sum (o.total_amt)/count (distinct o.user_id) ltv
       ,date_trunc('month', u.created_at)::date date
from tools_shop.orders o
join tools_shop.users u on o.user_id=u.user_id
group by date

--Task_04
select sum(o.total_amt)/count(distinct u.user_id)
from tools_shop.users u
left join tools_shop.orders o on u.user_id=o.user_id

--Task_05
select sum(o.revenue) / count(distinct p.user_id) arppu
      , o.event_dt  date
from online_store.orders o
join online_store.profiles p on o.user_id = p.user_id
group by date;

--Task_06
select round(sum (o.total_amt)/count(distinct u.user_id), 2) arppu
      , date_trunc ('year', o.created_at)::date  date
from tools_shop.users u
join tools_shop.orders o on u.user_id=o.user_id
group by date
order by arppu

--Task_07
select date_trunc ('month', paid_at)::date date
      , sum(total_amt) sum
from tools_shop.orders  o
group by date

--Task_08
select date_trunc('month', created_at)::date date
      , sum(costs) sum
from tools_shop.costs
group by date

--Task_09
select c.date
       , total_amt * 100 /costs roi
from
(select date_trunc('month', created_at)::date date
       ,sum(costs) costs
		from tools_shop.costs
		group by date) c
join(select date_trunc('month', paid_at)::date date, sum(total_amt) total_amt from tools_shop.orders group by date) o on c.date=o.date;

