USE master;
CREATE LOGIN ethan
WITH PASSWORD = 'WWI4eth!', CHECK_POLICY = OFF;

USE WideWorldImporters;
CREATE USER ethan FOR LOGIN ethan;
ALTER ROLE db_datareader ADD MEMBER ethan

GRANT UPDATE ON sales.Orders TO ethan;
GRANT UPDATE ON sales.OrderLines TO ethan;

DENY INSERT, UPDATE, DELETE ON Sales.Invoices TO ethan;
DENY INSERT, UPDATE, DELETE ON Sales.InvoiceLines TO ethan;

USE master;
GO

CREATE LOGIN stella
WITH PASSWORD = 'WWI4ste!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

ALTER ROLE bulkadmin ADD MEMBER stella;
GO

USE WideWorldImporters;
GO

CREATE USER stella FOR LOGIN stella
GO

GRANT INSERT ON SCHEMA:: Warehouse TO stella;
GO

GRANT ALTER ON SCHEMA::Warehouse TO stella;
GRANT CREATE TABLE TO stella;