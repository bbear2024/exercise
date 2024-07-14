/* This file is full of practical exercises that will help you in building up your advanced SQL skills.
 */

/* Q1. What's the highest number of flights that have departed in a day from an airport above altitude 7800?
 * 	   Please provide the query and answer below.
 */
WITH a_7800 AS (
	SELECT name,
			alt,
			faa
	FROM airports a
	WHERE alt > 7800
	),
	no_flights_per_day AS (
	SELECT flight_date,
			count(*) AS no_flights,
			origin
	FROM flights f 
	GROUP BY flight_date, origin
	)
SELECT name,
		alt,
		MAX(no_flights) AS highest_no_flights_in_a_day
FROM a_7800
INNER JOIN no_flights_per_day
ON a_7800.faa = no_flights_per_day.origin
GROUP BY name,alt

/* Q2. How many flights have departed and arrived in the United States?
 * 		Please provide the query and answer below.
 */

WITH usa AS (
	SELECT country,
			faa
	FROM airports a 
	WHERE country = 'United States'
	),
	departure AS (
	SELECT usa.country,
			count(dep_time) AS no_flights_departure
	FROM flights f 
	INNER JOIN usa
	ON f.origin = usa.faa
	WHERE dep_time IS NOT NULL
	GROUP BY usa.country
	),
	arrival AS (
	SELECT usa.country,
			count(arr_time) AS no_flights_arrival
	FROM flights f 
	INNER JOIN usa
	ON f.dest = usa.faa
	WHERE arr_time IS NOT NULL
	GROUP BY usa.country
	)
SELECT country,
		departure.no_flights_departure,
		arrival.no_flights_arrival
FROM departure
JOIN arrival
USING (country)

 /* Q3. Which flight had the highest departure delay?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which day and in which city?   
 * 	    Answer all questions with a single query.
 */
WITH a AS (
	SELECT dep_delay,
			tail_number,
			flight_date::date AS date,
			TO_CHAR(flight_date, 'Dy') AS weekday,
			origin
	FROM flights
	WHERE dep_delay IS NOT NULL
	ORDER BY dep_delay DESC
	LIMIT 1
	)
SELECT dep_delay,
		tail_number,
		date,
		weekday,
		city
FROM a
JOIN airports ap
ON a.origin = ap.faa;
		

/* Q4. What's the flight connection that covers the shortest distance?
 * 	   Please provide a list with 5 columns: 
 *     - origin_airport = The full name of the origin airport
 * 	   - origin_country = The country of the origin airport
 * 	   - destination_airport = The full name of the destination airport
 * 	   - destination_country = The country of the destination airport
 * 	   - smallest_distance = The flight distance between origin_airport and destination_airport
 * 	   Remember: Only provide the flight connection with the shortest distance of all flights in the flights table.
 * 	   Please provide the query below.
 */
WITH s AS (
	SELECT origin,
			dest,
			distance
	FROM flights f 
	ORDER BY distance
	LIMIT 1
	),
	o AS (
	SELECT name AS origin_airport,
			country AS origin_country,
			distance
	FROM s
	JOIN airports a
	ON s.origin = a.faa
	),
	d AS (
	SELECT name AS destination_airport,
			country AS destination_country,
			distance
	FROM s
	JOIN airports a
	ON s.dest = a.faa
	)
SELECT origin_airport,
		origin_country,
		destination_airport,
		destination_country,
		distance AS smallest_distance
FROM o
JOIN d
USING (distance);