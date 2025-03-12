-- Select columns to be used
SELECT passenger_count,
    trip_distance,
    PULocationID,
    DOLocationID,
    payment_type,
    fare_amount,
    tolls_amount,
    tip_amount
FROM `indigo-muse-452811-u7.zoomcamp_taxi.yellow_tripdata_partioned`
WHERE fare_amount != 0;
-- Create table to be used as dataset
CREATE OR REPLACE TABLE zoomcamp_taxi.yellow_tripdata_ml (
        `passenger_count` INTEGER,
        `trip_distance` FLOAT64,
        `PULocationID` STRING,
        `DOLactionID` STRING,
        `payment_type` STRING,
        `fare_amount` FLOAT64,
        `tolls_amount` FLOAT64,
        `tip_amount` FLOAT64
    ) AS (
        SELECT passenger_count,
            trip_distance,
            CAST(PULocationID AS STRING),
            CAST(DOLocationID AS STRING),
            CAST(Payment_type AS STRING),
            fare_amount,
            tolls_amount,
            tip_amount
        FROM `indigo-muse-452811-u7.zoomcamp_taxi.yellow_tripdata_partioned`
        WHERE fare_amount != 0
    );
-- Create model with default setting
CREATE OR REPLACE MODEL zoomcamp_taxi.yellow_taxi_tip_model OPTIONS (
        model_type = 'LINEAR_REG',
        input_label_cols = ['tip_amount'],
        data_split_method = 'auto_split'
    ) AS
SELECT *
FROM zoomcamp_taxi.yellow_tripdata_ml
WHERE tip_amount IS NOT NULL;
-- Check Features
SELECT *
FROM ML.FEATURE_INFO(MODEL zoomcamp_taxi.yellow_taxi_tip_model);
-- Check Model Evaluation
SELECT *
FROM ML.EVALUATE(
        MODEL zoomcamp_taxi.yellow_taxi_tip_model,
        (
            SELECT *
            FROM zoomcamp_taxi.yellow_tripdata_ml
            WHERE tip_amount IS NOT NULL
        )
    );
-- Predict Model
SELECT *
FROM ML.PREDICT(
        MODEL `zoomcamp_taxi.yellow_taxi_tip_model`,
        (
            SELECT *
            FROM `zoomcamp_taxi.yellow_tripdata_ml`
            WHERE tip_amount IS NOT NULL
        )
    );
-- Create model with tuning
CREATE OR REPLACE MODEL zoomcamp_taxi.yellow_taxi_tip_model_tune OPTIONS (
        model_type = 'linear_reg',
        input_label_cols = ['tip_amount'],
        data_split_method = 'auto_split',
        optimize_strategy = 'auto_strategy',
        hparam_tuning_algorithm = 'random_search'
    ) AS
SELECT *
FROM zoomcamp_taxi.yellow_tripdata_ml
WHERE tip_amount IS NOT NULL;
