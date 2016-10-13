
USE UrbanMobility;

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'involves_tram'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN involves_tram;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD involves_tram VARCHAR(3);
GO



WITH data AS (
	SELECT *,
			CASE WHEN mode_sequence LIKE '%tram%' THEN 'yes' ELSE 'no' END AS tram
	FROM CentennialTripPlan
)


MERGE INTO CentennialTripPlan AS tgt
USING data AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.involves_tram = src.tram;





-- Results
SELECT *
FROM CentennialTripPlan







