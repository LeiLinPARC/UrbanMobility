
USE UrbanMobility;
GO

-- Delete the table if it exists.
IF OBJECT_ID('CentennialTripPlan', 'U') IS NOT NULL 
  DROP TABLE CentennialTripPlan;


DECLARE @area GEOGRAPHY;
DECLARE @coords NVARCHAR(200);

/*
	Polygon around centennial:
	- same beginning and end point
	- longitude first, latitude second
	- order of points is counterclockwise
	- limit to six decimal places
	- gps coordinates found on this website: http://codepen.io/jhawes/pen/ujdgK
	- or here: http://drawingtool.powertoolsfortableau.com/ (better tool)
*/
SET @coords =	'-104.886045 39.596893, ' +
				'-104.904156 39.597025, ' +
				'-104.904156 39.580489, ' +
				'-104.923038 39.580621, ' +
				'-104.923124 39.565934, ' +
				'-104.871969 39.565934, ' +
				'-104.874802 39.577909, ' +
				'-104.886045 39.596893';
				
SET @area = geography::Parse('POLYGON ((' + @coords + '))');

WITH origins AS (
	SELECT	id,
			from_lng,
			from_lat,
			geography::STGeomFromText('POINT('+CONVERT(VARCHAR(20),from_lng)+' '+CONVERT(VARCHAR(20),from_lat)+')',4326)
				AS from_geography
	FROM TripPlan
),

origins_wrt_centennial AS (
	SELECT	*,
			CASE WHEN @area.STContains(from_geography) = 1 THEN 1 ELSE 0 END AS origin_in_centennial 
	FROM origins
),

destinations AS (
	SELECT	id,
			to_lng,
			to_lat,
			geography::STGeomFromText('POINT('+CONVERT(VARCHAR(20),to_lng)+' '+CONVERT(VARCHAR(20),to_lat)+')',4326)
				AS to_geography
	FROM TripPlan
),

destinations_wrt_centennial AS (
	SELECT	*,
			CASE WHEN @area.STContains(to_geography) = 1 THEN 1 ELSE 0 END AS destination_in_centennial 
	FROM destinations
),

pilot_trips AS (
	SELECT *
	FROM TripPlan
	WHERE insertedAt >= Convert(datetime, '2016-08-17 08:00:00')
),

all_centennialIO_trips AS (
	SELECT	a.*, b.origin_in_centennial, c.destination_in_centennial
	FROM pilot_trips a
	INNER JOIN origins_wrt_centennial b
	ON a.id = b.id
	INNER JOIN destinations_wrt_centennial c
	ON a.id = c.id
	WHERE (b.origin_in_centennial = 1 AND c.destination_in_centennial = 0)
	OR (b.origin_in_centennial = 0 AND c.destination_in_centennial = 1)
),

all_dryCreekLightRail_trips AS (
	SELECT DISTINCT id
	FROM TripPlanSegments
	WHERE from_address LIKE 'Dry Creek Station'
	OR to_address LIKE 'Dry Creek Station'
),

all_centennialIO_trips_with_dryCreekInfo AS (
	SELECT	a.*,
			CASE WHEN b.id IS NULL THEN 0 ELSE 1 END AS involve_DC_light_rail
	FROM all_centennialIO_trips a
	LEFT JOIN all_dryCreekLightRail_trips b
	ON a.id = b.id
)


SELECT *
INTO CentennialTripPlan
FROM all_centennialIO_trips_with_dryCreekInfo


-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY insertedAt

SELECT *
FROM CentennialTripPlan
WHERE involve_DC_light_rail = 1
ORDER BY queryTime





