
USE UrbanMobility;
GO

-- drop columns if they exist
IF EXISTS(
    SELECT TOP(1) 1
    FROM sys.columns 
    WHERE Name = N'queryTime_temperature'
    AND Object_ID = Object_ID(N'CentennialTripPlan'))
BEGIN
    ALTER TABLE CentennialTripPlan
	DROP COLUMN queryTime_temperature,
				queryTime_conditions;
END
GO


-- add column
ALTER TABLE CentennialTripPlan 
ADD queryTime_temperature FLOAT,
	queryTime_conditions VARCHAR(50);
GO



WITH centennial_with_weather AS (
	SELECT	a.*,
			ROUND(b.temperature,0) AS temperature,
			b.conditions
	FROM CentennialTripPlan a
	LEFT JOIN WeatherDenver b
	ON CAST(FLOOR(CAST( (DATEADD(HOUR,-8,insertedAt)) AS float)) AS DATETIME) = b.weather_date
	AND DATEPART(hh, (DATEADD(HOUR,-8,insertedAt))) = b.time_hour
)



MERGE INTO CentennialTripPlan AS tgt
USING centennial_with_weather AS src
ON tgt.id = src.id
WHEN MATCHED THEN
    UPDATE SET	tgt.queryTime_temperature = src.temperature,
				tgt.queryTime_conditions = src.conditions;
GO




-- Results
SELECT *
FROM CentennialTripPlan;
