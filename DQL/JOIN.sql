CREATE TABLE kunde (
    kundenid INT PRIMARY KEY,
    vorname VARCHAR(50),
    nachname VARCHAR(50)
);

CREATE TABLE bestellung (
    bestellid INT PRIMARY KEY,
    kundenid INT,
    preis MONEY
);

INSERT INTO kunde VALUES
(1, 'Hans', 'Meier'),
(2, 'Ueli', 'Muster'),
(3, 'Sepp', 'Hofer');

INSERT INTO bestellung VALUES
(1,4,10),
(2,2,13),
(3,1,20);

SELECT * FROM kunde AS k JOIN bestellung AS b ON k.kundenid = b.kundenid;

SELECT * FROM kunde AS k LEFT JOIN  bestellung AS b ON k.kundenid = b.kundenid
WHERE bestellid IS NULL;

SELECT * FROM bestellung AS b RIGHT JOIN kunde AS k ON b.kundenid = k.kundenid
WHERE bestellid IS NULL;

SELECT * FROM kunde AS k RIGHT JOIN bestellung AS b ON k.kundenid = b.kundenid
WHERE k.kundenid IS NULL;

SELECT * FROM bestellung AS b LEFT JOIN kunde AS k ON k.kundenid = b.kundenid
WHERE k.kundenid IS NULL;

SELECT * FROM kunde AS k FULL OUTER JOIN bestellung AS b ON k.kundenid = b.kundenid; 

SELECT * FROM kunde CROSS JOIN bestellung;

SELECT p.PersonID, p.FullName, p.LastEditedBy, e.PersonID, e.FUllName FROM Application.People p     -- Macht ein Join, welcher in der eigenen Tabelle ist.
JOIN Application.People e ON p.LastEditedBy = e.PersonID


SELECT c.SupplierCategoryName, count(s.SupplierID) [Anzahl Hersteller] FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c ON s.SupplierCategoryID = c.SupplierCategoryID
WHERE c.SupplierCategoryName LIKE '%services%'
GROUP BY c.SupplierCategoryName