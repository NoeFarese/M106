USE WideWorldImporters;
GO

INSERT INTO Application.People 
(
    PersonId, FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider,
    HashedPassword, IsSystemUser, IsEmployee, IsSalesperson, UserPreferences, PhoneNumber, FaxNumber,
    EmailAddress, Photo, CustomFields, LastEditedBy
) VALUES (
    1500,
    'Maria Herzog',
    'Maria',
    0,
    'NO LOGON',
    0,
    NULL,
    0,
    0,
    0,
    NULL,
    '+41 44 124 34 45',
    NULL,
    'maria@spielhandelsag.ch',
    NULL,
    NULL,
    1
);

INSERT INTO Application.People (
    PersonId, FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider,
    HashedPassword, IsSystemUser, IsEmployee, IsSalesperson, UserPreferences, PhoneNumber, FaxNumber,
    EmailAddress, Photo, CustomFields, LastEditedBy
) VALUES
    (1501, 'Sepp Stricher', 'Sepp', 0, 'NO LOGON', 0, NULL, 0, 0, 0, NULL, '+41 79 123 12 12', NULL, 'sepp.stricher@gmx.ch', NULL, NULL, 1),
    (1502, 'Peter Lacher', 'Peter', 0, 'NO LOGON', 0, NULL, 0, 0, 0, NULL, '+41 56 355 56 23', NULL, 'peter.lacher@gmx.ch', NULL, NULL, 1),
    (1503, 'Franz Müller', 'Franz', 0, 'NO LOGON', 0, NULL, 0, 0, 0, NULL, '+41 77 546 23 90', NULL, 'franz.mueller@gmx.ch', NULL, NULL, 1);


SELECT * FROM Application.People where PersonID = 1502   

INSERT INTO Sales.Customers (
    CustomerId, CustomerName, BillToCustomerId, CustomerCategoryId, BuyingGroupId, PrimaryContactPersonId, AlternateContactPersonId,
    DeliveryMethodID, DeliveryCityId, PostalCityId, CreditLimit, AccountOpenedDate, StandardDiscountPercentage,
    IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun,
    RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
    PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy
) VALUES (1100, 'SpielHandels AG', 1100, 5, NULL, 1500, 1503, 3, 35684, 35684, 3000.00, GETDATE(), 0.000, 0, 0, 7, '+41 41 123 34 45', 'n/a', NULL, NULL, 'http://www.spielhandelsag.ch', 'Stadtstrasse 12', '6000 Luzern', 35684, NULL, 'Stadtstrasse 12', 'Luzern', 35684, 1)


SELECT * FROM Sales.Customers WHERE CustomerID = 1100;

UPDATE Application.People SET FullName = 'Peter Meier' WHERE PersonId = 1502;
SELECT * FROM Application.People where PersonID = 1502;

DELETE FROM Application.People WHERE PersonID = 1503;
SELECT * FROM Application.People WHERE FullName = 'Franz Müller';