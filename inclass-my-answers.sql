use AdventureWorks2012
-- SLOT 2

-- 1
select distinct City
from Person.Address
order by City desc;


-- 2
select *
from Sales.SalesPerson
where Bonus between 2500 and 5000
order by Bonus asc;


-- 3
select pp.Name as [Product name]
	, th.Quantity as [Quantity]
	, th.TransactionDate as [Transaction date]
	, th.ActualCost as [Actual cost]
	, pp.Class as [Product color]
from Production.TransactionHistory th
join Production.Product pp
	on th.ProductID = pp.ProductID
where th.Quantity between 5 and 8 and pp.Name like '%sport%'
order by th.TransactionDate desc, pp.Name asc;


-- 4 
select ProductID, sum(ActualCost) as "Actual cost of each order", count(ProductID) as "Count of records"
from Production.TransactionHistory
where TransactionDate > '2013-07-31'
group by ProductID
having count(ProductID) > 60
order by 3 desc;


-- 5
select st.Name as "Store name"
	, DATEDIFF(month, sp.ModifiedDate, GETDATE()) as "months since last modification of the sales person"
	,  (select avg(SalesLastYear) from Sales.SalesPerson) as "average sales last year among all sales persons"
from Sales.SalesPerson sp
left join Sales.Store st
	on sp.BusinessEntityID = st.BusinessEntityID
where sp.SalesLastYear > 0 and sp.SalesLastYear < (select avg(SalesLastYear) from Sales.SalesPerson)
order by st.Name desc;


-- 6
go
create view employee_per_job as
select JobTitle, count(*) as "Number of emp per job"
from HumanResources.Employee
group by JobTitle;
go
-- cannot update job title because we use aggregate function count() and group by


-- 7
with AllNotJobCandidates as (
select BusinessEntityID from HumanResources.Employee
except 
select BusinessEntityID from HumanResources.JobCandidate
)
select pp.BusinessEntityID
	, emp.Gender as "Gender"
	, emp.MaritalStatus as "Marital status"
	, pp.FirstName as "First name"
	, pp.LastName as "Last name"
	, edh.StartDate as "Start date of working in this dept"
	, dp.Name as "Name of department"
from HumanResources.Employee emp
join AllNotJobCandidates nc
	on emp.BusinessEntityID = nc.BusinessEntityID
join Person.Person pp
	on emp.BusinessEntityID = pp.BusinessEntityID
join HumanResources.EmployeeDepartmentHistory edh
	on pp.BusinessEntityID = edh.BusinessEntityID
join HumanResources.Department dp
	on edh.DepartmentID = dp.DepartmentID
where emp.HireDate > '2012-01-01' and DATEPART(month, emp.HireDate) in (9, 5)
and edh.StartDate = (select max(StartDate) from HumanResources.EmployeeDepartmentHistory where BusinessEntityID = emp.BusinessEntityID)
order by edh.StartDate ASC

