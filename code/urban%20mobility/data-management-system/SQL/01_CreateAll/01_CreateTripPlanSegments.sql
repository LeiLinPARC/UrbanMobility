
USE UrbanMobility
GO

IF OBJECT_ID('TripPlanSegments', 'U') IS NOT NULL 
  DROP TABLE TripPlanSegments

CREATE TABLE TripPlanSegments
(
	-- 1-5
	id	INT,
	seg_id INT,
	to_lat FLOAT,
	to_lng FLOAT,
	to_address VARCHAR(200),

	-- 6-10
	from_lat FLOAT,
	from_lng FLOAT, 
	from_address VARCHAR(200),
	startTime DATETIME,
	endTime DATETIME,

	-- 11-15
	travelDirection INT,
	metres INT,
	mode VARCHAR(20),
	class VARCHAR(20),
	mode_tsp VARCHAR(100),

	-- 16
	mode_cost FLOAT
)


BULK INSERT TripPlanSegments
FROM 'C:\Users\usx21753\urbanmobility\tripPlanSegments.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n'  --Use to shift the control to next row
)
GO
