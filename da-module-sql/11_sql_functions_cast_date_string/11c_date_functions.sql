/* Date/Time Functions
 * In this file you will find Date/Time functions that are already hard coded into postgreSQL.
 * Make sure to understand what each function takes as input, what happens to the input and what output is returned.
 * Syntax: function(input type) -> return type: definition
 * dp = double precision
 * More info about Date/Time functions: https://www.postgresql.org/docs/current/functions-datetime.html
 */

/* Current dates & times
 * PostgreSQL provides a number of functions that return current timestamps, dates or times.
 * 1. Use CURRENT_TIMESTAMP or NOW() if you want the current timestamp with time zone
 * 3. Use CURRENT_DATE if you want the current date
 */
 
SELECT NOW() AS timestamp_with_time_zone;
SELECT CURRENT_TIMESTAMP AS curr_timestamp_with_time_zone;
SELECT CURRENT_DATE AS curr_date_without_time_zone;

/* Date/Time creation
 * 1. make_date(year int, month int, day int) -> date: Create date from year, month and day fields
 * 2. make_interval(years int DEFAULT 0, months int DEFAULT 0, weeks int DEFAULT 0, days int DEFAULT 0, 
 * hours int DEFAULT 0, mins int DEFAULT 0, secs double precision DEFAULT 0.0) -> interval: Create interval 
 * from years, months, weeks, days, hours, minutes and seconds fields
 */

SELECT MAKE_DATE(2021, 1, 1) AS new_date;
SELECT MAKE_INTERVAL(years => 10) AS ten_years_interval;
SELECT MAKE_INTERVAL(months => 10) AS ten_months_interval;
SELECT MAKE_INTERVAL(weeks => 10) AS ten_weeks_interval;
SELECT MAKE_INTERVAL(days => 10) AS ten_days_interval;
SELECT MAKE_INTERVAL(mins => 10) AS ten_mins_interval;

-- this function will fail if you provide a column that is not of type INT. Use cast to fix this.
-- this will fail because actual_elapsed_time is of type float/ double 
SELECT MAKE_INTERVAL(mins => actual_elapsed_time) AS ten_mins_interval from flights;
-- this will work
SELECT MAKE_INTERVAL(mins => CAST(actual_elapsed_time AS INT)) AS ten_mins_interval from flights;


/* Date/Time extraction
 * 1. a) extract(field from timestamp) -> double precision: Get subfield
 * 	  b) extract(field from interval) -> double precision: Get subfield
 * 2. a) date_part(text, timestamp) -> double precision: Get subfield (equivalent to extract)
 *    b) date_part(text, interval) -> double precision: Get subfield (equivalent to extract)
 * A full list of accepted values for field/text can be found here: 
 * https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT
 * Both functions are the same. The extract function complies with SQL standard, 
 * while date_part is as Postgres specific function.
 */

SELECT EXTRACT(DAY FROM TIMESTAMP '2021-01-01 10:30:00') AS extract_day;
SELECT EXTRACT(WEEK FROM TIMESTAMP '2021-01-01 10:30:00') AS extract_week;
SELECT EXTRACT(YEAR FROM TIMESTAMP '2021-01-01 10:30:00') AS extract_year;
SELECT EXTRACT(ISOYEAR FROM TIMESTAMP '2021-01-01 10:30:00') AS extract_isoyear;
SELECT EXTRACT(EPOCH FROM MAKE_TIMESTAMP(2021, 1, 1, 10, 30, 0)) AS from_timestamp_to_unix; -- Use this to convert to UNIX time

SELECT DATE_PART('day', TIMESTAMP '2021-01-01 10:30:00') AS extract_day;
SELECT DATE_PART('week', TIMESTAMP '2021-01-01 10:30:00') AS extract_week;
SELECT DATE_PART('year', TIMESTAMP '2021-01-01 10:30:00') AS extract_year;
SELECT DATE_PART('isoyear', TIMESTAMP '2021-01-01 10:30:00') AS extract_isoyear;

/* Date/Time truncation
 * a) date_trunc(text, timestamp) -> timestamp: Truncate to specified precision
 * b) date_trunc(text, timestamp with time zone, text) -> timestamp with time zone: 
 * Truncate to specified precision in the specified time zone
 * c) date_trunc(text, interval) -> interval: Truncate to specified precision
 * A full list of accepted values for text can be found here: 
 * https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-TRUNC
 */

SELECT DATE_TRUNC('decade', TIMESTAMP '2021-06-27 10:30:00') AS trunc_decade;
SELECT DATE_TRUNC('quarter', TIMESTAMP '2021-06-27 10:30:00') AS trunc_quarter;
SELECT DATE_TRUNC('year', TIMESTAMP '2021-06-27 10:30:00') AS trunc_year;
SELECT DATE_TRUNC('week', TIMESTAMP '2021-06-27 10:30:00') AS trunc_week;
SELECT DATE_TRUNC('hour', TIMESTAMP '2021-06-27 10:30:00') AS trunc_hour;

/* Date/Time arithmetic operations
 * 1. date + integer -> date: Add a number of days to a date
 * 2. date + interval -> timestamp: Add an interval to a date
 * 3. date + time -> timestamp: Add a time-of-day to a date
 * 4. interval + interval -> interval: Add intervals
 * 5. timestamp + interval -> timestamp: Add an interval to a timestamp
 * 6. time + interval -> time: Add an interval to a time
 * 7. - interval -> interval: Negate an interval
 * 8. date - date -> integer: Subtract dates, producing the number of days elapsed
 * 9. date - integer -> date: Subtract a number of days from a date
 * 10. date - interval -> timestamp: Subtract an interval from a date
 * 11. time - time -> interval: Subtract times
 * 12. time - interval -> time: Subtract an interval from a time
 * 13. timestamp - interval -> timestamp: Subtract an interval from a timestamp
 * 14. interval - interval -> interval: Subtract intervals
 * 15. timestamp - timestamp -> interval: Subtract timestamps (converting 24-hour intervals into days
 */

-- 1
SELECT DATE '2021-01-01' + 7;
-- 2
SELECT DATE '2021-01-01' + INTERVAL '7 hour';
-- 3
SELECT DATE '2021-01-01' + TIME '07:00';
-- 4
SELECT INTERVAL '7 day' + INTERVAL '7 hour';
-- 5
SELECT TIMESTAMP '2021-01-01 07:00' + INTERVAL '7 hour';
-- 6
SELECT TIME '07:00' + INTERVAL '77 hour';
-- 7
SELECT - INTERVAL '7 hour';
-- 8
SELECT DATE '2021-01-01' - DATE '2020-12-25';
-- 9
SELECT DATE '2021-01-01' - 7;
-- 10
SELECT DATE '2021-01-01' - INTERVAL '7 hour';
-- 11
SELECT TIME '07:00' - TIME '07:00' AS substract_times;
-- 12
SELECT TIME '07:00' - INTERVAL '7 minute' ;
-- 13
SELECT TIMESTAMP '2021-01-01 07:00' - INTERVAL '7 hour';
-- 14
SELECT INTERVAL '7 day 7 hour' - INTERVAL '7 hour';
-- 15
SELECT TIMESTAMP '2021-01-31 07:00' - TIMESTAMP '2021-01-01 07:00';

