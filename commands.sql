CREATE DATABASE SoftwareCompanyDB;
USE SoftwareCompanyDB;

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(255),
    Requirements TEXT,
    Deadline DATE
);

-- Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    ClientName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactEmail VARCHAR(255)
);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(255)
);

-- Team Members Table
CREATE TABLE TeamMembers (
    ProjectID INT,
    EmployeeID INT,
    PRIMARY KEY (ProjectID, EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Project Team Table
CREATE TABLE ProjectTeam (
    ProjectID INT,
    EmployeeID INT,
    TeamLead VARCHAR(3),
    PRIMARY KEY (ProjectID, EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


INSERT INTO Projects (ProjectID, ProjectName, Requirements, Deadline) VALUES
(1, 'E-commerce Platform', 'Extensive documentation', '2024-12-01'),
(2, 'Mobile App for Learning', 'Gamified learning modules', '2024-08-15'),
(3, 'Social Media Management Tool', 'User-friendly interface with analytics', '2024-10-31'),
(4, 'Inventory Management System', 'Barcode integration and real-time stock tracking', '2024-11-01'),
(5, 'Restaurant Reservation System', 'Online booking with table management', '2024-09-01');

-- INSETING DATA INTO CLIENT TABLE
INSERT INTO Clients (ClientID, ClientName, ContactName, ContactEmail) VALUES
(1, 'Big Retail Inc.', 'Peter Parker', 'peter.parker@example.com'),
(2, 'EduTech Solutions', 'Walter White', 'walter.white@example.com'),
(3, 'Trendsetters Inc.', 'Sandra Bullock', 'sandra.bullock@example.com'),
(4, 'Gearhead Supply Co.', 'Daniel Craig', 'daniel.craig@example.com'),
(5, 'Fine Dine Group', 'Olivia Rodriguez', 'olivia.rodriguez@example.com');


INSERT INTO Employees (EmployeeID, EmployeeName) VALUES
(1, 'Alice Brown'),
(2, 'David Lee'),
(3, 'Michael Young'),
(4, 'Jane Doe'),
(5, 'William Green'),
(6, 'Sarah Jones');

INSERT INTO TeamMembers (ProjectID, EmployeeID) VALUES
 (1, 2),
 (1, 6),
 (2, 3),
 (2, 4),
 (3, 4),
 (3, 5),
 (4, 3),
 (4, 6),
 (5, 5),
 (5, 6);

--  Find all projects with a deadline before December 1st, 2024
SELECT * FROM Projects WHERE Deadline < '2024-12-01';

-- List all projects for "Big Retail Inc." ordered by deadline
SELECT * FROM projects
WHERE ProjectName = "Big Retail Inc."
ORDER BY Deadline;