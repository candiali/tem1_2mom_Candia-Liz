-- ====================================================================
-- BLOQUE III: ANALÍTICA AVANZADA
-- PREGUNTA 8: Análisis Pareto de ventas y rentabilidad (Regla 80/20)
-- ====================================================================

USE superstore_db;

-- 8A: Cantidad de productos para el 80% de Ventas
WITH vp AS (
    SELECT product_id, product_name, ROUND(SUM(sales), 2) AS ventas
    FROM superstore_analytics
    GROUP BY product_id, product_name
),
acum_v AS (
    SELECT 
        product_id,
        product_name,
        ventas,
        ROUND((SUM(ventas) OVER (ORDER BY ventas DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(ventas) OVER ()) * 100, 2) AS pct_acum,
        ROW_NUMBER() OVER (ORDER BY ventas DESC) AS ranking,
        COUNT(*) OVER () AS total_prod
    FROM vp
),
corte_v AS (
    SELECT MIN(ranking) AS fila_corte FROM acum_v WHERE pct_acum >= 80.0
)
SELECT 
    COUNT(*) AS productos_80_ventas,
    MAX(total_prod) AS total_catalogo,
    ROUND(COUNT(*) * 100.0 / MAX(total_prod), 2) AS pct_catalogo_ventas
FROM acum_v a
CROSS JOIN corte_v c
WHERE a.ranking <= c.fila_corte;

-- 8B: Cantidad de productos para el 80% de Ganancias
WITH gp AS (
    SELECT product_id, product_name, ROUND(SUM(profit), 2) AS ganancia
    FROM superstore_analytics
    GROUP BY product_id, product_name
    HAVING SUM(profit) > 0
),
acum_g AS (
    SELECT 
        product_id,
        product_name,
        ganancia,
        ROUND((SUM(ganancia) OVER (ORDER BY ganancia DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(ganancia) OVER ()) * 100, 2) AS pct_acum,
        ROW_NUMBER() OVER (ORDER BY ganancia DESC) AS ranking,
        COUNT(*) OVER () AS total_rentables
    FROM gp
),
corte_g AS (
    SELECT MIN(ranking) AS fila_corte FROM acum_g WHERE pct_acum >= 80.0
)
SELECT 
    COUNT(*) AS productos_80_ganancias,
    MAX(total_rentables) AS total_rentables,
    ROUND(COUNT(*) * 100.0 / MAX(total_rentables), 2) AS pct_catalogo_ganancias
FROM acum_g a
CROSS JOIN corte_g c
WHERE a.ranking <= c.fila_corte;
