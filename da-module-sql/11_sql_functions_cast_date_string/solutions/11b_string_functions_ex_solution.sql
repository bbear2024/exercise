/*
 * 1. We want the customer names in a consistent format.
 * The frist task for this is to bring all initial letters of each word upper case
 * and all following letters lower case.
 * 
 * 2. Hang on! There is one exception. for the special case of 'Gmbh' we want it to be 'GmbH'
 * 
 * 3. Let's move to the email addresses, for later analysis we would like to store the email provider in a seperate column.
 * Please extract the email provider from all email addresses and store it in a new column called 'email_provider'
 * 
 * 4. let's have a look at the address column. First we would like to split street number and street. 
 * Create one column called 'street' that only contains the street information
 * and one column called 'street_number' that stores that street number.
 * 
 * Hint: extracting only street is tricky, either use: 
 * - REGEXP_SPLIT_TO_ARRAY() by splitting the numbers and text and then (assuming numbers come always last)
 * ..take the first element of this array with: (REGEXP_SPLIT_TO_ARRAY())[1]
 * - or use SUBSTRING with a more complex regex that extracts everything besides the numbers.
 *
 * 5. Furthermore, we want all street names to be in a consistent format.
 * For that, please make sure all the different version of street in german (str, Str, strasse, straße, Strasse) are replaced by simply 'street'.
 *
 * 6. Continuing with cleaning the street names...we want all street names and the word street connected without whitespace.
 * Please make sure all street names are in that format.
 *
 * 7. For some customers the address field is empty. Please fill the empty space with the string 'NA' and call the column 'address_final'.
 * Please do so with street and street_number as well and call the columns 'street_final' and 'street_number_final'.
 *
 */

/*
 * Please write the code for exercise in a seperate CTE and call it 'exercise_x'.
 * As some exercises depend on the exercises before, you might have to select from the previous CTE 'exercise_(x-1)' when working on 'exercise_x'. 
 */

/*
 * Solution below
 */

WITH exercise_1 AS (
SELECT email,
country,
address,
INITCAP(customer_name) AS customer_name
FROM messy_customer_data mcd 
),
exercise_2 AS (
SELECT  email,
country,
address,
REPLACE(customer_name,'Gmbh','GmbH') AS customer_name
FROM exercise_1 
),
exercise_3 AS (
SELECT *,
SPLIT_PART(SPLIT_PART(email, '@', 2),'.',1) AS email_provider
FROM messy_customer_data
WHERE customer_name LIKE '%√º%'
),
exercise_4 AS (
SELECT *,
SUBSTRING(address FROM '\d+') AS street_number,
SUBSTRING(address FROM '(\D+|\D+\s\D+)') AS street_option,
(REGEXP_SPLIT_TO_ARRAY(address,'\d+'))[1]  AS street
FROM exercise_3),
exercise_5 AS (
SELECT *,
regexp_replace(street,'(str|Str|strasse|straße|Strasse)','street') AS street_clean
FROM exercise_4
),
exercise_6 AS (
SELECT *,
REGEXP_REPLACE(street_clean,'%\s%','') AS street_final,
TRIM(street_clean,' ') AS street_option
FROM exercise_5),
exercise_7 AS (
SELECT *,
COALESCE(address,'NA') AS address_final,
COALESCE(street,'NA') AS street_final,
COALESCE(street_number, 'NA') AS street_number_final
FROM exercise_6
)
SELECT *
FROM exercise_7


 
/*optional, not sure if needed.
 * make sure that all words are only seperated by one whitespace
 * 
 * filter for all the customer names that have a special letter in their name.
 */



