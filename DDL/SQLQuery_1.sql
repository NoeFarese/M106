USE master;
GO

CREATE DATABASE m106;
USE m106;
GO

CREATE SCHEMA verkauf;  
GO

CREATE TABLE verkauf.kunden (
    kundenid INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    vorname VARCHAR(30) NOT NULL,
    nachname VARCHAR(30) NOT NULL
);

ALTER TABLE verkauf.kunden ADD zweiter_vorname VARCHAR(30);
ALTER TABLE verkauf.kunden ALTER COLUMN zweiter_vorname VARCHAR(50);
ALTER TABLE verkauf.kunden DROP COLUMN zweiter_vorname;

CREATE TABLE kunden (
    kundenid INT NOT NULL IDENTITY(1,1),
    vorname VARCHAR(30) NOT NULL,
    nachname VARCHAR(30) NOT NULL
);

ALTER TABLE kunden ADD PRIMARY KEY (kundenid);
ALTER TABLE kunden ADD CONSTRAINT pk_kunden_blabla PRIMARY KEY (vorname, nachname);

DROP TABLE kunden;

CREATE TABLE verkauf.bestellungen (
    bestellid INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    produkt VARCHAR(30) NOT NULL,
    kundenid INT
);

ALTER TABLE verkauf.bestellungen
ADD CONSTRAINT fk_bestell_kunden FOREIGN KEY (kundenid) REFERENCES verkauf.kunden (kundenid)

ALTER TABLE verkauf.bestellungen ADD DEFAULT 'Jeans' FOR produkt;
ALTER TABLE verkauf.bestellungen ADD CHECK (bestellid < 256);