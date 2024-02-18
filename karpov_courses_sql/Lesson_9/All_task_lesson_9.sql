--Task_01
select product_id 
       ,name 
       ,price 
       ,row_number() over (order by price desc) product_number 
       ,rank() over (order by price desc) product_rank 
       ,dense_rank () over (order by price desc) product_dense_rank
from   products

--Task_02
select product_id 
      , name 
      , price 
      , max(price) over () max_price 
      , round(price/max(price) over (), 2) share_of_max
from   products
order by price desc, product_id

--Task_03
select product_id 
       ,name 
       ,price 
       ,max(price) over (order by price desc) max_price 
       ,min(price) over (order by price desc) min_price
from   products
order by price desc, product_id

--Task_04
with tmp as (select creation_time::date date 
                    ,count(order_id) orders_count
             from   orders
             where  order_id not in(select order_id
                                    from   user_actions
                                    where  action = 'cancel_order')
             group by creation_time::date
             order by orders_count)

select date 
       ,orders_count::int 
       ,sum(orders_count) over (order by date)::int orders_cum_count
from   tmp
order by date

--Task_05
select user_id 
       ,order_id 
       ,time 
       ,row_number() over (partition by user_id order by order_id) order_number
from   user_actions
where  order_id not in(select order_id
                       from   user_actions
                       where  action = 'cancel_order')
order by user_id, order_id 
limit 1000

--Task_06
select user_id 
      , order_id 
      , time 
      , row_number() over (partition by user_id order by order_id) order_number 
      , lag(time) over (partition by user_id order by order_id) time_lag 
      , age(time , lag(time) over (partition by user_id order by order_id)) time_diff
from   user_actions
where  order_id not in(select order_id
                       from   user_actions
                       where  action = 'cancel_order')
order by user_id, order_id 
limit 1000

--Task_07
with temp as (select user_id 
                    , order_id 
                    , time 
                    , row_number() over (partition by user_id order by order_id) order_number 
                    , lag(time) over (partition by user_id order by order_id) time_lag 
                    , extract(epoch from (time - lag(time, 1) over ( partition by user_id order by time))) as time_between_orders
              from   user_actions
              where  order_id not in(select order_id
                                     from   user_actions
                                     where  action = 'cancel_order')
                 and user_id in(select user_id
                             from   user_actions
                             group by user_id having count(order_id) > 1)
              group by user_id, order_id, time
              order by user_id)

select t.user_id 
      , avg(time_between_orders/3600)::int hours_between_orders
from   temp t
where  time_between_orders is not null
group by t.user_id 
limit 1000

--Task_08
with tmp as (select creation_time::date date 
                  ,  count(order_id) orders_count
             from   orders
             where  order_id not in(select order_id
                                    from   user_actions
                                    where  action = 'cancel_order')
             group by creation_time::date
             order by orders_count)

select date 
       ,orders_count 
       ,round(avg(orders_count) over (order by date rows between 3 preceding and 1 preceding),2) moving_avg
from   tmp

--Task_09
with tmp as (select courier_id 
                    , count(order_id) cnt
             from   courier_actions
             where  action = 'deliver_order'
                and time >= '09-01-2022' and time <= '09-30-2022'
             group by courier_id
             order by courier_id)

select courier_id 
       ,cnt delivered_orders 
       ,round(avg(cnt) over (), 2) avg_delivered_orders 
       ,case
			 when cnt > avg(cnt) over () then 1
             else 0 
		end as is_above_avg
from   tmp

--Task_10
with tmp as(select time::date 
                 ,  case 
					  when rank() over (partition by user_id order by time) = 1 then 'первый'
					  when rank() over (partition by user_id order by time) > 1 then 'повторный' 
				    end order_type
            from   user_actions
            where  order_id not in (select order_id
                                    from   user_actions
                                    where  action = 'cancel_order'))
select time date 
       ,order_type 
       ,count(order_type) orders_count
from   tmp
group by time, order_type
order by time, order_type

--Task_11
with tmp as(select time::date 
                ,   case 
					  when rank() over (partition by user_id order by time) = 1 then 'первый'
				  	  when rank() over (partition by user_id order by time) > 1 then 'повторный' 
				    end order_type
            from   user_actions
            where  order_id not in (select order_id
                                    from   user_actions
                                    where  action = 'cancel_order'))
select date 
       ,order_type 
       ,orders_count 
       ,round(orders_count / sum(orders_count) over(partition by date),2) orders_share 
       from
        (select time date
        ,order_type 
        ,count(order_type) orders_count
                     from   tmp
                     group by time, order_type
                     order by time, order_type) t1
group by date, order_type, orders_count
order by date, order_type

--Task_12
select product_id 
       ,name 
       ,price 
       ,round(avg(price) over(), 2) avg_price 
       ,round(avg(price) filter (where price != (select max(price)from products))over(), 2) avg_price_filtered
from   products
order by price desc, product_id

--Task_13
select user_id 
       ,order_id 
       ,action 
       ,time 
       ,created_orders 
       ,canceled_orders 
       ,round(canceled_orders::decimal/created_orders::decimal, 2) cancel_rate
from   (select user_id 
              , order_id 
              , action 
              , time 
              , count(order_id) over(partition by user_id order by time) cnt 
              , count(order_id) filter(where action = 'create_order') over(partition by user_id order by time) created_orders 
              , count(order_id) filter(where action = 'cancel_order') over(partition by user_id order by time) canceled_orders
        from   user_actions) tmp
order by user_id, order_id, time 
limit 1000

--Task_14
with tmp as (select courier_id 
                    ,count(order_id) orders_count 
                    ,rank() over (order by count(order_id) desc, courier_id) courier_rank
             from   courier_actions
             where  action = 'deliver_order'
             group by courier_id)

select courier_id 
      , orders_count 
      , courier_rank
from   tmp limit round((select count(distinct courier_id)
                        from   courier_actions)*0.1)

--Task_15
select courier_id
       , days_employed::int
       , delivered_orders
from   (select courier_id
               ,max(last_action_time_cour) over ()
               ,round(date_part ('day', max(last_action_time_cour) over () - start_time)) as days_employed 
               ,delivered_orders 
			   from(select courier_id
						 , date_trunc ('day', min (time) filter (where action = 'accept_order')) start_time
                         , max (time) as last_action_time_cour
                         , count (order_id) filter (where action = 'deliver_order') as delivered_orders
                              from   courier_actions
                              group by courier_id) t1) t2
where  days_employed >= 10
order by days_employed desc, courier_id

--Task_16
with c as (select order_id 
                 , unnest(product_ids) id 
                 , creation_time date
           from   orders
           where  order_id not in (select order_id
                                   from   user_actions
                                   where  action = 'cancel_order'))

select order_id 
      , date creation_time 
      , price order_price 
      , sum(price) over (partition by date::date) daily_revenue 
      , round(100 * price::decimal/sum(price) over (partition by date::date), 3) percentage_of_daily_revenue
from   (select c.order_id 
               ,c.date 
               ,sum(p.price) over (partition by c.order_id) price
        from   c join products p on p.product_id = c.id) t
group by order_id, date, price
order by date::date desc, percentage_of_daily_revenue desc, order_id

--Task_17
with c as (select order_id ,
                  unnest(product_ids) id ,
                  creation_time date
           from   orders
           where  order_id not in (select order_id
                                   from   user_actions
                                   where  action = 'cancel_order'))

select date 
      , daily_revenue 
      , coalesce(daily_revenue - lag(daily_revenue) over (order by date),0) revenue_growth_abs 
      , coalesce(round((daily_revenue - lag(daily_revenue) over (order by date)) / lag(daily_revenue) over (order by date) * 100 , 1), 0) revenue_growth_percentage
from   (select date::date 
              , sum(price) over (partition by date::date) daily_revenue
        from   (select c.date 
                      , sum(p.price) price
                from   c
                    left join products p on p.product_id = c.id
                group by c.date) t
        group by date, price) t1
group by date, daily_revenue
order by date


