-- ====================================================================
-- PROYECTO: Superstore Sales Dataset - Apache Hive
-- UNIVERSIDAD DEL VALLE - EXAMEN PRÁCTICO 2DO MOMENTO
-- ARCHIVO: 01_create_database.hql
-- DESCRIPCIÓN: Creación de la base de datos analítica en Hive
-- ====================================================================

CREATE DATABASE IF NOT EXISTS superstore_db
COMMENT 'Base de datos analítica para el dataset Superstore Sales';

USE superstore_db;

SHOW DATABASES;
