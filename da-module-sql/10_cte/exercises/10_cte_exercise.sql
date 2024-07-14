/* Airport Stats
 *
 * In one table, how per airport in separate columns:
 *  - count of departures 
 *  - count of arrivals 
 *
 * BONUS: what other stats can be added?
 */

SELECT * FROM airports;

WITH departure AS(
	SELECT origin,
			count(*) AS no_departure
	FROM flights
	GROUP BY origin
	),
	arrival AS (
	SELECT dest,
			count(*) AS no_arrival
	FROM flights
	GROUP BY dest
	)
SELECT name AS airport_name,
		departure.no_departure,
		arrival.no_arrival
FROM airports
JOIN departure
ON airports.faa = departure.origin
JOIN arrival
ON airports.faa = arrival.dest;






/* Solve the Q3 JOINs exercise with CTEs:
 * 
 * Q3. On a 2023-12-23 find 3 cities: 
 * - city the most count of flights (departing) per day
 * - city with the most unique planes departed
 * - city with the most unique airlines active
 */

WITH most_flights AS (
	SELECT city,
			count(*) AS no_flights
	FROM airports a 
	RIGHT JOIN flights
	ON a.faa = flights.origin 
	WHERE flight_date = '2023-12-23'
	GROUP BY city
	ORDER BY no_flights DESC
	LIMIT 1
	),
	most_planes as(
	SELECT city,
			count(DISTINCT tail_number) AS no_planes
	FROM airports a 
	RIGHT JOIN flights
	ON a.faa = flights.origin 
	WHERE flight_date = '2023-12-23'
	GROUP BY city
	ORDER BY no_planes DESC
	LIMIT 1
	),
	most_airlines as(
	SELECT city,
			count(DISTINCT airline) AS no_airlines
	FROM airports a 
	RIGHT JOIN flights
	ON a.faa = flights.origin 
	WHERE flight_date = '2023-12-23'
	GROUP BY city
	ORDER BY no_airlines DESC
	LIMIT 1
	)
SELECT city, no_flights, no_planes, no_airlines FROM most_flights
FULL JOIN most_planes USING (city)
FULL JOIN most_airlines USING (city)