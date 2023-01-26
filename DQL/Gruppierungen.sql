SELECT 
    SUM(Quantity) AS bestellmenge, 
    COUNT(OrderID) AS 'Anzahl Bestellpositionen',
    COUNT(DISTINCT OrderID) AS 'Anzahl bestellungen',
    AVG(UnitPrice) AS 'Durchschnittlicher Artikelpreis',
    MIN(UnitPrice) AS 'Günstigster Artikel'
    FROM sales.OrderLines
WHERE OrderID = 47;

SELECT COUNT(*) FROM Sales.Orders; -- bezieht sich auf alle Datensätze
SELECT COUNT(PickedByPersonID) FROM Sales.Orders;
SELECT COUNT(ISNULL(PickedByPersonID, '0')), COUNT(PickedByPersonID), COUNT(*) FROM Sales.Orders;

SELECT OrderId,
    SUM(Quantity) AS bestellmenge, 
    AVG(UnitPrice) AS 'Durchschnittlicher Artikelpreis',
    MIN(UnitPrice) AS 'Günstigster Artikel'
    FROM sales.OrderLines
GROUP BY OrderID, StockItemID;


SELECT Continent, Region, count(*) 'Anzahl Länder', 
    sum(LatestRecordedPopulation) 'Bevölkerung' FROM Application.Countries
GROUP BY Continent, Region
HAVING COUNT(*) >= 10 AND Continent LIKE '[^aeiou]%'
ORDER BY 1

SELECT Continent, Region, count(*) 'Anzahl Länder', 
    sum(LatestRecordedPopulation) 'Bevölkerung' FROM Application.Countries
WHERE Continent LIKE '[^aeiou]%'    
GROUP BY Continent, Region
HAVING COUNT(*) >= 10 
ORDER BY 1

SELECT PostalAddressLine2, COUNT(*) Anzahl, MIN(AccountOpenedDate) AS 'älteste Kundenkontoeröffnung', MAX(LastEditedBy) AS 'höchste ID des letzten Editors' FROM Sales.Customers
GROUP BY PostalAddressLine2