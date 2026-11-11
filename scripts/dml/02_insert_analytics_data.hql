-- ====================================================================
-- PROYECTO: Superstore Sales Dataset - Apache Hive
-- UNIVERSIDAD DEL VALLE - EXAMEN PRÁCTICO 2DO MOMENTO
-- ARCHIVO: 02_insert_analytics_data.hql
-- DESCRIPCIÓN: Limpieza, conversión de fechas/tipos e inserción hacia ORC
-- ====================================================================

USE superstore_db;

INSERT OVERWRITE TABLE superstore_analytics
SELECT 
    CAST(TRIM(row_id) AS INT) AS row_id,
    TRIM(order_id) AS order_id,
    COALESCE(
        TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(TRIM(order_date), 'MM/dd/yyyy'))),
        TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(TRIM(order_date), 'M/d/yyyy'))),
        TO_DATE(TRIM(order_date))
    ) AS order_date,
    COALESCE(
        TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(TRIM(ship_date), 'MM/dd/yyyy'))),
        TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(TRIM(ship_date), 'M/d/yyyy'))),
        TO_DATE(TRIM(ship_date))
    ) AS ship_date,
    TRIM(ship_mode) AS ship_mode,
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(segment) AS segment,
    TRIM(country) AS country,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(postal_code) AS postal_code,
    TRIM(region) AS region,
    TRIM(product_id) AS product_id,
    TRIM(category) AS category,
    TRIM(sub_category) AS sub_category,
    TRIM(product_name) AS product_name,
    CAST(TRIM(sales) AS DECIMAL(10,2)) AS sales,
    CAST(TRIM(quantity) AS INT) AS quantity,
    CAST(TRIM(discount) AS DECIMAL(4,2)) AS discount,
    CAST(TRIM(profit) AS DECIMAL(10,2)) AS profit
FROM superstore_staging
WHERE row_id IS NOT NULL
  AND row_id != 'Row ID';

SELECT COUNT(*) AS total_importados FROM superstore_analytics;
SELECT row_id, order_id, order_date, customer_name, sales, profit FROM superstore_analytics LIMIT 5;
