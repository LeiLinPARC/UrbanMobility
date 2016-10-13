
USE UrbanMobility;

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'mode_seq_after_dcLightRail'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN mode_seq_after_dcLightRail;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD mode_seq_after_dcLightRail VARCHAR(200);
GO


WITH destination_centennial AS (
	SELECT	*,
			RIGHT(mode_sequence, (CHARINDEX('mart', REVERSE(mode_sequence))-2)) AS after_tram
	FROM CentennialTripPlan
	WHERE CHARINDEX('mart', REVERSE(mode_sequence)) > 1
	AND involve_DC_light_rail = 1
	AND destination_in_centennial = 1
),

origin_centennial AS (
	SELECT	*,
			RIGHT( mode_sequence, (LEN(mode_sequence) - (CHARINDEX('tram', mode_sequence)+4)) ) AS after_tram
	FROM CentennialTripPlan
	WHERE (LEN(mode_sequence) - (CHARINDEX('tram', mode_sequence)+4)) > 1
	AND involve_DC_light_rail = 1
	AND origin_in_centennial = 1
),

all_centennial AS (
	SELECT *
	FROM destination_centennial
	UNION
	SELECT *
	FROM origin_centennial
)

MERGE INTO CentennialTripPlan AS tgt
USING all_centennial  AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET tgt.mode_seq_after_dcLightRail = src.after_tram;


-- Results
SELECT *
FROM CentennialTripPlan
ORDER BY insertedAt




