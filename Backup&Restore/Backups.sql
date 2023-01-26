USE WideWorldImporters;
GO

-- Vollständige Sicherung
BACKUP DATABASE [WideWorldImporters]
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters.bak' 
WITH NOFORMAT, NOINIT, NAME = N'WideWorldImporters vollständige Datenbanksicherung', SKIP, STATS = 10
GO

-- Differenzielle Sicherung
BACKUP DATABASE [WideWorldImporters]   
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters_DIFF.bak'   
WITH DIFFERENTIAL;  
GO 

-- Transaktionsprotokoll Sicherung
/*Nur im Wiederherstellungsmodell "vollständig" möglich und 
wenn bereits eine Datenbanksicherung vorhanden ist*/
BACKUP LOG [WideWorldImporters]
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters_LOG.trn'  
WITH INIT, NAME = N'WideWorldImporters_Log'
GO