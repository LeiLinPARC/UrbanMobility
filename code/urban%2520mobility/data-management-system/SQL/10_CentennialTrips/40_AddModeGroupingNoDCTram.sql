
USE UrbanMobility;
GO

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'mode_group_no_dcLightRail'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN mode_group_no_dcLightRail;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD mode_group_no_dcLightRail VARCHAR(50);
GO

UPDATE CentennialTripPlan
SET	mode_group_no_dcLightRail = mode_sequence_no_stationary_or_walk
WHERE involve_DC_light_rail = 0;
GO


WITH arapahoe_station_trips AS (
	SELECT DISTINCT id
	FROM CentennialTripPlanSegments
	WHERE (from_address = 'Arapahoe at Village Center Station' AND mode = 'tram')
	OR (to_address = 'Arapahoe at Village Center Station' AND mode = 'tram')
),

county_line_station_trips AS (
	SELECT DISTINCT id
	FROM CentennialTripPlanSegments
	WHERE (from_address = 'County Line Station' AND mode = 'tram')
	OR (to_address = 'County Line Station' AND mode = 'tram')
),

dc_station_trips AS (
	SELECT DISTINCT id
	FROM CentennialTripPlan
	WHERE involve_DC_light_rail = 1
),

arapahoe_only_trips AS (
	SELECT	DISTINCT id,
			mode_group = 'arapahoe_station_light_rail'
	FROM arapahoe_station_trips
	WHERE id NOT IN (SELECT * FROM dc_station_trips)
),

county_line_only_trips AS (
	SELECT	DISTINCT id,
			mode_group = 'county_line_station_light_rail'
	FROM county_line_station_trips
	WHERE id NOT IN (SELECT * FROM dc_station_trips)
	AND id NOT IN (SELECT * FROM arapahoe_station_trips)
),

all_trips AS (
	SELECT *
	FROM arapahoe_only_trips
	UNION
	SELECT *
	FROM county_line_only_trips
)


MERGE INTO CentennialTripPlan AS tgt
USING all_trips AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.mode_group_no_dcLightRail = src.mode_group;
GO




-- Results
SELECT *
FROM CentennialTripPlan;

SELECT mode_group_no_dcLightRail, COUNT(*)
FROM CentennialTripPlan
WHERE involve_DC_light_rail = 0
GROUP BY mode_group_no_dcLightRail


