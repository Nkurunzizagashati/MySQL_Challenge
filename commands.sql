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

--1 Find all projects with a deadline before December 1st, 2024
SELECT * FROM Projects WHERE Deadline < '2024-12-01'; 

--2 List all projects for "Big Retail Inc." ordered by deadline
SELECT * FROM projects
WHERE ProjectName = "Big Retail Inc."
ORDER BY Deadline DESC;


--3. Find the team lead for the "Mobile App for Learning" project.
SELECT * FROM team_members WHERE project_id = 2 AND is_lead = 1;

--4.Finding projects containing "Management" in the name.
SELECT * FROM projects
WHERE ProjectName LIKE '%Management%'
;


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


--11. Create a view to simplify retrieving client contact
CREATE VIEW ClientContact AS
SELECT
    client_id,
    client_name,
    contact_name
FROM client;


--12. Create a view to show only ongoing projects (not yet completed).
CREATE VIEW OnGoingProjects AS
SELECT
    project_id,
    project_name,
    requirements,
    deadline,
    client_id
FROM project
WHERE
    deadline >= CURRENT_DATE;

--13. Create a view to display project information along with assigned team leads.
CREATE VIEW ProjectInformation AS
SELECT employees.employee_name, project.project_name, project.deadline
FROM
    team_members
    JOIN employees ON team_members.employee_id = employees.employee_id
    AND team_members.is_lead = 1
    JOIN project ON team_members.project_id = project.project_id;


--14.Create a view to show project names and client contact information for projects with a deadline in November 2024.
CREATE OR REPLACE VIEW Project_Client_November AS
SELECT project.project_name, project.deadline, client.contact_name, client.client_name
FROM project
    JOIN client ON project.client_id = client.client_id
WHERE
    deadline BETWEEN '2024-11-01' AND '2024-11-30';


--15. Create a view to display the total number of projects assigned to each employee.
CREATE OR REPLACE VIEW Employee_Project_Count AS
SELECT employees.employee_id, employees.employee_name, COUNT(team_members.project_id) AS projects_assigned
FROM employees
    JOIN team_members ON team_members.employee_id = employees.employee_id
GROUP BY
    employees.employee_id,
    employees.employee_name;



-- 16. Create a function to calculate the number of days remaining until a project deadline.
DELIMITER $$

CREATE FUNCTION days_until_deadline(project_id INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE deadline DATE;
    DECLARE days_remaining INT;
    
    -- Get the project deadline
    SELECT p.deadline INTO deadline
    FROM project p
    WHERE p.project_id = project_id;

    -- Calculate the number of days remaining
    SET days_remaining = DATEDIFF(deadline, CURRENT_DATE);
    
    RETURN days_remaining;
END$$

DELIMITER;
-- Usage
SELECT days_until_deadline (1) AS days_remaining;



-- 17. Create a function to calculate the number of days a project is overdue
DELIMITER $$

CREATE FUNCTION days_overdue(project_id INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE deadline DATE;
    DECLARE overdue_days INT;

    -- Get the project deadline
    SELECT p.deadline INTO deadline
    FROM project p
    WHERE p.project_id = project_id;

    -- Calculate the number of days overdue
    SET overdue_days = DATEDIFF(CURRENT_DATE, deadline);
    
    -- If the project is not overdue, return 0
    IF overdue_days < 0 THEN
        SET overdue_days = 0;
    END IF;

    RETURN overdue_days;
END$$

DELIMITER;

-- Usage
SELECT days_overdue (1) AS overdue_days;


--18. Create a stored procedure to add a new client and their first project in one call
DELIMITER $$

CREATE PROCEDURE add_client_project(
    IN client_name VARCHAR(255),
    IN contact_name VARCHAR(255),
    IN project_name VARCHAR(255),
    IN requirements TEXT,
    IN deadline DATE
)
BEGIN
    DECLARE client_id INT;
    DECLARE project_id INT;
    
    -- Add client
    INSERT INTO client (client_name, contact_name)
    VALUES (client_name, contact_name);
    
    -- Get the client_id of the newly added client
    SET client_id = LAST_INSERT_ID();
    
    -- Add project
    INSERT INTO project (project_name, requirements, deadline, client_id)
    VALUES (project_name, requirements, deadline, client_id);
    
    -- Get the project_id of the newly added project
    SET project_id = LAST_INSERT_ID();
    
    -- Return the project_id
    SELECT project_id, client_id,  project_name, client_name;
    
END$$

DELIMITER;

CALL add_client_project (
    'Boris Nyilindekwe', -- client_name
    'African Leadership University', -- contact_name
    'ALU Project', -- project_name
    'Complete all queries in the ALU project', -- requirements
    '2024-07-01' -- deadline
);


--19. Create a stored procedure to move completed projects (past deadlines) to an archive table
CREATE TABLE IF NOT EXISTS archived_projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    requirements TEXT,
    deadline DATE,
    client_id INT,
    archived_date DATE
);

ALTER TABLE archived_projects
ADD CONSTRAINT fk_archiveclient FOREIGN KEY (client_id) REFERENCES client (client_id);

DELIMITER $$

CREATE PROCEDURE archive_completed_projects()
BEGIN
    -- Insert completed projects into the archive table
    INSERT INTO archived_projects (project_id, project_name, requirements, deadline, client_id, archived_date)
    SELECT project_id, project_name, requirements, deadline, client_id, CURRENT_DATE
    FROM project
    WHERE deadline < CURRENT_DATE;

    -- Delete the completed projects from the original table
    DELETE FROM project
    WHERE deadline < CURRENT_DATE;
END$$

DELIMITER;

-- Usage
CALL archive_completed_projects ();


--20. Create a trigger to log any updates made to project records in a separate table for auditing purposes
CREATE TABLE IF NOT EXISTS project_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    old_project_name VARCHAR(255),
    new_project_name VARCHAR(255),
    old_requirements TEXT,
    new_requirements TEXT,
    old_deadline DATE,
    new_deadline DATE,
    old_client_id INT,
    new_client_id INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_project_update
AFTER UPDATE ON project
FOR EACH ROW
BEGIN
    INSERT INTO project_audit (
        project_id, 
        old_project_name, new_project_name,
        old_requirements, new_requirements,
        old_deadline, new_deadline,
        old_client_id, new_client_id
       
    ) VALUES (
        OLD.project_id, 
        OLD.project_name, NEW.project_name,
        OLD.requirements, NEW.requirements,
        OLD.deadline, NEW.deadline,
        OLD.client_id, NEW.client_id
     
    );
END$$

DELIMITER;


-- 21. Create a trigger to ensure a team lead assigned to a project is a valid employee
DELIMITER $$

CREATE TRIGGER trg_team_lead_check
BEFORE INSERT ON team_members
FOR EACH ROW
BEGIN
    DECLARE is_valid_lead INT;
    
    -- Check if the team lead is a valid employee
    SELECT COUNT(*)
    INTO is_valid_lead
    FROM employees
    WHERE employee_id = NEW.employee_id;
    
    -- If the team lead is not a valid employee, raise an error
    IF is_valid_lead = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid team lead employee';
    END IF;
END$$

DELIMITER;


--22.Create a view to display project details along with the total number of team members assigned
CREATE VIEW Project_Details_With_Team_Members AS
SELECT
    p.project_id,
    p.project_name,
    p.requirements,
    p.deadline,
    p.client_id,
    c.client_name,
    COUNT(tm.employee_id) AS total_team_members
FROM
    project p
    JOIN client c ON p.client_id = c.client_id
    LEFT JOIN team_members tm ON p.project_id = tm.project_id
GROUP BY
    p.project_id,
    p.project_name,
    p.requirements,
    p.deadline,
    p.client_id,
    c.client_name;

SELECT * FROM Project_Details_With_Team_Members;


--23.Create a view to show overdue projects with the number of days overdue
CREATE VIEW Overdue_Projects AS
SELECT p.project_id, p.project_name, p.requirements, p.deadline, p.client_id, c.client_name, DATEDIFF(CURRENT_DATE, p.deadline) AS days_overdue
FROM project p
    JOIN client c ON p.client_id = c.client_id
WHERE
    p.deadline < CURRENT_DATE;

SELECT * FROM Overdue_Projects;


--24. Create a stored procedure to update project team members (remove existing, add new ones)
DELIMITER $$

CREATE PROCEDURE update_project_team (
    IN p_project_id INT,
    IN new_team_members JSON
)
BEGIN
    -- Remove existing team members
    DELETE FROM team_members
    WHERE project_id = p_project_id;

    -- Declare variables for iterating through the JSON array
    DECLARE i INT DEFAULT 0;
    DECLARE n INT;
    DECLARE member_id INT;
    DECLARE is_lead BOOLEAN;

    -- Get the count of new team members
    SET n = JSON_LENGTH(new_team_members);

    -- Loop through the JSON array to insert new team members
    WHILE i < n DO
        SET member_id = JSON_UNQUOTE(JSON_EXTRACT(new_team_members, CONCAT('$[', i, '].employee_id')));
        SET is_lead = JSON_UNQUOTE(JSON_EXTRACT(new_team_members, CONCAT('$[', i, '].is_lead')));

        INSERT INTO team_members (project_id, employee_id, is_lead)
        VALUES (p_project_id, member_id, is_lead);

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER;



--25. Prevent the deletion of projects with assigned team members using a trigger
DELIMITER $$

CREATE TRIGGER prevent_project_deletion
BEFORE DELETE ON project
FOR EACH ROW
BEGIN
    DECLARE team_member_count INT;

    -- Count the number of team members assigned to the project
    SELECT COUNT(*)
    INTO team_member_count
    FROM team_members
    WHERE project_id = OLD.project_id;

    -- If there are any team members assigned, prevent the deletion
    IF team_member_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete project: Team members are still assigned to this project.';
    END IF;
END$$

DELIMITER;