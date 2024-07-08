/* String Functions
* String functions help us look at and kind of manipulate text and string data.  
* There are a lot of different string functions and we'll show you some of the most commonly used ones. 
 * Make sure to understand what each function takes as input, what happens to the input and what output is returned.
 * Syntax: function(input type) -> return type: definition
 * More info about string functions: https://www.postgresql.org/docs/current/functions-string.html
 */

/* I. String exploration
 * String length
 * 1. char_length(string) or character_length(string) -> int: Number of characters in string
 * 2. a) length(string): Number of characters in string
 * 	  b) length(string bytea, encoding name ): Number of characters in string in the given encoding. The string must be valid in this encoding.
 */
-- Nr 1
SELECT LENGTH('neuefische') AS string_length;

-- Nr 2
/* String filtering
 * starts_with(string, prefix) -> bool: Returns true if string starts with prefix.
 */
SELECT STARTS_WITH('neuefische', 'neu') AS string_position;

/* String concatenation
 * 2. concat(str "any" [, str "any" [, ...] ]) -> text: Concatenate the text representations of all the arguments. NULL arguments are ignored.
 * 3. concat_ws(sep text, str "any" [, str "any" [, ...] ]) -> text: Concatenate all but the first argument with separators. The first argument is used as the separator string. NULL arguments are ignored.
 */
-- Nr 3
SELECT CONCAT('neue', 'fische ', NULL, 2024) AS string_concat;
SELECT CONCAT_WS(' ', 'neue', 'fische', 2024) AS string_concat_ws;

-- Nr 4
SELECT COALESCE('neue', 'fische ', NULL);
SELECT COALESCE(NULL, 'neue', 'fische ');
SELECT COALESCE(NULL, 'neue', 2024);

-- Nr 5
/* III. String cleaning & replacing
 * String reversing
 * reverse(str) -> text: Return reversed string.
 */
SELECT REVERSE('1202 ehcsifeuen') AS string_reversed;

-- Nr 6
/* String letter case
 * 1. lower(string) -> text: Convert string to lower case
 * 2. upper(string) -> text: Convert string to upper case
 * 3. initcap(string) -> text: Convert the first letter of each word to upper case and the rest to lower case. Words are sequences of alphanumeric characters separated by non-alphanumeric characters.
 */
SELECT LOWER('NEUEFISCHE') string_lower;
SELECT UPPER('neuefische') string_upper;
SELECT INITCAP('we LOVE nEUefISCHe') string_initcap;

-- Nr 7
/* String trimming
 * 1. trim([leading | trailing | both] [characters] from string) -> text: Remove the longest string containing only characters from characters (a space by default) from the start, end, or both ends (both is the default) of string
 * 2. ltrim(string text [, characters text]) -> text: Remove the longest string containing only characters from characters (a space by default) from the start of string
 * 3. rtrim(string text [, characters text]) -> text: Remove the longest string containing only characters from characters (a space by default) from the end of string
 * 4. btrim(string text [, characters text]) -> text: Remove the longest string consisting only of characters in characters (a space by default) from the start and end of string
 */
SELECT TRIM(LEADING '.,;' FROM '.;!.neuefische.!;.') AS string_left_trim;
SELECT LTRIM('.;!.neuefische.!;.', '.,;') AS string_left_trim_alt;

SELECT TRIM(TRAILING '.,;' FROM '.;!.neuefische.!;.') AS string_right_trim;
SELECT RTRIM('.;!.neuefische.!;.', '.,;') AS string_right_trim_alt;

SELECT TRIM(BOTH '.,;' FROM '.;!.neuefische.!;.') AS string_both_trim;
SELECT BTRIM('.;!.neuefische.!;.', '.,;') AS string_both_trim_alt;

-- Nr 8
/* String replacing
 * 1. overlay(string placing string from int [for int]) -> text: Replace substring
 * 2. replace(string text, from text, to text) -> text: Replace all occurrences in string of substring from with substring to
 * 3. regexp_replace(string text, pattern text, replacement text [, flags text]) -> text: Replace substring(s) matching a POSIX regular expression.
 */
SELECT OVERLAY('nXXXXXXXXe' PLACING 'eu' FROM 2) AS string_overlay;
SELECT OVERLAY('nXXXXXXXXe' PLACING 'eu' FROM 2 FOR 8) AS string_overlay;
SELECT OVERLAY('nXXXXXXXXe' PLACING 'euefisch' FROM 2) AS string_overlay;

-- Nr 9
/* IV. String extraction
 * Extraction by index
 * 1. left(str text, n int) -> text: Return first n characters in the string. When n is negative, return all but last |n| characters.
 * 2. right(str text, n int) -> text: Return last n characters in the string. When n is negative, return all but first |n| characters.
 * 3. substring(string [from int] [for int]) -> text: Extract substring
 */
SELECT LEFT('neuefische', 4) AS string_from_left;
SELECT RIGHT('neuefische', 6) AS string_from_right;
SELECT SUBSTRING('neuefische' FROM 5 FOR 5) AS string_substring;

-- Nr 10
/* Extraction by splitting
 * split_part(string text, delimiter text, field int) -> text: Split string on delimiter and return the given field (counting from one)
 */
SELECT SPLIT_PART('neue-fische-2021', '-', 3) AS string_split;

-- Nr 10
/* Regular expressions!
explain:

*/

SELECT REGEX_REPLACE('neuefische', 'e', '') AS string_replace;


/* 
Teaching Tips:
it works well to do this code-along as a group work.
post this in slack as task description:
Try to understand the function of your group. use the documentation for that. 
Have alook what parameters the function requires.
after 15 minutes, present the function(s) that were introduced in your part. 
max 5 min per presentation
For the Presentation:
- Show us the documentation of the https://www.postgresql.org/docs/9.1/functions-string.html. especially go through al the parameters the function requires.
- Show us the examples in the script in dbeaver

Ella, XYZ - Group 1
Sascha, XYZ - Group 2
Jeremie,... - Group 3
....
*/
