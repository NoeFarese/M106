USE WideWorldImporters
GO

-- 1.1 SELECT
SELECT DISTINCT CustomerName FROM Sales.Customers;

-- 1.2
SELECT FullName FROM Application.People;

-- 1.3
SELECT DeliveryMethodName FROM Application.DeliveryMethods;

-- 1.4
SELECT CustomerId, CustomerName, PostalAddressLine1 + ', ' + PostalAddressLine2 + ', ' + PostalPostalCode AS Address FROM Sales.Customers;


-- 2.1 WHERE-Bedingungen
SELECT COUNT(IsEmployee) AS 'Anzahl Mitarbeiter' FROM Application.People WHERE IsEmployee = 1;
-- oder
SELECT COUNT(*) AS 'Anzahl Mitarbeiter' FROM [WideWorldImporters].[Application].[People] WHERE IsEmployee = 1;

-- 2.2
SELECT COUNT(*) FROM Application.People WHERE IsEmployee = 1 AND IsSalesperson = 1;
-- oder
SELECT COUNT(*) FROM [WideWorldImporters].[Application].[People] WHERE IsSalesperson = 1;

-- 2.3
SELECT DISTINCT CityName FROM Application.Cities WHERE LatestRecordedPopulation > 10000;

-- 2.4
SELECT DISTINCT CityName FROM Application.Cities WHERE CityName LIKE 'Ab%';


-- 3.1 JOIN
SELECT * FROM Sales.Customers c 
JOIN Sales.orders o ON c.CustomerID = o.CustomerID;

-- 3.2
SELECT CustomerID FROM Sales.Customers
EXCEPT 
SELECT CustomerID FROM Sales.orders;
-- oder
SELECT c.CustomerID, o.CustomerID FROM Sales.Customers c 
LEFT JOIN Sales.orders o ON c.customerid = o.customerid
WHERE o.customerid IS NULL;
-- oder
SELECT c.customerid FROM Sales.customers c
WHERE c.customerid NOT IN (SELECT customerid FROM Sales.orders);

-- 3.3


-- 4.1 CASE
SELECT FullName, PhoneNumber, FaxNumber, 
    CASE
        WHEN IsSalesperson = 1 THEN 'Verkäufer'
        WHEN IsEmployee = 1 THEN 'Arbeiter'
        ELSE 'Kunde'
    END AS 'ROLLE'
FROM Application.People WHERE PhoneNumber IS NOT NULL OR FaxNumber IS NOT NULL;


-- 5.1 Gruppierungen
SELECT TOP 10 ((Quantity * UnitPrice) + TaxRate) AS PRICE FROM Sales.OrderLines;
-- oder
SELECT TOP (10) ol.OrderID, SUM(ol.Quantity*ol.UnitPrice) AS 'TOTAL' FROM Sales.OrderLines ol 
GROUP BY ol.OrderID
ORDER BY TOTAL DESC;

-- 5.2
SELECT c.CustomerName FROM Sales.Customers c
JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
JOIN 
(SELECT TOP (10) ol.OrderID, SUM(ol.Quantity*ol.UnitPrice) AS 'TOTAL' FROM Sales.OrderLines ol
GROUP BY ol.OrderID
ORDER BY TOTAL DESC) u ON o.OrderID = u.OrderID;

-- 5.3


-- 5.4
SELECT ac.CountryName, COUNT(asp.StateProvinceID) AS Provinzanzahl FROM Application.Countries ac
JOIN Application.StateProvinces asp ON ac.CountryID = asp.CountryID
GROUP BY ac.CountryName

-- 5.6
SELECT OrderID, COUNT(OrderLineID) AS ANZAHL_LINES FROM Sales.OrderLines
GROUP BY OrderID
HAVING COUNT(OrderLineID) >= 5;

-- 6.1
SELECT CustomerCategoryID, CustomerCategoryName FROM Sales.CustomerCategories

WHERE CustomerCategoryID IN(SELECT DISTINCT CustomerCategoryID FROM Sales.Customers);