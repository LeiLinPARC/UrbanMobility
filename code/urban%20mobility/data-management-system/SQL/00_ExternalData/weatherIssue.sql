
USE UrbanMobility;
GO

SELECT *
FROM weatherDenver
WHERE weather_date = '2016-03-13 00:00:00.000'
OR weather_date = '2016-03-14 00:00:00.000'

/*
SELECT id, insertedAt, queryTime, depart,
		dateadd(hour,-8,insertedAt) as insertedAtCent
FROM CentennialTripPlan
ORDER BY insertedAt
*/
-- Centennial time is 8 hours behind insertedAt time