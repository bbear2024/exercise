/*  Functions for Data Aggregation - Key Element of Data Analytics
 * 
 * Aggregate functions, such as AVG(), SUM(), and COUNT(), compute a single result from a set of values. 
 * They allow us to condense large and complex sets of values into meaningful summary measures. 
 * The aggregated results provide a general overview that simplifies analysis.
 * 
 * Aggregated data can reveal trends, patterns, and insights that may not be apparent when examining 
 * individual data points.
 * 
 * Some common methods of summarizing are:
		
		- Minimum
		- Maximum
		- Count
		- Distinct Count
		- Mean
		- Sum
*/

/* 1. MIN() and MAX()
 * What is the highest and the lowest airport altitude?  
 */
SELECT MAX(alt) AS maximum_altitude
FROM airports;

SELECT MIN(alt) AS minimum_altitude
FROM airports;

-- try: find the first and last date in the table 'flights' 

SELECT MIN(flight_date) AS first_date
FROM flights;

SELECT MAX(flight_date) AS first_date
FROM flights;

/* 2. COUNT
 * Find out how many rows total are in the table.
 */
SELECT COUNT(*)
FROM airports;

-- try: Combine count with a condition: How many airports are listed for Germany?
SELECT COUNT(*)
FROM airports
WHERE country = 'Germany';

/* 3. COUNT DISTINCT 
 * We've learned how to show only unique values of a column by using DISTINCT
 */
SELECT DISTINCT country
FROM airports;

 /* To find out how many unique values are in a column we need to wrapt it in a COUNT() function
 */
SELECT COUNT(DISTINCT country)
FROM airports;

/*
-- try: In one query from the 'flights' table count: 
			- number of unique origin airport codes
			- number of unique tail numbers
			- number of unique airlines 
 */

SELECT count(DISTINCT origin) AS num_unique_origin_airport_codes,
	   count(DISTINCT tail_number) AS num_unique_tail_numbers,
	   count(DISTINCT airline) AS num_unique_airlines
FROM flights;

-- 4. AVG()
/* What is the average altitude of airports overall?
 */
SELECT AVG(alt) AS average_altitude
FROM airports;

--try: What is the average flight time from Boston (BOS) to Honolulu (HNL)
--	Hint: Use WHERE with two conditions.
SELECT AVG(air_time) AS average_flight_time
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL'

-- 5. SUM()
/* Find total distance of all flights in on the 1st of January 2024
 */
SELECT SUM(distance) AS total_distance
FROM flights
WHERE flight_date = '2024-01-01';

-- try: check the total flight time, basically how long would one plane to fly that distance 

SELECT SUM(air_time) AS total_flight_time
FROM flights
WHERE flight_date = '2024-01-01';

/* SIDEBAR: Mathematical Functions and Operators
*/

/* ROUND() Function:
	The ROUND() function is used to round a numeric value to a specified number of decimal places. 
	It takes two arguments: the numeric value to be rounded and the number of decimal places.
	For example, ROUND(5.7, 0) would yield 6, and ROUND(3.14159, 2) would yield 3.14.
*/
SELECT AVG(air_time) AS avg_air_time,
		ROUND(AVG(air_time), 2) AS avg_air_time_rounded
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

/* FLOOR() Function:
	The FLOOR() function rounds a numeric value down to the nearest integer that is less than or 
	equal to the input value.
	For instance, FLOOR(5.7) results in 5, and FLOOR(-42.8) yields -43.
*/
SELECT AVG(air_time) AS avg_air_time,
		FLOOR(AVG(air_time)) AS avg_air_time_floor
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

/* CEILING() Function:
	The CEILING() function rounds a numeric value up to the nearest integer that is greater than or 
	equal to the input value.
	For example, CEILING(3.2) results in 4, and CEILING(-2.5) yields -2.
*/
SELECT AVG(air_time) AS avg_air_time,
		CEILING(AVG(air_time)) AS avg_air_time_ceiling
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

-- REVIEW: Compare the different outcomes
SELECT FLOOR(2.75), CEILING(2.75), ROUND(2.75, 1)

/* Floor Division (Integer Division):
	When dividing two integers (e.g., 5 / 2), PostgreSQL truncates the result towards zero, 
	resulting in an integer quotient. Floor Division ensures that the result is always an integer, 
	discarding any fractional part. 
	In this case, 5 / 2 yields 2, and (-5) / 2 yields -2.
*/

-- show full airtime as minutes and as full hours (but no fractions)
SELECT flight_date,
	   origin,
       dest, 
       air_time AS air_time_minutes,
       air_time / 60 AS air_time_hours 
FROM flights;


/* Division with Decimal Numbers:
	To perform division with decimal numbers, simply use the / operator. 
	For example, 10.5 / 2.5 results in 4.2.
*/

SELECT AVG(air_time) AS avg_air_time,
	   AVG(distance) AS avg_distance,
	   AVG(distance) / AVG(air_time) miles_per_min
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';


/* Modulo Operator:
	The modulo operator (%) calculates the remainder when dividing one number by another.
	For instance, 7 % 3 yields 1, as 7 divided by 3 leaves a remainder of 1.
 */

SELECT
	COUNT(faa) AS airports_total,
	COUNT(DISTINCT country) unique_country_total,
	COUNT(faa) / COUNT(DISTINCT country) AS avg_airports_per_country,
	COUNT(faa) % COUNT(DISTINCT country) AS remainder_airports, -- the modulo example
	COUNT(faa)*1.0 / COUNT(DISTINCT country) AS true_ratio_avg_airports_per_country -- *1.0 turns the first value into NUMERIC type
FROM airports;

/* Practical Example ROUND():
 * Filter airports for countries China or Nepal with the altitude higher than 12400,
 * show altitude in separate columns measured in feet, in meters and in kilometers
 */
SELECT name, 
	   city, 
	   country,
	   alt AS altitude_in_feet,
	   ROUND(alt/3.281, 2) AS altitude_in_m,
	   ROUND((alt/3.281) / 1000.0, 3) AS altitude_in_km
FROM airports
WHERE alt >= 12400
  AND (country = 'China' OR country = 'Nepal');

/* Practical Example - Floor Division and Modulo:
 * How long is the total airtime on the 1st of January 2024 in days + hours + minutes?
 */

SELECT SUM(air_time) / 60 / 24 AS days,-- deviding total minutes to whole days
	   SUM(air_time) / 60 % 24 AS hours, -- shows the remaining hours after deviding to whole days
	   SUM(air_time) % 60 AS minutes -- shows the remaining minutes after deviding to total hours,
FROM flights
WHERE flight_date = '2024-01-01';
