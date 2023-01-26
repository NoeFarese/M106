-- SQL Server-Login erstellen
USE master;
CREATE LOGIN stricher
WITH PASSWORD = 'stricherspasswort', CHECK_POLICY = OFF;

ALTER LOGIN STRICHER
WITH
DEFAULT_DATABASE = master,
CHECK_EXPIRATION = OFF;

-- Einem Login ein User zuordnen
USE WideWorldImporters;
CREATE USER stricher FOR LOGIN stricher;

-- Dem Login eine Serverrolle zuweisen
USE master;
ALTER SERVER ROLE securityadmin ADD MEMBER stricher;

-- Dem Login eine Serverrolle wieder entziehen
ALTER SERVER ROLE securityadmin DROP MEMBER stricher;

-- Dem User eine Datenbankrolle zuweisen
USE WideWorldImporters;
ALTER ROLE db_datareader ADD MEMBER stricher;

-- Dem User eine Rolle wieder entziehen
ALTER ROLE db_datareader DROP MEMBER stricher;




-- Objektberechtigung vergeben
GRANT INSERT, UPDATE, DELETE ON application.people TO stricher;

-- Objektberechtigungen allen Usern vergeben
GRANT UPDATE ON Warehouse.colors TO PUBLIC;

/* 
Objektberechtigung vergeben inkl. dem Recht, diese Objektberechtigung 
an andere User weiterzugeben 
*/
GRANT INSERT ON application.countries TO stricher WITH GRANT OPTION;

-- Anweisungsberechtigung vergeben
GRANT CREATE TABLE TO stricher;

-- Objektberechtigung auf alle Objekte eines Schemas vergeben
GRANT SELECT, UPDATE ON SCHEMA::sales TO stricher;



-- Objektberechtigung entziehen
REVOKE DELETE ON application.people FROM stricher;
/* 
Objektberechtigung entziehen inkl. dem Recht, diese Objektberechtigung 
an andere User weiterzugeben. Mit CASCADE wird die Objektberechtigung auch
gleich all jenen Usern entzogen, die diese Berechtigung von dem User mit der
GRANT OPTION erhalten haben
*/
REVOKE GRANT OPTION FOR INSERT ON application.countries FROM stricher CASCADE;

-- Anweisungsberechtigung entziehen
REVOKE CREATE TABLE FROM stricher;

-- Objektberechtigung auf alle Objekte eines Schemas entziehen
REVOKE SELECT, UPDATE ON SCHEMA::schema_name FROM stricher;


-- Objektberechtigung verweigern
DENY SELECT, INSERT, UPDATE, DELETE ON table_name TO database_user;

-- Objektberechtigung allen Usern verweigern
DENY UPDATE ON table_name TO PUBLIC;

-- Anweisungsberechtigung verweigern
DENY CREATE TABLE TO database_user;

-- Objektberechtigung auf alle Objekte eines Schemas verweigern
DENY SELECT, UPDATE ON SCHEMA::schema_name TO database_user;