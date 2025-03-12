-- Query Public Available Dataset
SELECT *
FROM `bigquery-public-data.new_york_citibike.citibike_stations`
LIMIT 100;
-- Check external dataset
-- SELECT * FROM `indigo-muse-452811-u7.zoomcamp_taxi.green_tripdata_2019-01_ext` LIMIT 10;
-- Create a non-partioned_table
--- Green table
CREATE OR REPLACE TABLE indigo - muse -452811 - u7.zoomcamp_taxi.green_tripdata_non_partioned AS
SELECT *
FROM indigo - muse -452811 - u7.zoomcamp_taxi.green_tripdata;
--- Yellow table
CREATE OR REPLACE TABLE indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_non_partioned AS
SELECT *
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata;
-- Create partitioned table
--- Green table
CREATE OR REPLACE TABLE indigo - muse -452811 - u7.zoomcamp_taxi.green_tripdata_partioned PARTITION BY DATE(lpep_pickup_datetime) AS
SELECT *
FROM indigo - muse -452811 - u7.zoomcamp_taxi.green_tripdata;
--- Yellow table
CREATE OR REPLACE TABLE indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_partioned PARTITION BY DATE(tpep_pickup_datetime) AS
SELECT *
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata;
-- Performance Differents
--- 1.27Gb data processed
SELECT DISTINCT(vendorID)
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_non_partioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-01-01' AND '2020-01-01';
--- 886Mb data processed
SELECT DISTINCT(vendorID)
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_partioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-01-01' AND '2020-01-01';
SELECT table_name,
    partition_id,
    total_rows
FROM `zoomcamp_taxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = yellow_tripdata_partioned;
-- Create partitioned + clusted table
--- Yellow table
CREATE OR REPLACE TABLE indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_partioned_clustered PARTITION BY DATE(tpep_pickup_datetime) CLUSTER BY VendorID AS
SELECT *
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata;
--- Green table
CREATE OR REPLACE TABLE indigo - muse -452811 - u7.zoomcamp_taxi.green_tripdata_partioned_clustered PARTITION BY DATE(lpep_pickup_datetime) CLUSTER BY VendorID AS
SELECT *
FROM indigo - muse -452811 - u7.zoomcamp_taxi.green_tripdata;
-- Performance Differents
SELECT COUNT(*) AS vendor_trips
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_partioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-01-01' AND '2021-01-01'
    AND VendorID = '1';
SELECT COUNT(*) AS vendor_trips
FROM indigo - muse -452811 - u7.zoomcamp_taxi.yellow_tripdata_partioned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-01-01' AND '2021-01-01'
    AND VendorID = '1';
SELECT table_name,
    partition_id,
    total_rows
