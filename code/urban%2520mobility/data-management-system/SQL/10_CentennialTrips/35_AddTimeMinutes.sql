
USE UrbanMobility;
GO


-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'trip_time_minutes'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN trip_time_minutes;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD trip_time_minutes FLOAT;
GO

WITH add_minutes AS (
	SELECT	id, 
			timeCost,
			ROUND( (CAST(timeCost AS FLOAT) / CAST(60 AS FLOAT)), 0) AS time_min
	FROM CentennialTripPlan
)

MERGE INTO CentennialTripPlan AS tgt
USING add_minutes AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.trip_time_minutes = src.time_min;
GO




-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY queryTime