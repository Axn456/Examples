--Task_01
select *
      , sum(total_amt) over () total
from tools_shop.orders

--Task_02
select *
      , count(user_id) over () cnt
from tools_shop.users

--Task_03
select *
      , sum(total_amt) over (partition by user_id)  sum
from tools_shop.orders

--Task_04
select *
      , sum(total_amt) over (partition by date_trunc ('month', paid_at)::date) sum
from tools_shop.orders

--Task_05
select *
      , count(*) over (partition by created_at::date) cnt
from tools_shop.orders

--Task_06
select *
      , sum(total_amt) over (partition by date_trunc ('month', paid_at)::date) data
from tools_shop.orders

