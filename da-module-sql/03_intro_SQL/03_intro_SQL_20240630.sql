/* 
 * Welcome to Introduction to SQL!
 * This document includes practical examples of all basic SQL commands you will learn in this lecture.

 * How to use this file:
 * This file includes practical examples already pre-coded for you.
 * They will show you how they can be applied in reality and how the output changes based on each SQL command.
 * To execute an example simply click anywhere in the query and press 'Ctrl + ENTER' simultaneously.
 * This shortcut will execute the SQL statement and return the output below as a table, also called "result set".

 * The lecture will cover a lot of SQL commands, but don't worry we have a lot of practical exercises prepared for you.
 * With the exercises you will build up your SQL skills in no time! 
 */ 


-- 1. Your first SQL query
/* The SQL operation that is most often performed is querying of data. 
 * The SELECT statement is used to select a specific query of data from a database. 
 * The data returned is stored in a result table, called the result-set.
 * SELECT * (aka 'star') stands for "select all columns" 
 */
SELECT * FROM airports;

-- try it with another table e.g. 'flights':
SELECT * FROM flights;

-- 2. SELECT specific columns from the table 'airports'
/* Instead of the *, you select the name of the column to select.
 */
SELECT name
FROM airports;

-- try it with another column:
SELECT city
FROM airports;

-- To select multiple columns from a table, simply separate the column names with commas
SELECT faa,
	   name,
	   city,
	   country
FROM airports;

-- try changing the order of columns, or select same column twice:
SELECT city,
	   name,
	   faa,
	   country,
	   name
FROM airports;

-- 4. LIMIT the output 
/* For example we can limit our result to the first 15 rows and all columns from a table 
 */
SELECT *
FROM airports
LIMIT 15;

-- try it with 'flights', e.g. limit it to 1:
SELECT *
FROM flights
LIMIT 1;

-- 5. ORDER BY - Sorting Data
/* The ORDER BY command is used to sort the result set in ascending or descending order.
 * we can also sort by a primary column and a secondary column (or more)
 */
SELECT name, 
	   city, 
	   country
FROM airports
ORDER BY country ASC, city DESC;

-- try it with the table 'life_expectancy' order it by the column 'life_expectancy'
-- how could you find the top 5 life_expectancy values?:
SELECT *
FROM life_expectancy
ORDER BY life_expectancy DESC
LIMIT 5;

SELECT *
FROM life_expectancy
ORDER BY life_expectancy DESC
OFFSET 2
LIMIT 5;


-- 6. SELECT DISTINCT (unique)
/* If we order the table airports by 'country'
 * we can see that that most country names appear multiple times.
 */ 
SELECT *
FROM airports
ORDER BY country;

/* To find unique values in a column we need to add DISTINCT before the column name.
 * This time we get only unique country names.
 */ 
SELECT DISTINCT country
FROM airports
ORDER BY country
  
-- try finding unique airlines in the table 'flights':
SELECT DISTINCT airline
FROM flights;

-- 7. Forming the result set
/* In a SELECT statement, we shape the output — the result table. 
 * The comma-separated elements can represent columns from a source table, 
 * or they can be new columns derived from calculations or value modifications.
 * 
 * It’s all about defining what information we want to see in the final result!
 */

-- check out the output of this query
SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
ORDER BY alt;


/* try: NOT selecting the column 'name' 
 * also add two columns with some repeating text and a calculation of altitude from feet to meters:
		UPPER(country),
		'anything',
	 	alt / 3.28084
 */ 
SELECT name, 
	   city, 
	   country,
	   -- alt
	   UPPER(country),
	   alt / 3.28084
FROM airports
ORDER BY alt;

-- 8. Aliasing column names
/* you can change names of columns (aliasing) by adding them with an AS keyword

-- try changing to: 
		UPPER(country) as country_caps,
		'anything' AS random_text,
		alt AS alt_ft,
		alt / 3.28084 AS alt_m	   
*/
SELECT name, 
	   city, 
	   country,
	   alt AS alt_ft,
	   'anything' AS random_text,
	   UPPER(country) AS country_caps,
	   alt / 3.28084 AS alt_m
FROM airports
ORDER BY alt;

--9. Documenting Code
/* Adding comments or disabling parts of your query for tests (commenting-out).
*/

	-- This is a Single-line comment
	
	/* This is a Multi-line
	 * Comment
	 * and one more line... click here and hit ENTER
	*/

/* It is quite handy to put comma in front of the selected items
 * So it will not cause an error when the last element is commented out
 */
SELECT faa
	   ,name
--	   ,city
	   ,country
FROM airports
ORDER BY faa;

-- try commenting out 'country' and the order by clause in the above query. 


/* 10. To sum up: 
 * In a SELECT statement, we shape the output — the result table.
 * Note: The output of a SELECT statement is temporary and not persistent, no physical table is saved yet.
 * 
 * Some of the main elements of a SQL query follow that syntax order:

	SELECT columns
	FROM table
	WHERE condition -- will be covered in the next lecture 'filtering'
	ORDER BY column ASC|DESC
	LIMIT number;
 
 *
 */






