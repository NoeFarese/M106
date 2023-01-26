CREATE DATABASE Musterbank;
GO
USE Musterbank;

------------------------------------------
-- Einfache Konto-Tabelle erstellen
------------------------------------------
CREATE TABLE Account (
	AccountID INT IDENTITY(1,1) NOT NULL,
	CustomerName NVARCHAR(200) NOT NULL,
	Currency NCHAR(20) NOT NULL DEFAULT 'CHF',
	AccountBalance MONEY NOT NULL DEFAULT 0,
    PRIMARY KEY (AccountID)
);
GO

------------------------------------------
-- Startguthaben einfügen
------------------------------------------
INSERT INTO Account (CustomerName, AccountBalance) VALUES 
    ('Max Mustermann', 1200), 
    ('Jane Doe', 1500);
GO

------------------------------------------
-- Sicherstellen, dass der Kontostand nicht negativ werden kann
------------------------------------------
ALTER TABLE Account 
    ADD CONSTRAINT chk_kontostand CHECK (AccountBalance >= 0);

------------------------------------------
-- CHF 500.00 von Konto 1 auf Konto 2 überweisen 
UPDATE Account SET AccountBalance = AccountBalance - 500 WHERE AccountID = 1;
UPDATE Account SET AccountBalance = AccountBalance + 500 WHERE AccountID = 2;

------------------------------------------
-- Wir prüfen den Kontostand 
--  -> es hat geklappt: Jane hat nun 2000.00 auf dem Konto, Max noch 700.00
------------------------------------------
SELECT * FROM Account 

------------------------------------------
-- Überweisung mit Fehler 
--  -> Verletzung des CHECK-Constraints 
------------------------------------------
UPDATE Account SET AccountBalance = AccountBalance - 5000 WHERE AccountID = 1;
UPDATE Account SET AccountBalance = AccountBalance + 5000 WHERE AccountID = 2;

------------------------------------------
-- Uuuuups: Jane hat nun 7000.00 auf dem Konto, Max immer noch 700.00 
--  -> das Geld wurde aus dem Nichts generiert...
------------------------------------------
SELECT * FROM Account 

------------------------------------------
-- Fehler korrigieren 
------------------------------------------
UPDATE Account SET AccountBalance = AccountBalance - 5000 WHERE AccountID = 2

------------------------------------------
-- Lösung: Transaktion und try .. catch
------------------------------------------
BEGIN TRANSACTION

BEGIN TRY
    -- Überweise CHF 500.- von Konto 1 auf Konto 2:
    UPDATE Account SET AccountBalance = AccountBalance - 700 WHERE AccountID = 1
    UPDATE Account SET AccountBalance = AccountBalance + 700 WHERE AccountID = 2

    -- Commit der Transaktion
    COMMIT TRANSACTION

    -- Erfolgsmeldung ausgeben
    SELECT 'COMMITED: Transaktion war erfolgreich!' AS Meldung
END TRY

BEGIN CATCH
    -- Dieser Codeblock wird ausgeführt, sollte eine der Anweisungen fehlerhaft sein.
    -- Rollback der Transaktion
    ROLLBACK TRANSACTION
    
    -- Fehlermeldung ausgeben
    SELECT 'ROLLBACK: Zu wenig Geld auf dem Konto!' AS Meldung
END CATCH

GO

------------------------------------------
-- Wir prüfe den Kontostand 
--  -> alles i.O. Rollback hat gegriffen 
------------------------------------------
SELECT * FROM Account 

/*
Zusatzaufgabe: Buchungseinträge erstellen
Zu jedem der obigen Updates auf die Konto-Tabelle soll zusätzlich ein Buchungseintrag erstellt werden, 
der z.B. auf dem monatlichen Konto-Auszug sichtbar ist. Dazu brauchen wir eine zusätzliche Tabelle, 
in der die Überweisungen protokolliert werden: 
*/
------------------------------------------
-- Tabelle für Überweisungen erstellen 
------------------------------------------

CREATE TABLE Posting (
    PostingID INT IDENTITY(1,1) NOT NULL,
    AccountID_FK INT,
    Amount MONEY,
    Currency NCHAR(20)DEFAULT 'CHF',
    ExecutionDate DATETIME ,
    Notes NVARCHAR(200),
    PRIMARY KEY (PostingID), 
    FOREIGN KEY (AccountID_FK) REFERENCES Account(AccountID)
)

--SELECT * FROM Posting

--DROP PROCEDURE bankueberweisung

CREATE PROCEDURE bankueberweisung (@von_konto VARCHAR(100),@nach_konto VARCHAR(50),@betrag MONEY)
    
AS

BEGIN TRANSACTION

BEGIN TRY
    -- Überweise Betrag von Konto nach Konto
    UPDATE Account SET AccountBalance = AccountBalance - @betrag WHERE AccountID = @von_konto
    UPDATE Account SET AccountBalance = AccountBalance + @betrag WHERE AccountID = @nach_konto
    -- Commit der Transaktion
    COMMIT TRANSACTION

    -- Erfolgsmeldung ausgeben
	SELECT 'COMMITTED' AS Meldung

	INSERT INTO Posting(Amount,AccountID_FK,ExecutionDate,Notes)VALUES(@betrag,@von_konto,GETDATE(),'Betrag an Konto '+@nach_konto+' überwiesen')

END TRY

BEGIN CATCH
    -- Dieser Codeblock wird ausgeführt, sollte eine der Anweisungen fehlerhaft sein.
    -- Rollback der Transaktion
    ROLLBACK TRANSACTION
    
    -- Fehlermeldung ausgeben
    SELECT 'ROLLBACK: Zu wenig Geld auf dem Konto!' AS Meldung

	INSERT INTO Posting(AccountID_FK,ExecutionDate,Notes)VALUES(@von_konto,GETDATE(),'Zahlunsversuch von Betrag: CHF. '+CONVERT(nvarchar(200), @betrag, 2)+ ' an Konto '+@nach_konto+'wegen zu geringem Kontostand geblockt!')
END CATCH

GO

/*Teste die Stored Procedure*/

EXEC bankueberweisung 2,1,1500
SELECT * FROM Account
SELECT * FROM Posting
 