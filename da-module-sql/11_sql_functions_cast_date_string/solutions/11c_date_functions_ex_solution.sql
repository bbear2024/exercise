/* Exercises
 * Now it's time to put what you've learned into practice.
 * The following exercises need to be solved using the flights and airports table from the PostgreSQL database 
 * you've already worked with.
 * Challenge your understanding and try to come up with the correct solution.
 *
 *
 * 1. What's the current timestamp with time zone?
 *    Please provide the query below.
 */
SELECT NOW();    
SELECT CURRENT_TIMESTAMP;

/* 2.1 Return the current timestamp and truncate it to the current day.
 *     Please provide the query below.
 */   
SELECT DATE_TRUNC('day', CURRENT_TIMESTAMP) AS current_date;

/* 2.2 Return a sorted list of all unique flight dates (only show year, month, day) 
 * available in the flights table.
 *     Please provide the query below.
 */   
SELECT DISTINCT DATE_TRUNC('day', flight_date) AS current_date 
FROM flights
ORDER BY 1;

/* 2.3 Return a sorted list of all unique flight dates available in the flights table 
 * and add 30 days and 12 hours to each date.
 *     Please provide the query below.
 */   
SELECT DISTINCT flight_date + INTERVAL '30 day' + INTERVAL '12 hour' AS same_timestamp_yesterday
FROM flights
ORDER BY 1;

/* 3.1 Return the hour of the current timestamp.
 *     Please provide the query below.
 */
SELECT DATE_PART('hour', CURRENT_TIMESTAMP) AS current_day;

/* 3.2 Sum up all unique days of the flight dates available in the flights table.
 *     Please provide the query below.
 */
SELECT SUM(DISTINCT DATE_PART('day', flight_date)) AS current_day
FROM flights;
-- 496

/* 3.3 Split all unique flight dates into three separate columns: year, month, day. 
 */
SELECT DISTINCT DATE_PART('day', flight_date)::INT AS day,
				DATE_PART('month', flight_date)::INT AS month,
				DATE_PART('year', flight_date)::INT AS year
		    FROM flights

