-- Queries used for Tableau Project




-- 1. 
--Show the total case, total death and the death precentage
Select 
	SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From 
	Portfolio_Project..Covid_Death
where 
	continent is not null 
order by 1,2


-- 2. 

-- Show Death count in in term of each continent

Select 
	location, SUM(cast(new_deaths as int)) as TotalDeathCount
From 
	Portfolio_Project..Covid_Death
Where 
	continent is null and 
	location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by 
	location
order by 
	TotalDeathCount desc


-- 3.

-- Show which location hsa the highest infection count and percentage inflected 

Select 
	Location, Population, MAX(total_cases) as HighestInfectionCount,  
	Max((total_cases/population))*100 as PercentPopulationInfected
From 
	Portfolio_Project..Covid_Death
Group by 
	Location, Population
order by 
	PercentPopulationInfected desc


-- 4.

--

Select 
	Location, Population,date, MAX(total_cases) as HighestInfectionCount,  
	Max((total_cases/population))*100 as PercentPopulationInfected
From 
	Portfolio_Project..Covid_Death
Group by 
	Location, Population, date
order by 
	PercentPopulationInfected desc












-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out

