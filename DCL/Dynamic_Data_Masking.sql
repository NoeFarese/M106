-- Default
ALTER TABLE Application.People
ALTER COLUMN LogonName ADD MASKED WITH (FUNCTION = 'default()')
SELECT * FROM Application.People;

-- Email
ALTER TABLE Application.People
ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'email()')

-- Random
ALTER TABLE Sales.Orders
ALTER COLUMN PickedByPersonID ADD MASKED WITH (FUNCTION = 'random(1, 99)')

-- Custom String
ALTER TABLE Application.People
ALTER COLUMN PhoneNumber ADD MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)')
 

 EXECUTE AS USER = 'Sophia';
 REVERT;
 SELECT USER_NAME()