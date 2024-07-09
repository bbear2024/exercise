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

SELECT *
FROM flights;