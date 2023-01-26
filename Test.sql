USE [master]
RESTORE DATABASE [soundlib] FROM  DISK = N'/tmp/soundlib.bak' WITH  FILE = 1,  MOVE N'soundlib' TO N'/var/opt/mssql/data/soundlib.mdf',  MOVE N'soundlib_log' TO N'/var/opt/mssql/data/soundlib_log.LDF',  NOUNLOAD,  STATS = 5

USE soundlib;
GO

SELECT 'Ich, Noé Farese, habe am 24.09.2006 Geburtstag!' AS 'About me';


ALTER TABLE dbo.Customer ADD Firmenkunde BIT DEFAULT 0;
UPDATE dbo.Customer SET Firmenkunde = DEFAULT;

SELECT DISTINCT Company, FirstName, LastName, [Address], PostalCode, City, Country FROM dbo.Customer AS c
JOIN Invoice AS i ON i.CustomerId = c.CustomerId
WHERE InvoiceDate BETWEEN '2009-01-01 00:00:00.000' and '2009-06-30 00:00:00.000'
ORDER BY LastName;

SELECT COUNT(TrackId) AS 'Anzahl Songs' FROM dbo.Track;

BEGIN TRANSACTION
BEGIN TRY
    UPDATE Employee SET Title = 'Sales Support Agent' WHERE FirstName = 'Robert' and LastName = 'King'
    DELETE FROM Employee WHERE FirstName = 'Steve' and LastName = 'Johnson'

    COMMIT TRANSACTION
    SELECT 'COMMITED: Änderungen wurden gespeichert' AS Meldung
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION
    
    SELECT 'ROLLBACK: Fehler aufgetreten!' AS Meldung
END CATCH
GO

USE soundlib 
GO
SELECT YEAR(birthDate) AS 'Jahrgang' FROM Employee ORDER BY 1;

SELECT AVG(YEAR(birthDate)) AS 'Durchschnittswert' FROM Employee;


SELECT * FROM dbo.Artist WHERE [Name]  LIKE  '[BCDFGHJKMNPQRSVWXZ]%on';

USE master;
GO

CREATE LOGIN noe WITH PASSWORD = 'passwort', CHECK_POLICY = OFF;
GO

USE soundlib;
GO

CREATE USER noe FOR LOGIN noe;
GO


ALTER ROLE db_datareader ADD MEMBER noe
GRANT DELETE ON PlaylistTrack to noe
GRANT UPDATE ON Playlist to noe
GRANT INSERT ON Customer to noe
DENY SELECT, INSERT, UPDATE, DELETE ON Invoice TO noe;

SELECT USER_NAME();
GO

EXECUTE AS USER = 'noe';
GO

REVERT;
GO

INSERT INTO dbo.Artist (Name) VALUES ('MF DOOM');

ALTER TABLE dbo.Employee ALTER COLUMN Email ADD MASKED WITH (FUNCTION = 'email()');

CREATE INDEX TrackIndex ON Album (Title);

SELECT CustomerId, FirstName FROM dbo.Customer WHERE ((CustomerId*4)>100);

SELECT City FROM Customer
EXCEPT
SELECT BillingCity FROM Invoice

SELECT DISTINCT a.Name as 'Komponist', t.Name AS 'Song Name' FROM Artist AS a
JOIN Album AS al ON al.ArtistId = a.ArtistId
JOIN Track AS t ON t.TrackId = al.AlbumId
ORDER BY a.Name, t.Name ASC;

SELECT c.Company FROM dbo.Customer c
JOIN dbo.Invoice i ON c.CustomerId = i.CustomerId
JOIN dbo.InvoiceLine il ON i.InvoiceId = il.InvoicecId
HAVING count(distinct il.InvoiceLineId) > 10;


SELECT * FROM dbo.MediaType;

ALTER TABLE dbo.Invoice ADD Rechnungsstatus VARCHAR(10) DEFAULT 'offen'
CHECK(Rechnungsstatus = 'offen' OR Rechnungsstatus = 'ausstehend' OR Rechnungsstatus = 'bezahlt')

UPDATE dbo.Invoice SET Rechnungsstatus = DEFAULT;

SELECT t.TrackId, i.InvoiceLineId FROM Track as t
JOIN InvoiceLine as i on i.TrackId = t.TrackId
WHERE i.InvoiceLineId is null;

SELECT Composer + ' - ' + [Name] AS 'Interpret - Song' FROM dbo.Track AS t
JOIN dbo.PlaylistTrack AS pt ON t.TrackId = pt.TrackId

USE soundlib;
GO

BACKUP DATABASE [soundlib]
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\soundlib.bak' 
WITH NOFORMAT, NOINIT, NAME = N'Soundlib vollständige Datenbanksicherung', SKIP, STATS = 10
GO

-- CREATE VIEW Firmenkunden AS
   