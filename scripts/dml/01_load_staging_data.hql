-- ====================================================================
-- PROYECTO: Superstore Sales Dataset - Apache Hive
-- UNIVERSIDAD DEL VALLE - EXAMEN PRÁCTICO 2DO MOMENTO
-- ARCHIVO: 01_load_staging_data.hql
-- DESCRIPCIÓN: Carga del archivo CSV en la tabla Staging
-- ====================================================================

USE superstore_db;

LOAD DATA LOCAL INPATH '/tmp/superstore.csv' OVERWRITE INTO TABLE superstore_staging;

SELECT COUNT(*) AS total_registros_staging FROM superstore_staging;
SELECT * FROM superstore_staging LIMIT 5;
