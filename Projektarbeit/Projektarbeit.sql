-- Aufgabe 2 
-- Erstelle ein Backup von der soeben erstellten Northwind-Datenbank in den dafür vorgesehenen Backupfolder deiner SQL-Instanz.
BACKUP DATABASE [NorthWind]
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\NorthWind.bak'
WITH NOFORMAT, NOINIT, NAME = N'NorthWind vollständige Datenbanksicherung', SKIP, STATS = 10
GO

-- Aufgabe 3 
-- Teste dein Backup, indem du die Northwind-Datenbank löschst und anhand des Backups wieder herstellst.
USE master
GO

DROP DATABASE Northwind;
GO

RESTORE DATABASE Northwind
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\NorthWind.bak'

-- Aufgabe 4 
-- Du willst dir Übersicht über die Produktetabelle erschaffen und möchtest wissen, welche Datentypen in der Produktetabelle verwendet werden.
-- Erschaffe dir die Übersicht anhand der geeigneten gespeicherten Prozedur.
USE Northwind
GO
exec sp_columns Products
GO

-- Aufgabe 5 
-- Erstelle eine Tabelle payroll_accounting innerhalb eines separaten Schemas names hr mit den Spalten title und salary. 
-- Du musst dazu keine Primary oder Foreign-Key definieren. Fülle die Tabelle wie erwähnt ab.
CREATE SCHEMA hr;
GO

CREATE TABLE hr.payroll_accounting (
    title VARCHAR(50),
    salary MONEY
);
GO

INSERT INTO hr.payroll_accounting (title, salary) VALUES
    ('Inside Sales Coordinator', 8000),
    ('Vice President, Sales', 100000),
    ('Sales Representative', 80000),
    ('Sales Manager', 90000);
GO    

SELECT * FROM hr.payroll_accounting;   
GO 

-- Aufgabe 6 
/*
Erstelle eine View lohnuebersicht, welche den Vornamen, Nachnamen und das Gehalt ausgibt. 
Die Jahresgehälter werden jeden Monat um 30$ erhöht. Mitarbeiter, welche im Jahre 1993 eingestellt wurden, erhalten zudem jährlich noch einen Bonus von 1000$. 
Da immer wieder eine Lohnliste erstellt werden muss, machst du eine View
*/
USE Northwind;
GO

CREATE VIEW lohnuebersicht AS
SELECT e.FirstName AS 'Vorname', e.LastName AS 'Nachname', e.Title AS 'Anstellung',
CASE
    WHEN YEAR(e.HireDate) = '1993' THEN pa.salary+(1000*(DateDIFF(Year,HireDate,GETDATE())))+(30*(DateDIFF(Month,HireDate,GETDATE())))
    ELSE pa.salary+(30*(DateDIFF(Month,HireDate,GETDATE())))
END AS 'Gehalt'
FROM Employees AS e JOIN hr.payroll_accounting AS pa ON e.Title = pa.Title;
GO

SELECT * FROM lohnuebersicht;
GO

-- Aufgabe 7
/* 
Die Mitarbeiter werden jährlich aufgrund ihrer Leistung und der Zielerreichung bewertet. Die möglichen Bewertungen sind von A-D. 
Füge bei der Employees-Tabelle eine Spalte valuation mit dem Standartwert B ein. Achte darauf, dass nur die Werte A-D eingetragen werden können. 
Fülle diese Werte gleich ab: Alle Mitarbeiter erhalten die Bewertung B, einzig Nancy Davolio hat eine A und Robert King hat eine C.
*/
ALTER TABLE dbo.Employees ADD valuation CHAR DEFAULT 'B'
CHECK(valuation = 'A' OR valuation = 'B' OR valuation = 'C' OR valuation = 'D')
GO

UPDATE dbo.Employees SET valuation = DEFAULT;
UPDATE dbo.Employees SET valuation = 'A' WHERE FirstName = 'Nancy' AND LastName = 'Davolio';
UPDATE dbo.Employees SET valuation = 'C' WHERE FirstName = 'Robert' AND LastName = 'King';
GO

SELECT FirstName, LastName, valuation FROM dbo.Employees ORDER BY valuation;
GO

-- Aufgabe 8 
-- Die neue Spalte soll von valutation in rating umbenannt werden.
ALTER  TABLE Employees DROP CONSTRAINT CK__Employees__valua__160F4887;
ALTER  TABLE Employees DROP CONSTRAINT DF__Employees__valua__151B244E;
GO

EXEC sp_rename 'dbo.Employees.valuation', 'rating', 'COLUMN'
GO
-- Aufgabe 9 
-- Die Tabelle hr.payroll_accounting soll in hr.salaries umbenannt werden.
EXEC sp_rename 'hr.payroll_accounting', 'salaries';
GO

EXEC sp_rename '[hr].[hr.salaries]', 'salaries';

-- Aufgabe 10 
-- Erstelle von der Tabelle Products eine Kopie mit dem Namen products_backup (ohne Constraints).
SELECT * INTO products_backup FROM Products;
GO

SELECT * FROM products_backup;
SELECT * FROM Products;
GO

-- Aufgabe 11 Lösche den Inhalt der Tabelle products_backup innerhalb einer Transaktion. Schliesse die Transaktion so ab, dass die Änderungen nicht ausgeführt werden.
BEGIN TRANSACTION
DELETE FROM products_backup
ROLLBACK TRANSACTION;
GO

-- Aufgabe 12 Lösche den Inhalt der Tabelle products_backup mit einem DDL-Befehl.
TRUNCATE TABLE products_backup;
GO

-- Aufgabe 13 Lösche die gesamte Tabelle products_backup.
DROP TABLE products_backup;
GO

-- Aufgabe 14
/*
Erstelle nochmals eine Kopie der Produktetabelle. Ändere den Produktnamen eines beliebigen Produktes in der Produkte-Tabelle. 
Du möchtest nun diese Anpassung wieder rückgängig machen. Verwende hierzu einen Merge. Kontrolliere die Änderungen jeweils mit einer Abfrage.
*/
SELECT * INTO products_backup FROM Products;
GO

UPDATE Products
SET ProductName='Chai Ten'
WHERE ProductName='Chai'
GO

SELECT * FROM Products;
SELECT * FROM products_backup;
GO

MERGE products p
USING products_backup pb ON p.productid=pb.productid
WHEN MATCHED THEN
UPDATE SET p.productname=pb.productname;
GO

-- Aufgabe 15
/*
Erstelle einen neues Login und einen User mit dem Namen test. Erteile dem Login nur Leserechte auf der ganzen Northwind-Datenbank, indem du ihm die entsprechende Datenbankrolle zuteilst.
 Teste das neue Login. Um die Berechtigungen zu testen, führst du ein SELECT sowie ein UPDATE, INSERT oder DELETE-Statement aus. Was stellst du fest?
*/
USE master;
GO

CREATE LOGIN test WITH PASSWORD = 'passwort', CHECK_POLICY = OFF;
GO

USE Northwind;
GO

CREATE USER test FOR LOGIN test;
GO

USE Northwind;
GO
ALTER ROLE db_datareader ADD MEMBER test;
GO

SELECT * FROM Products;
INSERT INTO Products (ProductName) VALUES ('Test');
UPDATE Products SET ProductName = 'Test' WHERE ProductID = 2;
GO

SELECT USER_NAME();
GO

EXECUTE AS USER = 'test';
GO

REVERT;
GO
-- Aufgabe 16
GRANT UPDATE ON Products TO test;
GO

UPDATE Products SET ProductName = 'Test' WHERE ProductID = 2;
GO
-- Aufgabe 17
ALTER SCHEMA hr TRANSFER dbo.Employees;
GO

REVOKE UPDATE ON Products FROM test;
GO

ALTER ROLE db_datareader DROP MEMBER test;

GRANT SELECT ON SCHEMA::hr TO test;
GO

/*
    Berechtigungen testen
*/
EXECUTE AS USER = 'test';
GO

SELECT * FROM hr.Employees;
GO

UPDATE hr.Employees SET LastName = 'test' WHERE EmployeeID = 2;
GO

REVERT;
GO

-- Aufgabe 18
ALTER TABLE hr.salaries ALTER COLUMN salary ADD MASKED WITH (FUNCTION = 'default()');
GO

GRANT SELECT ON hr.salaries TO test;
GO

EXECUTE AS USER = 'test';
GO

SELECT salary FROM hr.salaries;
GO

REVERT;
GO

SELECT USER_NAME() AS 'Benutzer';
GO

-- Aufgabe 19
SELECT SUM((UnitPrice - Discount) * Quantity) AS 'Total' FROM dbo.[Order Details]
JOIN dbo.Orders ON [Order Details].OrderID = Orders.OrderID 
WHERE OrderDate BETWEEN '1997-01.01 00:00:00.000' and '1997-12.31 00:00:00.000';
GO

-- Aufgabe 20
SELECT c.ContactName, SUM(od.Quantity*od.UnitPrice) as 'Total' FROM Customers as c
JOIN Orders as o on o.CustomerID = c.CustomerID
JOIN [Order Details] as od on od.OrderID = o.OrderID
GROUP BY c.ContactName 
Order BY Total DESC
GO

-- Aufgabe 21
SELECT s.CompanyName FROM products p
JOIN suppliers s ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName
HAVING count(distinct p.Productname) > 4;

-- Aufgabe 22
SELECT TOP 1 LastName FROM hr.Employees ORDER BY HireDate;
GO
-- Aufgabe 23
SELECT LOWER(LEFT(Lastname,3)+LEFT(Firstname,3)) FROM [hr].[Employees];
GO

-- Aufgabe 24
SELECT (YEAR(hiredate)+MONTH(hiredate)+DAY(hiredate))* employeeID FROM [hr].[Employees];
GO

-- Aufgabe 25
SELECT Firstname, Lastname , DATEDIFF(YEAR,birthdate,GETDATE())FROM hr.Employees
GO

-- Aufgabe 26
SELECT productname FROM Products;
GO

DROP INDEX [ProductName] ON [dbo].[Products]
GO

CREATE INDEX [ProductName] ON [dbo].[Products] (ProductName)
GO