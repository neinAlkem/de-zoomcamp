

WITH fhv_trip AS (
    SELECT 
        *,
        EXTRACT(year FROM pickup_datetime) AS year,
        EXTRACT(month FROM pickup_datetime) AS month
    FROM {{ ref('stg_fhv') }}
),
zones AS (
    SELECT 
        *,

    FROM {{ ref('dim_zones') }}
)

SELECT 
    fhv_trip.*, 
    zones.*,      
FROM fhv_trip
JOIN zones pickup
    ON fhv_trip.PULocationID = pickup.locationid
JOIN zones dropoff
    on fhv_trip.DOLocationID = dropoff.locationid
