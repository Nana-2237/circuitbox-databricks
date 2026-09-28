-- Databricks notebook source
-- DBTITLE 1,Show credentials
SHOW STORAGE CREDENTIALS;

-- COMMAND ----------

-- DBTITLE 1,creating external location
CREATE EXTERNAL LOCATION circuitbox 
URL 'abfss://circuitbox@databricksexternaldl.dfs.core.windows.net/'
WITH (STORAGE CREDENTIAL databricks_course_ext_sc)
COMMENT 'External Location for the circuitbox data lakehouse'

-- COMMAND ----------

-- DBTITLE 1,fs ls circuitbox
-- MAGIC %fs ls 'abfss://circuitbox@databricksexternaldl.dfs.core.windows.net/'

-- COMMAND ----------

-- DBTITLE 1,Create catalog
    CREATE CATALOG IF NOT EXISTS circuitbox
MANAGED LOCATION 'abfss://circuitbox@databricksexternaldl.dfs.core.windows.net/'
COMMENT 'CircuitBox catalog data lakehouse';

-- COMMAND ----------

SHOW CATALOGS;

-- COMMAND ----------

-- DBTITLE 1,creating landing and lakehouse schema
USE CATALOG circuitbox;
CREATE SCHEMA IF NOT EXISTS landing
MANAGED LOCATION 'abfss://circuitbox@databricksexternaldl.dfs.core.windows.net/landing';
CREATE SCHEMA IF NOT EXISTS lakehouse
    MANAGED LOCATION 'abfss://circuitbox@databricksexternaldl.dfs.core.windows.net/lakehouse';

-- COMMAND ----------

SHOW SCHEMAS

-- COMMAND ----------

USE CATALOG circuitbox;
USE SCHEMA landing;
CREATE EXTERNAL VOLUME IF NOT EXISTS operational_data
    LOCATION 'abfss://circuitbox@databricksexternaldl.dfs.core.windows.net/landing/operational_data';

-- COMMAND ----------

-- MAGIC %fs ls /Volumes/circuitbox/landing/operational_data

-- COMMAND ----------

