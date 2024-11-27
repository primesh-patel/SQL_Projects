USE hospital;

-- 1) Write a query in SQL to find all the information of the nurses who are yet to be registered. 
SELECT * FROM nurse
WHERE registered = 'f';

-- 2) Write a query in SQL to find the name of the nurse who are the head of their department.
SELECT * FROM nurse
WHERE position = 'Head Nurse';

-- 3) Write a query in SQL to obtain the name of the physicians who are the head of each department.
SELECT p.name, d.name AS department FROM physician p
INNER JOIN department d
ON p.employeeid = d.head;


-- 4)Write a query in SQL to count the number of patients who taken appointment with at least one physician.
SELECT COUNT(DISTINCT (patient)) AS patient_count
FROM appointment;

-- 5)Write a query in SQL to find the floor and block where the room number 212 belongs to.
SELECT blockfloor,blockcode,roomnumber
FROM room
WHERE roomnumber=212;

-- 6)Write a query in SQL to count the number unavailable rooms
SELECT count(unavailable) AS unavailable_rooms
FROM room
WHERE unavailable='t';

-- 7)Write a query in SQL to count the number of available rooms.
WITH avlbl AS
(SELECT COUNT(unavailable) AS available_rooms
FROM room
WHERE unavailable='f'
)
SELECT * FROM avlbl;

-- 8)Write a query in SQL to obtain the name of the physician and the departments they are affiliated with.
SELECT p.name AS physician_name, d.name AS department_name
FROM physician p
INNER JOIN affiliated_with a
ON p.employeeid = a.physician
INNER JOIN department d
ON a.department = d.department_id
WHERE primaryaffiliation = 't';

-- 9)Write a query in SQL to obtain the name of the physicians who are trained for a special treatement.
SELECT employeeid, name 
FROM physician
WHERE employeeid IN (SELECT DISTINCT(physician)
FROM trained_in);

-- 10)Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated.
SELECT p.name AS physician_name,d.name AS department_name
FROM physician p
INNER JOIN affiliated_with aw
ON p.employeeid = aw.physician
INNER JOIN department d
ON aw.department = d.department_id
WHERE primaryaffiliation = 'f';

-- 11)Write a query in SQL to obtain the name of the physicians who are not a specialized physician.
SELECT employeeid, name AS not_trained_physician
FROM physician
WHERE employeeid NOT IN (SELECT DISTINCT(physician)
FROM trained_in);

-- 12)Write a query in SQL to obtain the name of the patients with their physicians by whom they got their preliminary treatement.
SELECT p.name AS patient_name, ph.name AS phy_who_did_pri_treatment
FROM patient p
INNER JOIN physician ph
ON p.pcp = ph.employeeid;

-- 13)Write a query in SQL to find the name of the patients and the number of physicians they have taken appointment.
SELECT p.name AS patient_name, COUNT(DISTINCT physician) AS no_of_phy_tkn_apmnt_frm
FROM patient p
INNER JOIN appointment a
ON p.ssn = a.patient
GROUP BY p.name;

-- 14)Write a query in SQL to count number of unique patients who got an appointment for examination room C.
SELECT examinationroom, COUNT(DISTINCT patient)
FROM appointment
GROUP BY examinationroom
HAVING examinationroom='C';

-- --15 Write a query in SQL to find the name of the patients and the number of the room where they have to go for their treatment
SELECT p.name AS patient_name, s.room AS room_number
FROM patient p
INNER JOIN stay s
ON p.ssn = s.patient
INNER JOIN room r
ON s.room = r.roomnumber;

-- 16)Write a query in SQL to find the name of the nurses and the room scheduled, where they will assist the physicians.
SELECT n.name AS nurse_name, u.physicianassit AS physician_assisted, s.room AS patient_room
FROM nurse n
INNER JOIN undergoes u
ON n.employeeid = u.ingnurse
INNER JOIN stay s
ON s.stayid = u.stay;

-- 17)Write a query in SQL to find the name of the patients who taken the appointment on the 25th of April at 10 am, and also display their physician, assisting nurses and room no.
SELECT 
    p.name AS patient_name,
    ph.name AS physician_name,
    n.name AS nurse_name,
    a.examinationroom
FROM patient p
LEFT OUTER JOIN appointment a
    ON p.ssn = a.patient
LEFT OUTER JOIN physician ph
    ON a.physician = ph.employeeid
LEFT OUTER JOIN nurse n
    ON a.prepnurse = n.employeeid
WHERE a.start_dt = '25/4/2008';

-- 18)Write a query in SQL to find the name of patients and their physicians who does not require any assistance of a nurse.
SELECT 
    p.name AS patient_name,
    ph.name AS physician_name
FROM 
    patient p
INNER JOIN 
    undergoes u ON p.ssn = u.patient
INNER JOIN 
    physician ph ON u.physicianassit = ph.employeeid
WHERE 
    u.ingnurse IS NULL;

-- 19)Write a query in SQL to find the name of the patients, their treating physicians and medication
SELECT 
    p.ssn,
    p.name AS patient_name,
    ph.name AS treating_phy_name,
    m.name AS medicine_name
FROM 
    patient p
INNER JOIN 
    undergoes u ON p.ssn = u.patient
INNER JOIN 
    prescribes pr ON u.patient = pr.patient
INNER JOIN 
    medication m ON pr.medication = m.code
INNER JOIN 
    physician ph ON pr.physician = ph.employeeid;

-- 20)Write a query in SQL to find the name of the patients who taken an advanced appointment, and also display their physicians and medication.
SELECT 
    p.ssn,
    p.name AS patient_name,
    ph.name AS physician_name,
    m.name AS medicine_name
FROM 
    patient p
LEFT OUTER JOIN 
    appointment a ON p.ssn = a.patient
LEFT OUTER JOIN 
    prescribes pr ON a.patient = pr.patient
LEFT OUTER JOIN 
    physician ph ON pr.physician = ph.employeeid
LEFT OUTER JOIN 
    medication m ON pr.medication = m.code
WHERE 
    a.start_dt > CURRENT_DATE;

-- 21)Write a query in SQL to find the name and medication for those patients who did not take any appointment.

-- 22)Write a query in SQL to count the number of available rooms in each block.  
SELECT blockcode AS block_no, count(*) AS no_of_available_rooms
FROM room
WHERE unavailable='f'
GROUP BY blockcode;

-- 23)Write a query in SQL to count the number of available rooms in each floor.
SELECT blockfloor, COUNT(*) AS available_rooms
FROM room
WHERE unavailable = 'f'
GROUP BY blockfloor;

-- 24)Write a query in SQL to count the number of available rooms for each block in each floor
SELECT blockcode, blockfloor, COUNT(*) AS available_rooms
FROM room
WHERE unavailable = 'f'
GROUP BY blockcode, blockfloor
ORDER BY 1,2;

-- 25)Write a query in SQL to count the number of unavailable rooms for each block in each floor. 
SELECT blockcode, blockfloor, COUNT(*) AS unavailable_rooms
FROM room
WHERE unavailable = 't'
GROUP BY blockcode, blockfloor
ORDER BY 1,2;

-- 26)Write a query in SQL to find out the floor where the maximum no of rooms are available.
SELECT 
    blockfloor, COUNT(unavailable) AS available_room
FROM
    room
WHERE
    unavailable = 'f'
GROUP BY blockfloor
ORDER BY COUNT(unavailable) DESC
LIMIT 0 , 1;

-- 27)Write a query in SQL to find out the floor where the minimum no of rooms are available
SELECT blockfloor, COUNT(*) AS available_rooms
FROM room
WHERE unavailable = 'f'
GROUP BY blockfloor
HAVING COUNT(*) = (
    SELECT MIN(room_count)
    FROM (
        SELECT COUNT(*) AS room_count
        FROM room
        WHERE unavailable = 'f'
        GROUP BY blockfloor
    ) AS subquery
)
ORDER BY blockfloor;

-- 28)Write a query in SQL to obtain the name of the patients, their block, floor, and room number where they are admitted. 
SELECT ssn AS patient_id,
       p.name AS patient_name,
       blockfloor,
       roomnumber
FROM patient p
INNER JOIN stay s
    ON p.ssn = s.patient
INNER JOIN room r
    ON s.room = r.roomnumber
WHERE p.name = 'John Smith';

-- 29)Write a query in SQL to obtain the nurses and the block where they are booked for attending the patients on call.
SELECT employeeid AS nurse_id,
       name AS nurse_name,
       blockcode
FROM nurse n
LEFT JOIN on_call oc
ON n.employeeid = oc.nurse;

-- 30)Write a query in SQL to make a report which will show -
-- a) name of the patient,
-- b) name of the physician who is treating him or her,
-- c) name of the nurse who is attending him or her,
-- d) which treatement is going on to the patient,
-- e) the date of release,
-- f) in which room the patient has admitted and which floor and block the room belongs to respectively.  
SELECT 
    p.name AS patient_name,
    ph.name AS physician_name,
    n.name AS nurse_name,
    m.name AS medication_name, 
    s.end_time AS release_date, 
    r.roomnumber, 
    r.blockfloor, 
    r.blockcode
FROM patient p
INNER JOIN appointment a ON p.ssn = a.patient
INNER JOIN physician ph ON a.physician = ph.employeeid
INNER JOIN nurse n ON a.prepnurse = n.employeeid
INNER JOIN prescribes pr ON p.ssn = pr.patient
INNER JOIN medication m ON pr.medication = m.code
INNER JOIN stay s ON p.ssn = s.patient
INNER JOIN room r ON s.room = r.roomnumber
WHERE s.end_time IS NOT NULL  -- Assuming end_time indicates the release date
ORDER BY p.name;

-- OR
SELECT DISTINCT
    p.name AS patient_name,
    ph.name AS physician_name,
    n.name AS nurse_name,
    m.name AS medication_name,
    s.end_time AS release_date,
    r.roomnumber,
    r.blockfloor,
    r.blockcode
FROM patient p
INNER JOIN appointment a ON p.ssn = a.patient
INNER JOIN physician ph ON a.physician = ph.employeeid
INNER JOIN nurse n ON a.prepnurse = n.employeeid
INNER JOIN prescribes pr ON p.ssn = pr.patient
INNER JOIN medication m ON pr.medication = m.code
INNER JOIN stay s ON p.ssn = s.patient
INNER JOIN room r ON s.room = r.roomnumber
WHERE s.end_time IS NOT NULL
ORDER BY p.name;

-- 31) Write a SQL query to obtain the names of all the physicians performed a medical procedure but they are not ceritifed to perform.
SELECT ph.name AS physician_name, u.procedures
FROM physician ph
INNER JOIN undergoes u
ON ph.employeeid = u.procedures
LEFT JOIN trained_in ti
ON u.procedures = ti.physician
AND u.procedures = ti.treatment
WHERE treatment IS NULL;

-- 32)Write a query in SQL to obtain the names of all the physicians, their procedure, date when the procedure was carried out and name of the patient on which procedure have been carried out but those physicians are not certified for that procedure.
SELECT p.name AS patient_name, ph.name AS physician_name, date AS date_of_procedure,
       pr.name AS procedure_name, code AS procedure_code
FROM physician ph
INNER JOIN undergoes u
ON ph.employeeid = u.procedures
LEFT JOIN trained_in ti
ON u.procedures = ti.physician
AND u.procedureS = ti.treatment
LEFT JOIN patient p
ON u.patient = p.ssn
LEFT JOIN procedureS pr
ON u.procedureS = pr.code
WHERE treatment IS NULL;

-- 33) Write a query in SQL to obtain the name and position of all physicians who completed a medical procedure with certification after the date of expiration of their certificate.
SELECT employeeid, name AS physician_name, position
FROM physician
WHERE employeeid IN (SELECT u.procedures
                    FROM undergoes u
                    INNER JOIN trained_in ti
                    ON u.procedures = ti.physician
                    WHERE date > certificationexpires);
                    
 --    34) Write a query in SQL to obtain the name of all those physicians who completed a medical procedure with certification after the date of expiration of their certificate, their position, procedure they have done, date of procedure, name of the patient on which the procedure had been applied and the date when the certification expired.                
SELECT employeeid,
       ph.name AS physician_name,
       ph.position,
       pr.name AS procedure_name,
       u.date AS date_of_procedure,
       p.name AS patient_name,
       ti.certificationexpires
FROM physician ph
LEFT JOIN undergoes u
ON ph.employeeid = u.procedures
LEFT JOIN patient p
ON u.patient = p.ssn
LEFT JOIN trained_in ti
ON u.procedureS = ti.treatment
LEFT JOIN procedures pr
ON ti.treatment = pr.code
WHERE date > certificationexpires;

-- 35) Write a query in SQL to obtain the names of all the nurses who have ever been on call for room 122. 
SELECT employeeid, name AS nurse_name
FROM nurse
WHERE employeeid IN (SELECT oc.nurse FROM on_call oc
                                    LEFT JOIN room r
                                    ON oc.blockfloor = r.blockfloor
                                    AND oc.blockcode = r.blockcode
                                    WHERE roomnumber = 122);

-- 36) Write a query in SQL to Obtain the names of all patients who has been prescribed some
-- medication by his/her physician who has carried out primary care and the name of that physician. 
 SELECT p.name AS patient_name,
       ph.name AS physician_name
FROM patient p
LEFT JOIN prescribes pr
ON p.ssn = pr.patient
LEFT JOIN physician ph
ON pr.physician = ph.employeeid
WHERE pcp = pr.physician;

-- 37) Write a query in SQL to obtain the names of all patients who has been undergone a procedure
-- costing more than $5,000 and the name of that physician who has carried out primary care.
SELECT p.ssn, ph.employeeid AS physician_id,
       p.name AS patient_name,
       ph.name AS primary_care_physician      
FROM patient p
INNER JOIN undergoes u
ON p.ssn = u.patient
INNER JOIN procedures pr
ON u.procedureS = pr.code
INNER JOIN physician ph
ON p.pcp = ph.employeeid
WHERE cost > 5000;

-- 38)Write a query in SQL to Obtain the names of all patients who had at least two appointment
-- where the nurse who prepped the appointment was a registered nurse and the physician
-- who has carried out primary care.
SELECT 
    a.patient AS patient_id, 
    p.name AS patient_name, 
    ph.name AS physician_name
FROM 
    patient p
INNER JOIN 
    appointment a ON p.ssn = a.patient
INNER JOIN 
    nurse n ON a.prepnurse = n.employeeid
INNER JOIN 
    physician ph ON p.pcp = ph.employeeid
WHERE 
    registered = 't'
GROUP BY 
    a.patient, p.name, ph.name
HAVING 
    COUNT(start_dt) >= 2;
    
-- 39) Write a query in SQL to Obtain the names of all patients whose primary
-- care is taken by a physician who is not the head of any department and
-- name of that physician along with their primary care physician.
SELECT p.name AS patient_name,
       ph.name AS primary_care_physician_name
FROM patient p
INNER JOIN physician ph
ON p.pcp = ph.employeeid
WHERE p.pcp NOT IN (SELECT head FROM department);
                                   