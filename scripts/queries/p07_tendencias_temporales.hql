-- ====================================================================
-- BLOQUE III: ANALÍTICA AVANZADA
-- PREGUNTA 7: Análisis de tendencias temporales
-- ====================================================================

USE superstore_db;

-- 7A: Evolución mensual (MoM, YoY y Promedio Móvil 3M)
WITH mensual AS (
    SELECT 
        DATE_FORMAT(order_date, 'yyyy-MM') AS anio_mes,
        ROUND(SUM(sales), 2) AS ventas,
        ROUND(SUM(profit), 2) AS ganancia
    FROM superstore_analytics
    GROUP BY DATE_FORMAT(order_date, 'yyyy-MM')
)
SELECT 
    anio_mes,
    ventas,
    ganancia,
    ROUND(((ventas - LAG(ventas, 1) OVER (ORDER BY anio_mes)) / LAG(ventas, 1) OVER (ORDER BY anio_mes)) * 100, 2) AS var_mom_pct,
    ROUND(((ventas - LAG(ventas, 12) OVER (ORDER BY anio_mes)) / LAG(ventas, 12) OVER (ORDER BY anio_mes)) * 100, 2) AS var_yoy_pct,
    ROUND(AVG(ventas) OVER (ORDER BY anio_mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS prom_movil_3m
FROM mensual
ORDER BY anio_mes;

-- 7B: Top 3 meses mayor venta y Top 3 meses menor venta
WITH mensual AS (
    SELECT 
        DATE_FORMAT(order_date, 'yyyy-MM') AS anio_mes,
        ROUND(SUM(sales), 2) AS ventas
    FROM superstore_analytics
    GROUP BY DATE_FORMAT(order_date, 'yyyy-MM')
),
rk AS (
    SELECT 
        anio_mes,
        ventas,
        DENSE_RANK() OVER (ORDER BY ventas DESC) AS rk_max,
        DENSE_RANK() OVER (ORDER BY ventas ASC) AS rk_min
    FROM mensual
)
SELECT anio_mes, ventas, rk_max, rk_min
FROM rk
WHERE rk_max <= 3 OR rk_min <= 3
ORDER BY ventas DESC;
