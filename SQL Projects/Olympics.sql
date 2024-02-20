-- Check data imported from both tables
USE Olympics;

SELECT *
FROM athlete_details

SELECT *
FROM event_details

-- Check data types of tables

EXEC sp_help 'athlete_details';

EXEC sp_help 'event_details';

-- Check for NULL values
SELECT *
	--COUNT(*)
FROM athlete_details
WHERE ID IS NULL OR Name IS NULL OR Sex IS NULL OR Age IS NULL OR Height IS NULL OR Weight IS NULL OR Team IS NULL OR NOC IS NULL

SELECT *
	--COUNT(*)
FROM Olympics..event_details
WHERE Games IS NULL OR Year IS NULL OR Season IS NULL OR City IS NULL OR Sport IS NULL OR Event IS NULL OR Medal IS NULL OR Athlete_Id IS NULL

-- Replace NULL values with a 0 in athlete_details tables. NULLS only found in Age, Height and Weight. Will ignore 0s when taking averages. 

SELECT
	ID, 
	Name,
	Sex,
	COALESCE(Age, 0) AS Age,
	COALESCE(Height, 0) AS Height,
	COALESCE(Weight, 0) AS Weight,
	Team, 
	NOC
FROM Athlete_details;

-- Update one column at a time
UPDATE athlete_details
SET 
	Height = 0
WHERE Height IS NULL

-- Update multiple columns at a time
UPDATE athlete_details
SET
    Age = CASE
              WHEN Age IS NULL THEN 0
              ELSE Age
          END,
    Weight = CASE
                 WHEN Weight IS NULL THEN 0
                 ELSE Weight
             END;

-- Exploratory Analysis

-- AVG, MIN, Max of athlete ages, heights and weights (ignoring 0 values). 
 
SELECT 
	AVG(Age) AS 'Average Age',
	MAX(Age) AS 'Maxiumum Age',
	MIN(Age) AS 'Minimum Age',
	AVG(Height) AS 'Average Height',
	MAX(Height) AS 'Maxiumum Height',
	MIN(Height) AS 'Minimum Height',
	ROUND(AVG(Weight),0) AS 'Average Weight',
	MAX(Weight) AS 'Maxiumum Weight',
	MIN(Weight) AS 'Minimum Weight'
FROM athlete_details
WHERE Height > 0 OR Weight > 0 OR Age > 0 OR (Height > 0 AND Weight > 0 AND Age > 0)

-- Calcuate the AVG, MIN and MAX age, height and weight of Olympic athletes. 
--Had to use CASE WHEN since there are some records where all three values were 0 so it was returning 0 values.
SELECT 
    AVG(CASE WHEN Age != 0 THEN Age ELSE NULL END) AS 'Average Age',
    MAX(CASE WHEN Age != 0 THEN Age ELSE NULL END) AS 'Maximum Age',
    MIN(CASE WHEN Age != 0 THEN Age ELSE NULL END) AS 'Minimum Age',
    AVG(CASE WHEN Height != 0 THEN Height ELSE NULL END) AS 'Average Height (cm)',
    MAX(CASE WHEN Height != 0 THEN Height ELSE NULL END) AS 'Maximum Height (cm)',
    MIN(CASE WHEN Height != 0 THEN Height ELSE NULL END) AS 'Minimum Height (cm)',
    ROUND(AVG(CASE WHEN Weight != 0 THEN Weight ELSE NULL END), 0) AS 'Average Weight (kg)',
    MAX(CASE WHEN Weight != 0 THEN Weight ELSE NULL END) AS 'Maximum Weight (kg)',
    MIN(CASE WHEN Weight != 0 THEN Weight ELSE NULL END) AS 'Minimum Weight (kg)'
FROM athlete_details;
--Yes there was a 97 year old competitor in the olympics. 
--John Quincy Adams Ward (USA) - 1928 Amsterdam Summer Olympics
-- He died in 1910 but his work was entered in the Sculpture competition.

-- Number of Athletes per country (Top 10)
SELECT TOP 10
    Team,
    COUNT(*) as 'Number of Athletes'
FROM athlete_details
GROUP BY Team
ORDER BY COUNT(*) DESC;

--Medals per athlete
SELECT
	a.Name,
	a.Team,
	(SELECT COUNT(*) FROM event_details e2 WHERE e2.Athlete_Id = a.ID AND e2.Medal = 'Gold') AS Gold_Medals,
	(SELECT COUNT(*) FROM event_details e2 WHERE e2.Athlete_Id = a.ID AND e2.Medal = 'Silver') AS Silver_Medals,
	(SELECT COUNT(*) FROM event_details e2 WHERE e2.Athlete_Id = a.ID AND e2.Medal = 'Bronze') AS Bronze_Medals,
	COUNT(*) AS Total_Medals 
FROM athlete_details a
JOIN event_details e
ON e.Athlete_Id = a.ID
WHERE e.medal != 'NA'
GROUP BY a.Name, a.Team, a.ID
ORDER BY Total_Medals DESC

-- Practice CTEs. 
-- Create CTE to select Team Australia and reference it in the main query
With country AS(
	SELECT
		Team
FROM athlete_details
WHERE Team = 'Australia')

SELECT
	Team
FROM country

-- Create a temporary table adding columns for gold, silver and bronze and 1 where the medal was won. 
-- This will make it easier to count the number of medals and each kind won.
CREATE TABLE #temp_event_details AS
SELECT *
FROM event_details;

SELECT *
INTO #temp_event_details
FROM event_details;

ALTER TABLE #temp_event_details
	ADD Gold INT,
		Silver INT,
		Bronze INT;

UPDATE #temp_event_details
SET Gold = CASE
				WHEN Medal = 'Gold' THEN 1
				ELSE 0
				END,
	Silver = CASE
				WHEN Medal = 'Silver' THEN 1
				ELSE 0
				END,

	Bronze = CASE
			WHEN Medal = 'Bronze' THEN 1
			ELSE 0
			END;

-- USE Temp Table and ROW_NUMBER window functionto find the athetes from each country that have won the most medals
SELECT
	a.Name, 
	a.Team,
	(SUM(GOLD) + SUM(Silver) +SUM(Bronze)) AS Total_Medals,
	SUM(GOLD) AS Gold_Medals,
	SUM(Silver) AS Silver_Medals,
	SUM(Bronze) AS Bronze_Medals,
	ROW_NUMBER() OVER(PARTITION BY a.Team ORDER BY (SUM(GOLD) + SUM(Silver) + SUM(Bronze)) DESC) AS Rank
FROM #temp_event_details t
JOIN athlete_details a
ON a.ID = t.Athlete_Id
GROUP BY Name, Team
ORDER BY Total_Medals DESC, Gold_Medals DESC;






