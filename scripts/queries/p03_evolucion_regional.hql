-- ====================================================================
-- BLOQUE II: PROCESAMIENTO Y CONSULTAS ANALÍTICAS
-- PREGUNTA 3: Análisis de evolución comercial por región
-- ====================================================================

USE superstore_db;

WITH resumen_anual AS (
    SELECT 
        region,
        YEAR(order_date) AS anio,
        ROUND(SUM(sales), 2) AS ventas_totales,
        ROUND(SUM(profit), 2) AS ganancia_total,
        ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS margen_pct
    FROM superstore_analytics
    GROUP BY region, YEAR(order_date)
)
SELECT 
    region,
    anio,
    ventas_totales,
    ganancia_total,
    margen_pct,
    LAG(ventas_totales) OVER (PARTITION BY region ORDER BY anio) AS ventas_anio_ant,
    ROUND(((ventas_totales - LAG(ventas_totales) OVER (PARTITION BY region ORDER BY anio)) 
           / LAG(ventas_totales) OVER (PARTITION BY region ORDER BY anio)) * 100, 2) AS var_pct_yoy,
    RANK() OVER (PARTITION BY anio ORDER BY ganancia_total DESC) AS rank_ganancia
FROM resumen_anual
ORDER BY anio, ventas_totales DESC;
