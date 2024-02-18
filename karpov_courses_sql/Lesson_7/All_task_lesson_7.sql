--Task_01
select round(avg(id), 2) orders_avg
from   (select count(order_id) id
        from   user_actions
        where  action = 'create_order'
        group by user_id) id

--Task_02
with cnt as (select count(order_id) id
             from   user_actions
             where  action = 'create_order'
             group by user_id)

select round(avg(id), 2) orders_avg
from   cnt

--Task_03
select product_id 
      , name 
      , price
from   products
where  price != (select min(price)
                 from   products)
order by product_id desc

--Task_04
with average as (select avg(price) pr
                 from   products)

select product_id 
       ,name 
       ,price
from   products
where  price > (select pr
                from   average) + 20
order by product_id desc

--Task_05
select count(distinct user_id) users_count
from   user_actions
where  time > (select max(time) - interval '1 week'
               from   user_actions)

--Task_06
select min(age((select max(time)::date
                from   courier_actions), birth_date))::varchar min_age
from   couriers
where  sex = 'male'

--Task_07
select order_id
from   user_actions
where  order_id not in(select order_id
                       from   user_actions
                       where  action = 'cancel_order')
order by order_id 
limit 1000

--Task_08
with temp as (select user_id 
                    , count(distinct order_id) orders_count
              from   user_actions
              group by user_id)

select user_id 
       ,orders_count 
       ,(select round(avg(orders_count), 2)from temp) orders_avg , orders_count - (select round(avg(orders_count), 2)from temp) orders_diff
from   temp
order by user_id 
limit 1000

--Task_09
with pr as (select round(avg(price), 2) price
            from   products)

select product_id 
      , name 
      , price 
      , case
			when price >= (select price from pr) + 50 then price * 0.85 
			when price <= (select price from pr) - 50 then price * 0.90 
			else price 
		end new_price
from   products
order by price desc, product_id

--Task_10
select count(order_id)orders_count
from   courier_actions
where  1 = 1
   and action = 'accept_order'
   and order_id not in (select order_id
                     from   user_actions
                     where  action = 'create_order')

--Task_11
select count(order_id)orders_count
from   courier_actions
where  1 = 1
   and action = 'accept_order'
   and order_id not in (select order_id
                     from   courier_actions
                     where  action = 'deliver_order')

--Task_12
select count(order_id) orders_canceled 
      , count(order_id) filter (where action = 'deliver_order') orders_canceled_and_delivered
from   courier_actions
where  order_id not in (select order_id
                        from   courier_actions
                        where  action = 'deliver_order')

--Task_13
select count(order_id) filter (where action != 'deliver_order') orders_undelivered 
      , count(order_id) orders_canceled 
      , count(order_id) filter (where action = 'cancel_order') orders_in_process
from   courier_actions
where  order_id in (select order_id
                    from   user_actions
                    where  action = 'cancel_order')

--Task_14
select user_id 
       ,birth_date
from   users
where  sex = 'male'
and birth_date < (select min(birth_date)
                  from   users
                  where  sex = 'female')
order by user_id

--Task_15
select order_id 
       ,product_ids
from   orders
where  order_id in (select order_id
                    from   courier_actions
                    where  action = 'deliver_order'
                    order by time desc 
					limit 100)
order by order_id

--Task_16
select courier_id 
       ,birth_date 
       ,sex
from   couriers
where  courier_id in (select courier_id
                      from   courier_actions
                      where  action = 'deliver_order'
                         and extract(month from time) = '9' 
						 and extract(year from   time) = '2022'
                      group by courier_id 
					  having count(order_id) >= 30)

--Task_17
select round(avg(array_length(product_ids, 1)), 3) avg_order_size
from   orders
where  order_id in (select order_id
                    from   user_actions
                    where  action = 'cancel_order'
                       and user_id in (select user_id
                                    from   users
                                    where  sex = 'male'))

--Task_18
with ages as (select user_id 
                    , date_part('year', age((select max(time) from user_actions), min(birth_date))) age
              from   users
              group by user_id)

select user_id ,
       coalesce(age,(select round(avg(age)) from ages))::int age
from   ages
group by user_id, age
order by user_id

--Task_19
select o.order_id 
       ,ca.time time_accepted 
       ,ca1.time time_delivered 
       ,round((extract(epoch from ca1.time) - extract(epoch from ca.time))/60)::int delivery_time
from orders o 
join courier_actions ca on ca.order_id = o.order_id and ca.action = 'accept_order' 
join courier_actions ca1 on ca1.order_id = o.order_id and ca1.action = 'deliver_order'
where array_length(product_ids, 1) > 5
and o.order_id not in (select order_id
                       from   user_actions
                       where  action = 'cancel_order')
order by o.order_id

--Task_20
select min_time date 
      , count(distinct user_id) first_orders
from   (select user_id 
              , min(time)::date min_time
        from   user_actions
        where  order_id not in (select order_id
                                from   user_actions
                                where  action = 'cancel_order')
        group by user_id ) t1
group by date

--Task_21
SELECT creation_time 
       ,order_id 
       ,product_ids 
       ,unnest(product_ids) product_id
FROM   orders 
limit 100

--Task_22
with t1 as (select unnest(product_ids)  product_id
            from   orders
            where  order_id not in (select order_id
                                    from   user_actions
                                    where  action = 'cancel_order')
            order by product_id)

select product_id 
      , times_purchased 
from(select product_id
		,count(*) times_purchased
                     from   t1
                     group by product_id
                     order by times_purchased desc
					 limit 10)  t2
order by product_id

--Task_23
with t as (select distinct order_id 
                          , unnest(product_ids) as product_id
           from   orders)
, t2 as (select max(price) price 
            , product_id
        from   products
        group by product_id
         order by price desc 
		 limit 5)

select order_id
       ,product_ids
from   orders
where  order_id in (select order_id
                    from   t
                    where  product_id in (select product_id
                                          from   t2))
order by order_id

