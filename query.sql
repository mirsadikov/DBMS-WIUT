--################### MOCK
use AdventureWorks2012
--1
select count(distinct JobTitle)
from HumanResources.Employee

--2
select *
from  Production.Product
where Name not like '%metal%'

--3
select *
from HumanResources.Employee

select *
from Person.Person



select JobTitle, HireDate, FirstName, LastName
from HumanResources.Employee e
	join Person.Person p
		on e.BusinessEntityID = p.BusinessEntityID
where HireDate < '01-01-2002'
order by HireDate


--4
select * 
from Production.Product

select * 
from Production.ProductModelProductDescriptionCulture

select * 
from Production.Culture


select pp.Name "Product name", pc.Name "Product culture"
from Production.Product pp
	join Production.ProductModelProductDescriptionCulture pd
		on pp.ProductModelID = pd.ProductModelID
	join Production.Culture pc
		on pd.CultureID = pc.CultureID
		

-- 5
select *
from HumanResources.Employee

select *
from Person.Person

select JobTitle, BirthDate, DATEDIFF(year,  emp.BirthDate, GETDATE()) "Age", FirstName, LastName 
from HumanResources.Employee emp
	join Person.Person pp
		on emp.BusinessEntityID = pp.BusinessEntityID
where DATEDIFF(year,  emp.BirthDate, GETDATE()) > 60
order by "Age"

--6
select *
from HumanResources.EmployeePayHistory

select *
from HumanResources.Employee

select ph.Rate, emp.JobTitle
from HumanResources.EmployeePayHistory ph
	join HumanResources.Employee emp
		on ph.BusinessEntityID = emp.BusinessEntityID
where ph.Rate < (select AVG(Rate) from HumanResources.EmployeePayHistory)

-- 7
select sc.Name
from Production.Product pp
	join Production.ProductSubcategory sc
		on pp.ProductSubcategoryID = sc.ProductSubcategoryID


select sc.Name, count(*) "Count"
from Production.Product pp
	join Production.ProductSubcategory sc
		on pp.ProductSubcategoryID = sc.ProductSubcategoryID
group by  sc.Name
having count(*) > 20


-- 8
select * from HumanResources.Department

go
create view products_per_subcat_view as
Select pp.FirstName
	, pp.LastName, hd.Name
	, rate
	, min(rate) over (partition by hd.name) as [minimum in its department]
	, rate-min(rate) over (partition by hd.name) as difference  from Person.Person pp
	join HumanResources.EmployeePayHistory hep
		on pp.BusinessEntityID=hep.BusinessEntityID
	join HumanResources.EmployeeDepartmentHistory hed
		on hed.BusinessEntityID=pp.BusinessEntityID
	join HumanResources.Department hd
		on hd.DepartmentID=hed.DepartmentID

go
create view product_names_view as
Select pp.Name as product, pc.Name as model
from Production.Product pp 
	join production.ProductModelProductDescriptionCulture pm 
		on pp.ProductModelID=pm.ProductModelID
	join Production.Culture pc 
		on pm.CultureID=pc.CultureID
go

-- 9
Select pp.FirstName
	, pp.LastName
	, hd.Name
	, rate
	, rate - min(rate) over (partition by hd.name) as [difference]  
	, min(rate) over (partition by hd.name) as [minimum in its department]
	, hd.DepartmentID
from Person.Person pp
	join HumanResources.EmployeePayHistory hep
		on pp.BusinessEntityID=hep.BusinessEntityID
	join HumanResources.EmployeeDepartmentHistory hed
		on hed.BusinessEntityID=pp.BusinessEntityID
	join HumanResources.Department hd
		on hd.DepartmentID=hed.DepartmentID
order by hd.Name, rate, [minimum in its department]


-- alternative solution
Select pp.FirstName
	, pp.LastName
	, hd.Name
	, rate
	, rate - (select rr.minrate 
			  from (select hed.DepartmentID, min(hep.Rate) [minrate]
					from HumanResources.EmployeePayHistory hep
					join HumanResources.EmployeeDepartmentHistory hed
						on hed.BusinessEntityID=hep.BusinessEntityID
					group by hed.DepartmentID) rr
			  where rr.DepartmentID = hd.DepartmentID) as [difference]  
	, (select rr.minrate 
	   from (select hed.DepartmentID, min(hep.Rate) [minrate]
				from HumanResources.EmployeePayHistory hep
				join HumanResources.EmployeeDepartmentHistory hed
					on hed.BusinessEntityID=hep.BusinessEntityID
				group by hed.DepartmentID) rr
	   where rr.DepartmentID = hd.DepartmentID) as [minimum in its department]
	, hd.DepartmentID
from Person.Person pp
	join HumanResources.EmployeePayHistory hep
		on pp.BusinessEntityID=hep.BusinessEntityID
	join HumanResources.EmployeeDepartmentHistory hed
		on hed.BusinessEntityID=pp.BusinessEntityID
	join HumanResources.Department hd
		on hd.DepartmentID=hed.DepartmentID
order by hd.Name, rate, [minimum in its department]




-- 10
WITH 
  cteCandidates (BusinessEntityID)
  AS
  (
    SELECT BusinessEntityID
    FROM HumanResources.Employee
    INTERSECT
    SELECT BusinessEntityID
    FROM HumanResources.JobCandidate
  )
SELECT 
  c.BusinessEntityID,
  e.LoginID,
  e.JobTitle
FROM 
  HumanResources.Employee AS e
  INNER JOIN cteCandidates AS c
    ON e.BusinessEntityID = c.BusinessEntityID
ORDER BY
  c.BusinessEntityID;



--#################### REVISION
use company
--1
select CONCAT(upper(ename), 's salary is ', sal, '$')
from EMP
where sal + coalesce(comm, 0) >1500

--2
select *
from EMP
where job in('clerk', 'manager') and (ename like '_____' or ename like '__R%')

--3
select d.dname, count(e.deptno) "Count"
	, min(e.sal) "MIN sal"
	, max(e.sal) "MAX sal"
	, avg(e.sal) "AVG sal"
from EMP e
	join DEPT d
	on e.deptno = d.deptno
group by d.dname
having count(e.deptno) > 2
order by d.dname

--4
select d.dname, count(e.deptno) "EMP Count"
	, min(e.sal) "MIN sal"
	, max(e.sal) "MAX sal"
	, avg(e.sal) "AVG sal"
from EMP e
	right join DEPT d
	on e.deptno = d.deptno
group by d.dname
having count(e.empno) > 2 or count(e.empno)=0
order by d.dname

--5 
select e.ename 'Name'
	, d.dname 'Department'
	, s.grade 'Salary grade'
	, m.ename 'Manager name'
from EMP e
	join DEPT d
	on e.deptno = d.deptno
	join SALGRADE s
	on e.sal between s.losal and s.hisal
	left join EMP m
	on e.manager = m.empno

-- 6
select d.*
from DEPT d
	left join EMP e on d.deptno = e.deptno
where e.deptno is null

-- 7
select *
	, (select m.ename from emp m where m.empno = e.manager) "Manager name"
from EMP e


--8 
select empno, ename, (select count(*) from emp e where e.manager = m.empno) [Num of emps managed directly]
from EMP m


--9
select job
from EMP e
where (sal + coalesce(comm, 0))  = (select max(sal + coalesce(comm, 0))  from EMP)

--10
select hisal, 'High'
from SALGRADE
union
select losal, 'Low'
from SALGRADE
order by 1 desc

--11
select e.ename from EMP e 
join DEPT d on e.deptno = d.deptno
where d.dname = 'Accounting'
union select loc from DEPT
order by 1

--12
select e.*
from EMP m
right join EMP e
on m.manager = e.empno
where m.ename is null

--same
select *
from emp nm
where nm.empno not in (select coalesce(e.manager, 0) from EMP e)

select * 
from emp
where empno in (select empno from emp
			    except
			    select manager from emp) 

--same
with t as 
(select empno from emp
 except
 select manager from emp)
select * 
from emp
where empno in (select empno from t)

--13
create table Product (
 Id integer not null,
 Name nvarchar(100) not null,
 DateManufactured datetime not null DEFAULT getdate(),
 Price decimal(10,2),
 IsAvailable bit,
 CategoryId integer,
 constraint pk_product_id primary key(id),
 constraint ck_product_price check(Price between 0 and 1000)
);

create table Category (
  Id integer not null,
  Name nvarchar(200) not null,
  Description nvarchar(1000),
  constraint uq_category_name UNIQUE(Name),
  constraint pk_category_id primary key(Id)
);

alter table Product add constraint fk_product_categoryid foreign key(categoryid) references category(Id) on delete set null;

--20
set identity_insert category on
insert into Category(id, name, description) 
values (1, 'Food', 'various food items')
	 , (2, 'Electronics', 'all kinds of electronic devices')
set identity_insert category off

insert into product(name, DateManufactured, Price, IsAvailable, CategoryId)
values('Milk', '2021-11-01', 1.01, 1, 1)
, ('Monitor', '2020-11-01', 300.55, 0, 2)

--21
select * into product_backup from product

--22 
delete from category where id = 1

--23
alter table product drop constraint fk_product_categoryid

alter table Product add constraint fk_product_categoryid foreign key(categoryid) references category(Id) on delete set null;

--24
alter table product add "Description" varchar(1000)

--25
alter table product drop column IsAvailable


--######################### LAST 1
use AdventureWorks2012

-- TASK 1	 
SELECT JobTitle, HireDate
FROM HumanResources.Employee;


-- TASK 2
SELECT *
FROM Production.Product
WHERE StandardCost BETWEEN 90 AND 100
ORDER BY StandardCost DESC;


-- TASK 3
SELECT p.Name [Product name]
	, SellStartDate [Sell start date]
	, ps.Name [Subcategory name]
	, ListPrice [Price], Color 
FROM Production.Product p
JOIN Production.ProductSubcategory ps
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p.Name LIKE '%Mountain%'
	AND ListPrice BETWEEN 500 AND 800
ORDER BY Color DESC, p.Name ASC;


-- TASK 4
SELECT MaritalStatus, Gender
	, AVG(SickLeaveHours) [Average sick leave hours]
	, count(*) [Number of employees]
FROM HumanResources.Employee
WHERE BirthDate > '1980-10-10'
GROUP BY MaritalStatus, Gender
HAVING AVG(SickLeaveHours) > 43
ORDER BY AVG(SickLeaveHours) ASC;


-- TASK 5
SELECT pp.FirstName AS "First name"
	, pp.LastName AS "Last name"
	, DATEDIFF(month, sp.ModifiedDate, GETDATE()) AS "Months since modification"
	, (SELECT AVG(SalesLastYear) from Sales.SalesPerson) AS "Average among all"
FROM Sales.SalesPerson sp
	JOIN Person.Person pp
		ON sp.BusinessEntityID = pp.BusinessEntityID
WHERE sp.Bonus > 100 AND sp.SalesLastYear > (SELECT AVG(SalesLastYear) from Sales.SalesPerson)
ORDER BY pp.LastName DESC;

-- TASK 6
GO
CREATE VIEW employee_per_job AS
SELECT JobTitle, count(*) "Number of emp per job"
FROM HumanResources.Employee
GROUP BY JobTitle;
GO
-- cannot update because we use aggregate function count() and group by

-- TASK 7
SELECT be.ModifiedDate AS "Business entity modified date"
	, ct.Name AS "Contact type"
	, ss.Name AS "Store name"
	, CONCAT_WS(', ', a.AddressLine1, a.PostalCode) AS "Full address"
FROM Person.BusinessEntity be
	JOIN person.BusinessEntityContact bec
		ON be.BusinessEntityID = bec.BusinessEntityID
	JOIN person.ContactType ct
		ON bec.ContactTypeID = ct.ContactTypeID
	JOIN person.BusinessEntityAddress bea
		ON be.BusinessEntityID = bea.BusinessEntityID
	JOIN person.Address a
		ON bea.AddressID = a.AddressID
	JOIN Sales.Store ss
		ON ss.BusinessEntityID = be.BusinessEntityID
WHERE ss.Name LIKE '%Toy%'
ORDER BY ct.Name ASC, ss.Name DESC, be.ModifiedDate ASC;


--#################### LAST 2
USE AdventureWorks2012

-- TASK 1
SELECT Name, SellStartDate
FROM Production.Product
ORDER BY SellStartDate DESC;

-- TASK 2
SELECT *
FROM HumanResources.Employee
WHERE HireDate > '2011-01-01'
ORDER BY HireDate DESC;

-- TASK 3
SELECT p.Name as "Product name"
	, p.ListPrice as "Current price"
	, ph.ListPrice as "History price"
	, ph.StartDate
	, ph.EndDate
FROM Production.Product p 
JOIN Production.ProductListPriceHistory ph
	on p.ProductID = ph.ProductID
WHERE p.ProductLine = 'S' 
	AND ph.StartDate > '2011-01-01' 
	AND ph.EndDate < '2012-06-01'
ORDER BY p.Name ASC, ph.StartDate DESC;


-- TASK 4
SELECT Class, AVG(Weight) "Average weight", COUNT(*) "Number of Products"
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Class
HAVING AVG(Weight) > 50
ORDER BY COUNT(*) DESC;


-- TASK 5
SELECT p.Name "Product name"
	, sc.Name "Subcategory name"
	, p.StandardCost "Standart cost"
	, SUBSTRING(p.ProductNumber, 1, 2) "2 chars of Product number"
	, (SELECT AVG(StandardCost) FROM Production.Product) "Average cost of all products"
FROM Production.Product p
JOIN Production.ProductSubcategory sc
	ON p.ProductSubcategoryID = sc.ProductSubcategoryID
WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)
ORDER BY p.StandardCost DESC;


-- TASK 6


-- TASK 7
SELECT p.*
	, pr.ReviewDate "Review date"
	, (SELECT max(StartDate) FROM Production.ProductListPriceHistory WHERE ProductID = p.ProductID) "Product last date price was changed"
FROM Production.Product p
	LEFT JOIN Sales.SpecialOfferProduct sop
		ON p.ProductID = sop.ProductID
	LEFT JOIN Production.ProductReview pr
		ON p.ProductID = pr.ProductID
WHERE p.ProductID NOT IN(SELECT ProductID FROM Sales.SpecialOfferProduct)
ORDER BY p.ListPrice DESC, p.StandardCost DESC, p.DiscontinuedDate ASC;

-- alternative

SELECT p.*
	, pr.ReviewDate "Review date"
	, (SELECT max(StartDate) FROM Production.ProductListPriceHistory WHERE ProductID = p.ProductID) "Product last date price was changed"
FROM Production.Product p
	LEFT JOIN Sales.SpecialOfferProduct sop
		ON p.ProductID = sop.ProductID
	LEFT JOIN Production.ProductReview pr
		ON p.ProductID = pr.ProductID
WHERE sop.ProductID IS NULL
ORDER BY p.ListPrice DESC, p.StandardCost DESC, p.DiscontinuedDate ASC;


-- CTE
use company
--all employees whom 7839 supervises directly or indirectly
with emp_hierarchy AS (
  select empno, ename, manager, 1 as level
  from emp
  where empno = 7839
  UNION ALL
  select e.empno, e.ename, e.manager, level + 1
  from emp e JOIN emp_hierarchy m ON e.manager = m.empno
)
select * from emp_hierarchy 
where empno <> 7902

--all employees whom BLAKE supervises directly or indirectly
with emp_hierarchy AS (
  select empno, ename, manager, 1 as level
  from emp
  where ename = 'BLAKE'
  UNION ALL
  select e.empno, e.ename, e.manager, level + 1
  from emp e JOIN emp_hierarchy m ON e.manager = m.empno
)
select * from emp_hierarchy 
where ename <> 'BLAKE'

--all supervisors of BLAKE
with emp_hierarchy AS (
  select empno, ename, manager, 1 as level
  from emp
  where ename = 'BLAKE'
  UNION ALL
  select e.empno, e.ename, e.manager, level + 1
  from emp e JOIN emp_hierarchy m 
                      ON m.manager = e.empno
)
select * from emp_hierarchy 
where ename <> 'BLAKE'
