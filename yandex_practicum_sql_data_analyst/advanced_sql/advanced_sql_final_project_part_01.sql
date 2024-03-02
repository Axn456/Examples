--Task_01
select count (*)
from stackoverflow.posts
where post_type_id = 1
 and (score > 300 or favorites_count >= 100)

--Task_02
select round(avg(c.cnt))
from (select  date_trunc ('day', creation_date)::date dt
      ,count(*) cnt
	  from stackoverflow.posts
	  where creation_date::date between '2008-11-01' and '2008-11-18'
		  and post_type_id = 1
	  group by dt
	  order by dt)  c

--Task_03
select count (distinct u.id) users_id
from stackoverflow.users u
join stackoverflow.badges b on u.id=b.user_id
where age(date_trunc ('day', u.creation_date::date), date_trunc ('day', b.creation_date::date)) = '0 days, 0:00:00'

--Task_04
with posti as (
select *
from stackoverflow.posts
where user_id in (select id
                    from stackoverflow.users
                    where display_name like 'Joel Coehoorn'))

select count(distinct p.id)
from posti p
join stackoverflow.votes v on p.id=v.post_id

--Task_05
select *
      , rank () over (order by id desc) rnk
from stackoverflow.vote_types
order by rnk desc

--Task_06
with tmp as (
select *
from stackoverflow.votes
where vote_type_id in (select id
                       from stackoverflow.vote_types
                       where name like 'Close'))

select u.id us
       , count(v.id) cnt
from stackoverflow.users u
join tmp t on u.id=t.user_id
group by u.id
order by cnt desc, us desc
limit 10

--Task_07
with tmp as (
select u.id
, count (b.id) cnt
from stackoverflow.users u
join stackoverflow.badges b on u.id=b.user_id
where b.creation_date::date between '2008-11-15' and '2008-12-15'
group by u.id
order by cnt desc, u.id
limit 10)

select *
	,dense_rank() over (order by cnt desc)
from tmp

--Task_08
select  title
       ,user_id
       ,score
       ,round(avg(score) over (partition by user_id order by user_id))
from stackoverflow.posts
where title is not null
and score != 0

--Task_09
select title
from stackoverflow.posts
where user_id in (select u.id
                    from stackoverflow.users u
                    join stackoverflow.badges b on u.id=b.user_id
                    group by u.id
                    having count (b.id) > 1000
                  )
and title is not null

--Task_10
select id
       ,views
       ,case
           when views >= 350 then 1
           when views between 100 and 349 then '2'
           when views < 100 then '3'
        end
from stackoverflow.users
where location like '%Canada%'
and views > 0

--Task_11
with tmp as (
select id
   , cat
   , views
   , max(views) over (partition by cat) max
 from (select id
	   ,views
	   ,case
		   when views >= 350 then 1
		   when views between 100 and 349 then '2'
		   when views < 100 then '3'
		end cat 
		from stackoverflow.users
		where location like '%Canada%'
		and views > 0) t
order by views desc, id)

select id
       ,cat
       ,views
from tmp
where views - max = 0

--Task_12
select *
      , sum(cnt) over (order by days)
from (select extract(day from creation_date) days
	  	  , count(id) cnt
	  from stackoverflow.users
	  where date_trunc('month', creation_date)::date = '2008-11-01'
	  group by days) cnt

--Task_13
with tmp as (
select t.id
      , t.data_reg reg
      , p.min_data min
from (select id
       , creation_date data_reg
	  from stackoverflow.users) t
join (select user_id id, min (creation_date) over (partition by user_id) min_data from stackoverflow.posts) p on t.id=p.id)

select t.id
     , t.min - reg razn
from tmp t
group by t.id, razn
