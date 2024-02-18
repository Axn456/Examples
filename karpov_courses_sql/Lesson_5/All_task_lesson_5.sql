--Task_01
select distinct courier_id
                ,order_id
from   courier_actions
order by courier_id, order_id

--Task_02
select max(price) max_price 
     , min(price) min_price
from   products

--Task_03
select count(*) dates 
     , count(birth_date) dates_not_null
from   users

--Task_04
select count(user_id) users 
      , count(distinct user_id) unique_users
from   user_actions

--Task_05
select count(courier_id) couriers
from   couriers
where  sex = 'female'

--Task_06
select min(time) first_delivery 
      , max(time) last_delivery
from   courier_actions
where  action = 'deliver_order'

--Task_07
select sum(price) order_price
from   products
where  product_id in (6, 30, 26)

--Task_08
select count(array_length(product_ids, 1)) orders
from   orders
where  array_length(product_ids, 1) >= 9

--Task_09
select min(age(current_date, birth_date))::varchar min_age
from   couriers
where  sex = 'male'

--Task_10
select sum(case 
			  when name = 'сухарики'			   	 then price * 3
              when name = 'чипсы'					 then price * 2
              when name = 'энергетический напиток'   then price 
		   end) order_price
from   products

--Task_11
select round(avg(case 
					when name like 'чай%' then price
                    when name like 'кофе%' then price 
				 end), 2) avg_price
from   products
where  name not in ('иван-чай','чайный гриб')

--Task_12
select age(max(birth_date)
	 , min(birth_date)):: varchar age_diff
from   users
where  sex = 'male'

--Task_13
select round(avg(array_length(product_ids, 1)), 2) avg_order_size
from   orders
where  date_part('dow', creation_time) in (0, 6)

--Task_14
select count(distinct user_id) unique_users 
       ,count(distinct order_id) unique_orders 
       ,round(count(distinct order_id)::decimal / count(distinct user_id)::decimal,2) orders_per_user
from   user_actions

--Task_15
select count(distinct user_id) - count(distinct user_id) filter (where action = 'cancel_order') users_count
from   user_actions

--Task_16
select count(order_id) orders 
      , count(order_id) filter (where array_length(product_ids, 1) >= 5) large_orders 
      , round(count(order_id) filter (where array_length(product_ids, 1) >= 5)::decimal / count(order_id), 2) large_orders_share
from   orders