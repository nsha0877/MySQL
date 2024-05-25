-- create databse
CREATE DATABASE HealthData;
USE HealthData;

-- insert tables

-- table for Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    contact_info VARCHAR(255)
);

-- table for ClinicalTrials
CREATE TABLE ClinicalTrials (
    trial_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    description TEXT
);

-- table for Treatments
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT
);

-- table for PatientTreatments
CREATE TABLE PatientTreatments (
    patient_id INT,
    treatment_id INT,
    date DATE,
    outcome_id INT,
    PRIMARY KEY (patient_id, treatment_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id),
    FOREIGN KEY (outcome_id) REFERENCES Outcomes(outcome_id)
);

-- table for Outcomes
CREATE TABLE Outcomes (
    outcome_id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT
);

-- insert data

-- insert patient data
INSERT INTO Patients (first_name, last_name, dob, gender, contact_info) VALUES
('Alice', 'Wong', '1990-11-15', 'Female', '555-2345'),
('Bob', 'Johnson', '1983-05-11', 'Male', '555-7890'),
('Clara', 'Lopez', '1975-03-30', 'Female', '555-4567'),
('David', 'Yang', '1988-02-09', 'Male', '555-6789');

-- insert Clinical Trials Data
INSERT INTO ClinicalTrials (name, start_date, end_date, description) VALUES
('Cardiovascular Study', '2023-01-01', '2023-12-31', 'A year-long study on the effects of a new heart medication.'),
('Diabetes Treatment Trial', '2023-03-15', '2024-03-14', 'Exploring the efficacy of a new diabetic treatment regimen.'),
('Cancer Research Phase II', '2023-05-01', '2023-11-01', 'Second phase of a study focusing on a promising cancer therapy.');

-- insert Treatment Data
INSERT INTO Treatments (name, description) VALUES
('Chemotherapy', 'A type of cancer treatment that uses one or more anti-cancer drugs.'),
('Insulin Therapy', 'Treatment of diabetes by administration of insulin.'),
('Rehabilitation', 'Programs aimed at improving patient mobility and recovery post-surgery.');

-- insert Outcomes
INSERT INTO Outcomes (description) VALUES
('Improved'), ('Unchanged'), ('Worsened');

-- Assuming outcome_id values are 1=Improved, 2=Unchanged, 3=Worsened
INSERT INTO PatientTreatments (patient_id, treatment_id, date, outcome_id) VALUES
(1, 1, '2024-04-01', 1),
(2, 2, '2024-04-02', 2),
(3, 3, '2024-04-03', 3),
(4, 1, '2024-04-04', 2),
(1, 3, '2024-04-05', 1),
(2, 1, '2024-04-06', 3);

-- Additional treatments for the same patients
INSERT INTO PatientTreatments (patient_id, treatment_id, date, outcome_id) VALUES
(3, 1, '2024-04-07', 1),
(4, 2, '2024-04-08', 2),
(1, 2, '2024-04-09', 3),
(2, 3, '2024-04-10', 1);

-- create queries

-- list all treatments received by each patient
SELECT 
    p.first_name, 
    p.last_name, 
    t.name AS treatment_name, 
    o.description AS outcome
FROM Patients p
JOIN PatientTreatments pt ON p.patient_id = pt.patient_id
JOIN Treatments t ON pt.treatment_id = t.treatment_id
JOIN Outcomes o ON pt.outcome_id = o.outcome_id
ORDER BY p.last_name, p.first_name;

-- count of each treatment outcome for a specific treatment
SELECT 
    t.name AS treatment_name, 
    o.description AS outcome, 
    COUNT(*) AS outcome_count
FROM Treatments t
JOIN PatientTreatments pt ON t.treatment_id = pt.treatment_id
JOIN Outcomes o ON pt.outcome_id = o.outcome_id
WHERE t.name = 'Chemotherapy'  -- Example for Chemotherapy
GROUP BY t.name, o.description
ORDER BY outcome_count DESC;

-- patients who received more than one type of treatment
SELECT 
    p.first_name, 
    p.last_name,
    COUNT(DISTINCT pt.treatment_id) AS number_of_treatments
FROM Patients p
JOIN PatientTreatments pt ON p.patient_id = pt.patient_id
GROUP BY p.patient_id
HAVING number_of_treatments > 1;

-- average cost of each treatment, assuming cost data

-- add cost to treatments table 
ALTER TABLE Treatments ADD cost DECIMAL(10, 2);

-- query
SELECT 
    t.name AS treatment_name, 
    AVG(t.cost) AS average_cost
FROM Treatments t
GROUP BY t.name;

-- list treatments and their outcomes within a specific time frame
SELECT 
    t.name AS treatment_name, 
    o.description AS outcome,
    pt.date
FROM PatientTreatments pt
JOIN Treatments t ON pt.treatment_id = t.treatment_id
JOIN Outcomes o ON pt.outcome_id = o.outcome_id
WHERE pt.date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY pt.date;

-- treatment frequency by month
SELECT 
    YEAR(pt.date) AS year, 
    MONTH(pt.date) AS month, 
    t.name AS treatment_name, 
    COUNT(*) AS treatment_count
FROM PatientTreatments pt
JOIN Treatments t ON pt.treatment_id = t.treatment_id
GROUP BY YEAR(pt.date), MONTH(pt.date), t.name
ORDER BY year, month, treatment_count DESC;

