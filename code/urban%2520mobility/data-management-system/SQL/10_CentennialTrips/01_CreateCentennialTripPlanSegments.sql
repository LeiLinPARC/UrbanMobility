
USE UrbanMobility;

-- Delete the table if it exists.
IF OBJECT_ID('CentennialTripPlanSegments', 'U') IS NOT NULL 
  DROP TABLE CentennialTripPlanSegments;


WITH segments AS (
	SELECT *
	FROM TripPlanSegments
	WHERE id IN (SELECT id FROM CentennialTripPlan)
)


SELECT *
INTO CentennialTripPlanSegments
FROM segments


-- Results
SELECT *
FROM CentennialTripPlanSegments
ORDER BY id





