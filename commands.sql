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