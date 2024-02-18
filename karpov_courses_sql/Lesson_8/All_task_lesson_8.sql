--Task_01
select u.user_id user_id_left 
       ,ua.user_id user_id_right 
       ,ua.order_id 
       ,ua.time 
       ,ua.action 
       ,u.sex 
       ,u.birth_date
from   user_actions ua 
join users u on u.user_id = ua.user_id
order by u.user_id asc

--Task_02
select count(distinct ua.user_id) users_count
from   user_actions ua 
join users u on u.user_id = ua.user_id

--Task_03
select ua.user_id user_id_left 
       ,u.user_id user_id_right 
       ,ua.order_id 
       ,ua.time 
       ,ua.action 
       ,u.sex 
       ,u.birth_date
from   user_actions ua
left join users u using (user_id)
order by ua.user_id

--Task_04
select count(distinct ua.user_id) users_count
from   user_actions ua
left join users u using (user_id)

--Task_05
select ua.user_id user_id_left 
      , u.user_id user_id_right 
      , ua.order_id 
      , ua.time 
      , ua.action 
      , u.sex 
      , u.birth_date
from   user_actions ua
left join users u using (user_id)
where  u.user_id is not null
order by ua.user_id

--Task_06
select users_birth_date 
       ,users_count 
       ,couriers_birth_date 
       ,couriers_count
from   (select birth_date users_birth_date 
              , count(user_id) as users_count
        from   users
        where  birth_date is not null
        group by users_birth_date) t1 full join (select birth_date couriers_birth_date 
                                                ,count(courier_id) as couriers_count
                                         from   couriers
                                         where  birth_date is not null
                                         group by couriers_birth_date) t2
        on t1.users_birth_date = t2.couriers_birth_date
order by t1.users_birth_date, t2.couriers_birth_date

--Task_07
select count(birth_date) dates_count
from   (select birth_date
        from   users
        where  birth_date is not null
        union
select birth_date
        from   couriers
        where  birth_date is not null) a

--Task_08
select user_id 
      , name
from   (select user_id
        from   users 
		limit 100) t1 cross join products p
order by user_id, name

--Task_09
select ua.user_id 
      , ua.order_id 
      , o.product_ids
from   user_actions ua 
join orders o using (order_id)
order by ua.user_id, ua.order_id 
limit 1000

--Task_10
select ua.user_id 
       ,ua.order_id 
       ,o.product_ids
from   user_actions ua 
join orders o using (order_id)
where  ua.order_id not in (select order_id
                           from   user_actions
                           where  action = 'cancel_order')
order by ua.user_id, ua.order_id 
limit 1000

--Task_11
select ua.user_id 
      , round(avg(array_length(product_ids, 1)), 2) avg_order_size
from   user_actions ua 
join orders o using (order_id)
where  ua.order_id not in (select order_id
                           from   user_actions
                           where  action = 'cancel_order')
group by ua.user_id
order by ua.user_id 
limit 1000

--Task_12
with t1 as (select order_id 
                  , unnest(product_ids) product_id
            from   orders)

select t.order_id 
       ,t.product_id 
       ,p.price
from   t1 t 
join products p using (product_id)
order by t.order_id, t.product_id 
limit 1000

--Task_13
with t1 as (select order_id 
                  , unnest(product_ids) product_id
            from   orders)

select t.order_id 
      , sum(p.price) order_price
from   t1 t 
join products p using (product_id)
group by t.order_id
order by t.order_id
limit 1000

--Task_14
with cnt as (select z.order_id
                    ,order_price
                    ,user_id
                    ,product_ids
             from   (select order_id
                           , sum(price) as order_price
                     from   (select order_id
                                    ,product_ids
                                    ,unnest(product_ids) as product_id
                             from   orders) t1
                         left join products using(product_id)
                     group by order_id
                     order by order_id) z
                 right join (select user_id
                                    ,order_id
                                    ,product_ids
                             from   (select user_id
                                           , order_id
                                     from   user_actions
                                     where  order_id not in (select order_id
                                                             from   user_actions
                                                             where  action = 'cancel_order')) t
                                 left join orders using(order_id)
                             order by user_id, order_id) z1
                     on z.order_id = z1.order_id)

select user_id
      , count(order_id) as orders_count
      , round(avg(array_length(product_ids, 1)), 2) as avg_order_size
      , sum(order_price) as sum_order_value
      , round(avg(order_price), 2) as avg_order_value
      , min(order_price) as min_order_value
      , max(order_price) as max_order_value
from   cnt
group by user_id
order by user_id 
limit 1000

--Task_15
with cte as (select order_id 
                    ,unnest(product_ids) id 
                    ,creation_time date
             from   orders)

select cte.date::date date 
       ,sum(p.price)::decimal revenue
from   cte 
join products p on p.product_id = cte.id
where  cte.order_id not in (select order_id
                            from   user_actions
                            where  action = 'cancel_order')
group by cte.date::date
order by cte.date::date

--Task_16
with t1 as (select unnest(product_ids) as product_id 
                  , o.order_id
            from   orders o
            where  o.order_id in (select order_id
                                  from   courier_actions
                                  where  action = 'deliver_order'
                                     and time between '2022-09-01'
                                     and '2022-10-01')
            order by product_id)

select name 
      , times_purchased
from   (select p.name 
              , count(distinct order_id) times_purchased
        from   t1 join products p on p.product_id = t1.product_id
        group by name
        order by times_purchased desc 
		limit 10) as t2

--Task_17
with rate as (select ua.user_id 
                     ,round(count(order_id) filter(where action = 'cancel_order')/ count(order_id) filter(where action = 'create_order')::decimal, 2) cancel_rate 
                    , u.sex
              from   user_actions ua
              left join users u on u.user_id = ua.user_id
              group by ua.user_id , u.sex
              order by ua.user_id)

select coalesce (r.sex, 'unknown') sex 
      , round(avg(r.cancel_rate), 3) avg_cancel_rate
from   rate r
group by sex
order by sex

--Task_18
select order_id
from   courier_actions
where  order_id in (select distinct (order_id)
                    from   courier_actions
                    where  action = 'deliver_order')
group by order_id
order by max(time) - min(time) desc 
limit 10

--Task_19
select order_id 
      , array_agg(name) product_names
from   (select order_id 
             ,  unnest(product_ids) product
        from   orders) t1 
		join products pr on pr.product_id = t1.product
group by order_id
order by order_id 
limit 1000

--Task_20
with ord as (SELECT order_id
             FROM   orders
             WHERE  array_length(product_ids, 1) = (SELECT max(array_length(product_ids, 1))
                                                    FROM   orders))

SELECT o.order_id 
       ,ua.user_id 
       ,date_part('year', age((SELECT max(time) FROM   user_actions), u.birth_date))::integer user_age 
	   , c.courier_id 
	   , date_part('year', age((SELECT max(time) FROM user_actions), c.birth_date))::integer courier_age
FROM ord o 
join user_actions ua ON ua.order_id = o.order_id 
join users u ON u.user_id = ua.user_id 
join courier_actions ca ON ca.order_id = o.order_id and ca.action = 'deliver_order' 
join couriers c ON c.courier_id = ca.courier_id
ORDER BY o.order_id

--Task_21
with main_table as (select distinct order_id
                                    ,product_id
                                    ,name
                    from   (select order_id
                                   ,unnest(product_ids) product_id
                            from   orders
                            where  order_id not in (select order_id
                                                    from   user_actions
                                                    where  action = 'cancel_order')
                               and order_id in (select order_id
                                             from   user_actions
                                             where  action = 'create_order')) t 
											 join products using(product_id)
                    order by order_id, name)

select pair,
       count(order_id) as count_pair
from   (select distinct a.order_id,
                        case 
							when a.name > b.name then string_to_array(concat(b.name, '+', a.name), '+')
							else string_to_array(concat(a.name, '+', b.name), '+') 
						end as pair
        from   main_table a 
		join main_table b on a.order_id = b.order_id and a.name != b.name) t
group by pair
order by count_pair desc, pair
