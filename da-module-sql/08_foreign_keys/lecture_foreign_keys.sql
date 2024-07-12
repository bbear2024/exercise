DROP TABLE IF EXISTS students CASCADE;
CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  student_name VARCHAR(255) NOT NULL,
  email TEXT UNIQUE
);

CREATE TABLE students (
  student_id SERIAL,
  student_name VARCHAR(255),
  email TEXT
);

ALTER TABLE students ADD PRIMARY KEY (student_id);
ALTER TABLE students ALTER COLUMN student_name SET NOT NULL;
ALTER TABLE students ADD UNIQUE (email);

/*Adding a foreign key*/

/*ALTER TABLE child_table_name
ADD FOREIGN KEY (child_foreign_key_column_name) REFERENCES parent_table(parent_primary_key_column);
*/

DROP TABLE IF EXISTS enrolments CASCADE;
CREATE TABLE enrolments (
  enrolment_id SERIAL PRIMARY KEY,
  seminar_name VARCHAR(255),
  student_id INT
);

ALTER TABLE enrolments
ADD FOREIGN KEY (student_id) REFERENCES students(student_id);

-- alternative

DROP TABLE IF EXISTS enrolments CASCADE;
CREATE TABLE enrolments (
 enrolment_id SERIAL PRIMARY KEY,
 seminar_name VARCHAR(255), 
 student_id INT REFERENCES students(student_id) -- Option 1
--  ,FOREIGN KEY (student_id) REFERENCES students(student_id) -- Option 2
);

--ALTER TABLE enrolments
--ADD FOREIGN KEY (student_id) REFERENCES students(student_id); -- Option 3

INSERT INTO students (student_name, email)
VALUES 
('Anna', 'anna@gmail.com')
,('Joseph', 'joseph@gmail.com')
,('Scally', 'scally@gmail.com')
,('Liam', 'liam@gmail.com')
,('Elif', 'elif@gmail.com');

INSERT INTO enrolments (seminar_name, student_id)
VALUES 
('science', 2)
,('history', 1)
,('ethics', 2)
,('politics', 1)
,('art', 5)
,('engineering', 4);

SELECT * FROM students;
SELECT * FROM enrolments;

/* INTEGRITY Test */

DROP TABLE students;

UPDATE students 
SET student_id = 6
WHERE student_name = 'Anna';

INSERT INTO enrolments (seminar_name, student_id)
VALUES ('sport', 8);