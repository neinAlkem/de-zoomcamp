

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

    FROM {{ ref('dim_zones') }}
)

SELECT 
    fhv_trip.*, 
    zone.*,      
FROM fhv_trip
JOIN zone pu
    ON fhv_trip.PULocationID = pu.locationid
JOIN zone do
    on fhv_trip.DOLocationID = do.locationid
