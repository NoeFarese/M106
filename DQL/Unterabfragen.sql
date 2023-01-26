USE WideWorldImporters;
GO

SELECT * FROM kunde 
WHERE kundenid IN (SELECT kundenid FROM bestellung);

SELECT * FROM kunde
WHERE kundenid NOT IN (SELECT kundenid FROM bestellung);

SELECT * FROM kunde
WHERE kundenid IN (SELECT b.bestellid FROM bestellung b WHERE kunde.kundenid = b.kundenid);

SELECT cityname FROM application.Cities
UNION ALL
SELECT stateprovincename FROM Application.StateProvinces;

SELECT CityName FROM Application.Cities
INTERSECT 
SELECT stateprovincename FROM Application.StateProvinces;

SELECT CityName FROM Application.Cities
EXCEPT
SELECT stateprovincename FROM Application.StateProvinces;