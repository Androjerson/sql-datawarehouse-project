/*
==================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==================================================================================
Script Purpose:
  This stored procedure loads data into 'bronze' schema from external csv files.
  Performs the following actions:
  - Truncates the bronze table before loading data
  - Then inserts data into tables.

Parameters:
  None
  This stored procedure does not accept any parameters
  Returns 0 for success and 1 for failure

Usage Example:
  CALL bronze.load_bronze();
==================================================================================
*/

--event log table to track errors and failures while loading in procedure 
CREATE OR REPLACE TABLE bronze.event_log(
obj_name VARCHAR(50),
start_time DATETIME,
end_time DATETIME,
is_error NUMBER,
error_type VARCHAR(100),
error_code VARCHAR(50),
error_message VARCHAR(100),
error_state VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS caller
AS
DECLARE
    start_time TIMESTAMP_LTZ := CURRENT_TIMESTAMP();
    end_time TIMESTAMP_LTZ;
BEGIN
    BEGIN TRANSACTION;
    
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY INTO bronze.crm_cust_info
    FROM @external_stages.s3_external_crm_stg/cust_info.csv;
    
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY INTO bronze.crm_prd_info
    FROM @external_stages.s3_external_crm_stg/prd_info.csv;
    
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY INTO bronze.crm_sales_details
    FROM @external_stages.s3_external_crm_stg/sales_details.csv;
    
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY INTO bronze.erp_cust_az12
    FROM @external_stages.s3_external_erp_stg/CUST_AZ12.csv;
    
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY INTO bronze.erp_loc_a101
    FROM @external_stages.s3_external_erp_stg/LOC_A101.csv;
    
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY INTO bronze.erp_px_cat_g1v2
    FROM @external_stages.s3_external_erp_stg/PX_CAT_G1V2.csv;

    COMMIT;

    end_time:=CURRENT_TIMESTAMP();

    RETURN 0;
    
EXCEPTION
    WHEN other THEN 
        ROLLBACK;
        end_time:=CURRENT_TIMESTAMP();  
        
        INSERT INTO event_log(obj_name,start_time ,end_time,is_error,error_type,error_code,error_message,error_state)                      VALUES('load_bronze',:start_time,:end_time,1,'Procedure error',:sqlcode,:sqlerrm,:sqlstate);
        RETURN 1;
END;


