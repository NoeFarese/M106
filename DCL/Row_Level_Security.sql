-- Datenbank-User erstellen 
USE WideWorldImporters;
GO

CREATE USER Sophia WITHOUT LOGIN;
CREATE USER Eric WITHOUT LOGIN;
GO

-- neues Schema zur Trennung der Security-Objekte anlegen
CREATE SCHEMA Security;
GO

-- Prädikats-Funktion erstellen, um den Datenzugriff einzuschränken
-- Mit dieser Funktion wird PersonId des eingeloggten Users ermittelt
CREATE FUNCTION Security.fn_SecurityPredicateOrders(@personID int)
RETURNS TABLE
WITH SCHEMABINDING 
AS 
RETURN (SELECT 1 AS fn_SecurityPredicateOrders_Result 
        FROM Application.People
        WHERE @personID = PersonID
        AND PreferredName = USER_NAME()
        AND IsSalesperson = 1);
GO

-- Sicherheits-Policy erstellen für die Datenfilterung
-- Die PersonID aus der Prädikats-Funktion wird als Filter in der Spalte
-- SalespersonPersonID benutzt
CREATE SECURITY POLICY Security.fn_SecurityPredicates
ADD FILTER PREDICATE Security.fn_SecurityPredicateOrders(SalespersonPersonID)
ON Sales.Orders
WITH (STATE = ON);
GO

-- Tabelle auslesen
SELECT * FROM Sales.Orders;
GO

-- den oben ertellten Usern Lese-Rechte auf die Tabelle erteilen
GRANT SELECT ON Sales.Orders TO Sophia;
GRANT SELECT ON Sales.Orders TO Eric;
GO

-- testen mit dem User Sophia
EXECUTE AS USER = 'Sophia';
SELECT * FROM Sales.Orders;
REVERT;

-- testen mit dem User Eric
EXECUTE AS USER = 'Eric';
SELECT * FROM Sales.Orders;
REVERT;