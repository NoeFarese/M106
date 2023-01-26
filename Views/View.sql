USE WideWorldImporters
GO

CREATE VIEW DunkleFarben AS
    SELECT ColorId, ColorName, Lasteditedby FROM Warehouse.Colors
    WHERE ColorName LIKE '%dark%'
GO

SELECT * FROM DunkleFarben;
SELECT * FROM Warehouse.Colors;

INSERT INTO DunkleFarben (ColorName, Lasteditedby) VALUES ('Dark Blue', 1);
INSERT INTO DunkleFarben (ColorName, Lasteditedby) VALUES ('Dark Red', 1);
GO

ALTER VIEW DunkleFarben AS 
    SELECT ColorId, ColorName, lasteditedby FROM Warehouse.Colors
    WHERE ColorName LIKE '%dark%'
    WITH CHECK OPTION;
GO    

INSERT INTO DunkleFarben (ColorName, Lasteditedby) VALUES ('Dark Gray', 1)