
USE UrbanMobility;


-- TripPlan --------------------------------
SELECT COUNT(*)
FROM TripPlan;

WITH distinct_tripplan_ids AS (
	SELECT	MIN(id) AS id,
			to_lat, to_lng, to_address,							-- dest						
			from_lat, from_lng, from_address,					-- origin		
			arrive, depart,										-- times,	
			timeCost, moneyCost, carbonCost, caloriesCost,		-- additional info
			anonymous_id, appcity								-- general
	FROM TripPlan
	GROUP BY	to_lat, to_lng, to_address,							-- dest						
				from_lat, from_lng, from_address,					-- origin		
				arrive, depart,										-- times	
				timeCost, moneyCost, carbonCost, caloriesCost,		-- additional info
				anonymous_id, appcity								-- general
)

DELETE FROM TripPlan
WHERE id NOT IN (SELECT id FROM distinct_tripplan_ids);

SELECT COUNT(*)
FROM TripPlan;



-- TripPlanSegments --------------------------------
SELECT COUNT(*)
FROM TripPlanSegments;

WITH distinct_tripplan_ids AS (
	SELECT	MIN(id) AS id,
			to_lat, to_lng, to_address,							-- dest						
			from_lat, from_lng, from_address,					-- origin		
			arrive, depart,										-- times,	
			timeCost, moneyCost, carbonCost, caloriesCost,		-- additional info
			anonymous_id, appcity								-- general
	FROM TripPlan
	GROUP BY	to_lat, to_lng, to_address,							-- dest						
				from_lat, from_lng, from_address,					-- origin		
				arrive, depart,										-- times,	
				timeCost, moneyCost, carbonCost, caloriesCost,		-- additional info
				anonymous_id, appcity								-- general
)

DELETE FROM TripPlanSegments
WHERE id NOT IN (SELECT id FROM distinct_tripplan_ids);

SELECT COUNT(*)
FROM TripPlanSegments;