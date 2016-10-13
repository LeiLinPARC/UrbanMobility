
USE UrbanMobility;
GO

SELECT *
FROM CentennialTripPlan
WHERE (	origin_in_centennial = 1
		AND to_denver_neighborhood IN (	'Lodo','Golden Triangle','Five Points','Auraria','Jefferson Park',
										'Northwestern Denver','Central West Denver'))
OR (destination_in_centennial = 1
	AND from_denver_neighborhood IN (	'Lodo','Golden Triangle','Five Points','Auraria','Jefferson Park',
										'Northwestern Denver','Central West Denver'))

ORDER BY trip_time_minutes



SELECT *
FROM CentennialTripPlan
WHERE free_lyft_ride = 1
--AND depart < Convert(datetime, '2016-10-01 00:00:00')
ORDER BY depart
