USE master
GO
DROP DATABASE cw12860
GO
CREATE DATABASE cw12860
GO
USE cw12860
GO
CREATE TABLE Course(
	CourseId int IDENTITY NOT NULL,
	CourseName nvarchar(200) NOT NULL,
	Duration int NULL,
	Price decimal(10, 2) NULL,
	CONSTRAINT PK_Course_CourseId PRIMARY KEY(CourseId)
) 
GO
CREATE TABLE Employee(
	EmpId int IDENTITY NOT NULL,
	FirstName nvarchar(200) NOT NULL,
	LastName nvarchar(200) NOT NULL,
	Email varchar(200) NULL,
	JobTitle nvarchar(200) NULL,
	Salary decimal(10, 2) NULL,
	BranchNo int NULL,
	ManagerId int NULL,
	HireDate date NULL,
	Phone varchar(50) NULL,
	CONSTRAINT PK_Employee_EmpId PRIMARY KEY(EmpId),
	CONSTRAINT UQ_Employee_Email UNIQUE(Email),
	CONSTRAINT UQ_Employee_Phone UNIQUE(Phone)
) 
GO
CREATE TABLE Manager(
	EmpId int NOT NULL,
	CONSTRAINT PK_Manager_EmpId PRIMARY KEY(EmpId)
) 
GO
CREATE TABLE Assistant(
	EmpId int NOT NULL,
	CONSTRAINT PK_Assistant_EmpId PRIMARY KEY(EmpId),
)
GO
CREATE TABLE Teacher(
	EmpId int NOT NULL,
	ExperienceYear int NULL,
	CONSTRAINT PK_Teacher_EmpId PRIMARY KEY(EmpId),
) 
GO
CREATE TABLE Branch(
	BranchNo int IDENTITY NOT NULL,
	BranchName nvarchar(200) NULL,
	Location nvarchar(200) NULL,
	TelephoneNumber varchar(50) NULL,
	ManagerId int NOT NULL,
	CONSTRAINT PK_Branch_BranchNo PRIMARY KEY(BranchNo),
	CONSTRAINT UQ_Branch_ManagerId UNIQUE(ManagerId),
) 
GO
CREATE TABLE EmpBranch(
	BranchNo int NOT NULL,
	EmpId int NOT NULL,
	CONSTRAINT PK_EmpBranch_BranchNo_EmpId PRIMARY KEY(BranchNo, EmpId),
) 
GO
CREATE TABLE BranchCourses(
	BranchNo int NOT NULL,
	CourseId int NOT NULL,
	CONSTRAINT PK_BranchCourses_BranchNo_CourseId PRIMARY KEY(BranchNo, CourseId),
) 
GO
CREATE TABLE AgeGroup(
	Age int IDENTITY NOT NULL,
	Name nvarchar(200) NULL,
	CONSTRAINT PK_AgeGroup_Age PRIMARY KEY(Age)
)
GO
CREATE TABLE Student(
	StudentId int IDENTITY NOT NULL,
	FullName nvarchar(200) NOT NULL,
	Age int NULL,
	Phone varchar(50) NULL,
	BranchNo int NOT NULL,
	CONSTRAINT PK_Student_StudentId PRIMARY KEY(StudentId),
	CONSTRAINT CK_Student_Age CHECK(Age>=7)
) 
GO
CREATE TABLE Class(
	ClassId int IDENTITY NOT NULL,
	TeacherId int NOT NULL,
	AssistantId int NOT NULL,
	EndDate date NULL,
	CONSTRAINT PK_Class_ClassId PRIMARY KEY(ClassId),
) 
GO
CREATE TABLE StudentCourseHistory(
	StudentId int NOT NULL,
	CourseId int NOT NULL,
	PayAmount decimal(10, 2) NULL,
	StartDate date NOT NULL,
	ClassId int NOT NULL,
	CONSTRAINT PK_StudentCourseHistory_StudentId_CourseId_StartDate PRIMARY KEY(StudentId, CourseId, StartDate),
	CONSTRAINT FK_StudentCourseHistory_ClassId FOREIGN KEY(ClassId) REFERENCES Class(ClassId),
) 
GO
CREATE TABLE Sertificates(
	EmpId int NOT NULL,
	SertificateName varchar(200) NOT NULL,
	CONSTRAINT PK_Sertificates_EmpId_SertificateName PRIMARY KEY(EmpId, SertificateName),
) 
GO
ALTER TABLE Employee ADD CONSTRAINT FK_Employee_ManagerId FOREIGN KEY(ManagerId) REFERENCES Manager(EmpId)
GO


-- INSERTING DATA --
USE cw12860
GO
INSERT INTO [Employee]([FirstName],[LastName],[Email],[JobTitle],[Salary],[HireDate],[Phone])
     VALUES ('Mark','Stark','mark@example.com','manager',2000,'07-07-2020','998993217777')
GO
INSERT INTO [Manager]([EmpId]) VALUES(1)
GO
INSERT INTO [Employee]([FirstName],[LastName],[Email],[JobTitle],[Salary],[BranchNo],[ManagerId],[HireDate],[Phone])
     VALUES ('Tony','Harris','tony@example.com','teacher',1500,1,1,'07-08-2020','998993216666')
GO
INSERT INTO [Teacher]([EmpId]) VALUES(2)
GO
INSERT INTO [Employee]([FirstName],[LastName],[Email],[JobTitle],[Salary],[BranchNo],[ManagerId],[HireDate],[Phone])
     VALUES ('Kamala','Harris','kamala@example.com','assistant',800,1,1,'11-11-2018','998991230000')
GO
INSERT INTO [dbo].[Assistant]([EmpId]) VALUES(3)
GO
INSERT INTO [Branch] ([BranchName],[Location],[TelephoneNumber],[ManagerId])
     VALUES ('Amir Temur Branch','Amir Temur, 1','99711231233',1)
GO
INSERT INTO [Employee]([FirstName],[LastName],[Email],[JobTitle],[Salary],[BranchNo],[ManagerId],[HireDate],[Phone])
     VALUES ('John','Doe','john@example.com','operator',1000,1,1,'11-11-2021','998991231212')
GO
INSERT INTO [Student]([FullName],[Age],[Phone],[BranchNo])
     VALUES ('Harry Potter', 15, '998333453333', 1)
GO
INSERT INTO [Student]([FullName],[Age],[Phone],[BranchNo])
     VALUES ('Tom Nason', 14, '998333451111', 1)
GO
INSERT INTO [Course]([CourseName],[Duration],[Price])
     VALUES ('IELTS',5,500.00)
GO
INSERT INTO [Course]([CourseName],[Duration],[Price])
     VALUES ('Beginner English',3,300.00)
GO
INSERT INTO [Class]([TeacherId],[AssistantId],[EndDate])
     VALUES(1,3,'01-05-2022')
GO
INSERT INTO [StudentCourseHistory]([StudentId],[CourseId],[PayAmount],[StartDate],[ClassId])
     VALUES (1,1,500.00, '01-01-2022',1)
GO


-- DELETE --
USE cw12860
GO
DROP TABLE [Employee]
GO
DROP TABLE [Manager]
GO
DROP TABLE [Teacher]
GO
DROP TABLE [Assistant]
GO
DROP TABLE [Branch]
GO 
DROP TABLE [Course]
GO
DROP TABLE [Student]
GO
DROP TABLE [AgeGroup]
GO
DROP TABLE [BranchCourses]
GO
ALTER TABLE StudentCourseHistory DROP CONSTRAINT FK_StudentCourseHistory_ClassId
GO
DROP TABLE [Class]
GO
DROP TABLE [EmpBranch]
GO
DROP TABLE [Sertificates]
GO
DROP TABLE [StudentCourseHistory]







