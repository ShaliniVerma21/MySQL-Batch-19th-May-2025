-- Step 1: Create the Database
Create database develearn;

-- Step 2: Use the Database

USE develearn;

-- Step 3: Create the Students Table

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1), -- Auto-incrementing primary key
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    EnrollmentDate DATE NOT NULL
);
drop table Students;
INSERT INTO Students(FirstName, LastName, DateOfBirth, Email, EnrollmentDate) VALUES
('John', 'Doe', '2000-01-15', 'john.doe@example.com', '2023-08-01'),
('Jane', 'Smith', '1999-05-22', 'jane.smith@example.com', '2023-08-01'),
('Alice', 'Johnson', '2001-03-10', 'alice.johnson@example.com', '2023-08-01'),
('Bob', 'Brown', '2000-07-30', 'bob.brown@example.com', '2023-08-01'),
('Charlie', 'Davis', '1998-11-05', 'charlie.davis@example.com', '2023-08-01');

select * from Students;
select Top 3 * from Students;

-- Step 4: Create the Faculty Table
CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY IDENTITY(1,1), -- Auto-incrementing primary key
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    HireDate DATE NOT NULL,
    Department NVARCHAR(50) NOT NULL
);

INSERT INTO Faculty (FirstName, LastName, Email, HireDate, Department) VALUES
('Dr. Emily', 'Clark', 'emily.clark@example.com', '2020-01-10', 'Computer Science'),
('Prof. Michael', 'Wilson', 'michael.wilson@example.com', '2019-08-15', 'Mathematics'),
('Dr. Sarah', 'Taylor', 'sarah.taylor@example.com', '2021-03-20', 'Physics'),
('Prof. David', 'Anderson', 'david.anderson@example.com', '2018-09-25', 'Chemistry'),
('Dr. Laura', 'Martinez', 'laura.martinez@example.com', '2022-05-30', 'Biology');



SELECT * FROM Students;
SELECT * FROM Faculty;



-- Step 5: Create the Staff Table
-- Note: SQL Server uses IDENTITY for auto-increment. MySQL uses AUTO_INCREMENT.

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),        -- Auto-incrementing primary key
    FirstName NVARCHAR(50) NOT NULL,              -- Unicode support for international names
    LastName NVARCHAR(50) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),  -- Constraint to allow only 'M' or 'F'
    DateOfBirth DATE NOT NULL,
    Mobile VARCHAR(15) UNIQUE,                    -- Mobile number should be unique
    Email NVARCHAR(100) UNIQUE NOT NULL,          -- Enforce unique email
    JoiningDate DATE DEFAULT GETDATE(),           -- Default value using SQL Server's GETDATE()
    Salary DECIMAL(10, 2) CHECK (Salary >= 0),    -- Salary must be non-negative
    Designation NVARCHAR(50) NOT NULL,
    Department NVARCHAR(50) NOT NULL
);

-- In MySQL:
-- Use AUTO_INCREMENT instead of IDENTITY
-- Default function is CURRENT_DATE or NOW()
-- CHECK constraints are ignored before version 8.0.16 unless enforced manually.


INSERT INTO Staff (FirstName, LastName, Gender, DateOfBirth, Mobile, Email, Salary, Designation, Department)
VALUES 
('Amit', 'Verma', 'M', '1985-04-12', '9876543210', 'amit.verma@develearn.com', 50000.00, 'Admin', 'HR'),
('Neha', 'Sharma', 'F', '1990-08-22', '9123456780', 'neha.sharma@develearn.com', 55000.00, 'Support', 'IT'),
('Ravi', 'Kumar', 'M', '1982-11-05', '9988776655', 'ravi.kumar@develearn.com', 60000.00, 'Supervisor', 'Finance'),
('Sneha', 'Mehta', 'F', '1995-02-28', '9900887766', 'sneha.mehta@develearn.com', 47000.00, 'Receptionist', 'Admin'),
('Ankit', 'Saxena', 'M', '1993-06-19', '9876123450', 'ankit.saxena@develearn.com', 52000.00, 'Coordinator', 'Operations');


-- Display All Staff
SELECT * FROM Staff;

-- Show Top 3 Highest Paid Staff
SELECT TOP 3 * FROM Staff ORDER BY Salary DESC;

-- Find Female Staff in IT Department
SELECT * FROM Staff WHERE Gender = 'F' AND Department = 'IT'; 

-- Show Staff who joined in 2024 or later
SELECT * FROM Staff WHERE YEAR(JoiningDate) >= 2024;

-- Drop table if exists in SQL Server
IF OBJECT_ID('Staff', 'U') IS NOT NULL
    DROP TABLE Staff;

-- ALTER TABLE: Add More Constraints to Staff

-- Add NOT NULL constraint to an existing column (if missing)
ALTER TABLE Staff ALTER COLUMN Department NVARCHAR(50) NOT NULL;

-- Add a DEFAULT constraint to Salary if not already present
ALTER TABLE Staff ADD CONSTRAINT DF_Salary DEFAULT 30000 FOR Salary;

-- Add CHECK for valid Designation values
ALTER TABLE Staff ADD CONSTRAINT CHK_Designation 
CHECK (Designation IN ('Admin', 'Support', 'Supervisor', 'Receptionist', 'Coordinator'));

-- Add FOREIGN KEY (optional: assume Department table exists)
ALTER TABLE Staff ADD CONSTRAINT FK_Dept FOREIGN KEY (Department) REFERENCES Department(DeptName);

-- Insert another staff record with default joining date
INSERT INTO Staff (FirstName, LastName, Gender, DateOfBirth, Mobile, Email, Salary, Designation, Department)
VALUES ('Kiran', 'Joshi', 'F', '1991-09-13', '7890123456', 'kiran.joshi@develearn.com', DEFAULT, 'Support', 'IT');

-- Update mobile number and salary of a staff member
UPDATE Staff
SET Mobile = '9000001234', Salary = 58000
WHERE Email = 'neha.sharma@develearn.com';

-- Delete staff who have salary below 40000
DELETE FROM Staff WHERE Salary < 40000;

-- Staff born before 1990 and earning above 50000
SELECT * FROM Staff
WHERE DateOfBirth < '1990-01-01' AND Salary > 50000;

-- Staff whose names start with 'S'
SELECT * FROM Staff WHERE FirstName LIKE 'S%';

-- Update Staff Salary
UPDATE Staff SET Salary = Salary + 3000 WHERE Department = 'HR';

-- Delete Staff from Admin department
DELETE FROM Staff WHERE Department = 'Admin';

-- Add Foreign Key Constraint (Example with a Departments table)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) UNIQUE
);

-- Insert Departments
INSERT INTO Departments (DepartmentName)
VALUES ('HR'), ('IT'), ('Finance'), ('Admin'), ('Operations');

-- Alter Staff Table to add Foreign Key
ALTER TABLE Staff
ADD DepartmentID INT;

ALTER TABLE Staff
ADD CONSTRAINT FK_Staff_Department FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID);


-- INNER JOIN between Staff and Departments
SELECT s.FirstName, s.LastName, d.DepartmentName
FROM Staff s
INNER JOIN Departments d ON s.DepartmentID = d.DepartmentID;


-- Get Staff with salary higher than average
SELECT * FROM Staff
WHERE Salary > (SELECT AVG(Salary) FROM Staff);


-- Create a Stored Procedure to get staff by department
CREATE PROCEDURE GetStaffByDepartment
    @Dept NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Staff WHERE Department = @Dept;
END;

-- Execute
EXEC GetStaffByDepartment 'IT';


-- Create audit table
CREATE TABLE StaffAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    StaffID INT,
    OldSalary DECIMAL(10, 2),
    NewSalary DECIMAL(10, 2),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Create Trigger to log salary changes
CREATE TRIGGER trg_SalaryChange
ON Staff
AFTER UPDATE
AS
BEGIN
    INSERT INTO StaffAudit (StaffID, OldSalary, NewSalary)
    SELECT d.StaffID, d.Salary, i.Salary
    FROM deleted d
    INNER JOIN inserted i ON d.StaffID = i.StaffID
    WHERE d.Salary <> i.Salary;
END;


-- Using LIKE and BETWEEN
SELECT * FROM Staff
WHERE FirstName LIKE 'A%' AND Salary BETWEEN 50000 AND 60000;


-- Rank staff by salary within department
SELECT FirstName, LastName, Department, Salary,
       RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
FROM Staff;


-- Use string and date functions
SELECT FirstName + ' ' + LastName AS FullName,
       UPPER(Designation) AS Role,
       DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Staff;


-- Use string and date functions
SELECT FirstName + ' ' + LastName AS FullName,
       UPPER(Designation) AS Role,
       DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Staff;


-- Create Scalar UDF to calculate bonus
CREATE FUNCTION dbo.CalculateBonus (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;

-- Use UDF
SELECT FirstName, LastName, Salary, dbo.CalculateBonus(Salary) AS Bonus
FROM Staff;


-- Create a view for active staff
CREATE VIEW vw_ActiveStaff AS
SELECT FirstName, LastName, Email, Department, Salary
FROM Staff
WHERE Salary > 48000;

-- Use View
SELECT * FROM vw_ActiveStaff;


-- CTE to get staff with above-average salary
WITH AboveAvgSalary AS (
    SELECT *, Salary - (SELECT AVG(Salary) FROM Staff) AS SalaryGap
    FROM Staff
    WHERE Salary > (SELECT AVG(Salary) FROM Staff)
)
SELECT FirstName, LastName, Salary, SalaryGap FROM AboveAvgSalary;





-- SQL BACKUP DATABASE for SQL Server
BACKUP DATABASE develearn
TO DISK = 'C:\Shalini Workspace\DBMS Workspace\Batch-4(4-6pm)\test.bak';
