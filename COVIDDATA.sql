SELECT *
FROM Cov..CovidDeaths$
--WHERE continent is not NULL
ORDER BY 3,4



SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Cov..CovidDeaths$
WHERE continent is not NULL
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- shows the likelihood of dying from covid


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS dp
FROM Cov..CovidDeaths$
WHERE LOCATION like '%states%' AND continent is not NULL
order by 1,2



--looking at total cases vs deaths
--shows the percentage of population who got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS death_population
FROM Cov..CovidDeaths$
WHERE LOCATION like '%states%' AND continent is not NULL
ORDER BY 1,2

--countries with the highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection_rate, MAX((total_cases/population))*100 AS percent_population_infected
FROM Cov..CovidDeaths$
--WHERE LOCATION like '%states%
WHERE continent is not NULL
GROUP BY location, population
order by percent_population_infected DESC


--showing countries highest death count per population

SELECT location, MAX(CAST(total_deaths AS int))AS death_count
FROM Cov..CovidDeaths$
--WHERE LOCATION like '%states%'
WHERE continent is not NULL
GROUP BY location
order by death_count DESC

--showing contintents with highest death

SELECT location, MAX(CAST(total_deaths AS int))AS death_count
FROM Cov..CovidDeaths$
--WHERE LOCATION like '%states%'
WHERE continent is NULL
GROUP BY location
order by death_count DESC

-- Global Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)* 100 AS DP
FROM Cov..CovidDeaths$
WHERE continent is not NULL
GROUP BY date
order by 1,2

-- Looking at total population vs vaccination
WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
--, (rolling_vaccinations/population)*100
FROM Cov..CovidDeaths$ dea
JOIN COV..CovidVAC$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null AND new_vaccinations is not null
--ORDER BY 2,3
)
SELECT*, (rolling_vaccinations/population)*100 AS percentage_vaccinated
FROM PopvsVac


--BELOW ARE WORK TABLES FOR TABLEAU SET AS VIEWS

CREATE VIEW Percent_Vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
--, (rolling_vaccinations/population)*100
FROM Cov..CovidDeaths$ dea
JOIN COV..CovidVAC$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null AND new_vaccinations is not null