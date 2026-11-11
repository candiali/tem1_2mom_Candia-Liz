-- ====================================================================
-- BLOQUE II: PROCESAMIENTO Y CONSULTAS ANALÍTICAS
-- PREGUNTA 4: Segmentación avanzada de clientes mediante RFM
-- ====================================================================

USE superstore_db;

WITH ref_date AS (
    SELECT MAX(order_date) AS max_d FROM superstore_analytics
),
metricas AS (
    SELECT 
        s.customer_id,
        s.customer_name,
        DATEDIFF(r.max_d, MAX(s.order_date)) AS recency_dias,
        COUNT(DISTINCT s.order_id) AS frequency_ordenes,
        ROUND(SUM(s.sales), 2) AS monetary_ventas
    FROM superstore_analytics s
    CROSS JOIN ref_date r
    GROUP BY s.customer_id, s.customer_name, r.max_d
),
scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_dias DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency_ordenes ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_ventas ASC) AS m_score
    FROM metricas
),
segmentado AS (
    SELECT *,
        CASE 
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto Valor (VIP)'
            WHEN r_score >= 3 AND f_score >= 3 THEN 'Recurrentes (Leales)'
            WHEN r_score <= 2 AND f_score >= 3 THEN 'En Riesgo de Abandono'
            WHEN r_score <= 2 AND f_score <= 2 THEN 'Inactivos / Hibernando'
            ELSE 'Ocasionales / Nuevos'
        END AS segmento_rfm
    FROM scores
)
SELECT 
    segmento_rfm,
    COUNT(*) AS total_clientes,
    ROUND(AVG(recency_dias), 1) AS avg_recency,
    ROUND(AVG(frequency_ordenes), 1) AS avg_ordenes,
    ROUND(SUM(monetary_ventas), 2) AS ventas_totales
FROM segmentado
GROUP BY segmento_rfm
ORDER BY ventas_totales DESC;
