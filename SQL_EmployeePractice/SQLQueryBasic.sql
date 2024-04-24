
CREATE TABLE EmployeeDemographics
(EmpID int,
Firstname varchar(50),
Lastname varchar(50),
Age int,
Gender varchar(50)
)



Create table EmployeeSalary
(EmpID int,
JobTitle varchar(50),
Salary int
)



INSERT INTO EmployeeDemographics VALUES
(1002, 'Rikker', 'Nguyen', 28, 'male'),
(1003, 'Jim', 'Smith', 33, 'male'),
(1004, 'Haylee', 'Kim', 45, 'female'),
(1005, 'Karen', 'Tran', 23, 'female'),
(1006, 'Toby', 'Scot', 30, 'male'),
(1007, 'Angela', 'Martin', 50, 'female'),
(1008, 'Michael', 'Palmer', 32, 'female'),
(1009, 'Kevin', 'Beasley', 29, 'male')



INSERT INTO EmployeeSalary VALUES
(1001, 'software engineer', 50),
(1002, 'sale manager', 60),
(1003, 'salesman', 30),
(1004, 'software engineer', 50),
(1005, 'HR', 50),
(1006, 'accountant', 40),
(1007, 'senior manager', 100),
(1008, 'accountant', 40),
(1009, 'UX designer', 50)


/*
* Select statement: Top, Distinct (used for unique values), Count (count all the non-null values in a column), As, Max, Min, Avg
*/

SELECT * FROM employeedemographics;

SELECT Firstname, Lastname FROM employeedemographics;

SELECT TOP 3 * FROM employeedemographics;

SELECT distinct(Gender) FROM employeedemographics;

SELECT COUNT(Lastname) FROM employeedemographics;

SELECT COUNT(Age) AS EmployeeAges FROM employeedemographics;

SELECT MAX(Salary) FROM employeesalary;

SELECT Min(Salary) FROM employeesalary;

SELECT AVG(Salary) FROM employeesalary;



/* 
* Where statement: =, <>(doesnot equal), <, >, And, Or, Like, Null, Not Null, In(used as = but to multiple things)
*/
Select * FROM employeedemographics WHERE Firstname <> 'Rikker';

Select * FROM employeedemographics WHERE Age >= 30;

Select * FROM employeedemographics WHERE Age >= 30 AND Gender = 'male';

Select * FROM employeedemographics WHERE Age >= 30 OR Gender = 'male';

Select * FROM employeedemographics WHERE Lastname LIKE 'K%';

Select * FROM employeedemographics WHERE Lastname is not null;

Select * FROM employeedemographics WHERE Firstname IN ('Jim', 'Rikker', 'Haylee');



/*
* Group By (used when to find how many employees have the same attribute); it reduces number of rows into groups and calculate it in SUM or AVG then return in the output
* Order By (used to put multiple columns in order ESC or DESC)
*/
SELECT Gender, Age, count(Gender) FROM employeedemographics group by Gender, Age; /*there are 2 employees have same gender and age*/

SELECT * FROM employeedemographics Order by Age DESC, Firstname;