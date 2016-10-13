
USE UrbanMobility;
GO


-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'from_fips_code'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN from_fips_code,
				to_fips_code;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD from_fips_code BIGINT,
	to_fips_code BIGINT;
GO

-- from_fips_code
UPDATE CentennialTripPlan
SET from_fips_code = fips_code
FROM CentennialODLocations
WHERE CentennialTripPlan.from_lat = CentennialODLocations.lat
AND CentennialTripPlan.from_lng = CentennialODLocations.lng;
GO

-- to_fips_code
UPDATE CentennialTripPlan
SET to_fips_code = fips_code
FROM CentennialODLocations
WHERE CentennialTripPlan.to_lat = CentennialODLocations.lat
AND CentennialTripPlan.to_lng = CentennialODLocations.lng;
GO

-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY queryTime


