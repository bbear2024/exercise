/*   As a Data Analyst, it is crucial that you can rely on the quality of your data at all times.
 *   The data in the actual_elapsed_time column in the flights table seems to be about the time from departure to arrival.
 *   Currently, this is only an assumption. Based on this assumption, do you feel confident in using this column in your 
 *   analysis and giving out business recommendations?
 *   If your answer is no, you're on a good path to becoming an analyst.
 *
 * 1.Using the data in the remaining columns in the flights table, can you think of a way to verify our assumption?
 *   Please provide the answer below.
 */

-- Yes, we can calculate the difference between departure and arrival time and compare it to the values in the 
-- actual_elapsed_time column to check if they're equal.

/*   Don't worry if you couldn't figure this one out. To verify our assumption, we can calculate the difference between 
 *   departure and arrival time and compare the result to the values in the actual_elapsed_time column to check if they're equal.
 */

/* 2.1 The first step is to become familiar with the dep_time, arr_time and actual_elapsed_time columns.
 *     Based on the column names and what you already know from previous exercises about the information that is stored 
 *     in these three columns, what are your assumptions about the data types of the values?
 */

-- arr_time: TIME value in the format XX:XX e.g. 11:30
-- dep_time: TIME value in the format XX:XX e.g. 11:30
-- actual_elapsed_time: Either in seconds, minutes or hours; stored as INT or INTERVAL in the format XX:XX:XX e.g. 00:10:00


/* 2.2 Retrieve all unique values from these columns in three separate queries and order them in descending order.
 *     Did your assumptions turn out to be correct?
 * 	   Please provide the queries below.
 */

SELECT DISTINCT arr_time
FROM flights f
ORDER BY arr_time DESC;
-- arr_time is stored as a hundred or thousand number

SELECT DISTINCT dep_time
FROM flights f
ORDER BY dep_time DESC;
-- dep_time is stored as a hundred or thousand number

SELECT DISTINCT actual_elapsed_time 
FROM flights f
ORDER BY actual_elapsed_time DESC;
-- actual_elapsed_time is stored in minutes as INT/FLOAT

/* 3.1 Next, calculate the difference of dep_time and arr_time and call it flight_duration.
 * 	   Please provide the query below.
 */

SELECT arr_time - dep_time AS flight_duration
FROM flights;

/* 3.2 Are the calculated flight duration values correct? If not, what's the problem and how can we solve it?
 *     Please provide the answer below.
 */

-- No, the values are not correct. dep_time and arr_time are not in time formats and the difference is not in minutes.

/* 4 In order to calculate correct flight duration values we need to convert dep_time, arr_time and actual_elapsed_time 
 *   into useful data types first.
 *   Change dep_time and arr_time into TIME variables, call them dep_time_f and arr_time_f. 
 *   Change actual_elapsed_time into an INTERVAL variable, call it actual_elapsed_time_f.
 *   Query flight_date, origin, dest, dep_time, dep_time_f, arr_time, arr_time_f, actual_elapsed_time and actual_elapsed_time_f.
 *   Please provide the query below.
 */

SELECT flight_date,
       origin,
       dest,
       dep_time,
       MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
       arr_time,
       MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
       actual_elapsed_time,
       MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
FROM flights;

/* 5.1 Querying the raw columns next to the ones we have transformed, makes it a lot easier to compare the result to the input.
 *     This allows for quick prototyping and debugging and helps to understand how functions work. 
 *     To optimize our query in terms of performance and readability, we can always remove unneccessary columns in the end. 
 *     Use the previous query and calculate the difference of arr_time_f and dep_time_f and call it flight_duration_f.
 * 	   Please provide the query below.
 */
 

WITH times_converted AS (
-- you type here
		SELECT flight_date,
		       origin,
		       dest,
		       dep_time,
		       MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
		       arr_time,
		       MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
		       actual_elapsed_time,
		       MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
		FROM flights
		)
SELECT -- you type here
		flight_date,
		origin,
		dest,
		dep_time_f,
		arr_time_f,
		arr_time_f - dep_time_f AS flight_duration_f,
		actual_elapsed_time_f
FROM times_converted;


/* 5.2 Compare the calculated flight duration values in flight_duration_f with the values in the actual_elapsed_time_f column and 
 * 	   calculate the percentage of values that are equal in both columns.
 * 	   Please provide the query below.
 */

/* Explanation of the solution: 
 * The output of comparing two numbers, actual_elapsed_time_f and flight_duration_f, results in TRUE/FALSE of type BOOLEAN
 * Casting a BOOLEAN into an INTEGER turns TRUE=1 and FALSE=0, summing up the values gives the total number of equal values
 * In order to calculate the percentage, we can simply divide it by the total number of flights using COUNT(*)
 * Remember: In SQL, dividing two INTEGERS results in an INTEGER. Therefore we need to cast one value into a float using * 1.0.
 */

WITH times_converted AS (
-- you type here
		SELECT flight_date,
		       origin,
		       dest,
		       dep_time,
		       MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
		       arr_time,
		       MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
		       actual_elapsed_time,
		       MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
		FROM flights
),
compare_times as(
-- you type here
		SELECT dep_time_f - arr_time_f AS flight_duration_f,
				actual_elapsed_time_f,
				((arr_time_f - dep_time_f) = actual_elapsed_time_f) AS is_equal
		FROM times_converted
)
SELECT -- you type here, use this last step to sum up the values and calc percentage
	(SUM(is_equal::INT)*100.0 / COUNT(*)) AS matching_percentage
FROM compare_times;

/* 5.3 Given the percentage of matching values, can you come up with possible explanations for why the rate is so low?
 *     Please provide the answer below.
 */
--1. departure city and arrival city may be in the different time zone
--2. departure and arrival may be not in the same day
--3. null values in the list


/* 6.1 Differences due to time zones might be one reason for the low rate of matching values.
 *     To make sure the dep_time and arr_time values are all in the same time zone we need to know in which time zone they are.
 *     Take your query from exercise 5.1 and add the time zone values from the airports table.
 * 	   Make sure to transform them to INTERVAL and change their names to origin_tz and dest_tz.
 *     Please provide the query below.
 */

WITH times_converted AS (
	SELECT flight_date,
	       origin,
	       dest,
	       dep_time,
	       MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
	       arr_time,
	       MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
	       actual_elapsed_time,
	       MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
	FROM flights
	)
SELECT	flight_date,
		origin,
		dest,
		dep_time_f,
		MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
		arr_time_f,
		MAKE_INTERVAL(hours => b.tz::INT) AS dest_tz,
		arr_time_f - dep_time_f AS flight_duration_f,
		actual_elapsed_time_f
FROM times_converted
JOIN airports a 
ON times_converted.origin = a.faa
JOIN airports b
ON times_converted.dest = b.faa;

/* 6.2 Use the time zone columns to convert dep_time_f and arr_time_f to UTC and call them dep_time_f_utc and arr_time_f_utc.
 * 	   Calculate the difference of both columns and call it flight_duration_f_utc.
 *     Please provide the query below.
 */

WITH times_converted AS (
	SELECT flight_date,
	       origin,
	       dest,
	       dep_time,
	       MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
	       arr_time,
	       MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
	       actual_elapsed_time,
	       MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
	FROM flights
	),
	flights_and_timezones AS (
  	SELECT	flight_date,
		origin,
		dest,
		dep_time_f,
		MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
		arr_time_f,
		MAKE_INTERVAL(hours => b.tz::INT) AS dest_tz,
		arr_time_f - dep_time_f AS flight_duration_f,
		actual_elapsed_time_f
	FROM times_converted
	JOIN airports a 
	ON times_converted.origin = a.faa
	JOIN airports b
	ON times_converted.dest = b.faa
	)
SELECT 	dep_time_f,
		origin_tz,
		(dep_time_f - origin_tz) AS dep_time_f_utc,
		arr_time_f,
		dest_tz,
		(arr_time_f - dest_tz) AS arr_time_f_utc,
		(arr_time_f - dest_tz) - (dep_time_f - origin_tz) AS flight_duration_f_utc,
		actual_elapsed_time_f
FROM flights_and_timezones;


/* 6.3 Again, calculate the percentage of matching records using the new flight_duration_f_utc column.
 *     Try to round the result to two decimals.
 *     Explain the increase in matching records.
 *     Please provide the query and answer below.
 */

WITH times_converted AS (
	SELECT flight_date,
	       origin,
	       dest,
	       dep_time,
	       MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
	       arr_time,
	       MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
	       actual_elapsed_time,
	       MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
	FROM flights
	),
	flights_and_timezones AS (
  	SELECT	flight_date,
		origin,
		dest,
		dep_time_f,
		MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
		arr_time_f,
		MAKE_INTERVAL(hours => b.tz::INT) AS dest_tz,
		arr_time_f - dep_time_f AS flight_duration_f,
		actual_elapsed_time_f
	FROM times_converted
	JOIN airports a 
	ON times_converted.origin = a.faa
	JOIN airports b
	ON times_converted.dest = b.faa
	),
	flights_selected AS (
	SELECT 	dep_time_f,
			origin_tz,
			(dep_time_f - origin_tz) AS dep_time_f_utc,
			arr_time_f,
			dest_tz,
			(arr_time_f - dest_tz) AS arr_time_f_utc,
			(arr_time_f - dest_tz) - (dep_time_f - origin_tz) AS flight_duration_f_utc,
			actual_elapsed_time_f
	FROM flights_and_timezones
	), 
	compare_times_utc AS (
	SELECT (flight_duration_f_utc = actual_elapsed_time_f) AS comparation
	FROM flights_selected
	)
SELECT ROUND((SUM(comparation::INT)*100.0 / count(*)), 2) AS matching_percentage
FROM compare_times_utc;

--81.35

/* Extra Challenge
 * For the essential part of the SQL challenge, it's ok if you just read through the SQL query.
 * Queries 7.1 and 7.2 are just there to make you aware of the problem...
 * Query 7.3 actual implements a solution. Pay especially attention to the CASE WHEN statement.
 * this is the statement that fixes the issue for overnight flights
 * 7.1 We managed to increase the rate of matching records to >80%, but it's still not at 100%.
 *     Could overnight flights be an issue?
 *     What is special about values in the flight_duration_f_utc column for overnight flights?
 *     Please provide the answer below.
 */

-- Answer: The flight_duration_f_utc is negative for overnight flights
WITH f AS (
	SELECT MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
	         MAKE_INTERVAL(hours => a2.tz::INT) AS dest_tz,
	         MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
	         MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
	         MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
	  FROM flights f
	  LEFT JOIN airports AS a
	         ON f.origin=a.faa
	  LEFT JOIN airports AS a2
	         ON f.dest=a2.faa
	         )
SELECT dep_time_f - origin_tz AS dep_time_f_utc,
	   arr_time_f - dest_tz AS arr_time_f_utc,
	   actual_elapsed_time_f,
	   (arr_time_f - dest_tz) - (dep_time_f - origin_tz) AS flight_duration_f_utc
FROM  f
ORDER BY flight_duration_f_utc;


/* 7.2 Calculate the total number of flights that arrived after midnight UTC.
 *     Please provide the query below.
 */
-- solution using two cte
WITH f AS (
SELECT MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
                   MAKE_INTERVAL(hours => a2.tz::INT) AS dest_tz,
                   MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
                   MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f
            FROM flights f
            LEFT JOIN airports AS a
                   ON f.origin=a.faa
            LEFT JOIN airports AS a2
                   ON f.dest=a2.faa
),
ff AS (
SELECT (arr_time_f - dest_tz) - (dep_time_f - origin_tz) AS flight_duration_f_utc
FROM f
)
SELECT COUNT(*)
FROM ff 
WHERE flight_duration_f_utc < INTERVAL '0';


/* 7.3 Use your knowledge from 7.1 and 7.2 to increase the rate of matching records even further.
 *     Please provide the query below.
 */
-- solution using three ctes

WITH f AS (
SELECT MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
	                     MAKE_INTERVAL(hours => a2.tz::INT) AS dest_tz,
	                     MAKE_TIME((dep_time::INT / 100), (dep_time::INT % 100), 0) AS dep_time_f,
	                     MAKE_TIME((arr_time::INT / 100), (arr_time::INT % 100), 0) AS arr_time_f,
	                     MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
	              FROM flights f
	              LEFT JOIN airports AS a
	                     ON f.origin=a.faa
	              LEFT JOIN airports AS a2
	                     ON f.dest=a2.faa
),
ff AS (
SELECT actual_elapsed_time_f,
       (arr_time_f - dest_tz) - (dep_time_f - origin_tz) AS flight_duration_f_utc
FROM  f
),
fff AS (
SELECT CASE WHEN flight_duration_f_utc < INTERVAL '0'
                  THEN flight_duration_f_utc + INTERVAL '24 hours'
                  ELSE flight_duration_f_utc
             END AS flight_duration_f_utc,
             actual_elapsed_time_f
      FROM  ff
)
SELECT ROUND((SUM((actual_elapsed_time_f = flight_duration_f_utc)::INT) * 1.0/COUNT(*) * 100),2) AS match_percent
FROM  fff;


/*
* ok great! we get a match of 98,77%! We leave it at that for now...
* After this long part of verifying the column actual_elapsed_time we feel confident
* to make analysis based on this column and give out business recommendations.
*
* The flight-scheduling department needs support with their monthly review of scheduled 
* flight durations. Their job is it to define the most accurate flight durations for all
* available routes. It works the following: you have 'scheduled departing time'
* and the flight-scheduling department is in charge of defining the 'scheduled arrival time'. 
* Given these two times, you can calculate the 'scheduled flight duration'.
* The 'scheduled flight duration' is the metric the department wants to review. 
* How accurate is the metric 'scheduled flight duration' compared to the 'actual_elapsed_time'? 
* The team is especially interested if 'scheduled flight duration' is shorter than 'actual_elapsed_time'.
* They want to know which routes have the highest share of flights where 
* the 'scheduled flight duration' is shorter than 'actual_elapsed_time'? 
* and what's the average difference for flights on that route? 
* To make it worthwhile, they focus on routes that had at least 30 flights in January.
* You as an analyst are asked to answer these questions with the help of the available data.
* You are asked to summarize your main findings in a short text.
*/


/*The code below is to select the routes which have over 30 flights in January in descending order
 * Using FMMonth (Fill mode) is to surpress trailing spaces.
 */
SELECT origin, dest, COUNT(*) AS num_flights
FROM flights
WHERE TO_CHAR(flight_date, 'FMMonth') = 'January'
GROUP BY origin, dest
HAVING COUNT(*) > 30
ORDER BY num_flights DESC;

WITH f AS (
			SELECT	flight_date,
					origin,
					dest,
					MAKE_INTERVAL(hours => a.tz::INT) AS origin_tz,
                    MAKE_INTERVAL(hours => a2.tz::INT) AS dest_tz,
                    MAKE_TIME((sched_dep_time::INT / 100), (sched_dep_time::INT % 100), 0) AS sched_dep_time_f,
                    MAKE_TIME((sched_arr_time::INT / 100), (sched_arr_time::INT % 100), 0) AS sched_arr_time_f,
                    MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time_f
              FROM flights f
              LEFT JOIN airports AS a
                     ON f.origin=a.faa
              LEFT JOIN airports AS a2
                     ON f.dest=a2.faa
              WHERE cancelled = 0
			),
	ff AS (
			SELECT	flight_date,
					origin,
					dest,
					actual_elapsed_time_f,
       				(sched_arr_time_f - dest_tz) - (sched_dep_time_f - origin_tz) AS sched_flight_duration_f_utc
			FROM  f
			),
	fff AS (
			SELECT CASE WHEN sched_flight_duration_f_utc < INTERVAL '0'
                  THEN sched_flight_duration_f_utc + INTERVAL '24 hours'
                  ELSE sched_flight_duration_f_utc
	             END AS sched_flight_duration_f_utc,
	             actual_elapsed_time_f,
	             flight_date,
	             origin,
	             dest
      		FROM  ff
		)
SELECT origin, 
		dest, 
		COUNT(*) AS num_flights,
		ROUND((SUM((sched_flight_duration_f_utc < actual_elapsed_time_f)::INT) * 1.0/COUNT(*) * 100),2) AS sched_shorter_than_actual_rate,
		AVG(sched_flight_duration_f_utc - actual_elapsed_time_f)
FROM fff
WHERE TO_CHAR(flight_date, 'FMMonth') = 'January'
GROUP BY origin, dest
HAVING COUNT(*) > 30
ORDER BY sched_shorter_than_actual_rate DESC;






/*Using another method
 * 
 * 1. Cleaning data
 * dep_time is null:	112,026
 * dep_time is null AND (cancelled = 1 or diverted = 1):	112,026
 * arr_time is null:	118,650
 * dep_time is not null and arr_time is null:	6624
 * 118,650 - 112,026 = 6624 matching
 * 
 * dep_time is not null and arr_time is NULL AND cancelled = 1:	4428
 * dep_time is not null and arr_time is NULL AND diverted = 1:	2195
 * arr_time is null AND diverted = 1:	2195
 * dep_time is not null and arr_time is NULL AND (cancelled = 0 AND diverted = 0):	1
 * 118,650 - 2195 = 116,455
 * 
 * cancelled = 1 and diverted = 0:	116,454
 * cancelled = 0 and diverted = 1:	20,248
 * cancelled = 1 and diverted = 1:	0
 * cancelled = 1 or diverted = 1: 136,702
 * actual_elapsed_time is NULL:	136,703
 * 
 * diverted = 1 AND actual_elapsed_time IS NOT NULL:	0, no actual_elapsed_time for diverted flights recorded
 */

SELECT * FROM flights
WHERE actual_elapsed_time is NULL;




/*Now we dont have null value for dep_time and arr_time
 * need to add time zone
 */

SELECT flight_date, dep_time, a.tz AS origin_tz, arr_time, a2.tz AS dest_tz , actual_elapsed_time FROM flights f
JOIN airports a
ON f.origin = a.faa
JOIN airports a2
ON f.origin = a2.faa
WHERE arr_time is NOT NULL;




/*Now it is time to find departure and arrival date and time in UTC
 */

WITH ff AS (
			SELECT flight_date, dep_time, a.tz AS origin_tz, arr_time, a2.tz AS dest_tz , actual_elapsed_time , arr_delay FROM flights f
			JOIN airports a
			ON f.origin = a.faa
			JOIN airports a2
			ON f.dest = a2.faa
			WHERE arr_time is NOT NULL AND actual_elapsed_time IS NOT NULL
			)
SELECT flight_date, dep_time, origin_tz,
	   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
	   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' AS dep_time_utc,
	   arr_time, dest_tz,
	   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
	   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' AS arr_time_utc,
	   MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time
FROM ff;




/* Find the overnight flights
 * Using case when, if dep_time > arr_time, it means it is a overnight flight
 */

WITH ff AS (
			SELECT flight_date, dep_time, a.tz AS origin_tz, arr_time, a2.tz AS dest_tz , actual_elapsed_time , arr_delay FROM flights f
			JOIN airports a
			ON f.origin = a.faa
			JOIN airports a2
			ON f.dest = a2.faa
			WHERE arr_time is NOT NULL AND actual_elapsed_time IS NOT NULL
			),
	fff AS 	(SELECT flight_date, dep_time, origin_tz,
			   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
			   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' AS dep_time_utc,
			   arr_time, dest_tz,
			   CASE WHEN (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
				   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' > 
				   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' 
				   THEN (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' + INTERVAL '1 day'
				   ELSE (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC'
			   END AS arr_time_utc,
			   MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time
			FROM ff
			)
SELECT 	dep_time_utc, 
		arr_time_utc,
		arr_time_utc - dep_time_utc AS flight_duration,
		actual_elapsed_time,
		(arr_time_utc - dep_time_utc) = actual_elapsed_time AS comparation
FROM fff;




/*Calculate the matching rate
 * result
 * num_flights	num_matched	match_percentage
 * 8,369,455	7,968,148	95.21%
 */

WITH ff AS (
			SELECT flight_date, dep_time, a.tz AS origin_tz, arr_time, a2.tz AS dest_tz , actual_elapsed_time , arr_delay FROM flights f
			JOIN airports a
			ON f.origin = a.faa
			JOIN airports a2
			ON f.dest = a2.faa
			WHERE arr_time is NOT NULL AND actual_elapsed_time IS NOT NULL
			),
	fff AS 	(SELECT flight_date, dep_time, origin_tz,
			   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
			   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' AS dep_time_utc,
			   arr_time, dest_tz,
			   CASE WHEN (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
				   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' > 
				   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' 
				   THEN (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' + INTERVAL '1 day'
				   ELSE (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC'
			   END AS arr_time_utc,
			   MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time
			FROM ff
			)
SELECT 	count(*) AS num_flights,
		SUM(((arr_time_utc - dep_time_utc) = actual_elapsed_time)::INT) AS num_matched,
		ROUND(SUM(((arr_time_utc - dep_time_utc) = actual_elapsed_time)::INT)*100.0/count(*), 2) AS match_percentage		
FROM fff;


/*Find unmatched
*
*/

WITH ff AS (
			SELECT flight_date, dep_time, a.tz AS origin_tz, origin, arr_time, a2.tz AS dest_tz , dest, actual_elapsed_time FROM flights f
			JOIN airports a
			ON f.origin = a.faa
			JOIN airports a2
			ON f.dest = a2.faa
			WHERE arr_time is NOT NULL AND actual_elapsed_time IS NOT NULL
			),
	fff AS 	(SELECT flight_date, dep_time, origin_tz,
			   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
			   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' AS dep_time_utc,
			   origin, arr_time, dest_tz,
			   CASE WHEN (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * origin_tz + (dep_time / 100) * INTERVAL '1 hour' 
				   + (dep_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' > 
				   (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' 
				   THEN (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC' + INTERVAL '1 day'
				   ELSE (flight_date AT TIME ZONE 'UTC' - INTERVAL '1 hour' * dest_tz + (arr_time / 100) * INTERVAL '1 hour' + 
				   (arr_time % 100) * INTERVAL '1 minute') AT TIME ZONE 'UTC'
			   END AS arr_time_utc, 
			   dest,
			   MAKE_INTERVAL(mins => actual_elapsed_time::INT) AS actual_elapsed_time
			FROM ff
			)
SELECT 	dep_time_utc, origin, origin_tz,
		arr_time_utc, dest, dest_tz,
		arr_time_utc - dep_time_utc AS flight_duration,
		actual_elapsed_time
FROM fff
WHERE (arr_time_utc - dep_time_utc) <> actual_elapsed_time;

