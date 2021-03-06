/****** Script for SelectTopNRows command from SSMS  ******/

USE UrbanMobility;


-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'free_lyft_ride'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN free_lyft_ride;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD free_lyft_ride INT NOT NULL CONSTRAINT tbl_temp_default DEFAULT 0;
ALTER TABLE CentennialTripPlan
DROP CONSTRAINT tbl_temp_default;
GO


DECLARE @area GEOGRAPHY;
DECLARE @coords NVARCHAR(200);

SET @coords =	'-104.886045 39.596893, ' +
				'-104.904156 39.597025, ' +
				'-104.904156 39.580489, ' +
				'-104.923038 39.580621, ' +
				'-104.923124 39.565934, ' +
				'-104.871969 39.565934, ' +
				'-104.874802 39.577909, ' +
				'-104.886045 39.596893';
				
SET @area = geography::Parse('POLYGON ((' + @coords + '))');


WITH lyft_rides AS (
	SELECT *
	FROM [UrbanMobility].[dbo].[CentennialTripPlanSegments]
	WHERE mode_tsp = 'Lyft'
	AND mode_cost = 0
),

add_geo AS (
	SELECT	*,
			geography::STGeomFromText('POINT('+CONVERT(VARCHAR(20),from_lng)+' '+CONVERT(VARCHAR(20),from_lat)+')',4326)
				AS from_geography,
			geography::STGeomFromText('POINT('+CONVERT(VARCHAR(20),to_lng)+' '+CONVERT(VARCHAR(20),to_lat)+')',4326)
				AS to_geography
	FROM lyft_rides
),

locations_wrt_centennial AS (
	SELECT	*,
			CASE WHEN @area.STContains(from_geography) = 1 THEN 1 ELSE 0 END AS from_in_centennial,
			CASE WHEN @area.STContains(to_geography) = 1 THEN 1 ELSE 0 END AS to_in_centennial  
	FROM add_geo
),


lyft_trip_in_centennial AS (
	SELECT *
	FROM locations_wrt_centennial
	WHERE from_in_centennial = 1
	AND to_in_centennial = 1 
),

also_used_dcs AS (
	SELECT	*,
			free_lyft_ride = 1
	FROM lyft_trip_in_centennial
	WHERE id IN (SELECT id FROM CentennialTripPlan WHERE involve_DC_light_rail = 1)
)


MERGE INTO CentennialTripPlan AS tgt
USING also_used_dcs AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.free_lyft_ride = src.free_lyft_ride;
GO



-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY insertedAt