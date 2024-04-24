-- SELECT statement

-- select all (*) columns from table
SELECT * FROM employees;
SELECT * FROM shops;
SELECT * FROM locations;
SELECT * FROM suppliers;

-- select some (3) columns of table
SELECT
	employee_id,
	first_name,
	last_name
FROM employees;

--===================================================

-- WHERE clause + AND & OR

-- Select only the employees who make more than 50k
SELECT *
FROM employees
WHERE salary > 50000;

-- Select only the employees who work in Common Grounds coffeshop
SELECT *
FROM employees
WHERE coffeeshop_id = 1;

-- Select all the employees who work in Common Grounds and make more than 50k
SELECT *
FROM employees
WHERE salary > 50000 AND coffeeshop_id = 1;

-- Select all the employees who work in Common Grounds or make more than 50k
SELECT *
FROM employees
WHERE salary > 50000 OR coffeeshop_id = 1;

-- Select all the employees who work in Common Grounds, make more than 50k and are male
SELECT *
FROM employees
WHERE
	salary > 50000
	AND coffeeshop_id = 1
	AND gender = 'M';

-- Select all the employees who work in Common Grounds or make more than 50k or are male
SELECT *
FROM employees
WHERE
	salary > 50000
	OR coffeeshop_id = 1
	OR gender = 'M';

--=======================================================