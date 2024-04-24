-- JOIN: join tables horizontally

-- Inserting values just for JOIN exercises
INSERT INTO locations VALUES (4, 'Paris', 'France');
INSERT INTO shops VALUES (6, 'Happy Brew', NULL);

-- Checking the values we inserted
SELECT * FROM shops;
SELECT * FROM locations;

-- "INNER JOIN" same as just "J0iN"
SELECT 
	s.coffeeshop_name,
	l.city,
	l.country
FROM (
	shops s
	inner JOIN locations as l
	ON s.city_id = l.city_id
);

SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
  shops s
  JOIN locations l
  ON s.city_id = l.city_id;

-- LEFT JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
	shops s
	LEFT JOIN locations l
	ON s.city_id = l.city_id;

-- RIGHT JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
	shops s
	RIGHT JOIN locations l
	ON s.city_id = l.city_id;

-- FULL OUTER JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
	shops s
	FULL OUTER JOIN locations l
	ON s.city_id = l.city_id;

-- Delete the values we created just for the JOIN exercises
DELETE FROM locations WHERE city_id = 4;
DELETE FROM shops WHERE coffeeshop_id = 6;

--========================================================

-- UNION (to stack data on top each otherverticlly)

-- Return all cities and countries
SELECT city FROM locations
UNION
SELECT country FROM locations;

-- UNION removes duplicates
SELECT country FROM locations
UNION
SELECT country FROM locations;

-- UNION ALL keeps duplicates
SELECT country FROM locations
UNION ALL
SELECT country FROM locations;

-- Return all coffeeshop names, cities and countries
SELECT coffeeshop_name FROM shops
UNION
SELECT city FROM locations
UNION
SELECT country FROM locations;

--=================================================

-- Subqueries

-- Basic subqueries with subqueries in the FROM clause
SELECT *
FROM (
	SELECT *
	FROM employees
	where coffeeshop_id IN (3,4)
) as a;

SELECT
  a.employ_id,
	a.first_name,
	a.last_name
FROM (
	SELECT *
	FROM employees
	where coffeeshop_id IN (3,4)
) a;

-- Basic subqueries with subqueries in the SELECT clause
SELECT
	first_name, 
	last_name, 
	salary,
	(
		SELECT MAX(salary)
		FROM employees
		LIMIT 1
	) max_sal
FROM employees;

SELECT
	first_name, 
	last_name, 
	salary,
	(
		SELECT ROUND(AVG(salary), 0)
		FROM employees
		LIMIT 1
	) avg_sal
FROM employees;

SELECT
	first_name, 
	last_name, 
	salary, 
	(
		SELECT ROUND(AVG(salary), 0)
		FROM employees
		LIMIT 1
	) avg_sal,
	salary - ( -- avg_sal
		SELECT ROUND(AVG(salary), 0)
		FROM employees
		LIMIT 1
	) avg_sal_diff
FROM employees;

-- Subqueries in the WHERE clause
-- Return all US coffee shops
SELECT * 
FROM shops
WHERE city_id IN ( -- US city_id's
	SELECT city_id
	FROM locations
	WHERE country = 'United States'
);

-- Return all employees who work in US coffee shops
SELECT *
FROM employees
WHERE coffeeshop_id IN ( -- US coffeeshop_id's
	SELECT coffeeshop_id 
	FROM shops
	WHERE city_id IN ( -- US city-id's
		SELECT city_id
		FROM locations
		WHERE country = 'United States'
	)
);

-- Return all employees who make over 35k and work in US coffee shops
SELECT *
FROM employees
WHERE salary > 35000 AND coffeeshop_id IN ( -- US coffeeshop_id's
	SELECT coffeeshop_id
	FROM shops
	WHERE city_id IN ( -- US city_id's
		SELECT city_id
		FROM locations
		WHERE country = 'United States'
	)
);

-- 30 day moving total pay
-- The inner query calculates the total_salary of employees who were hired "within" the 30-day period before the hire_date of the current employee
SELECT
	hire_date,
	salary,
	(
		SELECT SUM(salary)
		FROM employees e2
		WHERE e2.hire_date BETWEEN e1.hire_date - 30 AND e1.hire_date
	) AS pay_pattern
FROM employees e1
ORDER BY hire_date;
