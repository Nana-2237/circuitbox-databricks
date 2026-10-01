-- Databricks notebook source
-- MAGIC %md
-- MAGIC this file is going to be used in the pipeline to ingest the data from azure to databricks. i made a pipeline for this.

-- COMMAND ----------

-- DBTITLE 1,bronze customer table
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

-- DBTITLE 1,Silver cleaning customer data
CREATE OR REFRESH STREAMING TABLE silver_customers_clean(
    CONSTRAINT valid_customer_id EXPECT ( customer_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
    CONSTRAINT valid_customer_name EXPECT ( customer_name IS NOT NULL) ON VIOLATION DROP ROW ,
    CONSTRAINT valid_telephone EXPECT ( length(telephone)>=10),
    CONSTRAINT valid_email EXPECT ( email IS NOT NULL) ,
    CONSTRAINT valid_date_of_birth EXPECT ( date_of_birth >='1920-01-01')

)
COMMENT 'Cleaned customers data '
TBLPROPERTIES ('quality' = 'silver')
AS 
SELECT customer_id,
       customer_name,
       CAST(date_of_birth AS DATE) AS date_of_birth,
       telephone,
       email,
       CAST(created_date AS DATE) AS created_date
FROM STREAM(LIVE.bronze_customers);

-- COMMAND ----------

-- DBTITLE 1,Create Silver customers
CREATE OR REFRESH STREAMING TABLE silver_customers
COMMENT 'SCD Type 1 customers data'
TBLPROPERTIES('quality'='silver');

-- COMMAND ----------

APPLY CHANGES INTO LIVE.silver_customers
FROM STREAM(LIVE.silver_customers_clean )
KEYS (customer_id)
SEQUENCE BY created_date
STORED AS SCD TYPE 1; --type 1 is the default value