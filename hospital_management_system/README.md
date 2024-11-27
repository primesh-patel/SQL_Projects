# Hospital Management System (SQL-based)

## Overview
The **Hospital Management System (HMS)** is a comprehensive database solution designed to streamline and automate hospital operations, enabling healthcare providers to manage patient care, medical staff, room assignments, medication prescriptions, appointments, and medical procedures efficiently. This system helps in centralizing hospital records and ensuring smooth coordination between physicians, nurses, patients, and administrative staff.

The primary goal of this project is to improve operational efficiency, reduce human errors, and ensure seamless access to critical healthcare data. This system can be used by healthcare facilities of varying sizes to manage and monitor day-to-day activities related to patient care, appointments, medication management, and staff assignments.

## Project Purpose
This **Hospital Management System** is designed to:
- **Enhance hospital workflow** by managing various hospital functions such as appointment scheduling, medication prescriptions, and medical procedures.
- **Track patient history and treatment plans**, allowing physicians and nurses to make informed decisions.
- **Manage room and block allocations**, ensuring optimal use of hospital facilities.
- **Monitor nurse and physician schedules**, helping with shift planning and ensuring adequate staff coverage.
- **Simplify hospital administration** by centralizing patient, staff, and medical data in a relational database.

The system aims to ensure:
- **Data integrity** and consistency across all modules.
- **Real-time access** to critical information such as patient medical history, medication records, and staff availability.
- **Improved patient care** through better coordination between departments and staff.

## Project Structure
This database is organized into a series of interrelated tables, each serving a specific function in the hospital ecosystem. The tables and their relationships ensure the effective management of patient, physician, nurse, appointment, and medication information. The system is designed for use in real-world hospital environments where daily operations need to be streamlined and data integrity is critical.

## Tables and Their Descriptions

### 1. **affiliated_with**
This table stores the affiliation details of physicians with different hospital departments.
- **physician**: The physician's ID.
- **department**: Department the physician is affiliated with.
- **primaryaffiliation**: Denotes whether this department is the physician's primary affiliation.

### 2. **appointment**
This table holds details of patient appointments with physicians.
- **appointmentid**: Unique ID for each appointment.
- **patient**: Patient's SSN (Foreign Key referencing `patient.ssn`).
- **prepnurse**: Assigned nurse (Foreign Key referencing `nurse.employeeid`).
- **physician**: Assigned physician (Foreign Key referencing `physician.employeeid`).
- **start_dt**: Appointment start date and time.
- **end_dt**: Appointment end date and time.
- **examinationroom**: Room number assigned for examination (Foreign Key referencing `room.roomnumber`).

### 3. **block**
This table tracks the blocks (floors) in the hospital building.
- **blockfloor**: The floor number in the hospital.
- **blockcode**: Unique code for each block.

### 4. **department**
Stores information about hospital departments.
- **department_id**: Unique department ID.
- **name**: Name of the department (e.g., Cardiology, Pediatrics).
- **head**: Head of the department (Foreign Key referencing `physician.employeeid`).

### 5. **medication**
Contains information about medications available in the hospital.
- **code**: Unique medication code.
- **name**: Name of the medication.
- **brand**: Medication brand.
- **description**: Detailed description of the medication.

### 6. **nurse**
Stores information about the nurses working in the hospital.
- **employeeid**: Unique nurse ID.
- **name**: Nurse's name.
- **position**: Position (e.g., Registered Nurse, Nurse Practitioner).
- **registered**: Nurse's registration status.
- **ssn**: Social Security Number.

### 7. **on_call**
Tracks which nurses are on call and their assigned blocks.
- **nurse**: Nurse ID (Foreign Key referencing `nurse.employeeid`).
- **blockfloor**: Block floor number (Foreign Key referencing `block.blockfloor`).
- **blockcode**: Block code (Foreign Key referencing `block.blockcode`).
- **oncall**: Start date and time for the on-call period.
- **ONCALLEND**: End date and time for the on-call period.

### 8. **patient**
Holds detailed patient information.
- **ssn**: Unique patient SSN (Primary Key).
- **name**: Patient's name.
- **address**: Patient's address.
- **phone**: Patient's phone number.
- **insurenceid**: Patient's insurance ID.
- **pcp**: Primary Care Physician ID (Foreign Key referencing `physician.employeeid`).

### 9. **physician**
Contains details about physicians in the hospital.
- **employeeid**: Unique ID for the physician.
- **name**: Physician's name.
- **position**: Physician's position (e.g., Doctor, Specialist).
- **ssn**: Physician's SSN.

### 10. **prescribes**
Records prescriptions made by physicians to patients.
- **physician**: ID of the prescribing physician (Foreign Key referencing `physician.employeeid`).
- **patient**: ID of the patient receiving the prescription (Foreign Key referencing `patient.ssn`).
- **medication**: Medication prescribed (Foreign Key referencing `medication.code`).
- **date**: Date the medication was prescribed.
- **appointment**: Associated appointment ID (Foreign Key referencing `appointment.appointmentid`).
- **dose**: Prescribed dose.

### 11. **procedures**
Stores information about medical procedures performed in the hospital.
- **code**: Unique procedure code.
- **name**: Name of the procedure.
- **cost**: Cost of performing the procedure.

### 12. **room**
Tracks the availability and details of rooms in the hospital.
- **roomnumber**: Room number (Primary Key).
- **roomtype**: Type of room (e.g., ICU, General).
- **blockfloor**: Block floor (Foreign Key referencing `block.blockfloor`).
- **blockcode**: Block code (Foreign Key referencing `block.blockcode`).
- **unavailable**: Indicates whether the room is unavailable.

### 13. **stay**
Records the stay details of patients in hospital rooms.
- **stayid**: Unique stay ID.
- **patient**: Patient ID (Foreign Key referencing `patient.ssn`).
- **room**: Room assigned to the patient (Foreign Key referencing `room.roomnumber`).
- **start_time**: Time when the patient’s stay began.
- **end_time**: Time when the patient’s stay ended.

### 14. **trained_in**
Keeps track of physician certifications and their specialties.
- **physician**: Physician ID (Foreign Key referencing `physician.employeeid`).
- **treatment**: Treatment the physician is trained in.
- **certificationdate**: Date the physician received certification.
- **certificatioexpiers**: Expiry date of the certification.

### 15. **undergoes**
Records the medical procedures undergone by patients.
- **patient**: Patient ID (Foreign Key referencing `patient.ssn`).
- **procedures**: Procedure code (Foreign Key referencing `procedures.code`).
- **stay**: Stay ID associated with the procedure (Foreign Key referencing `stay.stayid`).
- **date**: Date the procedure was performed.
- **physicianassist**: Physician assisting the procedure (Foreign Key referencing `physician.employeeid`).
- **ingnurse**: Nurse assisting the procedure (Foreign Key referencing `nurse.employeeid`).

## Relationships Between Tables
- **Physician and Department**: A physician can be affiliated with one or more departments.
- **Patient and Appointment**: A patient can have multiple appointments, each associated with a specific physician and nurse.
- **Patient and Stay**: Each patient can have multiple stays, each in different rooms.
- **Physician and Medication**: Physicians prescribe medications to patients.
- **Patient and Procedures**: Patients can undergo multiple procedures during their stay.
- **Nurse and On-Call**: Nurses can be on call for specific blocks of the hospital.

## SQL Queries and Operations
This system allows for several key operations, such as:
- **Scheduling appointments**
- **Assigning physicians and nurses to patients**
- **Managing room allocations and availability**
- **Tracking medication prescriptions**
- **Recording and managing medical procedures**
- **Tracking nurses' on-call shifts**

### Example Queries:
1. **View All Patients Assigned to a Specific Physician**:
   ```sql
   SELECT p.name AS patient_name
   FROM patient p
   JOIN appointment a ON p.ssn = a.patient
   WHERE a.physician = 'Physician001';

