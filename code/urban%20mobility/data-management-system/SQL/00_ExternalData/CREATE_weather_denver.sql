
USE UrbanMobility
GO

IF OBJECT_ID('WeatherDenver', 'U') IS NOT NULL 
  DROP TABLE WeatherDenver

CREATE TABLE WeatherDenver
(
	weather_date DATETIME,
	time_hour INT,
	hourly_data_exists INT, 
	temperature FLOAT,
	visibility FLOAT,
	wind_speed FLOAT,
	precipitation FLOAT,
	events VARCHAR(50),
	conditions VARCHAR(50)
)


BULK INSERT WeatherDenver
FROM 'C:\Users\usx21753\urbanmobility\weatherDenver.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n'  --Use to shift the control to next row
)
GO
