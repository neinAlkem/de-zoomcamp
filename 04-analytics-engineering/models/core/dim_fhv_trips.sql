{{
    config(
        materialized='table'
    )
}}

WITH fhv_trip AS (
    SELECT 
        *,
        EXTRACT(year FROM pickup_datetime) AS year,
        EXTRACT(month FROM pickup_datetime) AS month
    FROM {{ ref('stg_fhv') }}
),
zone AS (
    SELECT 
        *,
        locationid AS zone_locationid  -- Rename locationid to zone_locationid in zone CTE
    FROM {{ ref('dim_zones') }}
)

SELECT 
    fhv_trip.*,  -- Select all columns from fhv_trip
    zone.*,      -- Select all columns from zone, which now has zone_locationid instead of locationid
    zone.zone_locationid AS zone_locationid  -- Explicitly select the renamed locationid
FROM fhv_trip
JOIN zone
    ON fhv_trip.PULocationID = zone.zone_locationid
    AND fhv_trip.DOLocationID = zone.zone_locationid;
