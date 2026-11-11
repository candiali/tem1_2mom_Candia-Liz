# tem1_2mom_Candia-Liz
**Universidad del Valle — Examen Práctico Individual (2do Momento)**  
**Estudiante:** Liz Gabriela Candia Escobar  
**Tecnología:** Apache Hive (HiveQL), Docker, PowerShell  

## 1. Descripción y Objetivos
Proyecto de procesamiento y análisis de datos sobre el conjunto **Sample Superstore** utilizando **Apache Hive**. Abarca modelado en dos capas (Staging + ORC), auditoría de calidad, segmentación RFM, rankings con funciones de ventana, impacto de descuentos, tendencias temporales y análisis Pareto 80/20.

## 2. Requisitos
- Docker Desktop con imagen `apache/hive:4.0.0`
- Windows PowerShell y Git
- Dataset: `data/superstore.csv` ([Superstore Dataset Final](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final))

## 3. Estructura del Repositorio
```text
├── README.md
├── data/
│   └── superstore.csv
├── docs/
│   ├── DICCIONARIO_DATOS.md
│   ├── ANALISIS_OPTIMIZACION.md
│   └── Examen segundo momento TEC.docx
└── scripts/
    ├── ddl/
    │   ├── 01_create_database.hql
    │   ├── 02_create_staging_table.hql
    │   └── 03_create_analytics_table.hql
    ├── dml/
    │   ├── 01_load_staging_data.hql
    │   └── 02_insert_analytics_data.hql
    └── queries/
        ├── p01_modelado_datos.hql
        ├── p02_auditoria_calidad.hql
        ├── p03_evolucion_regional.hql
        ├── p04_segmentacion_rfm.hql
        ├── p05_ranking_productos.hql
        ├── p06_impacto_descuentos.hql
        ├── p07_tendencias_temporales.hql
        └── p08_pareto_80_20.hql
```

## 4. Procedimiento de Ejecución
1. Levantar Hive en Docker y copiar el dataset:
   ```powershell
   docker start hive-server
   docker cp "data/superstore.csv" hive-server:/tmp/superstore.csv
   docker exec -it hive-server beeline -u "jdbc:hive2://localhost:10000/"
   ```
2. Ejecutar en orden los scripts de `scripts/ddl/`, `scripts/dml/` y `scripts/queries/`.

## 5. Conclusiones Generales
1. El uso de formato columnar **ORC + Snappy** redujo significativamente el almacenamiento y aceleró la ejecución de funciones de ventana sobre Tez.
2. La auditoría de calidad evidenció la importancia de sanitizar saltos de línea y caracteres especiales en campos de texto antes de castear columnas numéricas finales (especialmente la última columna `profit`).
3. El análisis RFM y regional mostró que la mayor concentración de ingresos proviene de clientes **Recurrentes (Leales)** y **Alto Valor (VIP)**, así como un crecimiento marcado en las regiones **West** y **East**.
4. Las tendencias temporales confirmaron una fuerte estacionalidad hacia fin de año (pico en noviembre de 2017) y valles en febrero.