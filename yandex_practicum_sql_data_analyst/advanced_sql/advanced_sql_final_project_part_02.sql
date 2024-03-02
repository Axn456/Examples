--Task_01
select sum(views_count) sum_v
     ,  date_trunc('month', creation_date)::date data_soz
from stackoverflow.posts
where extract(year from creation_date) = 2008
group by data_soz
having  sum(views_count) > 0
order by sum_v desc

--Task_02
select u.display_name
      , count(distinct t.user_id)
from stackoverflow.users u
join stackoverflow.posts t on u.id=t.user_id
where t.post_type_id = 2
and date_trunc('day', t.creation_date) <= date_trunc ('day', u.creation_date) + interval '1 month'
group by u.display_name
having count(t.id) > 100
order by u.display_name

--Task_03
select count (id)
     , date_trunc('month', creation_date)::date m
from stackoverflow.posts 
where user_id in (select p.user_id id_u
                  from stackoverflow.posts p
                  join stackoverflow.users u on p.user_id=u.id
                  where date_trunc('month', p.creation_date)::date = '2008-12-01'
                  and date_trunc('month', u.creation_date)::date = '2008-09-01')
group by m
order by m desc

--Task_04
select user_id
       ,creation_date
       ,views_count
       ,sum(views_count) over (partition by user_id order by creation_date)
from stackoverflow.posts

--Task_05
select round(avg(cnt))
from (select user_id
       ,count(distinct creation_date::date) cnt
	  from stackoverflow.posts
	  where creation_date::date between '2008-12-01' and '2008-12-07'
	  group by user_id) u

--Task_06
with tmp as (
select extract(month from creation_date) data
, count(id) cnt
from stackoverflow.posts
where date_trunc('month', creation_date)::date between '2008-09-01' and '2008-12-01'
group by data)


select data
	  , cnt
      , round((cnt::numeric/lag(cnt) over (order by t.data)-1),4)*100
from tmp t

--Task_07
with tmp as (
select extract(week from creation_date) wk
, max(creation_date) over (order by extract(week from creation_date)) max_dt
from stackoverflow.posts post
join (select user_id, count(id) cnt from stackoverflow.posts group by user_id order by cnt desc limit 1) t on post.user_id=t.user_id
where date_trunc ('month', creation_date):: date = '2008-10-01')

select *
from tmp
group by wk, max_dt
