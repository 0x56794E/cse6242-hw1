-- Schema:
-- athletes (id, name, nationality, gender, dob, height, weight, sport, gold, silver, bronze)
-- coutries (name, code, population, gdp_per_capita)


--Female athletes who won gold
select count(distinct a.id) 
from athletes a 
where a.gender == 'female' and a.gold > 0;

--Male athletes who won silver
select count(distinct a.id)
from athletes a
where a.gender == 'male' and a.silver > 0;

--Name, country and total medals of athletes who won the most medals
select a.id, a.nationality,  (a.gold + a.silver + a.bronze) as total_medal
from athletes a
order by total_medal desc
limit 1;

--Worldwide medal leaderboard
--List top ten countries that won the most medals
select tmp.country, sum(tmp.medal_count)
from (select a.nationality as country, (a.gold + a.silver + a.bronze) as total_medal from athletes a) tmp
group by tmp.country
order by sum(tmp.medal_count) desc
limit 1

--Performance leader board: find top 10 countries with best perf ratio - total medals * 1k /total athlestes

select tmp.total_a, tmp.total_medal_per_country

(select count(distinct a.id) as total_a, a.nationality as country, a.gold + a.silver + a.bronze as total_medal_per_country
from athletes a 
group by a.nationality) tmp
order by tmp.total_medal_per_country/tmp.total_a)

