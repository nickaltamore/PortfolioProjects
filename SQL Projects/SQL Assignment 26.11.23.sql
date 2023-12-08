-- 2. Using COUNT to get the number of cities in the USA
SELECT COUNT (*)
FROM city
WHERE CountryCode = 'USA';

-- 3. Population and average life expectancy in Argentina
SELECT Name as 'Country Name', Population, LifeExpectancy as 'Average Life Expectancy'
FROM country
WHERE Name = 'Argentina'

-- 4. Using ORDER BY to find the country with the highest life expectancy.
-- NB instructions said to use LIMIT however this key word dosent exist in SQL servere
-- so SELECT TOP was used instead
SELECT TOP 1 Name as 'Country Name', LifeExpectancy as 'Average Life Expectancy'
FROM country
ORDER BY lifeExpectancy DESC;

-- 5. Selecting 25 cities from around the world that begin with F.
SELECT TOP 25 *
FROM city
WHERE Name LIKE 'f%';

-- 6. Select column ID, Name and population and only show top 10 rows. 
SELECT TOP 10 ID, Name, Population
FROM city

--7. Find cities with populations greater than 2000000.
SELECT Name, Population
FROM city
WHERE Population > 2000000;


-- 8. Find all city names that begin with "Be" 
SELECT  *
FROM city
WHERE Name LIKE 'Be%';

-- 9. Select Cities with population between 500000-1000000.
SELECT Name, Population
FROM city
WHERE Population BETWEEN 500000 AND 1000000;

-- 10 Use LEFT JOIN to find the capital of Spain. City ID and Capital match so join on those values. 
SELECT city.ID, country.Capital as 'Capital ID', country.Name as Country, city.Name as Capital
FROM city
LEFT JOIN country
ON city.ID = country.Capital
WHERE city.ID = '653';

-- 11. Use left join to list all languages spoken in SE Asia, countrylanguage.CountryCode and country.code match so join on those values. 
SELECT con.Code, lan.CountryCode con,Region, lan.Language
From country AS con
LEFT JOIN countrylanguage AS lan
ON con.CODE = lan.CountryCode
WHERE Region = 'Southeast Asia';

-- 12. Find the city with the lowest population in city table. Attempted to use MIN() function but returned aggregate error
-- SELECT Name, MIN(Population)
--FROM City
-- ORDER BY Population

--Msg 8120, Level 16, State 1, Line 61
--Column 'City.Name' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.

SELECT TOP 1 Name, Population
FROM City
ORDER BY Population;