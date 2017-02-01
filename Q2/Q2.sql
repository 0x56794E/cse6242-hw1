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
.import athletes.csv athletes
.import countries.csv countries

-- (b) Build indexes
-- [insert sql statement(s) below]
CREATE INDEX athletes_country_index ON athletes (nationality);
CREATE INDEX countries_country_index ON countries (code);

-- (c) Quick computations.
-- [insert sql statement(s) below]
-- Total number of female athletes who won gold medals
SELECT COUNT(DISTINCT id)
FROM athletes
WHERE gender='femaile' AND gold > 0;

-- Total numbers of male athletes who won silver medals
SELECT COUNT(DISTINCT id)
FROM athletes
WHERE gender='male' AND silver > 0;

-- (d) Who won the most medals? 
--Top 10 athletes who won the most total medals 
SELECT a.name, c.country, tmp.total_medals
FROM (SELECT id, (gold + silver + bronze) AS total_medals FROM athletes) tmp
JOIN athletes a ON a.id = tmp.id
JOIN countries c ON c.code = a.nationality
ORDER BY tmp.total_medals DESC, a.name ASC
LIMIT 10;

-- (e) Worldwide medal leaderboard
-- [insert sql statement(s) below]

-- top ten countries winniing the most medals and their medal counts in ea category: g, s, b
-- sort by total medal desc then asc name
-- output format country, gold_sum, silver_sum, bronze_sum
SELECT c.country, tmp.gold_sum, tmp.silver_sum, tmp.bronze_sum
FROM (SELECT a.nationality AS code, SUM (a.gold) AS gold_sum, SUM (a.silver) AS silver_sum, SUM (a.bronze) AS bronze_sum
      FROM athletes a
      GROUP BY a.nationality) tmp
JOIN countries c ON c.code = tmp.code
ORDER BY (gold_sum + silver_sum + bronze_sum) DESC, c.country ASC
LIMIT 10;

-- (f) Performance leaderboard
-- [insert sql statement(s) below]
-- !!!!!IN-PROGRESSSSS: TODO: bmi, gdp
-- top 10 countries w best perf ratio: total medals * 1000 / ath => simplified to just total medals /ath
-- output format:
-- country name, perf ratio, gdp per capita, avg bmi
SELECT c.country, (0.0 + c_summary.a_count) / c_summary.total_medal AS perf_rate, c.gdp_per_capita, c_summary.avg_bmi
FROM (SELECT a.nationality AS code, COUNT(DISTINCT id) AS a_count, SUM (a.gold + a.silver + a.bronze) AS total_medal, AVG(a.weight/(a.height * a.height)) AS avg_bmi
      FROM athletes a 
      GROUP BY  a.nationality
      ) c_summary
JOIN countries c ON c.code = c_summary.code
ORDER BY perf_rate DESC 
LIMIT 10;

-- (g) Creating views
-- [insert sql statement(s) below]

-- Query sports that have more than 500 athletes
CREATE VIEW most_played_sport AS
SELECT sport, SUM (gold + silver + bronze) AS total_medals
FROM athletes 
GROUP BY sport
HAVING COUNT(DISTINCT id) > 500;

-- Query pairs of sports s1 and s2 such that s1's total medals < s2's total medals
SELECT s1.sport, s2.sport
FROM most_played_sports s1
CROSS JOIN most_played_sports s2 
WHERE s1.total_medals < s2.total_medals AND s1.sport != s2.sport
ORDER BY s1.sport ASC, s2.sport ASC;

-- (h) Count total pairs 
-- [insert sql statement(s) below]
SELECT COUNT(*) 
FROM (SELECT s1.sport, s2.sport
      FROM most_played_sports s1
      CROSS JOIN most_played_sports s2
      WHERE s1.total_medals < s2.total_medals AND s1.sport != s2.sport); 

-- (i) Create and import data into FTS table movie_overview.
-- Create table
DROP TABLE if EXISTS movie_overview;
CREATE VIRTUAL TABLE movie_overview USING fts4 (id integer, name text, year integer, overview text, popularity real);
       
-- Import
.separator ,
.import movie-overview.txt movie_overview

-- (i) part 1
-- [insert sql statement(s) below]
-- count number of moives w word love and NOT hate
SELECT count (DISTINCT id)
FROM movie_overview WHERE overview MATCH 'love NOT hate';

-- (i) part 2
-- [insert sql statement(s) below]
-- list id, in asc order, of movies containing (1) love and (2) war in overiew
-- and (3) NO FEWER than 6 terms in btw

