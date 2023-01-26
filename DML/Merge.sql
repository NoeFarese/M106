use m106;
GO

-- Ziel-Tabelle erstellen
CREATE TABLE Produkte
(
   ProduktID INT PRIMARY KEY,
   ProduktName VARCHAR(100),
   Preis MONEY
) 
GO

-- Werte in die Produkttabelle einfügen
INSERT INTO Produkte
VALUES
   (1, 'Tee', 10.00),
   (2, 'Kaffee', 20.00),
   (3, 'Muffin', 30.00),
   (4, 'Kuchen', 40.00)
GO

-- Quell-Tabelle (Merge) erstellen
CREATE TABLE UpdatedProdukte
(
   ProduktID INT PRIMARY KEY,
   ProduktName VARCHAR(100),
   Preis MONEY
) 
GO

-- Daten einfügen
INSERT INTO UpdatedProdukte
VALUES
   (1, 'Tee', 10.00),
   (2, 'Kaffee', 25.00),
   (3, 'Muffin', 35.00),
   (5, 'Pizza', 60.00)
GO

SELECT * FROM Produkte;
SELECT * FROM UpdatedProdukte;

-- Zieltabelle definieren
MERGE Produkte AS TARGET
-- Quelltabelle definieren
USING UpdatedProdukte AS SOURCE
-- Suchkondition definieren
ON (TARGET.ProduktID = SOURCE.ProduktID)
-- Was geschieht bei Matched? => Update
WHEN MATCHED AND TARGET.ProduktName <> SOURCE.ProduktName OR TARGET.Preis <> SOURCE.Preis
-- Werte updaten
THEN UPDATE SET TARGET.ProduktName = SOURCE.ProduktName, TARGET.Preis = SOURCE.Preis
-- Wenn die Werte auf der Ziel-Tabelle nicht matchen => Datensatz einfügen
WHEN NOT MATCHED BY TARGET
-- Wert in Target einfügen
THEN INSERT (ProduktID, ProduktName, Preis) VALUES (SOURCE.ProduktID, SOURCE.ProduktName, SOURCE.Preis)
-- Wenn die Werte auf der Quell-Tabelle nicht matchen => Datensatz löschen
WHEN NOT MATCHED BY SOURCE
-- Record löschen
THEN DELETE;

SELECT * FROM Produkte;