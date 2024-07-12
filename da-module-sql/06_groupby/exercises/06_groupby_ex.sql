-- GROUP BY Exercises

/* Q1.1 Which country has the highest number of airports?
 *       Please provide the query and answer below.
 */

SELECT country,
	   COUNT(country) AS number_airports 
FROM airports
GROUP BY country
ORDER BY number_airports DESC 

 /* Q1.2 Change the query of Q1, so that we also see the timezone along with the country.
 *       Please provide the query and answer below.
 */
SELECT country,
	   tz,
	   COUNT(country) AS number_airports 
FROM airports
GROUP BY country, tz
ORDER BY number_airports DESC

/* Q2. Which city has the highest number of airports?
         Hint: there are many cities with the same name.
 *       Please provide the query and answer below.
 */
SELECT country,
	   city,
	   count(country) AS number_airports
FROM airports
GROUP BY country, city
HAVING NOT city ISNULL
ORDER BY number_airports DESC

 /* Q3. What's the average altitude of airports per country?
 *       Please provide the query and answer below.
 */
SELECT country,
		round(avg(alt), 2) AS average_altitude, 
		round(avg(alt)/3.28, 2) AS alt_meter
FROM airports
GROUP BY country
ORDER BY average_altitude DESC

SELECT country,
		city,
		name,
		round(alt/3.28, 2) AS alt_meter
FROM airports
WHERE country = 'Ethiopia'

/* Q4. Only show airports of the US. Which city of the US has the highest number of airports?
 * 		 (bonus: Which city of the US has the airport with the highest altitude?) 
 *       Please provide the query and answer below.
 */

SELECT city,
		count(city) AS number_of_airports,
		max(alt) AS max_altitude 
FROM airports
WHERE country = 'United States'
GROUP BY city
ORDER BY number_of_airports DESC

SELECT city,
		max(alt) AS max_altitude 
FROM airports
WHERE country = 'United States'
GROUP BY city
ORDER BY max_altitude DESC

/* Q5. Which plane has flown the most flights? Provide the plane number, the airline it belongs to, and how often was it in the air?
 *      Hint: cancelled is not "in the air"
 *      Please provide the query and answer below.
 */

SELECT tail_number AS plane_number,
		airline,
		count(tail_number) AS how_often_in_the_air
FROM flights
WHERE cancelled IS NOT NULL 
GROUP BY tail_number, airline
ORDER BY how_often_in_the_air DESC

/* Q6. How many planes have flown just a single flight?
 * 		Please provide the query and answer below.
 */

SELECT tail_number AS plane_number,
		count(tail_number) AS how_often_in_the_air
FROM flights
--WHERE cancelled IS NOT NULL
GROUP BY tail_number
HAVING count(tail_number) = 1

/* Q7. Let's understand our airlines a bit better...
* Please summarize in one table the following performance metrics per airline:
* - the nr of total flights
* - the average time in the air per flight
* - the average distance flown per flight
* - the maximum delay on arriving
*/
SELECT airline,
		count(*) AS total_nr_flights,
		ROUND(AVG(air_time), 2) AS avg_air_time,
		ROUND(AVG(distance), 2) AS avg_distance,
		MAX(arr_delay) AS max_delay_on_arriving,
		ROUND(AVG(arr_delay), 2) AS avg_delay_on_arriving
FROM flights
WHERE cancelled IS NOT NULL 
GROUP BY airline
ORDER BY count(*) DESC;

SELECT arr_delay,
		airline
FROM flights
WHERE arr_delay IS NOT NULL
ORDER BY arr_delay DESC;