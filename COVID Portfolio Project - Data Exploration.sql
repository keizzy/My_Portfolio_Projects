
-----------------------------------DATA EXPLORATION--------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

SELECT *
FROM PortfolioProject..CovidDeaths
WHERE [continent] IS NOT NULL 
ORDER BY 3,4

------------------------------------------------------------------------------------------------------------------
---------------------------------PERCENTAGE OF DEATH IF COVID IS CAUGHT-------------------------------------------
------------------------------------------------------------------------------------------------------------------

SELECT [Location], [date], [total_cases], [total_deaths], (CAST([total_deaths] as int)/[total_cases])*100  Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE [location] LIKE '%states%'
AND [continent] IS NOT NULL
ORDER BY 1,2

---------------------------------------------------------------------------------------------------------------------------
---------------------------------POPULATION INFECTED WITH COVID BY PERCENTAGE----------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

SELECT [Location], [date], [Population], [total_cases],  ([total_cases]/[population])*100  Percent_Population_Infected
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

----------------------------------------------------------------------------------------------------------------------------------
-----------------------------COUNTRIES WITH HIGHEST INFECTED RATE BY PERCENTAGE----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

SELECT [Location], [Population], MAX([total_cases])  Highest_Infection_Count,  Max(([total_cases]/[population]))*100  Percent_Population_Infected
FROM PortfolioProject..CovidDeaths
GROUP BY [Location], [Population]
ORDER BY Percent_Population_Infected DESC

------------------------------------------------------------------------------------------------------------------------------
----------------------------------COUNTRIES WITH HIGHEST DEATH RATE----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

SELECT [Location], MAX(CAST([Total_deaths] as int)) Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
GROUP BY [Location]
ORDER BY Total_Death_Count DESC

------------------------------------------------------------------------------------------------------------------------
----------------------------------CONTINENT WITH THE HIGHEST DEATH RATE-------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT [continent], MAX(CAST([Total_deaths] as INT)) as Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE [continent] IS NOT NULL 
GROUP BY continent
ORDER BY Total_Death_Count DESC


--------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------GLOBAL NUMBERS-------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SUM([new_cases]) total_cases, SUM(CAST([new_deaths] as INT)) total_deaths, SUM(CAST([new_deaths] as INT))/SUM([New_Cases])*100  Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE [continent] IS NOT NULL

---------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------TOTAL POPULATION THAT GOT VACCINATED WORLDWIDE---------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
WITH peopleVac (continent, location, date, population, new_vaccination, vaccinated_people)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) Vaccinated_People
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (vaccinated_people/population)*100
FROM peopleVac


CREATE VIEW Population_vaccinated_percentage 
AS SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) Vaccinated_People
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL