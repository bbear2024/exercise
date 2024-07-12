/* Handling Multi-Step Queries
 *  
 * Occasionally, we encounter situations where retrieving information from a database requires more 
 * than a straightforward query. In robust databases, data is often distributed across multiple 
 * specialized tables. Complex requests may involve multiple tasks such as joining tables, aggregating 
 * data, applying filters, and performing calculations.
 */ 

/* Example Task:
 * For the route ('JFK', 'LAX'), compare the number of daily flights with the maximum of daily flights per month.
 * - filter for ('JFK', 'LAX')
 * - for each day the total number of flights
 * - for each month the maximum of the total daily flights
 * - for each day add the value of the monthly maximum 
 */

/* OBJECTIVES:
 *	 Solve the task with:
 * 		- VIEWs
 * 		- Sub-Queries
 * 		- CTEs
 */

/* 1. Use VIEWs as intermediate steps
 * 
 * A straightforward and efficient approach involves creating a VIEW and then querying its results. 
 * This allows you to break down complex tasks into manageable steps. Simply rinse and repeat this process 
 * for subsequent operations. 
 */

-- 1st VIEW daily_totals
CREATE VIEW daily_totals AS 
	SELECT flight_date,
		   origin, 
		   dest, 
		   COUNT(*) AS flights_per_day 
	FROM flights
	WHERE (origin, dest) = ('JFK', 'LAX')
	--WHERE origin = 'JFK' AND dest ='LAX' --alternative
	GROUP BY flight_date, origin, dest;

-- 2nd VIEW: monthly_totals
CREATE VIEW monthly_totals AS

/* SELECT flight_date,
		DATE_TRUNC('month', flight_date) AS yearmonth
FROM flights
WHERE (origin, dest) = ('JFK', 'LAX');
*/

	SELECT DATE_TRUNC('month', flight_date) AS yearmonth, 
	   origin, 
	   dest, 
	   MAX(flights_per_day) AS max_daily_total_per_month 	
	FROM daily_totals
	GROUP BY yearmonth, origin, dest;

SELECT * FROM monthly_totals;

-- 3rd VIEW: add the maximum to the daily detail
--CREATE VIEW daily_totals_with_max AS
	SELECT f.flight_date,
		   f.origin,
		   f.dest,
		   COUNT(*) AS flights_per_day,
		   MAX(mt.max_daily_total_per_month) AS max_daily_total_per_month
	FROM flights f 
	JOIN monthly_totals mt
	ON DATE_TRUNC('month', f.flight_date) = mt.yearmonth 
		AND f.origin=mt.origin 
		AND f.dest=mt.dest
	GROUP BY flight_date, f.origin, f.dest;

SELECT * FROM daily_totals_with_max;

/* 2. Use SUB-QUERIES 
 * Instead of storing intermediate result sets in VIEWS, the results could be used for the outer-query.
 * 
 * The FROM clause allows you to specify a subquery expression (the inner query) in SQL. The result set 
 * produced by the subquery serves as a new relation on which the outer query is applied. Although it 
 * might seem overwhelming at first, this technique can be quite useful. 
 */

-- Here is the Sub-Query solution for our task:

SELECT 	f.flight_date,
		f.origin, 
		f.dest, 
		COUNT(*) AS flights_per_day,
		MAX(max_daily_flights) AS max_daily_flights
FROM flights f
JOIN (
	SELECT 	origin, 
			dest,
			DATE_TRUNC('month', flight_date) AS yearmonth,
			MAX(flights_per_day) AS max_daily_flights
	FROM (
		SELECT flight_date,
				   origin, 
				   dest, 
				   COUNT(*) AS flights_per_day 
		FROM flights
		WHERE (origin, dest) = ('JFK', 'LAX')
			--WHERE origin = 'JFK' AND dest ='LAX' --alternative
		GROUP BY flight_date, origin, dest
		) dt
	GROUP BY yearmonth, origin, dest
	) mt
ON DATE_TRUNC('month', flight_date) = yearmonth AND f.origin = mt.origin AND f.dest = mt.dest
WHERE (f.origin, f.dest) = ('JFK', 'LAX')
GROUP BY f.flight_date, f.origin, f.dest


-- Subqueries can be used in various clauses within SQL statements: SELECT, FROM, WHERE, HAVING, INSERT, UPDATE, DELETE

/* 3. Use CTEs
 * Common Table Expressions allow you to create **temporary *named* result sets** from a simple query. 
 * You can then use these result sets in subsequent statements of the query. CTEs act as virtual tables, 
 * created during the execution of a query, used by the query, and eliminated after query execution.
 */

/* In this lecture we are going to focus on the none-recursive type of Common Table Expressions.
 * 
 * ## Syntax
 * Common Table Expressions start with the `WITH` statement, followed by the `Expression Name`, the name 
 * for a `SELECT Statement` inside parantesis, which is the content of a single CTE. You can define one or 
 * more common table expressions in this fashion. 
 * The CTEs construct ends with a **final query** that will give us our result output.

		WITH my_cte AS (
		                SELECT column1,
		                       column2,
		                       column3,
		                FROM table_name
		               )               
		SELECT * FROM my_cte;
 
 */

-- Here is the CTE solution for our task:

WITH daily_flights AS (
    SELECT flight_date,
    	   LEFT(flight_date::TEXT, 7) AS yearmonth,
		   origin, 
		   dest, 
		   COUNT(*) AS flights_per_day 
	FROM flights
	WHERE (origin, dest) = ('JFK', 'LAX')
	GROUP BY flight_date, origin, dest
),
monthly_flights AS (
    SELECT yearmonth, 
		   origin, 
		   dest, 
		   MAX(flights_per_day) monthly_max_flights_per_day
	FROM daily_flights
	GROUP BY yearmonth, origin, dest
)
SELECT
    flight_date,
    --TO_CHAR(flight_date, 'Day') AS weekday,
	origin,
	dest,
	flights_per_day,
	monthly_max_flights_per_day
FROM daily_flights d
JOIN monthly_flights m
USING (yearmonth, origin, dest)
ORDER BY flight_date, origin, dest;


--CTE examples
--generate number serials
WITH RECURSIVE cte_count AS (
	SELECT 1 AS n
	UNION ALL --UNION ALL remove duplicates
	SELECT n + 1
	FROM cte_count
	WHERE n < 50
	)
SELECT * FROM cte_count;

WITH RECURSIVE first_dates AS (
	SELECT DATE('2024-01-01') AS first_day
	UNION ALL
	SELECT DATE(first_day + INTERVAL '1 Month')
	FROM first_dates
	WHERE first_day < DATE('2025-01-01')
	)
SELECT * FROM first_dates;
