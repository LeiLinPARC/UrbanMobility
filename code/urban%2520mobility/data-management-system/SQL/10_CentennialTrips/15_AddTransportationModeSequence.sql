
USE UrbanMobility;

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'mode_sequence'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN mode_sequence;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD mode_sequence VARCHAR(200);
GO



WITH orders AS (
	SELECT	id, 
			STUFF((
				SELECT ',' + mode
				FROM CentennialTripPlanSegments
				WHERE id = a.id
				FOR XML PATH ('')), 1, 1, '')  AS mode_sequence
	FROM CentennialTripPlanSegments AS a
	GROUP BY id
)


MERGE INTO CentennialTripPlan AS tgt
USING orders AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.mode_sequence = src.mode_sequence;


-- Results
SELECT *
FROM CentennialTripPlan







