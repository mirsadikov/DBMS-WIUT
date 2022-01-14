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