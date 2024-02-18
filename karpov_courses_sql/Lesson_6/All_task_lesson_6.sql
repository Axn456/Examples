--Task_01
select action 
      , count(order_id) orders_count
from   user_actions
group by action
order by orders_count

--Task_02
select date_trunc('month', creation_time) as month 
       ,count(order_id) orders_count
from   orders
group by month
order by month

--Task_03
select date_trunc('month', time) as month 
      , action 
      , count(order_id) orders_count
from   user_actions
group by month, action
order by month

--Task_04
select sex 
       , max(extract(month from birth_date))::integer max_month
from   users
group by sex
order by sex

--Task_05
select sex 
       ,date_part('month', max(birth_date))::integer max_month
from   users
group by sex
order by sex

--Task_06
select sex 
      , max(date_part('year', age(birth_date)))::integer max_age
from   users
group by sex
order by max_age

--Task_07
select date_part('year', age(birth_date))::integer age 
       ,count(user_id) users_count
from   users
group by age
order by age

--Task_08
select date_part('year', age(birth_date))::integer age 
      , sex 
      , count(user_id) users_count
from   users
where  birth_date is not null
group by age, sex
order by age, sex

--Task_09
select array_length(product_ids, 1) order_size 
      , count(order_id) orders_count
from   orders
where  creation_time between '2022-08-29' and '2022-09-05'
group by order_size
order by order_size

--Task_10
select array_length(product_ids, 1) order_size 
      , count(order_id) orders_count
from   orders
where  date_part('isodow', creation_time) in (1, 2, 3, 4, 5)
group by order_size having count(order_id) >= 2000
order by order_size

--Task_11
select user_id 
      , count(order_id) created_orders
from   user_actions
where  extract(month from time) = 8 and action = 'create_order'
group by user_id
order by created_orders desc, user_id 
limit 5

--Task_12
select courier_id
from   courier_actions
where  extract(month from time) = 9 and action = 'deliver_order'
group by courier_id 
having count(order_id) = 1
order by courier_id

--Task_13
select user_id
from   user_actions
where  action = 'create_order'
group by user_id 
having max(time) < '2022-09-08'
order by user_id

--Task_14
select case 
		  when array_length(product_ids, 1) <= 3 then 'малый'
          when array_length(product_ids, 1) between 4 and 6 then 'средний'
          when array_length(product_ids, 1) >= 7 then 'большой' 
	   end order_size 
      , count(array_length(product_ids, 1)) orders_count
from   orders
group by order_size
order by orders_count

--Task_15
select case 
			when date_part('year', age(birth_date))::integer between 19 and 24 then '19-24'
            when date_part('year', age(birth_date))::integer between 25 and 29 then '25-29'
            when date_part('year', age(birth_date))::integer between 30 and 35 then '30-35'
            when date_part('year', age(birth_date))::integer between 36 and 41 then '36-41' 
		end group_age 
      , count(user_id) users_count
from   users
where  birth_date is not null
group by group_age
order by group_age

--Task_16
select case 
		 when date_part('isodow', creation_time) in (1, 2, 3, 4, 5) then 'weekdays'
         when date_part('isodow', creation_time) in (6, 7) then 'weekend' 
	   end as week_part 
     , round(avg(array_length(product_ids, 1)), 2) avg_order_size
from   orders
group by week_part
order by avg_order_size

--Task_17
select user_id 
      , count(order_id) filter(where action = 'create_order') orders_count 
      , round(count(order_id) filter(where action = 'cancel_order')/ count(order_id) filter(where action = 'create_order')::decimal, 2) cancel_rate
from   user_actions
group by user_id 
having count(order_id)    filter(where  action = 'create_order') > 3
and round(count(order_id) filter(where  action = 'cancel_order')/ count(order_id) filter(where  action = 'create_order')::decimal, 2) >= 0.5
order by user_id

--Task_18
select date_part('isodow', time)::integer weekday_number 
       ,to_char(time, 'dy') weekday 
       ,count(order_id) filter(where action = 'create_order') created_orders 
       ,count(order_id) filter(where action = 'cancel_order') canceled_orders 
       ,count(order_id) filter(where action = 'create_order') - count(order_id) filter(where action = 'cancel_order') actual_orders 
       ,round((count(order_id) filter(where action = 'create_order') - count(order_id) filter(where action = 'cancel_order')) / count(order_id) filter(where action = 'create_order')::decimal,3) success_rate
from   user_actions
where  time >= '2022-08-24' and time < '2022-09-07'
group by weekday_number, weekday
order by weekday_number
