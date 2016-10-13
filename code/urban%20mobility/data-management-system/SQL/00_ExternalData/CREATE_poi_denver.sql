
USE UrbanMobility
GO

IF OBJECT_ID('POIDenver', 'U') IS NOT NULL 
  DROP TABLE POIDenver

CREATE TABLE POIDenver
(
	poi_name VARCHAR(100),
	poi_address VARCHAR(50),
	lat FLOAT, 
	lng FLOAT,
	
)


BULK INSERT POIDenver
FROM 'C:\Users\usx21753\urbanmobility\points_of_interest_denver_DB.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n'  --Use to shift the control to next row
)
GO
