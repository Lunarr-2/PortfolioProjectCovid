
SELECT *
FROM CovidDeaths


--1 

SELECT  sum(new_cases) as no_of_new_cases, sum(cast(new_deaths as int)) as no_of_deaths,
sum(cast(new_deaths as int) * 1.0)  /sum(new_cases)  * 100 as death_percentage
FROM CovidDeaths
WHERE continent is not  NULL
ORDER by 1,2


--2

SELECT location, sum(cast( new_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is NULL
AND location NOT in ('World', 'European Union' , 'International')
GROUP by location
ORDER by TotalDeathCount DESC


--3
SELECT location, population,  max(total_cases) as highest_case, population, max(CAST(total_cases) as int/ population) * 100 as percentage_of_infected
 --(CAST(max(total_cases) as REAL) / population ) * 100 as percentage_of_infected
FROM CovidDeaths
GROUP by location,population
ORDER by percentage_of_infected DESC

--4
SELECT location, population,date, max(total_cases) as highest_case, population, max(CAST(total_cases) as int/ population) * 100 as percentage_of_infected
 --(CAST(max(total_cases) as REAL) / population ) * 100 as percentage_of_infected
FROM CovidDeaths
GROUP by location,population,substr(date,7,4) || '-' || substr(date,4,2) || '-' || substr(date,1,2)
ORDER by percentage_of_infected DESC