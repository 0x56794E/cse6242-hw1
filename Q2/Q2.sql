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
select a.name, c.country, t.total_medals
from (select id, (gold + silver + bronze) as total_medals from athletes) t
join athletes a on a.id = t.id
join countries c on c.code = a.nationality
order by t.total_medals desc, a.name asc
limit 10;

-- (e) Worldwide medal leaderboard
-- [insert sql statement(s) below]


-- (f) Performance leaderboard
-- [insert sql statement(s) below]


select '';

-- (g) Creating views
-- [insert sql statement(s) below]


select '';

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
