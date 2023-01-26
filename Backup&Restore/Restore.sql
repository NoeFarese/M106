USE WideWorldImporters;
GO

RESTORE DATABASE [WideWorldImporters]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters.bak'

RESTORE DATABASE [WideWorldImporters]
FROM DISK = N'C:\Pfad\zum\Backup.bak'
WITH
    MOVE 'WideWorldImporters' to 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WideWorldImporters-backup.mdf',
    MOVE 'WideWorldImporters_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WideWorldImporters-backup.ldf';
