
USE UrbanMobility;

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'mode_seq_before_dcLightRail'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN mode_seq_before_dcLightRail;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD mode_seq_before_dcLightRail VARCHAR(200);
GO


/*
WITH dc_light_rail_trips AS (
	SELECT	*,
			LEFT( mode_sequence, (charindex('tram', mode_sequence)-2) ) as before_tram
	FROM CentennialTripPlan
	WHERE charindex('tram', mode_sequence) > 1
	AND involve_DC_light_rail = 1
)
*/
WITH origin_centennial AS (
	SELECT	*,
			LEFT( mode_sequence, (CHARINDEX('tram', mode_sequence)-2) ) AS before_tram
	FROM CentennialTripPlan
	WHERE CHARINDEX('tram', mode_sequence) > 1
	AND involve_DC_light_rail = 1
	AND origin_in_centennial = 1
),

destination_centennial AS (
	SELECT	*,
			LEFT(mode_sequence, (LEN(mode_sequence) - (CHARINDEX('mart', REVERSE(mode_sequence))+4))) AS before_tram
	FROM CentennialTripPlan
	WHERE CHARINDEX('tram', mode_sequence) > 1
	AND involve_DC_light_rail = 1
	AND destination_in_centennial = 1
),

all_centennial AS (
	SELECT *
	FROM origin_centennial
	UNION
	SELECT *
	FROM destination_centennial
)

MERGE INTO CentennialTripPlan AS tgt
USING all_centennial  AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET tgt.mode_seq_before_dcLightRail = src.before_tram;


-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY insertedAt




