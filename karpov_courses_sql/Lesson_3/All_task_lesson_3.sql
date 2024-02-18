--Task_01
select *
from   products
order by name

--Task_02
select courier_id 
       ,order_id 
       ,action 
       ,time
from   courier_actions
order by courier_id , action , time desc 
limit 1000

--Task_03
select name 
       ,price
from   products
order by price desc 
limit 5

--Task_04
select name product_name 
       ,price product_price
from   products
order by price desc 
limit 5

--Task_05
select name 
       ,length(name) name_length 
       ,price
from   products
order by name_length desc 
limit 1

--Task_06
select name 
       ,upper(split_part(name,' ', 1)) first_word 
       ,price
from   products
order by name

--Task_07
select name 
       ,price 
       ,price::varchar price_char
from   products
order by name

--Task_08
select concat('заказ №',' ', order_id,' создан ', creation_time::date) order_info
from   orders 
limit 200

--Task_09
select courier_id 
       ,date_part('year', birth_date) birth_year
from   couriers
order by birth_year desc, courier_id

--Task_10
select courier_id 
       ,coalesce(date_part('year', birth_date)::varchar,'unknown') birth_year
from   couriers
order by birth_year desc, courier_id

--Task_11
select product_id 
       ,name 
       ,price old_price 
       ,price + (price/100 * 5) new_price
from   products
order by new_price desc, product_id

--Task_12
select product_id 
       ,name 
       ,price old_price 
       ,round(price + (price/100 * 5), 1) new_price
from   products
order by new_price desc, product_id

--Task_13
select product_id 
       ,name 
       ,price old_price 
       ,case 
		  when name = 'икра' then price
          when price > 100   then price * 1.05
          else price 
		end new_price
from   products
order by new_price desc, product_id

--Task_14
select product_id 
       ,name 
       ,price 
       ,round(price - price / 1.20, 2) tax 
       ,round(price / 1.20, 2) price_before_tax
from   products
order by price desc, product_id