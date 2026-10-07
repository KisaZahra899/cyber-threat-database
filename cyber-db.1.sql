DROP DATABASE IF EXISTS cyber;
CREATE DATABASE cyber;
USE cyber;

-- =========================================
-- 1. ORGANIZATION
-- =========================================

CREATE TABLE Organization (
    org_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);


-- =========================================
-- 2. SYSTEMS
-- =========================================

CREATE TABLE Systems (
    system_id INT PRIMARY KEY AUTO_INCREMENT,
    system_name VARCHAR(100) NOT NULL,
    system_type VARCHAR(50),
    vulnerability_level VARCHAR(50),
    org_id INT,
    FOREIGN KEY (org_id) REFERENCES Organization(org_id)
);


-- =========================================
-- 3. USERS
-- =========================================

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);


-- =========================================
-- 4. THREATS
-- =========================================

CREATE TABLE Threats (
    threat_id INT PRIMARY KEY AUTO_INCREMENT,
    threat_name VARCHAR(100) NOT NULL,
    type VARCHAR(100),
    severity_level VARCHAR(50)
);


-- =========================================
-- 5. INCIDENTS
-- =========================================

CREATE TABLE Incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    attack_date DATE,
    impact_level VARCHAR(50),
    description TEXT,
    threat_id INT,
    FOREIGN KEY (threat_id) REFERENCES Threats(threat_id)
);


-- =========================================
-- 6. LOGS AND ALERTS
-- =========================================

CREATE TABLE LogsAlerts (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    system_id INT,
    timestamp DATETIME,
    log_data TEXT,
    FOREIGN KEY (system_id) REFERENCES Systems(system_id)
);


-- =========================================
-- 7. PREDICTIONS
-- =========================================

CREATE TABLE Predictions (
    prediction_id INT PRIMARY KEY AUTO_INCREMENT,
    probability DECIMAL(5,2),
    predicted_date DATE,
    pattern_attribute TEXT,
    incident_id INT,
    FOREIGN KEY (incident_id) REFERENCES Incidents(incident_id)
);


-- =========================================
-- 8. INCIDENT-SYSTEM RELATIONSHIP
-- =========================================

CREATE TABLE Incident_Systems (
    incident_id INT,
    system_id INT,
    PRIMARY KEY (incident_id, system_id),
    FOREIGN KEY (incident_id) REFERENCES Incidents(incident_id),
    FOREIGN KEY (system_id) REFERENCES Systems(system_id)
);


-- =========================================
-- INSERT ORGANIZATIONS
-- =========================================

INSERT INTO Organization (name, location)
VALUES
('Habib Bank Limited (HBL)', 'Karachi'),
('Punjab IT Board (PITB)', 'Lahore'),
('Nayatel', 'Islamabad'),
('Fauji Fertilizer Company', 'Rawalpindi'),
('Khyber Pakhtunkhwa IT Board', 'Peshawar'),
('Lucky Cement', 'Pezu'),
('Engro Corporation', 'Karachi'),
('Systems Limited', 'Lahore');


-- =========================================
-- INSERT SYSTEMS
-- =========================================

INSERT INTO Systems
(system_name, system_type, vulnerability_level, org_id)
VALUES
('HBL-Swift-Gateway', 'Server', 'Low', 1),
('PITB-Citizen-Portal-DB', 'Database', 'Low', 2),
('PITB-Citizen-Portal-DB', 'Database', 'Medium', 2),
('PITB-Citizen-Portal-DB', 'Database', 'High', 2),
('Nayatel-Fiber-Controller', 'Network Device', 'Low', 3),
('FFC-ERP-Terminal', 'Workstation', 'High', 4),
('KP-Health-Data-Server', 'Server', 'High', 5),
('Systems-Ltd-Dev-Cloud', 'Cloud Instance', 'Low', 8);


-- =========================================
-- INSERT THREATS
-- =========================================

INSERT INTO Threats
(threat_name, type, severity_level)
VALUES
('SQL Injection', 'Web Attack', 'High'),
('DDoS Attack', 'Network', 'Medium'),
('Ransomware', 'Malware', 'Critical'),
('Phishing', 'Social Engineering', 'High'),
('Brute Force', 'Authentication', 'Medium'),
('Zero-Day Exploit', 'Software Vulnerability', 'Critical'),
('Insider Threat', 'Human Factor', 'High');


-- =========================================
-- INSERT INCIDENTS
-- =========================================

INSERT INTO Incidents
(attack_date, impact_level, description, threat_id)
VALUES
('2026-05-10', 'High',
 'Unauthorized database access detected via vulnerable login portal.', 1),

('2026-05-12', 'Medium',
 'Temporary service outage due to flood of incoming UDP packets.', 2),

('2026-05-13', 'Low',
 'Temporary service outage due to flood of incoming UDP packets.', 2),

('2026-05-14', 'Critical',
 'Critical servers encrypted; ransom note found on desktop.', 3),

('2026-05-15', 'Low',
 'Several employees reported receiving suspicious emails targeting credentials.', 4);


-- =========================================
-- INSERT LOGS AND ALERTS
-- =========================================

INSERT INTO LogsAlerts
(system_id, timestamp, log_data)
VALUES
(1, '2026-05-15 09:30:00',
 'Failed login attempt from IP 192.168.10.45 on HBL-Swift-Gateway'),

(2, '2026-05-15 10:15:22',
 'Unauthorized access attempt to PITB-Citizen-Portal-DB admin panel'),

(3, '2026-05-15 10:45:10',
 'Nayatel-Fiber-Controller reported unusual traffic spike from North region'),

(4, '2026-05-15 11:00:05',
 'FFC-ERP-Terminal: Malware signature detected in temp folder'),

(1, '2026-05-15 11:05:00',
 'Multiple failed SSH attempts on HBL-Swift-Gateway - Possible Brute Force');


-- =========================================
-- INSERT USERS
-- =========================================

-- Demo credentials only. Do not use real passwords.
INSERT INTO Users
(username, password)
VALUES
('asif_cyber', 'DEMO_PASSWORD_1'),
('fatima_admin', 'DEMO_PASSWORD_2'),
('zain_analyst', 'DEMO_PASSWORD_3'),
('noman_root', 'DEMO_PASSWORD_4');


-- =========================================
-- INSERT PREDICTIONS
-- =========================================

INSERT INTO Predictions
(probability, predicted_date, pattern_attribute, incident_id)
VALUES
(0.85, '2026-05-20',
 'Repeated failed logins from same IP range indicates a likely breach attempt.', 1),

(0.45, '2026-06-01',
 'Increase in dormant account activity suggesting credential stuffing.', 1),

(0.90, '2026-05-18',
 'Lateral movement detected in network logs suggests imminent ransomware deployment.', 3),

(0.60, '2026-05-25',
 'Spike in DNS queries to known malicious domains.', 2);


-- =========================================
-- INSERT INCIDENT-SYSTEM RELATIONSHIPS
-- =========================================

INSERT INTO Incident_Systems
(incident_id, system_id)
VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(2, 1);


-- =========================================
-- SQL QUERIES
-- =========================================

-- WHERE
SELECT *
FROM Systems
WHERE vulnerability_level = 'High';


-- BETWEEN
SELECT *
FROM Incidents
WHERE attack_date BETWEEN '2026-05-12' AND '2026-05-30';


-- LOW VULNERABILITY
SELECT *
FROM Systems
WHERE vulnerability_level = 'Low';


-- IN
SELECT *
FROM Threats
WHERE type IN ('Web Attack', 'Malware');


-- LIKE
SELECT *
FROM Users
WHERE username LIKE 'a%';


-- IS NULL
SELECT *
FROM Predictions
WHERE pattern_attribute IS NULL;


-- AND
SELECT *
FROM Systems
WHERE org_id = 5
AND vulnerability_level = 'High';


-- OR
SELECT *
FROM Threats
WHERE severity_level = 'Critical'
OR severity_level = 'High';


-- NOT
SELECT *
FROM Systems
WHERE NOT vulnerability_level = 'Low';


-- ORDER BY
SELECT *
FROM Incidents
ORDER BY attack_date DESC;


-- JOIN
SELECT
    i.incident_id,
    t.threat_name,
    i.attack_date,
    i.impact_level
FROM Incidents i
JOIN Threats t
ON i.threat_id = t.threat_id;


-- COUNT
SELECT COUNT(*) AS total_incidents
FROM Incidents;


-- GROUP BY
SELECT
    threat_id,
    COUNT(*) AS total_incidents
FROM Incidents
GROUP BY threat_id;


-- HAVING
SELECT
    s.system_name,
    COUNT(isys.incident_id) AS incident_count
FROM Systems s
JOIN Incident_Systems isys
ON s.system_id = isys.system_id
GROUP BY s.system_name
HAVING COUNT(isys.incident_id) >= 1;


-- DELETE
-- Demonstration query; execute only if you want to remove log_id 1.
-- DELETE FROM LogsAlerts
-- WHERE log_id = 1;