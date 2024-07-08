
/* Exercise on string functions and data cleaning!
* As a data analyst you will work with customer data in many situations, 
* typical customer data is company or customer name, addresses and email addresses,...
* this is all text data so we can apply SQL string functions for data cleaning and transformation.
* In this exercise we provide you a realistic example dataset and some hands-on exercises how you would clean up such data :-)
*/ 

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