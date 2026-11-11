-- ====================================================================
-- BLOQUE I: INGENIERÍA Y MODELADO DE DATOS
-- PREGUNTA 2: Auditoría de calidad e integridad de datos
-- ====================================================================

USE superstore_db;

SELECT 
    COUNT(*) AS total_registros,
    COUNT(*) - COUNT(DISTINCT row_id) AS duplicados_row_id,
    COUNT(DISTINCT order_id) AS ordenes_unicas,
    COUNT(DISTINCT customer_id) AS clientes_unicos,
    SUM(CASE WHEN row_id IS NULL OR order_id IS NULL OR order_date IS NULL 
                  OR ship_date IS NULL OR customer_id IS NULL 
                  OR sales IS NULL OR profit IS NULL THEN 1 ELSE 0 END) AS nulos_criticos,
    SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) AS nulos_postal_code,
    SUM(CASE WHEN order_date IS NULL OR ship_date IS NULL THEN 1 ELSE 0 END) AS fechas_invalidas,
    SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_menor_igual_cero,
    SUM(CASE WHEN discount < 0.0 OR discount > 1.0 THEN 1 ELSE 0 END) AS descuentos_fuera_rango,
    SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END) AS envio_antes_pedido
FROM superstore_analytics;
