--Task_01
select user_id
from   users
where  sex = 'female'
order by user_id 
limit 1000

--Task_02
select user_id 
       ,order_id 
       ,time
from   user_actions
where  action = 'create_order'
and time > '2022-09-06 00:00:00'
order by order_id

--Task_03
select product_id 
       ,name 
       ,price old_price 
       ,price - price * 0.20 new_price
from   products
where  price - price * 0.20 > 100
order by product_id

--Task_04
select product_id 
       ,name
from   products
where  split_part(name,' ', 1) = 'чай' or length(name) = 5
order by product_id asc

--Task_05
select product_id 
       ,name
from   products
where  name like '%чай%'
order by product_id

--Task_06
select product_id 
       ,name
from   products
where  length(name) - length(replace(name, ' ', '')) = 0
and name like 'с%'

--Task_07
select product_id 
       ,name 
       ,price 
       ,'25%' discount 
       ,price * 0.75 new_price
from   products
where  split_part(name,' ', 1) = 'чай' and price > 60
order by product_id

--Task_08
select user_id 
       ,order_id 
       ,action 
       ,time
from   user_actions
where  user_id in (170, 200, 230)
and time between '2022-08-25' and '2022-09-05'
order by order_id desc

--Task_09
select birth_date 
       ,courier_id 
       ,sex
from   couriers
where  birth_date is null
order by courier_id

--Task_10
select user_id 
       ,birth_date
from   users
where  birth_date is not null
and sex = 'male'
order by birth_date desc 
limit 50

--Task_11
select order_id 
       ,time
from   courier_actions
where  courier_id = 100
and action = 'deliver_order'
order by time desc 
limit 10

--Task_12
select order_id
from   user_actions
where  extract(month from   time) = 8 
and action = 'create_order'
order by order_id

--Task_13
select courier_id
from   couriers
where  birth_date is not null
and extract(year from birth_date) in (1990, 1991, 1992, 1993, 1994, 1995)
order by courier_id

--Task_14
select user_id 
       ,order_id 
       ,action 
       ,time
from   user_actions
where  action = 'cancel_order'
and date_part('month', time) = 8
and date_part('dow', time) = 3
and date_part('hour', time) between '12' and '15'
order by order_id desc

--Task_15
select product_id 
       ,name 
       ,price 
       ,case 
		  when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price - price /1.1,2)
          else round(price - price /1.20, 2) 
		end tax 
       ,case 
		  when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price /1.1,2)
          else round(price /1.2, 2) 
		end price_before_tax
from   products
order by price_before_tax desc, product_id