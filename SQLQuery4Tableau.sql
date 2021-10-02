/*
Queries used for Tableau Project
*/



-- 1. 

SELECT SUM(new_cases) AS Total_Cases, 
	SUM(CAST(new_deaths AS INT)) AS Total_Deaths, 
	SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS Death_Percentage
FROM COV..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location



-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(CAST(new_deaths AS INT)) AS Total_Death_Count
FROM Cov..CovidDeaths$
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY Total_Death_Count DESC


-- 3.

SELECT location, population, MAX(total_cases) AS Highest_Infection_Count,  Max((total_cases/population))*100 AS Percent_Population_Infected
FROM Cov..CovidDeaths$
GROUP BY location, population
ORDER BY Percent_Population_Infected DESC


-- 4.


SELECT location, population,date, MAX(total_cases) AS Highest_Infection_Count,  Max((total_cases/population))*100 AS Percent_Population_Infected
FROM Cov..CovidDeaths$
GROUP BY location, population, date
ORDER BY Percent_Population_Infected DESC




-- Queries Left out of Visualization
-- Queries also need syntax update

-- 1.

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Cov..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Cov..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2




-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Cov..CovidDeaths$
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Cov..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From Cov..CovidDeaths$
where continent is not null 
order by 1,2


-- 6. 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Cov..CovidDeaths$ dea
Join Cov..CovidVAC$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Cov..CovidDeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

