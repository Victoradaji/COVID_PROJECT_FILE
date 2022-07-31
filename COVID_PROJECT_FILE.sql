

--SQL SCRIPT DETAILING ANALYTIC BREAKDOWN OF COVID DATA


--1.A SELECT STATEMENT SHOWING THE NUMBER OF NEWCASES, TOTALCASES,TOTALDEATHS AND POPULATION ACROSS CONTINENTS 

select location,date,total_cases,new_cases,total_deaths,population
from covidportfolioproject..CovidDeaths 
where continent is not null
order by 1,2


--2. A SELECT STATEMENT SHOWING THE CONTINENT WITH THE HIGHEST TOTALCASES

select continent, MAX(total_cases) as max_totalcases_by_continent
from covidportfolioproject..CovidDeaths 
where continent is not  null and location is not null
group by continent
order by 1 desc 

--3. A SELECT STATEMENT SHOWING THE CONTINENT WITH THE HIGHEST NEWCASES 

select continent, MAX(new_cases) as max_newcases_by_continent
from covidportfolioproject..CovidDeaths 
where continent is not  null and location is not null
group by continent
order by 1 desc 

--4. A SELECT STATEMENT SHOWING THE CONTINENT WITH THE HIGHEST TOTALDEATHS

select continent, MAX(convert(int,total_deaths)) as max_totaldeaths_by_continent
from covidportfolioproject..CovidDeaths 
where continent is not  null and location is not null
group by continent
order by 1 desc 

--5. A SELECT STATEMENT SHOWING  DEATH PERCENTAGE USING TOTAL_DEATHS VS TOTAL_CASES RATIO IN UNITED STATES OF AMERICA

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from covidportfolioproject..CovidDeaths 
where continent is not null
and location= 'united states' 
order by 1,2 DESC

--6. A SELECT STATEMENT SHOWING  DEATH PERCENTAGE USING TOTAL_DEATHS VS TOTAL_CASES RATIO IN CANADA

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from covidportfolioproject..CovidDeaths 
where continent is not null
and location= 'canada' 
order by 1,2 DESC  


--7. A SELECT STATEMENT SHOWING  DEATH PERCENTAGE USING TOTAL_DEATHS VS TOTAL_CASES RATIO IN AUSTRALIA 

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from covidportfolioproject..CovidDeaths 
where continent is not null
and location= 'australia' 
order by 1,2 DESC  

--8. A SELECT STATEMENT SHOWING  PERCENTAGE OF INFECTION USING TOTAL_CASES VS POPULATION RATIO IN USA

select location,date,total_cases,population,(total_cases/population)*100 as Infection_Percentage
from covidportfolioproject..CovidDeaths 
where location= 'united states'
and continent is not null
order by 1,2 DESC 


--9. A SELECT STATEMENT SHOWING  PERCENTAGE OF INFECTION USING TOTAL_CASES VS POPULATION RATIO IN CANADA

select location,date,total_cases,population,(total_cases/population)*100 as Infection_Percentage
from covidportfolioproject..CovidDeaths 
where location= 'canada'
and continent is not null
order by 1,2 DESC 


--10. A SELECT STATEMENT SHOWING  PERCENTAGE OF INFECTION USING TOTAL_CASES VS POPULATION RATIO IN AUSTRALIA 

select location,date,total_cases,population,(total_cases/population)*100 as Infection_Percentage
from covidportfolioproject..CovidDeaths 
where location= 'australia'
and continent is not null
order by 1,2 DESC 


--11. A SELECT STATEMENT SHOWING  MAXIMUM INFECTION CASES AND MAXIMUM INFECTION PERCENTAGE USING MAX_TOTAL_CASES VS POPULATION RATIO  

select location,population, max(total_cases) as maxcase,max((total_cases/population)) *100 as Max_Infection_Percentage
from covidportfolioproject..CovidDeaths 
 where continent is not null
group by location,population
order by Max_Infection_Percentage desc 

--12. A SELECT STATEMENT SHOWING  MAXIMUM DEATH CASES  

select continent, max(cast(total_deaths as int )) as Max_Deaths
from covidportfolioproject..CovidDeaths 
where continent is not  null
group by continent
order by Max_Deaths desc

--13. ANALYZING NEW CASES,NEW DEATHS AND NEW DEATH PERCENTAGE GLOBALLY 

select date, sum(new_cases)as Global_New_Cases, sum(cast(new_deaths as int )) as Global_New_Deaths, sum(cast(new_deaths as int ))/sum(new_cases)*100 as Global_New_Death_Percentage
from covidportfolioproject..CovidDeaths 
where continent is not null
group by date
order by 1,2 desc 

--14. A SELECT STATEMENT AND AN INNER JOIN QUERRY SHOWING COVID DEATH AND COVID VACCINATION TABLE 

select * 
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date  

--15. A SELECT STATEMENT  SHOWING DEATH, POPULATION, DATE, CONTINENT AND NEW VACCINATIONS  

select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 
where death.continent is not null 
order by 2,3  


--16. A SELECT STATEMENT  SHOWING RUNNIG TOTAL OF NEW VACCINATIONS USING PARTITION BY   

select death.continent,death.location,death.date,death.population,(convert (bigint,vaccines.new_vaccinations)) as New_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Running_Total_Of_New_Vaccinations
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 
where death.continent is  null 
order by 2,3  



--16. A SELECT STATEMENT  USING COMMON TABLE EXPRESSION TO MANIPULATE AGGREGATED COLUMS AND DETERMINE THE PERCENTAGE OF POPULATION VACCINATED
--USING RUNNING_TOTAL_OF_NEW_VACCINATIONS VS POPULATION RATIO

with Population_Vaccinated ( continent, location,date,population,new_vaccines,Running_Total_Of_New_Vaccinations)
as (
select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Running_Total_Of_New_Vaccinations
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 
where death.continent is  null) 

select *, (Running_Total_Of_New_Vaccinations/population)*100 as Percentage_of_Population_Vaccinated
from Population_Vaccinated 

--CREATING VIEWS FOR TABLEAU VISUALIZATIONS TO REPRESENT ANALYSIS AND FINDINGS THROUGH A DASHBOARD
--VIEW OF PERCENTAGE OF POPULATION VACCINATED

create view Percentage_of_Population_Vaccinated as 
 
select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Percentage_of_Population_Vaccinated
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 

where death.continent is  null

select * 
from  Percentage_of_Population_Vaccinated

--VIEW OF RUNNING TOTAL OF NEW VACCINATIONS

create view Running_Total_Of_New_Vaccinations as

select death.continent,death.location,death.date,death.population,(convert (bigint,vaccines.new_vaccinations)) as New_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as Running_Total_Of_New_Vaccinations
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 
where death.continent is  null 

select * 
from  Running_Total_Of_New_Vaccinations

