use WideWorldImporters;
GO

SELECT * FROM Application.People;

SELECT PersonID, FUllname FROM Application.People;

SELECT PersonID, Fullname AS Name FROM Application.People;

SELECT p.PersonID, p.Fullname AS NAME FROM Application.People AS p;

SELECT p.Fullname + ', ' + p.EmailAddress AS Email FROM Application.People AS p;

SELECT OrderID * CustomerID AS 'Beispiel für einen Ausdruck', OrderID + CustomerID 'weiteres Beispiel' FROM Sales.Orders;

SELECT DISTINCT CityName, CityID FROM Application.Cities ORDER BY CITYNAME DESC;

SELECT CountryName, Continent, Region FROM Application.Countries ORDER BY Continent, CountryName;

SELECT TOP 3 CityName, CityID FROM Application.Cities ORDER BY CityName ASC;

SELECT TOP 3 * FROM Application.Countries ORDER BY LatestRecordedPopulation DESC;

SELECT * FROM Warehouse.StockItems WHERE SupplierID = 12;

SELECT * FROM Warehouse.StockItems WHERE StockItemName > 'dba' ORDER BY 2;

SELECT * FROM WAREHOUSE.StockItems WHERE StockItemName < 'dba joke' ORDER BY 2;

SELECT StockItemID, ValidFrom, ValidTo FROM Warehouse.StockItems WHERE ValidFrom > '2016-05-31';

SELECT CustomerID, AccountOpenedDate FROM Sales.Customers WHERE AccountOpenedDate != '01.01.2013';

SELECT CustomerID, AccountOpenedDate FROM Sales.Customers WHERE NOT AccountOpenedDate = '01.01.2013';

SELECT * FROM Sales.Customers;

SELECT * FROM Sales.Customers WHERE AccountOpenedDate BETWEEN '2013-01-01' AND '2013-12-31';
SELECT * FROM Sales.Customers WHERE AccountOpenedDate >= '2013-01-01' AND AccountOpenedDate <= '2013-12-31';
SELECT * FROM Sales.Customers WHERE CustomerID BETWEEN 1 and 100;
SELECT * FROM Sales.Customers WHERE CustomerName BETWEEN 'a' AND 'czzzz' ORDER BY 2;

SELECT * FROM Sales.Customers WHERE CustomerCategoryID IN (1, 2, 3);
SELECT * FROM Sales.Customers WHERE CustomerCategoryID = 1 OR CustomerCategoryID = 2 OR CustomerCategoryID = 3;

SELECT * FROM Sales.Customers WHERE CustomerName LIKE 't%)';
SELECT * FROM Sales.Customers WHERE CustomerName LIKE '[aeiou]%r';
SELECT * FROM Sales.Customers WHERE CustomerName LIKE '_[^bin]%';

SELECT * FROM Sales.Customers WHERE CreditLimit IS NOT NULL;
SELECT * FROM Sales.Customers WHERE CreditLimit != 0;
SELECT * FROM Sales.Customers WHERE CreditLimit IS NULL;

SELECT CountryName,
    CASE 
        WHEN LatestRecordedPopulation < 100000 THEN 'very small country'
        WHEN LatestRecordedPopulation < 1000000 THEN 'small country'
        WHEN LatestRecordedPopulation < 10000000 THEN 'big country'
        ELSE 'very big country'
    END AS 'country size'    
FROM Application.Countries ORDER BY 2 DESC;   