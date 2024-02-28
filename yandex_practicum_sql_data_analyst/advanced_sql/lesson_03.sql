--Task_01
select *
      , row_number() over ()
from tools_shop.items

--Task_02
select *
      , row_number() over ()
from tools_shop.orders

--Task_03
with users as
(select *
, row_number() over (order by created_at) rng 
from tools_shop.users)

select user_id
from users
where users.rng = 2021

--Task_04
with orders as
(select *
, row_number() over (order by paid_at desc) rng
from tools_shop.orders)

select total_amt
from orders
where orders.rng = 50

--Task_05
select *
      , rank() over (order by item_id)
from tools_shop.order_x_item

--Task_06
select *
      , dense_rank() over (order by created_at desc) 
from tools_shop.users

--Task_07
select order_id
      , total_amt
      , ntile(10) over (order by total_amt)
from tools_shop.orders

--Task_08
select user_id
      , created_at
      , ntile(5) over (order by created_at desc)
from tools_shop.users

--Task_09
select *
      , row_number() over(partition by user_id order by paid_at)
from tools_shop.orders

--Task_10
select *
      , row_number() over(partition by user_id order by event_time desc)
from tools_shop.events