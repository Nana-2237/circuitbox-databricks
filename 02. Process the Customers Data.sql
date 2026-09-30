-- Databricks notebook source
-- MAGIC %md
-- MAGIC this file is going to be used in the pipeline to ingest the data from azure to databricks. i made a pipeline for this.

-- COMMAND ----------

CREATE OR REFRESH STREAMING TABLE bronze_customers
COMMENT 'Raw customers data ingested from the source system operational data'
TBLPROPERTIES ('quality' = 'bronze')
AS
SELECT *, _metadata.file_path AS input_file_path, CURRENT_TIMESTAMP AS ingestion_timestamp
 FROM STREAM cloud_files(
    '/Volumes/circuitbox/landing/operational_data/customers/',
    'json',
    map('cloudFiles.inferColumnTypes','true')
 );

-- COMMAND ----------

