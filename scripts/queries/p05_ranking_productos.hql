-- ====================================================================
-- BLOQUE II: PROCESAMIENTO Y CONSULTAS ANALÍTICAS
-- PREGUNTA 5: Ranking de productos según rentabilidad
-- ====================================================================

USE superstore_db;

-- 5A: Top 5 productos con mayor ganancia por categoría
WITH prod_cat AS (
    SELECT 
        category,
        product_name,
        ROUND(SUM(sales), 2) AS ventas,
        ROUND(SUM(profit), 2) AS ganancia,
        ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS margen_pct,
        RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS rank_cat,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS dense_rank_cat
    FROM superstore_analytics
    GROUP BY category, product_name
)
SELECT * FROM prod_cat
WHERE rank_cat <= 5
ORDER BY category, rank_cat;

-- 5B: Top 5 productos con mayor volumen de ventas
SELECT 
    product_name,
    category,
    ROUND(SUM(sales), 2) AS ventas,
    SUM(quantity) AS unidades,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS margen_pct
FROM superstore_analytics
GROUP BY product_name, category
ORDER BY ventas DESC
LIMIT 5;

-- 5C: Top 5 productos con menor rentabilidad
SELECT 
    product_name,
    category,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS margen_pct
FROM superstore_analytics
GROUP BY product_name, category
ORDER BY ganancia ASC
LIMIT 5;
