
USE UrbanMobility
GO

IF OBJECT_ID('BusinessesLA', 'U') IS NOT NULL 
  DROP TABLE BusinessesLA

CREATE TABLE BusinessesLA
(
	business_description VARCHAR(200),
	lat FLOAT, 
	lng FLOAT,
	
)


BULK INSERT BusinessesLA
FROM 'C:\Users\usx21753\urbanmobility\businesses_la_DB.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n'  --Use to shift the control to next row
)
GO
