/* Exercise on joins
 * This file is full of practical exercises that will help you in building up your advanced SQL skills.
 */

/* Warm-up with tables 'life_expectancy' and 'continents'
 */

 /* Q1. Please calculate the average life expectancy for each country. 
 Include the continent of the country and information what's the first and last year considered.
 */ 

  /* Q2. Please calculate the average life expectancy per continent. 
 Which continent has the highest?
 Include the number of country that were considered in your output.
 */ 

   /* Q3. Now we'll look at it from a different angle. 
 We want to understand the global development of the average life expectancy over time.
 Please write a query that answers this questions for us.
 */ 

 /* Let's work with the tables 'airports' and 'flights'
 */

/* Q1.1 Which countries had any departures on the '2021-01-04'?
 *      Please provide the query and answer below.
 */ 


/* Q1.2 Which plane had the most departures?
 *      Please provide the query and answer below.
 */




/* Q1.3 Which country had the most departures?
 *      Please provide the query and answer below.
 */



/* Q1.4 To which city/cities does the airport with the second most arrivals belong?
 *      Please provide the query and answer below.
 */



/* Q2. How many rows are in your result set when you inner join the flights and airports table on faa and origin column?
 * 	   How many rows are in your result set when you left join the flights and airports table on faa and origin column?
 * 	   How many rows are in your result set when you right the flights and airports table on faa and origin column?
 *     How many rows are in your result set when you full join the flights and airports table on faa and origin column?
 * 	   Please explain why the number of rows are different.
 */
 


--> differences in the number of airport codes between flights (origin) and airports (faa)

/* N.B.: if no primary key between tables are available or enough to join two tables, we can add as many keys as necessary in the JOIN.
Example: if we did not have a code to join the airports and flights tables, but only the city name. 
We could run into issues e.g. Paris, France and Paris, Texas in the USA.
Therefore, in that case, we could use 2 keys to distinguish the two.
The requirement would be that both airports and flights table contain a field "city" and a field "country"
See the example below:
*/




/* Q3.1 Filter the data to January 1, 2021 and count all rows for that day so that your result set has two columns: flight_date, total_flights.  
 * 		Repeat this step, but this time only include data from January 2, 2021.
 * 		Combine the two result sets using UNION.
 */


--> UNION combines the distinct results of two or more SELECT statements


/* Q3.2 Rewrite the query above so that you get the same output, but this time you are not allowed to use UNION.
 */



 /* Q4. Which flights had a departure delay of more than 30 minutes?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which day and in which city?   
 * 	    Answer all questions with a single query.
 */



 /* Q5. For each airport get some summary statistics about the flights acitivity:
 *      How many incoming and departing flights per day on average?
 * 	    How many departing flights that are delayed, on_time or too_early per day on average? 
 * 	    How many connecting airports?
 *		Can you come up with some more interesting metrics?
 * 	    Answer all questions with a single query.
 */


