USE WideWorldImporters;
GO

SELECT StockItemID, StockItemName, ColorID, ISNULL(ColorID, 'keine Farbe') Farbe FROM Warehouse.StockItems

-- Datums- und Uhrzeitfunktionen
SELECT YEAR(LastEditedWhen) AS 'zuletzt bearbeitet' FROM Purchasing.PurchaseOrderLines;

SELECT MONTH(ValidTo) AS 'Ablaufdatum' FROM Purchasing.SupplierCategories;

SELECT GETDATE() AS 'Datum und Uhrzeit';

SELECT LastEditedWhen, DATEADD(Year, 1, LastEditedWhen) AS 'zuletzt bearbeitet' FROM Purchasing.PurchaseOrderLines;

-- Konventierungsfunktionen
SELECT CONVERT(DATE, TransactionDate, 104), TransactionDate
FROM Sales.CustomerTransactions;


SELECT StockItemName, ISNULL(CONVERT(varchar, ColorID), 'keine Farbe') 'Farbe' FROM Warehouse.StockItems;