-- Select everything from CovidDeath table
SELECT *
From PortfolioProject..CovidDeaths
 Where continent is not null
order by 3,4

-- Select everything from CovidVaccination table
SELECT *
From PortfolioProject..CovidVaccination
 Where continent is not null
order by 3,4

-- Select Specific data from CovidDeaths table
Select Location, date, total_cases, new_cases, total_deaths, population
 Where continent is not null
From PortfolioProject..CovidDeaths,

 --Looking at Total Cases vs Total Deaths
 --Shows likelyood of death by country due to COVID
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Where Location like '%kingdom%'
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population got covid
Select Location, date, population, total_cases, (total_cases/Population)*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
Where Location like '%kingdom%'
order by 1,2

-- Contry with highest infection rate compared to population
Select Location, population, Max(total_cases) as HighestInfectionRate, Max((total_cases/Population))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
--Where Location like '%kingdom%'
Group by Location, population
order by PercentagePopulationInfected desc

-- Country with highest deaths by population
Select Location, Max(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
--Where Location like '%kingdom%'
Group by Location, population
order by TotalDeathCount desc

-- Continents with the h ighest death count
Select location, Max(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
--Where Location like '%kingdom%'
Group by location
order by TotalDeathCount desc

-- Global Numbers (Had to add nullif statement in division as some value in table were 0)
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths) / NULLIF(SUM(new_cases),0) *100 as deathpercentage
From PortfolioProject..CovidDeaths
--Where Location like '%kingdom%'
where continent is not null
--Group by date
order by 1,2

-- Join CovidDeaths and CovidVaccination tables on location and date
Select*
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Total Population vs vacinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE (Common Table Expression) to divide RollingPeopleVaccinated by population:
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated / Population) *100 as RollingPercentageVaccinated
From PopvsVac

-- USE TempTable to divide RollingPeopleVaccinated by population:
DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated / Population) *100 as RollingPercentageVaccinated
From #PercentPopulationVaccinated

-- Creating view for visualisation
USE PortfolioProject
GO
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select  *
From PercentPopulationVaccinated
