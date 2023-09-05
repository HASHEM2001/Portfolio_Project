
Select *
From covid_deth
Where continent is not null 
order by 3,4



-- the pecentage of deathes in Egypt compred to the cases 
select location,date, total_cases,total_deaths ,(total_deaths/total_cases)*100 as Dethbatchart
from covid_deth
where location like 'egy%'
order by 1,2



-- looking at thr countries with the highest rate compared tipo population

select location,population,max( total_cases)as Haighestinfaction, 
	max((total_cases/population))*100 as percenpopulitoin
from covid_deth
group by location,population
order by 4 desc



-- showing countries with highest Death count per population 
select location , max(cast (total_deaths as int)) as TotalDeathCount
from covid_deth
where continent is not null
Group by location
order by 2 desc 



-- let's break thinges by continent 
select location , max(cast (total_deaths as int)) as TotalDeathCount
from covid_deth
where continent is null
Group by location
order by 2 desc 

-- update the zeros values into null values 
UPDATE covid_deth SET new_cases = NULL WHERE new_cases = 0;



-- global number 
select date,sum(new_cases)as total_cases,sum(new_deaths)as total_death,(sum(new_deaths)/sum(new_cases))*100 as deathPercent
from covid_deth
where continent is not null 
group by date
order by 1,2 desc 


-- looking at the total population vs vaccination 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deth dea
Join covidvics vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deth dea
Join covidvics vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)

select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deth dea
Join covidvics vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated







