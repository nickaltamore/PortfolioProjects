-- Basic data checking an cleaning and exploratory data analysis. 
-- Data taken from kaggle: https://www.kaggle.com/datasets/devendrasingh22/astronomical-data

-- Check data has uploaded properly
SELECT *
FROM Astronomical..star_data

-- Check details of columns such as data type
USE Astronomical;
EXEC sp_help 'star_data';



--Data Cleaning--
--Check for NULL Values
SELECT COUNT(*)
FROM Astronomical..star_data
WHERE Temperature_K IS NULL OR Luminosity_L_Lo IS NULL OR Radius_R_Ro IS NULL OR 
Absolute_magnitude_Mv IS NULL OR Star_type IS NULL OR Star_color IS NULL OR Spectral_Class IS NULL;

-- Add Column to name star types where:0-> Brown Dwarf, 1->Red Dwarf, 2->White Dwarf, 3->Main Sequence, 4->Supergiants, 5-Unkown
ALTER TABLE Astronomical..star_data
ADD Star_type_name VARCHAR(14);

UPDATE Astronomical..star_data
SET Star_type_name = 
CASE
	WHEN Star_type = 0 THEN 'Brown Dwarf'
	WHEN Star_type = 1 THEN 'Red Dwarf'
	WHEN Star_type = 2 THEN 'White Dwarf'
	WHEN Star_type = 3 THEN 'Main Sequence'
	WHEN Star_type = 4 THEN 'Supergiant'
	ELSE 'Unknown'
END
	

-- Find total number of records
SELECT
	COUNT(*)
FROM Astronomical..star_data

-- Exploratory Data Analysis
-- How many records for each star type?
SELECT
	star_type_name AS 'star type',
	COUNT(*) AS count
FROM Astronomical..star_data
GROUP BY star_type_name;

-- How many records for each star color?
SELECT
	Star_color AS 'star color',
	COUNT(*) AS count
FROM Astronomical..star_data
GROUP BY star_color;


-- Find Average, SD, Variance, Min and Max values rounded to 2 decimal places. Due to the very small figure
-- for min(luminosity) it was rounded to 6 DP. Group by star types to make comparasins.
-- Exclusing unknown star types
SELECT 
	star_type_name,
    ROUND(AVG(Luminosity_L_Lo), 2) AS 'Average Luminosity',
    ROUND(STDEV(Luminosity_L_Lo), 2) AS 'SD Luminosity',
	ROUND(VAR(Luminosity_L_Lo), 2) AS 'Luminosity Variance',
	ROUND(MAX(Luminosity_L_Lo), 2) AS 'Max Luminosity',
	ROUND(MIN(Luminosity_L_Lo), 6) AS 'Min Luminosity'
FROM 
Astronomical..star_data
GROUP BY star_type_name
HAVING star_type_name != 'Unknown';

-- Find median
SELECT DISTINCT
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Luminosity_L_Lo]) OVER () AS median,
FROM Astronomical..star_data

-- Find Mode
WITH Mode_CTE AS (
    SELECT Luminosity_L_Lo, COUNT(*) AS CountValue,
           ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS RowNum
    FROM Astronomical..star_data
    GROUP BY Luminosity_L_Lo
)

SELECT Luminosity_L_Lo
FROM Mode_CTE
WHERE RowNum = 1;

-- Compare radius statistics by star colour
SELECT 
	Star_color,
    ROUND(AVG(Radius_R_Ro), 2) AS 'Average Radius',
    ROUND(STDEV(Luminosity_L_Lo), 2) AS 'SD Radius',
	ROUND(VAR(Luminosity_L_Lo), 2) AS 'Radius Variance',
	ROUND(MAX(Luminosity_L_Lo), 2) AS 'Max Radius',
	ROUND(MIN(Luminosity_L_Lo), 6) AS 'Min Radius'
FROM 
Astronomical..star_data
GROUP BY star_color;











