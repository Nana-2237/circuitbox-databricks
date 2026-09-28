-- Databricks notebook source
CREATE OR REFRESH STREAMING TABLE bronze_customers
COMMENT 'raw customers data ingested from the source sytem operational data'
AS SELECT 