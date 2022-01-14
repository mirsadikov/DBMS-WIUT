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