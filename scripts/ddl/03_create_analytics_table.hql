-- ====================================================================
-- PROYECTO: Superstore Sales Dataset - Apache Hive
-- UNIVERSIDAD DEL VALLE - EXAMEN PRÁCTICO 2DO MOMENTO
-- ARCHIVO: 03_create_analytics_table.hql
-- DESCRIPCIÓN: Creación de la tabla analítica en formato columnar ORC
-- con compresión Snappy y tipos de datos apropiados.
-- ====================================================================

USE superstore_db;

DROP TABLE IF EXISTS superstore_analytics;

CREATE TABLE IF NOT EXISTS superstore_analytics (
    row_id INT,
    order_id STRING,
    order_date DATE,
    ship_date DATE,
    ship_mode STRING,
    customer_id STRING,
    customer_name STRING,
    segment STRING,
    country STRING,
    city STRING,
    state STRING,
    postal_code STRING,
    region STRING,
    product_id STRING,
    category STRING,
    sub_category STRING,
    product_name STRING,
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
)
COMMENT 'Tabla analítica procesada y tipada para Superstore Sales'
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

DESCRIBE superstore_analytics;
