SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

/* Selecting important Data */

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

/* Looking at Total Cases vs Total Deaths */

Select location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases as float))*100 as 'Percentage Deaths over Cases'
From PortfolioProject..CovidDeaths
order by 1,2

/* Looking at Maximum Total Cases and Maximum Total Percent of Corona Cases to population in Percent*/

Select location, population, max(total_cases) as HighestInfectionCount, (max(cast(total_cases as float))/max(cast(population as float)))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%world%'
Group by location, population
order by PercentPopulationInfected desc

/* Looking at Countries (without continent) with highest death count per Population*/

Select location, max(cast(total_deaths as int)) as TotalDeathCount, (max(cast(total_deaths as float))/max(cast(population as float)))*100 as PercentPopulationDeath
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by location
order by TotalDeathCount desc

/* Showing the Continents with the highest death count per population */

Select location, max(cast(total_deaths as int)) as TotalDeathCount, (max(cast(total_deaths as float))/max(cast(population as float)))*100 as PercentPopulationDeath
From PortfolioProject..CovidDeaths
Where continent is NULL
Group by location
order by TotalDeathCount desc

/* Descriptive Statistics */

Select location, median_age, avg(cast(total_tests as float)) as AverageTesting, avg(cast(positive_rate as float)) as AveragePositiveTesting, max(cast(total_vaccinations as int)) as TotalVaccination
FROM PortfolioProject..CovidVaccinations
where location not like 'World'
group by location, median_age
Order by TotalVaccination desc

/* Global Numbers */
/* Selected by Date */

Select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100 as DeathPercentageGlobal
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1

/* Selected by total Number*/

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100 as DeathPercentageGlobal
From PortfolioProject..CovidDeaths
where continent is not null
order by 1

/* Queries for Vaccinated-Table */
/* Looking at Total Population vs Vaccinations and Rolling Count */

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
Order by 2,3

/* Looking at Percentage of People Vaccinated with CTE - Number of Colums of CTE must be as long as the Number of Select Statements */

With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
)
Select *,(Convert(float,RollingPeopleVaccinated)/(convert(float, Population)))*100 as PerPeopleVaccinated
From PopvsVac


/* Looking at Percentage of People Vaccinated with TempTable */

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date date, 
Population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
) 

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null

Select *,(Convert(float,RollingPeopleVaccinated)/(convert(float, Population)))*100 as PerPeopleVaccinated
From #PercentPopulationVaccinated


/* Creating View to store data for visualizations later */

Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null




