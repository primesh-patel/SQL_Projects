CREATE DATABASE topic_CS_flights_292;
USE topic_CS_flights_292;

CREATE TABLE flights (
    Airline VARCHAR(100),             -- Name of the airline
    Date_of_Journey DATE,             -- Date of the journey
    Source VARCHAR(50),               -- Source location
    Destination VARCHAR(50),          -- Destination location
    Route VARCHAR(255),                       -- Route of the flight
    Dep_Time TIME,                    -- Departure time
    Duration VARCHAR(20),             -- Duration of the flight
    Total_Stops VARCHAR(20),          -- Total stops during the journey
    Price DECIMAL(10, 2)              -- Ticket price
);

SHOW VARIABLES LIKE "local_infile"; -- it must be ON. If it is OFF set global local_infile=1;
SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE 'D:\\sql_projects\\flights_analysis\\flights_cleaned.csv' 
INTO TABLE topic_cs_flights_292.flights
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows
FROM flights;

SET SQL_SAFE_UPDATES = 0;

UPDATE flights
SET Route = REPLACE(Route, '?', '→');

---------------------------------------------------------------------------------------------------------
-- Q1 find the month with the most number of flights
SELECT MONTHNAME(Date_of_Journey) AS monthname, COUNT(*) AS no_of_flights
FROM flights
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY no_of_flights DESC
LIMIT 1;

-- Q2 which week day has most costly flights
SELECT DAYNAME(Date_of_Journey) AS day_of_week, AVG(Price) AS avg_flight_costs
FROM flights
GROUP BY DAYNAME(Date_of_Journey)
ORDER BY avg_flight_costs DESC
LIMIT 1;

-- Q3 find number of indigo flights every months
SELECT MONTHNAME(Date_of_Journey) AS month_name, COUNT(*) AS total_flights
FROM flights
WHERE Airline = 'Indigo'
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY MONTH(total_flights);

-- Q4 find list of all flights that depart between 10AM and 2PM from DELHI to BANGLORE
SELECT *
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi' 
AND Dep_Time BETWEEN '10:00:00' AND '14:00:00';

-- Q5 find all flights list departing on weekends from Banglore
SELECT *, DAYNAME(Date_of_Journey) AS weekends
FROM flights
WHERE Source = 'Banglore' AND
DAYNAME(Date_of_Journey) IN ('Saturday', 'Sunday');

-- Q6 calculate the arrival time for all flights by adding the duration to the departure time
ALTER TABLE flights ADD COLUMN departure DATETIME;

UPDATE flights
SET departure = STR_TO_DATE(CONCAT(Date_of_Journey, ' ', Dep_Time), '%Y-%m-%d %H:%i:%s');

-- Q7 calculate the arrival date for all flights
ALTER TABLE flights
ADD COLUMN duration_mins INTEGER,
ADD COLUMN arrival DATETIME;

ALTER TABLE flights DROP COLUMN duration_mins;

UPDATE flights
SET arrival = DATE_ADD(departure, INTERVAL Duration MINUTE);

-- Q8 find the number the flights which travel on multiple dates
SELECT COUNT(*) AS no_flights_mltpl_dates
FROM flights
WHERE DATE(departure) != DATE(arrival);

-- Q9 calculate the average duration of flights between all city pairs
SELECT Source, Destination, AVG(Duration) AS avg_duration_bw_city
FROM flights
GROUP BY Source, Destination;
# OR
SELECT Source, Destination, 
CONCAT(FLOOR(AVG(Duration) / 60), 'h ', ROUND(AVG(Duration) % 60), 'm') AS avg_duration
FROM flights
GROUP BY Source, Destination;

SELECT Source, Destination,
       TIME_FORMAT(SEC_TO_TIME(AVG(Duration) * 60), '%kh %im') AS avg_duration
FROM flights
GROUP BY Source, Destination;

-- Q10 find all flights which departed before midnight but arrived at their destination after midnight
-- having only 0 stop
SELECT *
FROM flights
WHERE Total_Stops = 'non-stop' AND
DATE(departure) < DATE(arrival);

-- Q11 find quarter wise number of flights for each airline
SELECT QUARTER(departure) AS quarter_no, Airline, COUNT(*) AS no_of_flights
FROM flights
GROUP BY Airline, quarter_no;

-- Q12: Find the flight with the longest time duration
SELECT Source, Destination, Duration AS max_time
FROM flights
ORDER BY Duration DESC
LIMIT 1;

-- Q13 average time duration for flights that have 1 stop vs more than 1 stops
WITH temp_table AS (
    SELECT *,
    CASE
        WHEN Total_Stops = 'non-stop' THEN 'non-stop'
        ELSE 'with-stop'
    END AS temp
    FROM flights
)

SELECT temp, 
       TIME_FORMAT(SEC_TO_TIME(AVG(Duration) * 60), '%kh %im') AS avg_duration
FROM temp_table
GROUP BY temp;

-- Q14 find all Air india flights in a given date(1st Mar 2019 To 10th Mar 2019) range originating from delhi
SELECT *
FROM flights
WHERE departure BETWEEN '2019-03-01' AND '2019-03-10' AND
Airline = 'Air India';

-- Q15 find the longest flight of each airline
SELECT Airline, TIME_FORMAT(SEC_TO_TIME(MAX(duration)*60), '%kh %im') AS longest_flight
FROM flights
GROUP BY Airline
ORDER BY longest_flight DESC;

-- Q16: Find all pairs of cities having average time duration > 3 hours
SELECT Source, Destination, 
       TIME_FORMAT(SEC_TO_TIME(AVG(Duration) * 60), '%kh') AS avg_time_duration
FROM flights
GROUP BY Source, Destination
HAVING AVG(Duration) > 180; -- 3 hours = 180 minutes

-- Q17 make a weekday vs time grid showing frquancy of flights from banglore and delhi
-- You can modify your MySQL server settings to turn off ONLY_FULL_GROUP_BY. Here's how:

-- Check the current SQL mode:
SELECT @@GLOBAL.sql_mode;

-- if you want to apply it only for the session:
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

-- Remove ONLY_FULL_GROUP_BY from the SQL mode:
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';


SELECT 
    DAYNAME(departure) AS day_name,
    SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM-6AM',
    SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM-12PM',
    SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM-6PM',
    SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM-12PM'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;

-- Q18 make a weekday vs time grid showing avg flight price from Banglore and Delhi
SELECT 
    DAYNAME(departure) AS day_name,
    AVG(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN Price ELSE NULL END) AS '12AM-6AM',
    AVG(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN Price ELSE NULL END) AS '6AM-12PM',
    AVG(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN Price ELSE NULL END) AS '12PM-6PM',
    AVG(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN Price ELSE NULL END) AS '6PM-12PM'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;
