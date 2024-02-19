--Task_01
select
  ntile(2) over w as tile
  , name
  , city
  , salary
from employees
window w as (partition by city order by salary)

--Task_02
with temp as (
select
  dense_rank() over w as salary_rank
  , id
  , name
  , department
  , salary
from employees
window w as (partition by department order by salary desc)
order by salary_rank
)

select id
, name
, department
, salary
from temp 
where salary_rank = 1

--Task_03
select
  name
, department
, lag(salary,1) over w as prev
, salary
, lead(salary, 1) over w as next
from employees
window w as (order by salary)

--Task_04
select
  name
, city
, salary
, round((salary*100.0) / last_value(salary) over w,0) percent
from employees
window w as (partition by city order by salary rows between unbounded preceding and unbounded following)
order by city, salary

--Task_05
select 
  name
, city
, salary
, sum(salary) over w as fund
, round(salary * 100.0 / sum(salary) over w, 0) perc
from employees 
window w as (partition by city)
order by city, salary

--Task_06
select 
name
, department
, salary
, count(department) over w emp_cnt
, round(avg(salary) over w,0) sal_avg
, round((salary - avg(salary) over w)*100/avg(salary) over w,0) diff
from employees 
window w as (partition by department)
order by department, salary, id

--Task_07
select 
year
, month
, income
, avg(income) over w roll_avg
from expenses
window w as (order by month rows between 1 preceding  and current row )
order by year, month

--Task_08
select id
, name
, department
, salary
, sum(salary) over w total
from employees
window w as (partition by department order by department rows between unbounded preceding and current row)
order by department, salary, id

--Task_09
select id
, name
, department
, salary
, first_value(salary) over (partition by department order by salary rows between 1 preceding  and current row) prev_salary
, last_value(salary) over (partition by department order by salary rows between unbounded preceding  and unbounded following ) max_salary
from employees
order by department, salary, id

--Task_10
select id
, name
, salary
, count(*) over w as ge_cnt
from employees
window w as ( order by salary desc groups between unbounded preceding and current row)
order by salary, id

--Task_11
select id
, name
, salary
, first_value(salary) over w next_salary
from employees
window w as (order by salary groups between 1 following and 2 following )
order by salary, id

--Task_12
select id
, name
, salary
, count(*) over w p10_cnt
from employees
window w as ( order by salary range between current row and 10 following)
order by salary, id

--Task_13
select id
, name
, salary
, max(salary) over w lower_sal
from employees
window w as ( order by salary range between 30 PRECEDING and 10 PRECEDING)
order by salary, id

--Task_14
select id
, name
, salary
, round(avg(salary) over w,0) p20_sal
from employees
window w as ( order by salary range between current row and 20 following exclude current row)
order by salary, id

--Task_15
select
  id
, name
, salary
, round(salary * 100 / avg(salary) over ()) as "perc"
, round(salary * 100 / avg(salary) filter(where city = 'Москва') over ()) as "msk"
, round(salary * 100 / avg(salary) filter(where city = 'Самара') over ()) as "sam"
from employees
order by id;

--Task_16
select
  name
  , city
  , sum(salary) over w as base
  , sum(case when department <> 'it' then salary end ) over w as no_it
from employees
window w as (partition by city)
order by city, id;

--Task_17
select
  name
  ,city
  ,sum(salary) over (partition by city) as base
  ,sum(case
		when department = 'it' then salary / 2
		when department = 'hr' then salary * 2
		else salary
		end) over (partition by city order by city  rows between unbounded preceding  and unbounded following) as alt
from employees
order by city, id;

--Task_18
select year
, month
, revenue
, last_value(revenue) over (order by month rows between 2 preceding and 1 preceding) prev
, round(revenue * 100.0 / last_value(revenue) over (order by month rows between 2 preceding and 1 preceding), 0) perc
from sales
where year = '2020' and plan = 'gold'
order by month

--Task_19
select plan
, year
, month
, revenue
, sum(revenue) over w total
from sales
where year = '2020' and month in (1,2,3)
window w as (partition by plan order by plan rows between unbounded preceding and current row)
order by plan, month

--Task_20
select 
 year
, month
, revenue
, round(avg(revenue) over w,0) avg3m
from sales
where year = '2020' and plan = 'platinum'
window w as (order by plan rows between 1 preceding and 1 following)
order by plan, month

--Task_21
select 
 year
, month
, revenue
, last_value(revenue) over w december
, round(revenue * 100.0 / last_value(revenue) over w,0) perc
from sales
where plan = 'silver'
window w as (partition by year order by month rows between unbounded preceding and unbounded following)
order by year, month

--Task_22
select 
 year
, plan
, sum(revenue) revenue
, sum(sum(revenue)) over w total
, round(sum(revenue) * 100.0 / sum(sum(revenue)) over w,0) perc
from sales
group by year, plan
window w as (partition by year )
order by year, plan

--Task_23
select 
 year
, month
, sum(revenue) revenue
, ntile(3) over w tile
from sales
where year = '2020'
group by month
window w as (order by sum(revenue) desc)
order by revenue desc

--Task_24
with data as(
select 
 year
, quarter
, sum(
case when year ='2020' then revenue end
) over  (partition by quarter order by year) revenue
,sum(
case when year ='2019' then revenue end
) over  (partition by quarter order by year) prev
from sales)

select 
year
, quarter
, revenue
, prev
, round(revenue * 100 / prev,0) perc
from data 
where year = '2020'
group by quarter, year, revenue, prev
order by quarter

--Task_25
with sil as(
select year
, month
, rank() over (partition by plan order by quantity desc) rang
from sales
where year = '2020' and plan = 'silver'
),
gol as(
select year
, month
, rank()  over (partition by plan order by quantity desc) rang
from sales
where year = '2020' and plan = 'gold'
),
 pla as(
select year
, month
, rank()  over (partition by plan order by quantity desc) rang
from sales
where year = '2020' and plan = 'platinum'
)

select s.year
, s.month
, s.rang as silver
, g.rang as gold
, p.rang as platinum
from sil s
join gol g on g.month = s.month
join pla p on p.month = s.month
order by s.month

