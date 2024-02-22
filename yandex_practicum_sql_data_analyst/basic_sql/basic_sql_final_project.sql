--Task_01
select *
from company
where status like 'closed'

--Task_02
select funding_total
from company
where country_code like 'USA'
      and category_code like 'news'
order by funding_total desc;

--Task_03
select sum(price_amount)
from acquisition
where term_code like 'cash'
and extract (year from acquired_at) between '2011' and '2013'

--Task_04
select first_name
       , last_name
       , network_username
from people
where network_username like 'Silver%'

--Task_05
select *
from people 
where network_username like '%money%'
and last_name like 'K%'

--Task_06
select country_code
       ,sum(funding_total)
from company
group by country_code
order by sum(funding_total) desc

--Task_07
select funded_at
      , min(raised_amount)
      , max(raised_amount) 
from funding_round
group by funded_at 
having min(raised_amount) != 0    
 and min(raised_amount) != max(raised_amount)

--Task_08
select *
      , case 
           when invested_companies >= 100 then 'high_activity'
           when invested_companies between 20 and 100 then 'middle_activity'
           else 'low_activity'
        end cat
from fund
         
--Task_09
select round(avg(investment_rounds)) average
      , case
           when invested_companies>=100 then 'high_activity'
           when invested_companies>=20 then 'middle_activity'
           else 'low_activity'
       end  activity
from fund
group by activity 
order by average asc;

--Task_10
select country_code
       , min(invested_companies)
       , max(invested_companies)
       , avg(invested_companies)
from fund
where extract(year from founded_at) between '2010' and '2012'
group by country_code
having min(invested_companies) != 0
order by avg(invested_companies) desc, country_code
limit 10;

--Task_11
select p.first_name
      , p.last_name
      , e.instituition
from people p
left join education e on p.id=e.person_id

--Task_12
select c.name
     , count(distinct e.instituition) inst
from company c
join people p on c.id=p.company_id
join education e on p.id=e.person_id
group by c.name
order by count(distinct e.instituition) desc
limit 5;

--Task_13
select distinct name
from company
where id in (select distinct company_id
            from funding_round
            where is_first_round = 1
             and is_last_round = 1)
and status like 'closed'

--Task_14
select id
from people
where company_id in (select distinct id
                   from company
                   where id in (select distinct company_id
                   from funding_round
                   where is_first_round = 1
                   and is_last_round = 1)
                   and status like 'closed')

--Task_15
select distinct person_id
      , instituition    
from education
where person_id in (select id
       from people
       where company_id in (select distinct id
                   from company
                   where id in (select distinct company_id
                   from funding_round
                   where is_first_round = 1
                   and is_last_round = 1)
                   and status like 'closed'))

--Task_16
select e.person_id
     , count(e.instituition)
from education e
join people p on e.person_id=p.id
join company c on p.company_id=c.id
where c.id in (select company_id
               from funding_round
               where is_first_round = 1
               and is_last_round = 1) 
      and c.status like 'closed'
group by e.person_id

--Task_17
select avg(inst.cnt)
from (select e.person_id
			 , count(e.instituition) cnt
		from education e
		join people p on e.person_id=p.id
		join company c on p.company_id=c.id
		where c.id in (select company_id
					   from funding_round
					   where is_first_round = 1
					   and is_last_round = 1) 
			  and c.status like 'closed'
		group by e.person_id) inst

--Task_18
select avg(inst.cnt)
from (select e.person_id
		 , count(e.instituition) cnt
		 , c.name
	from education e
	join people p on e.person_id=p.id
	join company c on p.company_id=c.id
	where  c.name = 'socialnet'
	group by e.person_id, c.name) inst

--Task_19
select f.name name_of_fund
      , c.name name_of_company
      , fr.raised_amount  amount
from company c
join investment i on c.id=i.company_id
join fund f on i.fund_id=f.id
join funding_round fr on i.funding_round_id=fr.id
where c.milestones > 6
      and extract(year from fr.funded_at) between '2012' and '2013'

--Task_20
with buy as (select c.id  id
                  , c.name 
           from company c
           join acquisition a on c.id=a.acquiring_company_id)
, sell as (select c.id  id
                  , c.name 
                  , funding_total  priv
            from company  c
            join acquisition  a on c.id=a.acquired_company_id
           group by c.id, c.name) 

select buy.name bought
      , sell.name sold
      , a.price_amount price
      , sell.priv
      , round (a.price_amount/sell.priv) prc
from acquisition  a
join buy on a.acquiring_company_id=buy.id
join sell on a.acquired_company_id=sell.id
group by bought, sold, price, sell.priv
having a.price_amount != 0 and sell.priv != 0
order by a.price_amount desc, sold
limit 10

--Task_21
select extract(month from fr.funded_at)
      , c.name
from company as c 
join funding_round as fr on c.id=fr.company_id
where c.category_code like 'social'
and extract (year from fr.funded_at) between '2010' and '2013'
and fr.raised_amount != 0

--Task_22
with tmp as (select extract(month from funded_at) as month
             ,count(distinct f.name) cnt_country
             from funding_round fr
             left join investment i on fr.id=i.funding_round_id
             left join fund f on i.fund_id=f.id
             where extract (year from fr.funded_at) between '2010' and '2013'
             and country_code like 'USA'
             group by extract (month from funded_at))             
,tmp1 as (select extract (month from acquired_at) as month
             ,count (id) as cnt_company,
             sum (price_amount) as price
             from acquisition
             where extract (year from acquired_at) between '2010' and '2013'
             group by extract (month from acquired_at))

select tmp.month,
       tmp.cnt_country,
       tmp1.cnt_company,
       tmp1.price
from tmp 
join tmp1 on tmp.month = tmp1.month
             
--Task_23
with y1 as (select country_code cc
        , avg(funding_total) average_11
from company  
where extract (year from founded_at) = '2011' 
group by cc)
, y2 as (select country_code cc
        , avg(funding_total) average_12
from company  
where extract (year from founded_at) = '2012' 
group by cc)
, y3 as (select country_code cc
        , avg(funding_total) average_13
from company  
where extract (year from founded_at) = '2013' 
group by cc)

select y1.cc
       , y1.average_11
       , y2.average_12
       , y3.average_13
from y1
join y2 on y1.cc=y2.cc
join y3 on y2.cc=y3.cc
order by y1.average_11 desc


