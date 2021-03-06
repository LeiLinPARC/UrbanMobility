
USE UrbanMobility
GO

-- Trips
--SELECT *
--FROM TripPlan


-- Number of trips
SELECT COUNT(*) as num_distinct_trips
FROM TripPlan;


-- Number of trips by city
SELECT appcity, COUNT(*) AS num_distinct_trips
FROM TripPlan
GROUP BY appcity
ORDER BY COUNT(*) DESC;


-- Me
SELECT *
FROM TripPlan
WHERE anonymous_id = 'ebc13da53674f8d2'


-- Rochester user location
SELECT *
FROM TripPlan
WHERE user_location_lat <= 44
AND user_location_lat >= 43
AND user_location_lng <= -77
AND user_location_lng >= -78
ORDER BY queryTime
