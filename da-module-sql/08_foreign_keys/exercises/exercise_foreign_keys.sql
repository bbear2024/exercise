CREATE TABLE life_expectancy AS
SELECT * FROM public.life_expectancy; -- Note: the source table is in the schema 'public'

DROP TABLE IF EXISTS regions CASCADE;
CREATE TABLE regions AS
SELECT * FROM public.regions; -- Note: the source table is in the schema 'public'

ALTER TABLE countries ADD PRIMARY KEY (country);
ALTER TABLE regions ADD PRIMARY KEY (country);

ALTER TABLE countries 
ADD FOREIGN KEY (country) REFERENCES regions(country);

ALTER TABLE life_expectancy 
ADD FOREIGN KEY (country) REFERENCES countries(country);

ALTER TABLE countries_selection 
ADD FOREIGN KEY (state) REFERENCES countries(country);

ALTER TABLE life_expectancy 
ADD FOREIGN KEY (country) REFERENCES regions(country);

ALTER TABLE countries_selection 
ADD FOREIGN KEY (state) REFERENCES regions(country);


DROP TABLE IF EXISTS regions;