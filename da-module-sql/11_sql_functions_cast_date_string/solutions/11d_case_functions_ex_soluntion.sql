/* Q5. For each airport get some summary statistics about the flights acitivity:
 *      How many incoming and departing flights per day on average?
 * 	    How many departing flights that are delayed, on_time or too_early per day on average? 
 * 	    How many connecting airports?
 *		Can you come up with some more interesting metrics?
 * 	    Answer all questions with a single query.
 */

SELECT a.name, 
		COUNT(CASE WHEN dep_delay < 0 THEN 1 ELSE NULL END)/COUNT(DISTINCT flight_date) AS avg_daily_early, 
		COUNT(CASE WHEN dep_delay > 0 THEN 1 ELSE NULL END)/COUNT(DISTINCT flight_date) AS avg_daily_delayed, 
		COUNT(CASE WHEN dep_delay = 0 THEN 1 ELSE NULL END)/COUNT(DISTINCT flight_date) AS avg_daily_on_time,
		(COUNT(*)/COUNT(DISTINCT flight_date)) AS avg_daily_flights,
		COUNT(DISTINCT dest) AS number_connecting_airports
FROM flights f 
JOIN airports a 
ON a.faa = origin
JOIN airports a2
ON a2.faa = dest
GROUP BY 1