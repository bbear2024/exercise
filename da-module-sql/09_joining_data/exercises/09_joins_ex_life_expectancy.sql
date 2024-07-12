/* # JOINS - Exercises */
/* JOINS with Tables: 'life_expectancy' and 'regions'  */

/* Q1. Please calculate the average life expectancy for each country.
 * 	 		Include the names of the region and of the country.
 * 			Include information what are the first and last year considered.
 */ 
SELECT * FROM life_expectancy;

SELECT country,
		region,
		min(year) AS first_year,
		max(year) AS last_year,
		round(CAST(avg(life_expectancy) AS NUMERIC),2) AS avg_life_expectancy
FROM life_expectancy
LEFT JOIN regions
USING(country)
GROUP BY country, region
ORDER BY avg_life_expectancy DESC;

/* Q2. Please calculate the average life expectancy per region. 
 * 			Include the number of countries that were considered, the years for period_start and period_end 
 * 			in your output.
 * 			Which region has the highest? 
 * 			
 * 			Note: We compressed a lot of countries and different years.
 */ 

SELECT	region,
		count(DISTINCT country) AS nr_countries,
		min(year) AS first_year,
		max(year) AS last_year,
		round(CAST(avg(life_expectancy) AS NUMERIC),2) AS avg_life_expectancy
FROM life_expectancy
LEFT JOIN regions
USING(country)
GROUP BY region
ORDER BY avg_life_expectancy DESC;

/* Q3. What was the average life expectancy per region in year 2024
 */ 

SELECT	region,
		count(DISTINCT country) AS nr_countries,
		round(CAST(avg(life_expectancy) AS NUMERIC),2) AS avg_life_expectancy_2024
FROM life_expectancy
LEFT JOIN regions
USING(country)
WHERE YEAR = 2024
GROUP BY region
ORDER BY avg_life_expectancy_2024 DESC;

/* Q4. Present the global development of the average life expectancy over time.
 */ 
SELECT 	year,
		round(CAST(avg(life_expectancy)AS NUMERIC),2) AS avg_life_expectancy
FROM life_expectancy
GROUP BY YEAR
ORDER BY year



/* BONUS: Should be done with JOIN only, without Window functions (not covered yet)
 * Show country and life expectancy this and last year, add column showing the change in %
 */


DROP VIEW IF EXISTS life_expectancy_2023_view;
CREATE VIEW life_expectancy_2023_view AS (
	SELECT	country,
			life_expectancy 
	FROM life_expectancy
	WHERE YEAR =2023
);

SELECT 	life_expectancy.country,
		life_expectancy.life_expectancy AS le_2024,
		life_expectancy_2023_view.life_expectancy AS le_2023,
		CASE WHEN life_expectancy_2023_view.life_expectancy = 0 THEN 0
			ELSE round(CAST((life_expectancy.life_expectancy - life_expectancy_2023_view.life_expectancy)*100.0/life_expectancy_2023_view.life_expectancy AS NUMERIC), 2)
		END AS change_in_percent
FROM life_expectancy
INNER JOIN life_expectancy_2023_view
USING (country)
WHERE YEAR = 2024
;

select
    le1.country,
    le1.year AS current_year,
    le1.life_expectancy AS le_current,
    le2.year AS last_year,
    le2.life_expectancy AS le_last_year,
    ROUND(((le1.life_expectancy - le2.life_expectancy) / le2.life_expectancy)::numeric * 100, 2) AS change_in_percent
from life_expectancy le1
join life_expectancy le2 ON le1.country = le2.country AND le2.year = le1.year - 1
order by le1.country, le1.year;

-- what if we need it per region
CREATE TABLE le_region_23 AS
SELECT	region,
		round(CAST(avg(life_expectancy) AS NUMERIC),2) AS avg_le_23
FROM life_expectancy
LEFT JOIN regions
USING(country)
WHERE YEAR = 2023
GROUP BY region;

CREATE TABLE le_region_24 AS
SELECT	region,
		round(CAST(avg(life_expectancy) AS NUMERIC),2) AS avg_le_24
FROM life_expectancy
LEFT JOIN regions
USING(country)
WHERE YEAR = 2024
GROUP BY region;

SELECT region,
		avg_le_24,
		avg_le_23,
		round((avg_le_24-avg_le_23)*100/avg_le_23,2) AS percent_change
FROM le_region_24
INNER JOIN le_region_23
USING (region);