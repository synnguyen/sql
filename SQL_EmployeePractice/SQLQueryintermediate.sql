/* Joins is used to combine multible tables to 1 output. Combines tables based off common column
* Inner Join (output the common/overlap on both tables based of their same column name), Full/Left/Right/ Outer Join
*/
SELECT * FROM SQLPractice.dbo.EmployeeDemographics 
INNER JOIN SQLPractice.dbo.EmployeeSalary
	ON employeedemographics.EmpID = employeesalary.EmpID;   /*Output everyting common as EmpID in table A to table B*/
    
SELECT * FROM employeedemographics 
Full OUTER JOIN employeesalary
	ON employeedemographics.EmpID = employeesalary.EmpID; /* Output everthing from table A and table B regardless they have a match or not*/
    
SELECT * FROM employeedemographics 
Left OUTER JOIN employeesalary
	ON employeedemographics.EmpID = employeesalary.EmpID;  /*Output everything from the left table A and only show things from table B that match table A; if not match, put null*/
    
SELECT * FROM employeedemographics 
Right OUTER JOIN employeesalary
	ON employeedemographics.EmpID = employeesalary.EmpID; /* Output everything from the right table B and only show things from table A that match table B; if not match, put null*/
    
SELECT employeedemographics.EmpID, Firstname, Lastname, JobTitle, Salary FROM employeedemographics 
INNER JOIN employeesalary
	ON employeedemographics.EmpID = employeesalary.EmpID;


/*
* Union- remove duplicate from tables; check: both tables have the same number of columns and columns content same information.
* Union All- combine tables but show the duplicates 
*/
SELECT * FROM employeedemographics
UNION
SELECT * FROM warehouseemployeedemographics;


/*
* Case statement- specify conditions & what to return when condition is met; used for catergorize or label thing
*/
SELECT Firstname, Lastname, Age,
CASE 
	WHEN Age >= 30 THEN 'Old'
    ELSE 'YOUNG'
END AS AgeLabel
FROM employeedemographics
WHERE Age is not null
ORDER BY Age;

SELECT Firstname, Lastname, Jobtitle, Salary,
Case 
	When Jobtitle = 'salesman' THEN Salary + (Salary * .10)
    When Jobtitle = 'HR' THEN Salary + (Salary * .0005)
    When Jobtitle = 'sale manager' THEN Salary + (Salary * .25)
    When Jobtitle = 'senior manager' THEN Salary + (Salary * .40)
    ELSE Salary + (Salary * .20)
END AS SalaryAfterRaise
From employeedemographics
JOIN employeesalary ON employeedemographics.EmpID = employeesalary.EmpID;



/*
* Having Clause- used for aggregate functions (as AVG,; COUNT; MIN; MAX;...); used after GROUP BY & before ORDER BY
* aggregate functions calculates on a set of values & return single value
*/
SELECT Jobtitle, COUNT(Jobtitle)
FROM employeedemographics JOIN employeesalary ON employeedemographics.EmpID = employeesalary.EmpID
GROUP BY Jobtitle
HAVING COUNT(Jobtitle) >= 1
ORDER BY COUNT(Jobtitle);

SELECT Jobtitle,  AVG(Salary)
FROM employeedemographics JOIN employeesalary ON employeedemographics.EmpID = employeesalary.EmpID
GROUP BY Jobtitle
HAVING AVG(Salary) >= 50
ORDER BY AVG(Salary);


/*
* Updating/Deleting data- to update or delete data
*/
UPDATE employeedemographics SET EmpID = 1060, Age=26 WHERE Firstname = 'Kaylie' AND Lastname = 'Nguyen';

DELETE FROM employeedemographics WHERE EmpID = 1005;


/*
* Aliasing- give column a temporary name
*/
SELECT AVG(Age) AS AvgAge FROM employeedemographics;
SELECT Firstname Fname FROM employeedemographics;



/*
* Partition By- divide result set into partitions/subsets. Used with OVER clause to specify column; 
* be able to isolate 1 column we want to perform aggregate function.
*/
SELECT Firstname, Lastname, Gender, Salary, COUNT(Gender)
OVER(PARTITION BY Gender) AS TotalGender
FROM employeedemographics dem 
JOIN employeesalary sal
	ON dem.EmpID = sal.EmpID;

