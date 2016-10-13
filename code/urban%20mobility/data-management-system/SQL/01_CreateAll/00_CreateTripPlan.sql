
USE UrbanMobility
GO

IF OBJECT_ID('TripPlan', 'U') IS NOT NULL 
  DROP TABLE TripPlan

CREATE TABLE TripPlan
(
	-- 1-5
	id INT,
	sessionID VARCHAR(50),
	insertedAt DATETIME,
	to_lat FLOAT,
	to_lng FLOAT,

	-- 6-10
	to_address VARCHAR(200),
	from_lat FLOAT, 
	from_lng FLOAT,
	from_address VARCHAR(200),
	arrive DATETIME,

	-- 11-15
	depart DATETIME,
	distance INT,
	timeCost INT,
	moneyCost FLOAT,
	queryTime DATETIME,

	-- 16-20
	carbonCost FLOAT,
	caloriesCost FLOAT,
	queryIsLeaveAfter VARCHAR(10),
	appcity VARCHAR(15),
	anonymous_id VARCHAR(40),

	-- 21-25
	user_location_lat FLOAT,
	user_location_lng FLOAT,
	localsearchdatetime DATETIME,
	localtimezone FLOAT,
	app_identifier VARCHAR(50),

	-- 26-30
	preference_distanceunit VARCHAR(10),
	preference_default_tripsort VARCHAR(10),
	preference_car VARCHAR(15),
	preference_walkspeed INT,
	preference_maxwalksecs INT,

	-- 31-35
	preference_mintransfersecs INT,
	preference_vot INT,
	preference_current_tripsort VARCHAR(10),
	preference_transport_pt VARCHAR(3),
	preference_transport_taxi VARCHAR(3),

	-- 36-40
	preference_transport_flit VARCHAR(3),
	preference_transport_lyft VARCHAR(3),
	preference_transport_car VARCHAR(3),
	preference_transport_c2g VARCHAR(3),
	preference_transport_zip VARCHAR(3),

	-- 41-45
	preference_transport_mot VARCHAR(3),
	preference_transport_bike VARCHAR(3),
	preference_transport_boulder_bike VARCHAR(3),
	preference_transport_denver_bike VARCHAR(3),
	preference_transport_bike_share VARCHAR(3)
)


BULK INSERT TripPlan
FROM 'C:\Users\usx21753\urbanmobility\tripPlan.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n'  --Use to shift the control to next row
)
GO



SELECT *
FROM TripPlan
ORDER BY insertedAt
