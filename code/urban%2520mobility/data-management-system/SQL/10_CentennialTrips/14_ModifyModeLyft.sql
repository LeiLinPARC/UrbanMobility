
USE UrbanMobility;



UPDATE CentennialTripPlanSegments
SET mode = 'lyft'
WHERE mode = 'taxi' AND mode_tsp = 'Lyft'


-- Results
SELECT *
FROM CentennialTripPlanSegments