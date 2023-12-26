Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject..CovidDeaths
--Order by 3,4

--Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at total cases vs total deaths

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where  location like '%kenya%'
Order by 1,2

--looking at total cases vs population
-- shows what percentage of population got covid

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
Where  location like '%kenya%'
Order by 1,2

--looking at countries with highest infection rate compared to population

Select Location,  population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 
as PercentOfPopulationInfected
From PortfolioProject..CovidDeaths
--Where  location like '%kenya%'
Group by Location, population
Order by PercentOfPopulationInfected DESC

-- SHOWING COUNTRIES WITH HIGHEST MORTALITY RATE

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--Where  location like '%kenya%'
Where continent is not null
Group by Location
Order by TotalDeathCount  DESC

--LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--Where  location like '%kenya%'
Where continent is not null
Group by continent
Order by TotalDeathCount  DESC


-- Showing the continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--Where  location like '%kenya%'
Where continent is not null
Group by continent
Order by TotalDeathCount  DESC

--global numbers

Select  date, Sum(new_cases) as total_cases, Sum(Cast(new_deaths as int)) as total_deaths, 
Sum(Cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where  location like '%kenya%'
Where continent is not null
Group by date
Order by 1,2

Select  Sum(new_cases) as total_cases, Sum(Cast(new_deaths as int)) as total_deaths, 
Sum(Cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where  location like '%kenya%'
Where continent is not null
--Group by date
Order by 1,2


-- looking at total population vs vaccinations

  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum (CONVERT (int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
  dea.Date) as CummilativePeopleVaccinated

  from PortfolioProject..CovidDeaths dea
  join  PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	Order by 2,3


	--use CTE
	With popvsVac ( Continent, Location, Date, Population, new_vaccinations, CummilativePeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum (CONVERT (int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
  dea.Date) as CummilativePeopleVaccinated

  from PortfolioProject..CovidDeaths dea
  join  PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	--Order by 2,3
	)
	 
Select *, (CummilativePeopleVaccinated/Population) *100
from popvsVac


	 --Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table  #PercentPopulationVaccinated

(Continent nvarchar(255),           
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CummilativePeopleVaccinated numeric
)

	 Insert into #PercentPopulationVaccinated
	 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum (CONVERT (int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
  dea.Date) as CummilativePeopleVaccinated

  from PortfolioProject..CovidDeaths dea
  join  PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	--Where dea.continent is not null
	--Order by 2,3

	Select *, (CummilativePeopleVaccinated/Population) *100
from #PercentPopulationVaccinated


--creating view to store data for later data visualization

Create View PercentPopulationVaccinated as

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum (CONVERT (int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
  dea.Date) as CummilativePeopleVaccinated

  from PortfolioProject..CovidDeaths dea
  join  PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
	--Order by 2,3

	Create View PercentPopulationVaccinated2  as

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum (CONVERT (int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
  dea.Date) as CummilativePeopleVaccinated

  from PortfolioProject..CovidDeaths dea
  join  PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
	--Order by 2,3

	Select *
	From PercentPopulationVaccinated2