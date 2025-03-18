WITH quarterly_revenue AS (
    SELECT * 
    FROM {{ ref('fact_trips') }}  -- Ensure you reference the table correctly via dbt's `ref` function
),
aggregated_revenue AS (
    SELECT 
        extract(year from pickup_datetime ) as year,
        extract(quarter from pickup_datetime ) as quarter,
        service_type,
        SUM(total_amount) AS sum_total
    FROM quarterly_revenue
    where EXTRACT(year from pickup_datetime) IN (2019, 2020)
    GROUP BY year,quarter, service_type
)


SELECT 
    year,
    quarter,
    service_type,
    sum_total,
    100 * ROUND((sum_total / nullif(LAG(sum_total,4) over (partition by service_type order by year,quarter),0) - 1),2) as yearly_quarter_growth
from aggregated_revenue
order by year,quarter asc
