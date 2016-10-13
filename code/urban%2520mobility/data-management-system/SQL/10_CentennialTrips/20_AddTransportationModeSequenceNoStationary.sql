
USE UrbanMobility;

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'mode_sequence_no_stationary_or_walk'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN mode_sequence_no_stationary_or_walk;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD mode_sequence_no_stationary_or_walk VARCHAR(200);
GO


WITH remove_stationary_and_walk AS (
	SELECT *
	FROM CentennialTripPlanSegments
	WHERE class != 'stationary'
	AND mode != 'walk'
),

orders AS (
	SELECT	id, 
			STUFF((
				SELECT ',' + mode
				FROM remove_stationary_and_walk
				WHERE id = a.id
				FOR XML PATH ('')), 1, 1, '')  AS mode_sequence_no_stationary_or_walk
	FROM remove_stationary_and_walk AS a
	GROUP BY id
)


MERGE INTO CentennialTripPlan AS tgt
USING orders AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.mode_sequence_no_stationary_or_walk = src.mode_sequence_no_stationary_or_walk;


-- Results
SELECT *
FROM CentennialTripPlan







