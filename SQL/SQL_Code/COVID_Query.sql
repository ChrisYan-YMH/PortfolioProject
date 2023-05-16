--Do some basic checking (i.e. if import right data, data type, etc)
Select *
From Portfolio_Project..Covid_Death
-- total_cases is set to be nvarchar(255), it should be numeric, so as new_deaths_million and total_case_per_million
Select *
From Portfolio_Project..Covid_Vac

--------------------------------------------------------------------------------------------------------------------------------------------

--Break down the data by the location

--Total Cases VS Total Death in Japan
Select 
	date, location, total_cases, total_deaths, 
	ROUND((CAST(total_deaths as float)/CAST(total_cases as int)*100),2) as DC
From Portfolio_Project..Covid_Death
where location like '%japan%'
Order by date asc

--Look for the location with the highest inflection rate
Select 
	Location, population, MAX(cast(total_cases as int)) as HighestCaseCount, 
	MAX(ROUND(((cast(total_cases as int)/population)*100),2)) as InfectionRate
From Portfolio_Project..Covid_Death
Group by Location, population
Order by InfectionRate desc

--Find the country with the highest # of death
Select location, MAX(cast(total_deaths as int)) as total_death_over_3_years
From Portfolio_Project..Covid_Death
Group by location
Order by total_death_over_3_years desc
--Problem here is that the location contains something like World, income group and continent

--Figure out how to get rid of these
Select distinct(location), continent
From Portfolio_Project..Covid_Death
--It seems that those income group, world and continent in the location columns has a null value in continent column

--Find the country with the highest # of death after getting rid of those noises
Select location, MAX(cast(total_deaths as int)) as total_death_over_3_years
From Portfolio_Project..Covid_Death
where continent is not null
Group by location
Order by total_death_over_3_years desc

--------------------------------------------------------------------------------------------------------------------------------------------

--Break the data by Continent

--Find the death for each continent
Select continent, MAX(cast(total_deaths as int)) as DeathCount
From Portfolio_Project..Covid_Death
Where continent is not null
Group by continent 
Order by DeathCount desc

--------------------------------------------------------------------------------------------------------------------------------------------

--Global Data
Select 
	SUM(new_cases) as Total_New_Case, SUM(new_deaths) as Total_New_Death,
Case --Prevent 0 divide by 0
	When SUM(new_cases) = 0 or SUM(new_deaths) = 0 Then 0
	Else ROUND(SUM(new_deaths)/SUM(new_cases)*100,2)
End as DeathPercentage
From Portfolio_Project..Covid_Death
Order by DeathPercentage desc

--Total Population vs vaccination population
--Merging Death Dataset and Vac Dataset
Select 
	death.date, death.continent,death.location, death.population,vac.new_vaccinations, 
	SUM(cast(vac.new_vaccinations as bigint)) over() as Global_Total_Vac,
	SUM(cast(vac.new_vaccinations as bigint)) over(partition by death.location order by death.location, death.date) as Rolling_Total_Vac
From 
	Portfolio_Project..Covid_Death Death
Inner Join 
	Portfolio_Project..Covid_Vac Vac 
	On Death.location = Vac.location and Death.date = Vac.date
Where 
	death.continent is not null

With Pop_vac (Date, Continent, Location, Population, New_Vaccination, Global_Total_Vac, Rolling_Total_Vac) 
as 
(
Select 
	death.date, death.continent,death.location, death.population,vac.new_vaccinations, 
	SUM(cast(vac.new_vaccinations as bigint)) over() as Global_Total_Vac,
	SUM(cast(vac.new_vaccinations as bigint)) over(partition by death.location order by death.location, death.date) as Rolling_Total_Vac
From 
	Portfolio_Project..Covid_Death Death
Inner Join 
	Portfolio_Project..Covid_Vac Vac 
	On Death.location = Vac.location and Death.date = Vac.date
Where 
	death.continent is not null 
)

Select 
	*, ROUND((Rolling_Total_Vac/Population)*100,2) as VacPercentage
From Pop_vac

--Save it into a temp table
Create Table #Pop_Vs_Vac
(
	date date,
	Contient nvarchar(255),
	Location nvarchar(255),
	Population numeric,
	New_Vaccinations numeric,
	Global_Total_Vac numeric,
	Rolling_Total_Vac numeric
)

Insert into #Pop_Vs_Vac
Select 
	death.date, death.continent,death.location, death.population,vac.new_vaccinations, 
	SUM(cast(vac.new_vaccinations as bigint)) over() as Global_Total_Vac,
	SUM(cast(vac.new_vaccinations as bigint)) over(partition by death.location order by death.location, death.date) as Rolling_Total_Vac
From 
	Portfolio_Project..Covid_Death Death
Inner Join 
	Portfolio_Project..Covid_Vac Vac 
	On Death.location = Vac.location and Death.date = Vac.date
Where 
	death.continent is not null

Select 
	*, ROUND((Rolling_Total_Vac/Population)*100,2) as VacPercentage
From #Pop_Vs_Vac