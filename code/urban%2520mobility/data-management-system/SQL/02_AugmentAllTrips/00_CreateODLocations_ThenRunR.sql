
USE UrbanMobility;

/*
DROP TABLE ODLocations;
GO
*/


-- Only create the table if it doesn't exist
IF NOT EXISTS
	(SELECT * FROM sysobjects WHERE name='ODLocations' and xtype='U')
	CREATE TABLE ODLocations
	(
		gps_ID INT,
		lat FLOAT,
		lng FLOAT,
		location VARCHAR(15),
		denver_neighborhood VARCHAR(200),
		denver_land_use VARCHAR(200),
		centennial_zoning_class VARCHAR(200),
		la_land_use VARCHAR(200),
		fips_code BIGINT,
		employed FLOAT,
		high_school FLOAT,
		bach_degree FLOAT
	)
GO

-- Get all OD coordinates from the Centennial trips
WITH OD_coordinates AS (
	SELECT	to_lat AS lat, 
			to_lng AS lng
	FROM TripPlan
	UNION
	SELECT from_lat AS lat,
			from_lng AS lng
	FROM TripPlan
)

-- Insert only new lat, lng coordinates
INSERT ODLocations (lat, lng)
SELECT lat, lng
FROM OD_coordinates a
WHERE
   NOT EXISTS (SELECT * FROM ODLocations b
			   WHERE a.lat = b.lat
			   AND a.lng = b.lng);
GO


WITH update_row_number AS (
	SELECT lat, lng, ROW_NUMBER() OVER (ORDER BY lat) AS rn
	FROM ODLocations
)

UPDATE ODLocations
SET gps_ID = rn
FROM ODLocations
INNER JOIN update_row_number 
ON ODLocations.lat = update_row_number.lat
AND ODLocations.lng = update_row_number.lng


/* #######################################
Then run R scripts to fill in NULL values for these columns:
Location Data
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external\
Files:
	1) GPSLocation\getLocation.R

Denver Specific Data:
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external\Denver\
Files:
	1) denverNeighborhoods\getNeighborhoods.R
	2) denverLandUse\getLandUse.R
	3) centennialZoning\getZoning.R

LA Specific Data:
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external\LA\
Files:
	1) laLandUse\getLandUse.R

Census/ACS Specific Data:
Directory: C:\Users\usx21753\Desktop\Transportation\UrbanMobility\Analytics\data\external
Files:
	1) FIPSCodes\getFipsCodes.R (required)
	2) ACS\RLoadingScripts\getEmploymentData.R
	3) ACS\RLoadingScripts\getEducationData.R
-- #######################################
*/ 

-- Results
SELECT *
FROM ODLocations
ORDER BY gps_ID

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