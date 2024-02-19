--Task_01
select gender
, age
from buyer
limit 7

--Task_02
select last_name
, gender
, age
, connection_area area
, percent_of_discount discount
from buyer
limit 7 offset 9

--Task_03
select *
from buyer
offset 169

--Task_04
select *
from buyer
where age <= 30

--Task_05
select first_name
, connection_area
, company_marker
from buyer
where  1 = 1
 and connection_area = 'роботический лабиринт'

--Task_06
select *
from buyer
where percent_of_discount != 3

--Task_07
select *
from buyer
where 1 = 1
and age <= 30
and gender = 'мужской'

--Task_08
select *
from buyer
where first_name = 'Ольга' or percent_of_discount = 20

--Task_09
select last_name
, percent_of_discount
, company_marker
from buyer
where percent_of_discount = 20 or company_marker = 1

--Task_10
select last_name
, age
from buyer
where age in (25, 32, 38) 
or age between 40 and 45

--Task_11
select bracelet_id
, last_name
, first_name
from buyer
where 1 = 1
    and age between 30 and 48
    and connection_area not in ('Роботические гонки', 'Робо-город')
    and percent_of_discount = 0

--Task_12
select connection_area area
, gender gender_of_client
from buyer
where 1 = 1
and first_name in ('Андрей', 'Николай')
and age < 38
and last_name not in ('Иванов', 'Кузнецов')
and connection_area = 'Роботический лабиринт'

--Task_13
select *
from pizza

--Task_14
select *
from pizza
limit 5 offset 1066

--Task_15
select date order_date
, name pizza_name
, bracelet_id client_id
, price
, quantity
from pizza
limit 10

--Task_16
select *
from pizza
where price > 40

--Task_17
select date
, name
, price
from pizza
where date >= '2022-02-01' and date <= '2022-02-15' and price > 40

--Task_18
select name
, date
, extract(week from date)
, radius
from pizza
where 1 = 1
and (price < 30 and radius > 37)
or (radius >= 35 and price > 35)

--Task_19
select date
, date_trunc('month', date)
, name
, quantity
from pizza
where quantity != 1 
    and  date_trunc('month', date) = '2022-02-01'

--Task_20
select name
, price
, quantity
from pizza
where bracelet_id in (145738, 145759, 145773, 145807, 145815, 145821, 145873, 145880)
and date_trunc ('month', date) = '2022-03-01'

--Task_21
select bracelet_id
, name
from pizza
where 1 = 1
and vegan_marker = 1
and  bracelet_id in (145738, 145759, 145773, 145807, 145815, 145821, 145873, 145880)