/*

==================================================================================================
DDL Script: Create Bronxe Tables
==================================================================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables if they already exist
  Run this script to re-deine the DDL structure of  'Bronze' table
===================================================================================================
*/

USE DATABASE datawarehouse;

USE SCHEMA bronze;

-- CREATE crm source tables

CREATE OR REPLACE TRANSIENT TABLE bronze.crm_cust_info (
cst_id NUMBER,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(10),
cst_gndr NVARCHAR(10),
cst_create_date DATE
);

CREATE OR REPLACE TRANSIENT TABLE bronze.crm_prd_info (
prd_id NUMBER,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost NUMBER,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE
);

CREATE OR REPLACE TRANSIENT TABLE bronze.crm_sales_details (
sls_order_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id NUMBER,
sls_order_dt NUMBER,
sls_ship_dt NUMBER,
sls_due_dt  NUMBER,
sls_sales NUMBER,
sls_quantity NUMBER,
sls_price NUMBER
);

-- Create ERP source system tables 

CREATE OR REPLACE TRANSIENT TABLE bronze.erp_cust_az12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
);

CREATE OR REPLACE TRANSIENT TABLE bronze.erp_loc_a101 (
CID NVARCHAR(50),
CNTRY NVARCHAR(50)
);

CREATE TRANSIENT TABLE bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintanance NVARCHAR(50)
);
