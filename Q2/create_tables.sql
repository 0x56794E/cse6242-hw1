-- Check if a table has already been created
-- If yes, drop it then create a new one.
drop table if exists athletes;

create table athletes (
       id integer primary key not null,
       name text,
       nationality text,
       gender text,
       dob real,
       height real,
       weight int,
       sport text,
       gold int,
       silver int,
       bronze int       
);

drop table if exists countries;

create table countries (
       country text,
       code text,
       population integer,
       gdp_per_capita real
);

-- Create idx for tables
create index athletes_country_index on athletes (nationality);
create index countries_country_index on countries (code);
