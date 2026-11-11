-- ====================================================================
-- BLOQUE II: PROCESAMIENTO Y CONSULTAS ANALÍTICAS
-- PREGUNTA 6: Análisis del impacto de los descuentos
-- ====================================================================

USE superstore_db;

-- 6A: Rangos de descuento
WITH rangos AS (
    SELECT *,
        CASE 
            WHEN discount = 0.0 THEN '1. Sin descuento (0%)'
            WHEN discount > 0.0 AND discount <= 0.20 THEN '2. Bajo (>0% a 20%)'
            WHEN discount > 0.20 AND discount <= 0.50 THEN '3. Medio (>20% a 50%)'
            ELSE '4. Alto (>50%)'
        END AS rango_descuento
    FROM superstore_analytics
)
SELECT 
    rango_descuento,
    COUNT(*) AS registros,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS margen_pct,
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS cant_perdidas,
    ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_no_rentables,
    ROUND(AVG(discount) * 100, 2) AS descuento_prom_pct
FROM rangos
GROUP BY rango_descuento
ORDER BY rango_descuento;

-- 6B: Categorías y subcategorías más afectadas por descuento alto (>50%)
SELECT 
    category,
    sub_category,
    COUNT(*) AS operaciones,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia_perdida,
    ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_perdidas
FROM superstore_analytics
WHERE discount > 0.50
GROUP BY category, sub_category
ORDER BY ganancia_perdida ASC;
