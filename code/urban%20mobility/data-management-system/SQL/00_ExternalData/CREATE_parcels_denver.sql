
USE UrbanMobility;
GO

IF OBJECT_ID('tempdb.dbo.#ParcelsDenver', 'U') IS NOT NULL 
  DROP TABLE #ParcelsDenver
GO

CREATE TABLE #ParcelsDenver
(
	parcel_classification VARCHAR(200), 
	lng FLOAT,
	lat FLOAT
)
GO


BULK INSERT #ParcelsDenver
FROM 'C:\Users\usx21753\urbanmobility\parcels_denver_DB.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n'  --Use to shift the control to next row
)
GO


-- Now, clean this temporary table and create the permanent table...
--	1) Group classification categories
--	2) Create a distinct classification for each GPS location

IF OBJECT_ID('ParcelsDenver', 'U') IS NOT NULL 
  DROP TABLE ParcelsDenver;
GO


WITH parcel_breakdown AS (
	SELECT	parcel_classification,
			COUNT(*) AS freq,
			ROUND( (CAST(100 AS FLOAT) * CAST(COUNT(*) AS FLOAT) / CAST( (SELECT COUNT(*) FROM #ParcelsDenver) AS FLOAT)), 3) 
				AS pct
	FROM #ParcelsDenver
	GROUP BY parcel_classification
),

-- To save time, don't form new parcel classification types for parcels that occur in less than 0.01 percent of the table
-- Note: CASE WHEN is based on the first match
parcel_grouping AS (
	SELECT	*,
			CASE	WHEN parcel_classification LIKE '%SINGLE FAMILY%' THEN 'residential'
					WHEN parcel_classification LIKE '%CONDOMINIUM%' THEN 'residential' 
					WHEN parcel_classification LIKE '%ROWHOUSE%' THEN 'residential'
					WHEN parcel_classification LIKE '%APT%' THEN 'residential'
					WHEN parcel_classification LIKE '%CONDO PKG%' THEN 'residential'

					WHEN parcel_classification LIKE '%WAREHOUSE%' THEN 'industrial'
					WHEN parcel_classification LIKE '%VCNT%' THEN 'vacant lot'
					WHEN parcel_classification LIKE '%OFFICE%' THEN 'office'
					WHEN parcel_classification LIKE '%RETAIL%' THEN 'retail'
					WHEN parcel_classification LIKE '%PARKING%' THEN 'parking facility'

					WHEN parcel_classification LIKE '%RESTAURANT%' THEN 'restaurant'
					WHEN parcel_classification LIKE '%AUTO SERVICE%' THEN 'commercial other'
					WHEN parcel_classification LIKE '%CHURCH%' THEN 'church'
					WHEN parcel_classification LIKE '%SCHOOL%' THEN 'school'
					WHEN parcel_classification LIKE '%MOBILE HOME%' THEN 'residential'

					WHEN parcel_classification LIKE '%FACTORY%' THEN 'industrial'
					WHEN parcel_classification LIKE '%SHOPPING%' THEN 'retail'
					WHEN parcel_classification LIKE '%FRANCHISE REST%' THEN 'restaurant'
					WHEN parcel_classification LIKE '%DENVER HOUSING AUTH%' THEN 'government'
					WHEN parcel_classification LIKE '%DENVER PARK%' THEN 'park'

					WHEN parcel_classification LIKE '%MEDICAL%' THEN 'medical'
					WHEN parcel_classification LIKE '%SHOPPETTE%' THEN 'retail'
					WHEN parcel_classification LIKE '%GAS STATION%' THEN 'commercial other'
					WHEN parcel_classification LIKE '%APARTMENT%' THEN 'residential'
					WHEN parcel_classification LIKE '%FINANCIAL%' THEN 'industrial'

					WHEN parcel_classification LIKE '%BOARDING HOME%' THEN 'residential'
					WHEN parcel_classification LIKE '%MINI STORAGE%' THEN 'industrial'
					WHEN parcel_classification LIKE '%FOOD PROCESS%' THEN 'industrial'
					WHEN parcel_classification LIKE '%NURSING HOME%' THEN 'residential'
					WHEN parcel_classification LIKE '%AUTO DEAL%' THEN 'commercial other'

					WHEN parcel_classification LIKE '%LIBRARY%' THEN 'library'
					WHEN parcel_classification LIKE '%RESD%' THEN 'residential'
					WHEN parcel_classification LIKE '%SUPERMKT%' THEN 'retail'
					WHEN parcel_classification LIKE '%LAUNDROMAT%' THEN 'commercial other'
					WHEN parcel_classification LIKE '%HOTEL%' THEN 'hotel'

					WHEN parcel_classification LIKE '%FIRE STATION%' THEN 'fire station'
					WHEN parcel_classification LIKE '%MANUFACTURING%' THEN 'industrial'
					WHEN parcel_classification LIKE '%CARWASH%' THEN 'commercial other'
					WHEN parcel_classification LIKE '%PBG%' THEN 'residential'

					WHEN pct >= 0.01 THEN 'other'
					ELSE LOWER(parcel_classification) END AS parcel_classification_type
	FROM parcel_breakdown
),

/*
-- just to look at mapping
SELECT *
FROM join_groups
*/


join_groups AS (
	SELECT	a.*,
			b.parcel_classification_type
	FROM #ParcelsDenver a
	INNER JOIN parcel_grouping b
	ON a.parcel_classification = b.parcel_classification
),



counts_of_each_type_at_each_location AS (
	SELECT	lat,
			lng,
			parcel_classification_type,
			type_count = COUNT(parcel_classification_type)
	FROM join_groups
	GROUP BY lat, lng, parcel_classification_type
),

-- Note: if there is tie in terms of the mode, then the selection is the first that comes alphabetically
-- This is a results of using ROW_NUMBER()
choose_type_at_each_location AS (
	SELECT	lat,
			lng,
			parcel_classification = parcel_classification_type
	FROM (
		SELECT *,
        row_num = ROW_NUMBER() OVER(PARTITION BY lat, lng ORDER BY type_count DESC)
        FROM counts_of_each_type_at_each_location ) a
	WHERE row_num = 1
)


SELECT *
INTO ParcelsDenver
FROM choose_type_at_each_location;


-- Results
SELECT *
FROM ParcelsDenver

