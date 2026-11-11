-- ====================================================================
-- BLOQUE I: INGENIERÍA Y MODELADO DE DATOS
-- PREGUNTA 1: Diseño e implementación del modelo de datos
-- ====================================================================

USE superstore_db;

DESCRIBE superstore_analytics;

SELECT 
    COUNT(*) AS total_importados,
    COUNT(DISTINCT row_id) AS filas_unicas,
    MIN(order_date) AS fecha_minima,
    MAX(order_date) AS fecha_maxima
FROM superstore_analytics;

SELECT row_id, order_id, order_date, customer_name, sales, profit
FROM superstore_analytics
ORDER BY row_id ASC
LIMIT 5;
