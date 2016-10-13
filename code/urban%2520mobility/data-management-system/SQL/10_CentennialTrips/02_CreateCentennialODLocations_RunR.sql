
USE UrbanMobility;

/*
DROP TABLE CentennialODLocations;
GO
*/


-- Only create the table if it doesn't exist
IF NOT EXISTS
	(SELECT * FROM sysobjects WHERE name='CentennialODLocations' and xtype='U')
	CREATE TABLE CentennialODLocations
	(
		gps_ID INT,
		lat FLOAT,
		lng FLOAT,
		denver_neighborhood VARCHAR(200),
		denver_land_use VARCHAR(200),
		centennial_zoning_class VARCHAR(200),
		fips_code BIGINT,
		employed FLOAT,
		high_school FLOAT,
		bach_degree FLOAT
	)
GO

-- Get all OD coordinates from the Centennial trips
WITH centennial_OD_coordinates AS (
	SELECT	to_lat AS lat, 
			to_lng AS lng
	FROM CentennialTripPlan
	UNION
	SELECT from_lat AS lat,
			from_lng AS lng
	FROM CentennialTripPlan
)

-- Insert only new lat, lng coordinates
INSERT CentennialODLocations (lat, lng)
SELECT lat, lng
FROM centennial_OD_coordinates a
WHERE
   NOT EXISTS (SELECT * FROM CentennialODLocations b
			   WHERE a.lat = b.lat
			   AND a.lng = b.lng);
GO


WITH update_row_number AS (
	SELECT lat, lng, ROW_NUMBER() OVER (ORDER BY lat) AS rn
	FROM CentennialODLocations
)

UPDATE CentennialODLocations
SET gps_ID = rn
FROM CentennialODLocations
INNER JOIN update_row_number 
ON CentennialODLocations.lat = update_row_number.lat
AND CentennialODLocations.lng = update_row_number.lng


/* #######################################
Then run R scripts to fill in NULL values for these columns:

Denver Specific Data:
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external\Denver\
Files:
	1) \denverNeighborhoods\getNeighborhoods.R
	2) \denverLandUse\getLandUse.R
	3) \centennialZoning\getZoning.R

LA Specific Data:
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external\LA\
Files:
	1) \laLandUse\getLandUse.R

Census/ACS Specific Data:
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external\
Files:
	1) \FIPSCodes\getFipsCodes.R (required)
	2) \ACS\RLoadingScripts\getEmploymentData.R
	3) \ACS\RLoadingScripts\getEducationData.R
-- #######################################
*/ 

-- Results
SELECT *
FROM CentennialODLocations

--WHERE neighborhood IS NOT NULL



/*
-- If necessary, add more columns
ALTER TABLE CentennialODLocations
ADD high_school FLOAT;
GO

-- If necessary, drop columns
ALTER TABLE CentennialODLocations
DROP COLUMN high_school;
GO
*/