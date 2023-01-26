/* 
    -- Tabelle für Buchungseinträge erstellen
*/  
CREATE TABLE Posting (
    PostingID INT IDENTITY(1,1) NOT NULL,
    AccountID_FK INT NOT NULL,
    Amount MONEY NOT NULL,
    Currency NCHAR(20) NOT NULL DEFAULT 'CHF',
    ExecutionDate DATETIME NOT NULL,
    Notes NVARCHAR(200),
    PRIMARY KEY (PostingID), 
    FOREIGN KEY (AccountID_FK) REFERENCES Account(AccountID)
)

BEGIN TRANSACTION

BEGIN TRY
    -- ====> Variablen sind nicht Teil des ÜKs 106, wird hier nur der Einfachheit halber verwendet 
    DECLARE @amount as int 
    set @amount = 10 

    -- Überweise CHF 500.- von Konto 1 auf Konto 2:
    UPDATE Account SET AccountBalance = AccountBalance - @amount WHERE AccountID = 1 
    UPDATE Account SET AccountBalance = AccountBalance + @amount WHERE AccountID = 2

    -- Buchungseinträgeerstellen 
    INSERT INTO Posting (AccountID_FK, Amount, ExecutionDate, Notes) 
        VALUES(1, @amount, GetDate(), 'Lastschrift: Überweisung an Konto 2')
    INSERT INTO Posting (AccountID_FK, Amount, ExecutionDate, Notes) 
        VALUES(2, @amount, GetDate(), 'Gutschrift: Überweisung von Konto 1')   -- ====> GetDate() Funktion

    -- Commit der Transaktion
    COMMIT TRANSACTION

    -- Erfolgsmeldung ausgeben
    SELECT 'COMMITED: Transaktion von CHF 500 war erfolgreich!' AS Meldung
END TRY

BEGIN CATCH
    -- Dieser Codeblock wird ausgeführt, sollte eine der Anweisungen fehlerhaft sein.
    -- Rollback der Transaktion
    ROLLBACK TRANSACTION
    
    -- Fehlermeldung ausgeben
    SELECT 'ROLLBACK: Zu wenig Geld auf dem Konto!' AS Meldung
END CATCH

-- prüfen, ob Geld angekommen u. Buchungseinträge erstellt 
--  (alles oder nichts?)
select * from Account
select * from Posting