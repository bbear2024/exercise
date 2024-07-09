-- Functions for Aggregation Data in SQL

/* Q1.1 What is the total number of rows in the flights table?
 * 		Please provide the query and answer below.
 */

SELECT count(*)
FROM flights;

/* Q1.2 What is the total number of unique airlines in the flights table?
 * 		Please provide the query and answer below.
 */
SELECT count(DISTINCT airline) AS unique_airlines
FROM flights;

/* Q3. How many airports does Germany have?
 *     Please provide the query and answer below.
 */

SELECT count(*) AS airports_in_germany
FROM airports
WHERE country = 'Germany';

/* Q4. How many flights had a departure delay smaller or equal to 0?
 *     Please provide the query and answer below.
 */

SELECT count(*) AS num_flights_departure_delay_smaller_or_equal_to_0
FROM flights
WHERE dep_delay <= 0;

/* Q5. What's the first day and what's the last day of flight_dates in the flights table?
 *     Please provide the query and answer below.
 */

SELECT min(flight_date) AS first_day,
	   max(flight_date) AS last_day 
FROM flights

/* Q6. What was the average departure delay of all flights on January 1, 2023.
 *     Please provide the query and answer below.
 */

SELECT round(avg(dep_delay), 2) AS avg_departure_delay_on_2023_01_01
FROM flights
WHERE flight_date = '2023-01-01'

/* Q7.1 How many flights have a missing value (NULL value) as their departure time?
 *      Please provide the query and answer below.
 */

SELECT count(*) AS num_missing_value_departure_time
FROM flights
WHERE dep_time IS NULL;

/* Q7.2 Out of all flights how many flights were cancelled? 
 *      Is this number equal to the number of flights that have a NULL value as their departure time above?
 *      Please provide the query and answer below.
 */

SELECT count(*) AS num_cancelled_flights
FROM flights
WHERE cancelled = 1;

/* Q7.3 The number of canceled_flights (Q7.2) is higher than the no_dep_time (Q7.1), 
 * 		which means there are flight records with departure time (flight started) but the flights were stil cancelled.
 * 		Show those canceled flight with departure time.
 */

SELECT * 
FROM flights
WHERE cancelled = 1 AND NOT (dep_time ISNULL);

/* Q8. What's the total number of flights on January 1, 2023 that have a departure time of NULL or were cancelled?
 *      Please provide the query and answer below.
 */

SELECT count(*)
FROM flights
WHERE flight_date = '2023-1-1' AND (dep_time ISNULL OR cancelled = 1)

/* Q9. What's the number of airlines that had flights on January 1, 2023 that have a departure time of NULL or were cancelled?
 *      Please provide the query and answer below.
 */

SELECT count(DISTINCT airline) AS num_of_airlines
FROM flights
WHERE flight_date = '2023-1-1' AND (dep_time ISNULL OR cancelled = 1)

/* Q10. Which airport has the lowest altitude?
 *      Please provide the query and answer below.
 */

SELECT name,
		city,
		country,
		alt
FROM airports
WHERE alt = (
	SELECT min(alt)
	FROM airports
	);