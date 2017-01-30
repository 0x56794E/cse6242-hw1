— Country with highest gap per capital
Select country, gdp_per_capita 
from countries
order by gdp_per_capita desc
limit 1

— country with lowest avg bmi
Select c.name, avg(bmi)
From Country c
Join Athele a on a.nationality = c.name
Group by c.name
Order by avg(vmi) asc
Limit 1

—
Select country avg_bmi
from country c join athelete_name on athelete.nationality = country.name
Order by a.bmi
Limit 1


—
Count the number of movies’ names contain l but not h
Select count distinct m.name
From Movies 
Where names like

Sqlite Olympics.db < q2.swl.txt > q2.out.

-- initial commands
.headers off
.separator ','

-- (a) Import data
-- [insert sql statement(s) below]
.mode csv athletes
.import athletes.csv athletes

.mode csv countries
.import countries.csv countries

select '';

-- (b) Build indexes
-- [insert sql statement(s) below]
create index athletes_country_index on athletes (nationality);
create index countries_country_index on countries (code);


-- (c) Quick computations.
-- [insert sql statement(s) below]

-- Total number of female athletes who won gold medals
select count(distinct id)
from athletes 
where gender='female' and gold > 0;
 
-- Total numbers of male athletes who won silver medals
select count (distinct id)
from athletes
where gender='male' and silver > 0;

-- (d) Who won the most medals? 
-- [insert sql statement(s) below]

--Top 10 athletes who won the most total medals 
select a.name, c.country, tmp.total_medals
from (select id, (gold + silver + bronze) as total_medals from athletes) tmp
join athletes a on a.id = tmp.id
join countries c on c.code = a.nationality
order by tmp.total_medals desc, a.name asc
limit 10;

-- (e) Worldwide medal leaderboard
-- [insert sql statement(s) below]

-- top ten countries winniing the most medals and their medal counts in ea category: g, s, b
-- sort by total medal desc then asc name
-- output format country, gold_sum, silver_sum, bronze_sum

select c.country, tmp.gold_sum, tmp.silver_sum, tmp.bronze_sum
from (select a.nationality as code, sum(a.gold) as gold_sum, sum(a.silver) as silver_sum, sum(a.bronze) as bronze_sum
      from athletes a
      group by a.nationality) tmp
join countries c on c.code = tmp.code
order by (gold_sum + silver_sum + bronze_sum) desc, c.country asc
limit 10;

-- (f) Performance leaderboard
-- [insert sql statement(s) below]
-- !!!!!IN-PROGRESSSSS: TODO: bmi, gdp
-- top 10 countries w best perf ratio: total medals * 1000 / ath => simplified to just total medals /ath
-- output format:
-- country name, perf ratio, gdp per capita, avg bmi
select c.country, (0.0 + c_summary.a_count) / c_summary.total_medal as perf_rate, c.gdp_per_capita, c_summary.avg_bmi
from 
     (select a.nationality as code, count(distinct id) as a_count, sum(a.gold + a.silver + a.bronze) as total_medal, avg(a.weight/(a.height * a.height)) as avg_bmi
      from athletes a 
      group by  a.nationality
      ) c_summary
join countries c on c.code = c_summary.code
order by perf_rate desc 
limit 10;

-- (g) Creating views
-- [insert sql statement(s) below]

-- Query sports that have more than 500 athletes
create view most_played_sports as
select sport, sum(gold + silver + bronze) as total_medals
from athletes 
group by sport
having count(distinct id) > 500;

-- Query pairs of sports s1 and s2 such that s1's total medals < s2's total medals

select s1.sport, s2.sport
from most_played_sports s1
cross join most_played_sports s2 
where s1.total_medals < s2.total_medals and s1.sport != s2.sport
order by s1.sport asc, s2.sport asc;

-- (h) Count total pairs 
-- [insert sql statement(s) below]


select '';

-- (i) Create and import data into FTS table movie_overview.
-- [insert sql statement(s) below]


select '';

-- (i) part 1
-- [insert sql statement(s) below]


select '';

-- (i) part 2
-- [insert sql statement(s) below]


select '';
