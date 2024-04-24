/*
* CTEs Common Table Expression: is a temporary named result set that you can reference within SELECT, INSERT, UPDATE, DELETE statement. 
* Only can use one of above statements after CTE
* USE CTE to help simplify queries


WITH CTE_Employee as 
(SELECT Firstname, Lastname, Gender, Salary, 
COUNT(Gender) OVER(PARTITION BY Gender) AS TotalGender,
AVG(Salary) OVER(PARTITION BY Gender) AS AvgSalary
FROM employeedemographics dem 
JOIN employeesalary sal
	ON dem.EmpID = sal.EmpID
WHERE Salary > '40'
)
Select * FROM CTE_Employee;
*/

/*
* Temp Tables: used when we want to insert output of the query to temporary table; 
* Even thou temp table not live in the database but somewhere >>> use DROP TABLE IF EXISTS #tablename

CREATE TABLE #temp_Employee ( 			
EmpID int,
Jobtitle varchar(50),
Salary int
);

INSERT INTO #temp_Employee VALUES (
'1002', 'HR', '45'
);

INSERT INTO #temp_Employee select * from #temp_Employee;

DROP TABLE IF EXISTS #temp_Employee2
CREATE TABLE #temp_Employee2 ( 			
Jobtitle varchar(50),
Employeesperjob int,
AvgAge int,
avgSalary int
);

INSERT INTO #temp_Employee2
SELECT Jobtitle, COUNT(Jobtitle), Avg(Age), Avg(Salary)
FROM employeedemographics 
JOIN employeesalary 
	ON employeedemographics.EmpID = employeesalary.EmpID
GROUP BY Jobtitle;

*/

/*
Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower


--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim: trim both left and right side, LTRIM, RTRIM: used to get rid of blank and space in the column of the table

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

	



-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed		-- REPLACE(columnname, 'what need to replace', 'replace to')
FROM EmployeeErrors


-- Using Substring: SUBSTRING(columnnname, from index, to index); use SUBSTRING when we dont have empid and want to match people across tables by substring DOB, lastname, firstname,

Select Substring(err.FirstName,1,3)
FROM EmployeeErrors err;

Select err.FirstName, Substring(err.FirstName,1,3), dem.FirstName, Substring(dem.FirstName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3);




-- Using UPPER and lower

Select firstname, LOWER(firstname)		-- take everything in the column to the lowercase.
from EmployeeErrors

Select Firstname, UPPER(FirstName)		-- take everything in the column to the uppercase.
from EmployeeErrors


*/

/*

Today's Topic: Stored Procedures
* A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again. 
* So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it.




CREATE PROCEDURE Temp_Employee				--CREATE PROCEDURE procedurename AS query
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)
EXEC Temp_Employee;

Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmpID = sal.EmpID
group by JobTitle


Select * 
From #temp_employee
GO;


CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;


exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'




CREATE PROCEDURE TEST
AS
select * from EmployeeDemographics;

EXEC TEST;

*/


/*

Today's Topic: Subqueries (in the Select, From, and Where Statement)

* It gonna execute the subquery first then the whole query



Select EmpID, JobTitle, Salary
From EmployeeSalary

-- Subquery in Select

Select EmpID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary
 
-- How to do it with Partition By
Select EmpID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmpID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmpID, Salary
order by EmpID


-- Subquery in From

Select a.EmpID, AllAvgSalary
From 
	(Select EmpID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmpID


-- Subquery in Where


Select EmpID, JobTitle, Salary
From EmployeeSalary
where EmpID in (
	Select EmpID 
	From EmployeeDemographics
	where Age > 30)
*/

Select EmpID, JobTitle, Salary From EmployeeSalary
Where EmpID in (Select EmpID from EmployeeDemographics where Age > 30)
