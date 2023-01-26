USE WideWorldImporters;

CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123_MyComplexPassword';  

CREATE CERTIFICATE SuppliersBAN
   WITH SUBJECT = 'Suppliers Bank Account Number';  
GO  

CREATE SYMMETRIC KEY SSN_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE SuppliersBAN;  
GO  

ALTER TABLE Purchasing.Suppliers
    ADD EncryptedBAN varbinary(128);   
GO  

OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE SuppliersBAN;  

UPDATE Purchasing.Suppliers  
SET EncryptedBAN = EncryptByKey(Key_GUID('SSN_Key_01'), BankAccountNumber);  
GO  


SELECT BankAccountNumber, EncryptedBAN
    AS 'Encrypted Bank Account Number',  
    CONVERT(nvarchar, DecryptByKey(EncryptedBAN))   
    AS 'Decrypted Bank Account Number'  
    FROM Purchasing.Suppliers;  
GO

CLOSE SYMMETRIC KEY SSN_Key_01;
GO






USE WideWorldImporters;

/*
falls noch nicht vorhanden, einen Database Master Key erstellen.
Der Key muss in der DB WideWorldImporters erstellt sein
*/
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123_MyComplexPassword';  

-- ein Zertifikat erstellen
CREATE CERTIFICATE SuppliersBAN
   WITH SUBJECT = 'Suppliers Bank Account Number';  
GO  

-- symmetrischen Key erstellen
CREATE SYMMETRIC KEY SSN_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE SuppliersBAN;  
GO  

-- neue Spalte für die verschlüsselten Daten hinzufügen  
ALTER TABLE Purchasing.Suppliers
    ADD EncryptedBAN varbinary(128);   
GO  

-- den symmetrischen Key öffnen, mit welchem die Daten verschlüsselt werden sollen  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE SuppliersBAN;  

/* 
die Werte in der Spalte BankAccountNumber mit dem symmetrischen Key SSN_Key_01
verschlüsseln und in der neuen Spalte EncryptedBAN speichern
*/ 
UPDATE Purchasing.Suppliers  
SET EncryptedBAN = EncryptByKey(Key_GUID('SSN_Key_01'), BankAccountNumber);  
GO  

/*
Prüfen, ob die Verschlüsselung erfolgreich war 
bei der Ausgabe dieser Abfrage müssten nun die Werte der ersten Spalte mit den
Werten der dritten Spalte übereinstimmen 
*/
SELECT BankAccountNumber, EncryptedBAN
    AS 'Encrypted Bank Account Number',  
    CONVERT(nvarchar, DecryptByKey(EncryptedBAN))   
    AS 'Decrypted Bank Account Number'  
    FROM Purchasing.Suppliers;  
GO

-- Symmetrischen Key wieder schliessen
CLOSE SYMMETRIC KEY SSN_Key_01;
GO