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

--1 List all projects for "Big Retail Inc." ordered by deadline
SELECT * FROM projects
WHERE ProjectName = "Big Retail Inc."
ORDER BY Deadline;


--2. List all projects for "Big Retail Inc." ordered by deadline.
SELECT * FROM project WHERE client_id = 1 ORDER BY deadline DESC;

--3. Find the team lead for the "Mobile App for Learning" project.
SELECT * FROM team_members WHERE project_id = 2 AND is_lead = 1;

--4.Find projects containing "Management" in the name.
SELECT * FROM project WHERE project_name LIKE '%Management%';


--5.Count the number of projects assigned to David Lee.
SELECT COUNT(*) FROM team_members WHERE employee_id = 1;


--6 Find the total number of employees working on each project.
SELECT project_id, COUNT(employee_id)
FROM team_members
GROUP BY
    project_id;


--7. Find all clients with projects having a deadline after October 31st, 2024.
SELECT client_name
FROM client
WHERE
    client_id IN (
        SELECT client_id
        FROM project
        WHERE
            deadline > '2024-10-31'
    );

--8.List employees who are not currently team leads on any project.
SELECT * FROM team_members WHERE is_lead = 0;


--9. Combine a list of projects with deadlines before December 1st and another list with "Management" in the project name
SELECT *
FROM project
WHERE
    deadline < '2024-12-01'
UNION
SELECT *
FROM project
WHERE
    project_name LIKE '%Management%';


--10. Display a message indicating if a project is overdue (deadline passed).
SELECT
    project_name,
    deadline,
    CASE
        WHEN deadline < CURRENT_DATE THEN 'Overdue'
        ELSE 'Not overdue'
    END AS status
FROM project;