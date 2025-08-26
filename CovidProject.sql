
--verify table contents

SELECT *  from CovidDeaths
WHERE continent is not NULL



SELECT *  from CovidVaccinations;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent is not NULL
ORDER by location,
substr(date,7,4) || '-' || substr(date,4,2) || '-' || substr(date,1,2);
--ORDER by 1, 2


--Total cases vs total deaths (death percentage for infected people)
SELECT location, date, total_cases, total_deaths,  (CAST(total_deaths as REAL) / total_cases ) * 100 as death_percentage 
FROM CovidDeaths
WHERE continent is not NULL
ORDER by location,
substr(date,7,4) || '-' || substr(date,4,2) || '-' || substr(date,1,2);


--death percentage in `Hungary` 
SELECT location, date, total_cases, total_deaths,  (CAST(total_deaths as REAL) / total_cases ) * 100 as death_percentage 
FROM CovidDeaths
WHERE  location like '%hun%' and  continent is not NULL
ORDER by location,
substr(date,7,4) || '-' || substr(date,4,2) || '-' || substr(date,1,2);

--total cases vs population(percentage of the population that got covid)
SELECT location, date, total_cases, population,  (CAST(total_cases as REAL) / population ) * 100 as percentage_of_infected
FROM CovidDeaths
--WHERE  location like '%hun%'
WHERE continent is not NULL
ORDER by location,
substr(date,7,4) || '-' || substr(date,4,2) || '-' || substr(date,1,2);

--coutry vs population (Country with the highest infection rate )
SELECT location,  max(total_cases) as highest_case, population,  (CAST(max(total_cases) as REAL) / population ) * 100 as percentage_of_infected
FROM CovidDeaths
--WHERE  location like '%hun%'
WHERE continent is not NULL
GROUP by location,population
ORDER by percentage_of_infected DESC



--CONTINENT
--country with the highest death count per population

--show contitnent witht the highest death count 
SELECT continent,  max(CAST(total_deaths as INT))as highest_death
FROM CovidDeaths
WHERE continent is  NULL
GROUP by continent
ORDER by highest_death DESC



--GLOBAL
--no of covid cases per day on a global scale, as opposed to a particular contitnet or location
SELECT date , sum(new_cases) as no_of_new_cases, sum(cast(new_deaths as int)) as no_of_deaths,
sum(cast(new_deaths as int) * 1.0)  /sum(new_cases)  * 100 as deaath_percentage
FROM CovidDeaths
WHERE continent is not  NULL
GROUP by date
ORDER by substr(date,7,4) || '-' || substr(date,4,2) || '-' || substr(date,1,2);

--no of the popukation that were vaccinated
WITH POPvsVAC (continent, location, date, population, new_vaccinations, total_vaccinations_count)
as
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
				sum(cast(cv.new_vaccinations as int)) OVER (PARTITION by cd.location ORDER  by cd.location,
				 cd.date ) 
				as total_vaccinations_count
				--, max(total_vaccinations_count) / cd.population as total_vaccinated_people --need cte to run this
FROM  CovidDeaths cd 
JOIN CovidVaccinations cv
on  cd.location = cv.location 
and cd.date = cv.date
WHERE cd.continent is not null
ORDER by cd.location
and substr(cd.date,7,4) || '-' || substr(cd.date,4,2) || '-' || substr(cd.date,1,2)
)
SELECT * , total_vaccinations_count * 1.0/ population as total_vaccinated_people
FROM POPvsVAC
--can't exactly use a column we just created to make divisions so we are going to use a cte 
--CTE


CREATE VIEW PercentageOfPopulationVaccinated as 
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
				sum(cast(cv.new_vaccinations as int)) OVER (PARTITION by cd.location ORDER  by cd.location,
				 cd.date ) 
				as total_vaccinations_count
				--, max(total_vaccinations_count) / cd.population as total_vaccinated_people --need cte to run this
FROM  CovidDeaths cd 
JOIN CovidVaccinations cv
on  cd.location = cv.location 
and cd.date = cv.date
WHERE cd.continent is not null
ORDER by cd.location
and substr(cd.date,7,4) || '-' || substr(cd.date,4,2) || '-' || substr(cd.date,1,2)

