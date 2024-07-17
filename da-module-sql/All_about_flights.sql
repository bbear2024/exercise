-- the time range of the flight, between 2023-01-01 and 2024-03-31
SELECT min(flight_date),
	max(flight_date) 
FROM flights;

--how many flights in total, 8_506_158
SELECT count(*)
FROM flights;

--how many unique airlines, only 15
SELECT count(DISTINCT airline)
FROM flights;

--show these airlines names, AA, F9, B6, G4, DL, UA, WN, OH, MQ, NK, 9E, HA, OO, AS, YX
SELECT DISTINCT airline
FROM flights; 

--how many unique tail number, 6_056, that means only 6056 airplanes, but fly 8,506,158 times, each fly 1404 times
SELECT count(DISTINCT tail_number)
FROM flights;

--unique tail number for each airline, AA:956, F9:146, B6:306, G4:132, DL:960, UA:961, 
--WN:860, OH:128, MQ:196, NK:228, 9E:154, HA:60, OO:506, AS:251, YX:234
SELECT count(DISTINCT tail_number)
FROM flights
WHERE airline = 'YX';

--which route has the longest distance?   BOS => HNL 5,095 miles
SELECT origin, a.name, a.city, dest, a2.name, a2.city, 
	   ROUND(distance * 1.609) AS distance_km FROM flights f
JOIN airports a 
ON f.origin = a.faa 
JOIN airports a2 
ON f.dest = a2.faa 
ORDER BY distance DESC
LIMIT 1;

--which route has the highest altitude change? ASE => SFO 2379m

SELECT origin, a.name, a.city, a.alt, dest, a2.name, a2.city, a2.alt, 
	   ROUND(ABS(a.alt - a2.alt) / 3.281) AS altitude_change_m FROM flights f
JOIN airports a 
ON f.origin = a.faa 
JOIN airports a2 
ON f.dest = a2.faa 
ORDER BY altitude_change_m DESC
LIMIT 1;

--highest and lowest airport in flights table
--Aspen-Pitkin Co/Sardy Field / Aspen / 7820 ft
--Key West International Airport / Key West / 3 ft

SELECT DISTINCT origin, a.name, a.city, a.alt FROM flights f
JOIN airports a 
ON f.origin = a.faa
ORDER BY alt
LIMIT 1;

/*on which day has the highest number of cancelled flights?
 * ON 2024-01-15 because of winter storm
 * https://www.forbes.com/sites/mollybohannon/2024/01/15/more-than-3700-flight-delays-and-cancellations-monday-as-arctic-blast-linger-in-us/
 * ON 2023-02-01 becuase of ice storm
 * https://www.reuters.com/world/us/airlines-cancel-over-1400-us-flights-ice-storm-hits-multiple-states-2023-02-01/
 * ON 2023-6-26 because of severe thunderstorm across East Coast
 * https://www.forbes.com/sites/mollybohannon/2023/06/26/flight-cancellations-and-delays-cause-gridlock-across-east-coast-6500-flights-affected/
 */


SELECT flight_date, TO_CHAR(flight_date,'Dy'), SUM(cancelled) AS num_cancelled, COUNT(*) AS num_flights 
FROM flights
GROUP BY flight_date
ORDER BY num_cancelled DESC;

