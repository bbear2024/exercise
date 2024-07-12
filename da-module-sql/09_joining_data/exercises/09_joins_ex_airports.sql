/* # JOINS - Exercises */

/* JOINS with Tables: 'flights' and 'airports'  */

/* Q1. What was the longest flight? (not using JOIN yet) --724
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */

SELECT max(air_time) AS longest_flight FROM flights;

SELECT air_time FROM flights
WHERE air_time IS NOT null
ORDER BY air_time DESC;


/* Q2. From which airport the longest flight? (now with JOIN) --724 General Edward Lawrence Logan International Airport
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */
SELECT * FROM flights;
SELECT * FROM airports;

SELECT 	air_time,
		name
FROM flights
INNER JOIN airports
ON flights.origin = airports.faa
WHERE air_time IS NOT null
ORDER BY air_time DESC;

/* Q3. On a 2023-12-23 find 3 cities: 
 * 
 * Step 1: city the most count of flights (departing) per day --Atlanta 900
 * Step 2: city with the most unique planes departed --Chicago 644
 * Step 3: city with the most unique airlines active --Nashville 14
 * 
 * Solving without Subqueries or CTE's (covered tomorrow):
 * first we'll find the values for each statistic (3 queries)
 * in the final query manually paste the values to the grouping condition 
 */

-- Step 1
SELECT	city,
		count(*) AS nr_flights
FROM airports
INNER JOIN flights
ON airports.faa = flights.origin
WHERE flight_date = '2023-12-23'
GROUP BY city
ORDER BY nr_flights DESC;

-- Step 2
SELECT	city,
		count(DISTINCT tail_number) AS nr_unique_planes
FROM airports
INNER JOIN flights
ON airports.faa = flights.origin
WHERE flight_date = '2023-12-23'
GROUP BY city
ORDER BY nr_unique_planes DESC;


-- Step 3
SELECT	city,
		count(DISTINCT airline) AS nr_unique_airlines
FROM airports
INNER JOIN flights
ON airports.faa = flights.origin
WHERE flight_date = '2023-12-23'
GROUP BY city
ORDER BY nr_unique_airlines DESC;


-- Final Query



/* Q4. The table 'flights' is about domestic flights in US. Let's double-check! 
 * 		Find unique country names for all departures in January 2024.
 * 
 * Guam, Virgin Islands, American Samoa, United States, Puerto Rico, Northern Mariana Islands
 * 
 * 		Hint: One option to filter dates is to use BETWEEN '2024-01-01' AND '2024-01-31'
 */ 
  
SELECT DISTINCT country
FROM airports
INNER JOIN flights
ON airports.faa = flights.origin 
WHERE flight_date BETWEEN '2024-01-01' AND '2024-01-31';

/* Q5. What is the count of all departures per 'country' in January 2024?
 * 
 * Guam	62, Virgin Islands	697, American Samoa	10, United States	522764, Puerto Rico	3318, Northern Mariana Islands	31
 * 		Hint: some listed flights wer cancelled, consider it in the filter
 */

SELECT 	country,
		count(*)
FROM airports
INNER JOIN flights
ON airports.faa = flights.origin 
WHERE flight_date BETWEEN '2024-01-01' AND '2024-01-31'
		AND cancelled = 0
GROUP BY country;

/* Q6. Which airport and in which city had the most departures in January 2024?
 * 
 * Hartsfield Jackson Atlanta International Airport, Atlanta, 26043
 * 
 * 		Hint: we also need to filter out the cancelled flights.
 */

SELECT 	name,
		city,
		count(*) AS nr_departures
FROM airports
INNER JOIN flights
ON airports.faa = flights.origin 
WHERE flight_date BETWEEN '2024-01-01' AND '2024-01-31'
		AND cancelled = 0
GROUP BY name, city
ORDER BY count(*) DESC;

/* Q7. To which city/cities does the airport with the second most arrivals belong?
 * 
 * Denver, Denver International Airport, 359061
 * 
 * 		Hint: remember the the clause to Skip a number of rows before LIMITing it?
 */

SELECT 	city,
		name,
		count(*) AS nr_arrivals
FROM airports
RIGHT JOIN flights
ON airports.faa = flights.dest
GROUP BY city, name
ORDER BY count(*) DESC
LIMIT 1 OFFSET 1;

/* Q8. Filter the data to January 1, 2023 and count all rows for that day so that your result set has two columns: flight_date, total_flights.  
 * 		Repeat this step, but this time only include data from January 1, 2024.
 * 		Combine the two result sets using UNION.
 */

--> UNION combines the distinct results of two or more SELECT statements

SELECT 	flight_date,
		count(*) AS total_flights
FROM flights
WHERE flight_date = '2023-01-01'
GROUP BY flight_date
UNION 
SELECT 	flight_date,
		count(*) AS total_flights
FROM flights
WHERE flight_date = '2024-01-01'
GROUP BY flight_date;


/* Q9. The last query can be optimized, right?
 * 		Rewrite the query above so that you get the same output, but this time you are not allowed to use UNION.
 * 
 * 		Hint: we filter data for those 2 days. 
 */

SELECT 	flight_date,
		count(*) AS total_flights
FROM flights
WHERE flight_date = '2023-01-01' OR flight_date = '2024-01-01'
GROUP BY flight_date;


/* Q10. Which flights had a departure delay of more than 30 minutes?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which day and in which city?   
 * 	    Answer all questions with a single query.
 */

SELECT 	dep_delay,
		tail_number,
		flight_date,
		city
FROM flights
LEFT JOIN airports
ON flights.origin = airports.faa
WHERE dep_delay > 30
ORDER BY dep_delay DESC

/* Q11. Which airports (add city name)
 * 		- had how many fligts with a departure delay of more than 30 minutes?
 *      	- what was the average delay?
 * 			- how many unique aiplanes were involved?
 */

SELECT 	name,
		city,
		count(*) AS nr_flights_30m_delay,
		round(avg(dep_delay), 2) AS avg_delay,
		count(DISTINCT tail_number) AS nr_unique_planes
FROM airports
RIGHT JOIN flights
ON airports.faa = flights.origin
WHERE dep_delay > 30
GROUP BY name, city
ORDER BY avg_delay DESC



