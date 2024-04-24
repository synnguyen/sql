-- IN, NOT IN, IS NULL, BETWEEN

-- Select all rows from the suppliers table where the supplier is Beans and Barley
SELECT *
FROM suppliers
WHERE supplier_name = 'Beans and Barley';

-- Select all rows from the suppliers table where the supplier is NOT Beans and Barley
SELECT *
FROM suppliers
WHERE NOT supplier_name = 'Beans and Barley';

SELECT *
FROM suppliers
WHERE supplier_name <> 'Beans and Barley';

-- Select all Robusta and Arabica coffee types
SELECT *
FROM suppliers
WHERE coffee_type IN ('Robusta', 'Arabica');

SELECT *
FROM suppliers
WHERE
	coffee_type = 'Robusta'
	OR coffee_type = 'Arabica';

-- Select all coffee types that are not Robusta or Arabica
SELECT *
FROM suppliers
WHERE coffee_type NOT IN ('Robusta', 'Arabica');

-- Select all employees with missing email addresses
SELECT *
FROM employees
WHERE email IS NULL;

-- Select all employees whose emails are not missing
SELECT *
FROM employees
WHERE NOT email IS NULL;

-- Select all employees who make between 35k and 50k
SELECT
	employ_id,
	first_name,
	last_name,
	salary
FROM employees
WHERE salary BETWEEN 35000 AND 50000;

SELECT
	employ_id,
	first_name,
	last_name,
	salary
FROM employees
WHERE
	salary >= 35000
	AND salary <= 50000;

--===========================================================

-- ORDER BY, LIMIT, DISTINCT, Renaming columns

-- Order by salary ascending 
SELECT
	employ_id,
	first_name,
	last_name,
	salary
FROM employees
ORDER BY salary;

-- Order by salary descending 
SELECT
	employ_id,
	first_name,
	last_name,
	salary
FROM employees
ORDER BY salary DESC;

-- Top 10 highest paid employees
SELECT
	employ_id,
	first_name,
	last_name,
	salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

-- Return all unique coffeeshop ids
SELECT DISTINCT coffeeshop_id
FROM employees;

-- Return all unique countries
SELECT DISTINCT country
FROM locations;

-- Renaming columns
SELECT
	email,
	email AS email_address, 
	hire_date,
  hire_date AS date_joined,
	salary,
  salary AS pay
FROM employees;

--=========================================================

-- EXTRACT

SELECT
	hire_date as date,
	EXTRACT(YEAR FROM hire_date) AS year,
	EXTRACT(MONTH FROM hire_date) AS month,
	EXTRACT(DAY FROM hire_date) AS day
FROM employees;

--=========================================================

-- UPPER, LOWER, LENGTH, TRIM

-- Uppercase first and last names
SELECT
	first_name,
	UPPER(first_name) AS first_name_upper,
	last_name,
	UPPER(last_name) AS last_name_upper
FROM employees;

-- Lowercase first and last names
SELECT
	first_name,
	LOWER(first_name) AS first_name_upper,
	last_name,
	LOWER(last_name) AS last_name_upper
FROM employees;

-- Return the email and the length of emails
SELECT
	email,
	LENGTH(email) AS email_length
FROM employees;

-- TRIM
SELECT
    LENGTH('     HELLO     ') AS hello_with_spaces,
LENGTH('HELLO') AS hello_no_spaces,
    LENGTH(TRIM('     HELLO     ')) AS hello_trimmed;

--=========================================================

-- Concatenation, Boolean expressions, wildcards

-- Concatenate first and last names to create full names
SELECT
	first_name,
	last_name,
	first_name || ' ' || last_name AS full_name
FROM employees;

-- Concatenate columns to create a sentence
SELECT 
	first_name || ' ' || last_name || ' makes ' || salary AS profile_sumary
FROM employees;

-- Boolean expressios
-- if the person makes less than 50k, then true, otherwise false
SELECT
	first_name || ' ' || last_name AS full_name,
	(salary < 50000) AS less_than_50k
FROM employees;

-- if the person is a female and makes less than 50k, then true, otherwise false
SELECT
	first_name || ' ' || last_name AS full_name,
	(salary < 50000 AND gender = 'F') AS less_than_50k_female
FROM employees;

-- Boolean expressions with wildcards (% subString)
-- if email has '.com', return true, otherwise false
SELECT
	email,
	(email like '%.com%') AS dotcom_flag
FROM employees;

SELECT
	email,
	(email like '%.gov%') AS dotgov_flag
FROM employees;

-- return only government employees
select
  first_name || ' ' || last_name as full_name,
  email as gov_email
from employees
where email like '%.gov%';

--==========================================================

-- SUBSTRING, POSITION, COALESCE

-- SUBSTRING
-- Get the email from the 5th character
SELECT 
	email,
	SUBSTRING(email FROM 5)
FROM employees;

-- POSITION
-- Find the position of '@' in the email
SELECT 
	email,
	POSITION('@' IN email)
FROM employees;

-- SUBSTRING & POSITION to find the email client
SELECT 
	email,
	SUBSTRING(email FROM POSITION('@' IN email))
FROM employees;

SELECT 
	email,
	SUBSTRING(email FROM POSITION('@' IN email) + 1)
FROM employees;

-- COALESCE to fill missing emails with custom value
SELECT 
	email,
	COALESCE(email, 'NO EMAIL PROVIDED')
FROM employees;

--===================================================

-- MIN, MAX, AVG, SUM, COUNT

-- Select the minimum salary
SELECT MIN(salary) as min_sal
FROM employees;

-- Select the maximum salary
SELECT MAX(salary) as max_sal
FROM employees;

-- Select difference between maximum and minimum salary
SELECT MAX(salary) - MIN(salary)
FROM employees;

-- Select the average salary
SELECT AVG(salary)
FROM employees;

-- Round average salary to nearest integer
SELECT ROUND(AVG(salary),0)
FROM employees;

-- Sum up the salaries
SELECT SUM(salary)
FROM employees;

-- Count the number of entries
SELECT COUNT(*)
FROM employees;

SELECT COUNT(salary)
FROM employees;

SELECT COUNT(email)
FROM employees;

-- summary
SELECT
  MIN(salary) as min_sal,
  MAX(salary) as max_sal,
  MAX(salary) - MIN(salary) as diff_sal,
  round(avg(salary), 0) as average_sal,
  sum(salary) as total_sal,
  count(*) as num_of_emp
FROM employees;

--=========================================================

-- GROUP BY & HAVING

-- Return the number of employees for each coffeeshop
SELECT
  coffeeshop_id,
	COUNT(employ_id)
FROM employees
GROUP BY coffeeshop_id;

-- Return the total salaries for each coffeeshop
SELECT
  coffeeshop_id,
	SUM(salary)
FROM employees
GROUP BY coffeeshop_id;

-- Return the number of employees, the avg & min & max & total salaries for each coffeeshop
SELECT
	coffeeshop_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
ORDER BY num_of_emp DESC;

-- HAVING
-- After GROUP BY, return only the coffeeshops with more than 200 employees
SELECT
	coffeeshop_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING COUNT(*) > 200  -- filter, alter "where" after "gruop by"
ORDER BY num_of_emp DESC;

-- After GROUP BY, return only the coffeeshops with a minimum salary of less than 10k
SELECT
	coffeeshop_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING MIN(salary) < 10000
ORDER BY num_of_emp DESC;

--===========================================================

-- CASE, CASE with GROUP BY, and CASE for transposing data

-- CASE
-- If pay is less than 50k, then low pay, otherwise high pay
SELECT
	employ_id,
	first_name || ' ' || last_name as full_name,
	salary,
	CASE
		WHEN salary < 50000 THEN 'low pay'
		WHEN salary >= 50000 THEN 'high pay'
		ELSE 'no pay'
	END as pay_category
FROM employees
ORDER BY salary DESC;

-- If pay is less than 20k, then low pay
-- if between 20k-50k inclusive, then medium pay
-- if over 50k, then high pay
SELECT
	employ_id,
	first_name || ' ' || last_name as full_name,
	salary,
	CASE
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END as pay_category
FROM employees
ORDER BY salary DESC;

-- CASE & GROUP BY 
-- Return the count of employees in each pay category
SELECT a.pay_category, COUNT(*)
FROM(
	SELECT
		employ_id,
	    first_name || ' ' || last_name as full_name,
		salary,
    CASE
			WHEN salary < 20000 THEN 'low pay'
			WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
			WHEN salary > 50000 THEN 'high pay'
			ELSE 'no pay'
		END as pay_category
	FROM employees  
	ORDER BY salary DESC
) a
GROUP BY a.pay_category;

-- Transpose above
SELECT
	SUM(CASE WHEN salary < 20000 THEN 1 ELSE 0 END) AS low_pay,
	SUM(CASE WHEN salary BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END) AS medium_pay,
	SUM(CASE WHEN salary > 50000 THEN 1 ELSE 0 END) AS high_pay
FROM employees;

--================================================
