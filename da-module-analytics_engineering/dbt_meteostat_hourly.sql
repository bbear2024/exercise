SELECT * FROM weather_hourly_raw;

SELECT extracted_data -> 'meta'
FROM weather_hourly_raw;

SELECT extracted_data -> 'data' -> 90 -> 'temp',
extracted_data -> 'data' -> 90 -> 'time'
FROM weather_hourly_raw;

SELECT 	airport_code
		,station_id
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'time' AS time
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'temp' AS temp_c
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'dwpt' AS dew_point_c
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'rhum' AS relative_humidity
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'prcp' AS precipitation_mm
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'snow' AS snow_depth_mm
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'wdir' AS wind_direction
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'wspd' AS avg_wind_speed
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'wpgt' AS avg_peakgust
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'pres' AS avg_pressure_hpa
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'tsun' AS sun_minutes
		,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') -> 'coco' AS condition_code
FROM weather_hourly_raw;

/*using CTE
 */

WITH hourly_raw AS (
				SELECT 	airport_code
						,station_id
						,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') AS json_data
				FROM weather_hourly_raw
),
hourly_flattened AS (
					SELECT 	airport_code
							,station_id
							,(json_data ->> 'time')::DATE AS time
							,(json_data ->> 'temp')::NUMERIC AS temp_c
							,(json_data ->> 'dwpt')::NUMERIC AS dew_point_c
							,(json_data ->> 'rhum')::NUMERIC AS relative_humidity
							,(json_data ->> 'prcp')::NUMERIC AS precipitation_mm
							,(json_data ->> 'snow')::NUMERIC::INTEGER AS snow_depth_mm
							,(json_data ->> 'wdir')::NUMERIC::INTEGER AS wind_direction
							,(json_data ->> 'wspd')::NUMERIC AS avg_wind_speed
							,(json_data ->> 'wpgt')::NUMERIC AS avg_peakgust
							,(json_data ->> 'pres')::NUMERIC AS avg_pressure_hpa
							,(json_data ->> 'tsun')::NUMERIC::INTEGER AS sun_minutes
							,(json_data ->> 'coco')::NUMERIC::INTEGER AS condition_code
					FROM hourly_raw
				)
SELECT * FROM hourly_flattened;

    "time": "2023-01-01 00:00:00",
    "temp": 10,
    "dwpt": 10,
    "rhum": 100,
    "prcp": 0.6,
    "snow": null,
    "wdir": 0,
    "wspd": 0,
    "wpgt": null,
    "pres": 1010.8,
    "tsun": null,
    "coco": 7
