
USE UrbanMobility;
GO


-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'from_denver_land_use'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN from_denver_land_use,
				to_denver_land_use;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD from_denver_land_use VARCHAR(200),
	to_denver_land_use VARCHAR(200);
GO

-- from_denver_land_use
UPDATE CentennialTripPlan
SET from_denver_land_use = denver_land_use
FROM CentennialODLocations
WHERE CentennialTripPlan.from_lat = CentennialODLocations.lat
AND CentennialTripPlan.from_lng = CentennialODLocations.lng;
GO

-- to_denver_land_use
UPDATE CentennialTripPlan
SET to_denver_land_use = denver_land_use
FROM CentennialODLocations
WHERE CentennialTripPlan.to_lat = CentennialODLocations.lat
AND CentennialTripPlan.to_lng = CentennialODLocations.lng;
GO

-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY queryTime

SELECT *
FROM CentennialTripPlan
WHERE involve_DC_light_rail = 1
ORDER BY queryTime
