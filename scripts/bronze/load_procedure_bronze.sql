/*
===========================================================================
  LOAD BRONZE LAYER (SRC --> BRONZE) AS STORED PROCEDURE 
===========================================================================
-LOADS DATA INTO THE 'BRONZE' SCHEMA FROM EXTERNAL CSV FILES (CRM AND ERP SOURCES)
-TRUNCATES TABLES BEFORE LOADING THE DATA 
-USING BULK INSERT TO DO A MASSIVE LOAD DATA 

*/

--USAGE:
--EXEC bronze.load_bronze;


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
	DECLARE @start_time DATETIME , @end_time DATETIME;
	DECLARE  @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '-------------------------------'
		PRINT 'Loading BRONZE LAYER'
		PRINT '-------------------------------'

		PRINT '-------------------------------'
		PRINT 'Loading CRM TABLES'
		PRINT '-------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table:  bronze.crm_cust_info '
		TRUNCATE TABLE bronze.crm_cust_info ; --make the table empty
		PRINT '>> Inserting into table:  bronze.crm_cust_info '
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\User1\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2 , --skip the first row as its the header 
			FIELDTERMINATOR = ',', --separator
			TABLOCK --lock the whole table
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 's';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table:  bronze.crm_prd_info '
		TRUNCATE TABLE bronze.crm_prd_info ; --make the table empty
		PRINT '>> Inserting into table:  bronze.crm_prd_info '
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\User1\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2 , --skip the first row as its the header 
			FIELDTERMINATOR = ',', --separator
			TABLOCK --lock the whole table
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 's';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table:  bronze.crm_sales_details '
		TRUNCATE TABLE bronze.crm_sales_details ; --make the table empty
		PRINT '>> Inserting into table:  bronze.crm_sales_details '
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\User1\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2 , --skip the first row as its the header 
			FIELDTERMINATOR = ',', --separator
			TABLOCK --lock the whole table
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 's';


		PRINT '-------------------------------'
		PRINT 'Loading ERP TABLES'
		PRINT '-------------------------------'


		SET @start_time = GETDATE();
		PRINT '>> Truncating table:  bronze.erp_cust_az12 '
		TRUNCATE TABLE bronze.erp_cust_az12 ; --make the table empty
		PRINT '>> Inserting into table:  bronze.erp_cust_az12 '
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\User1\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2 , --skip the first row as its the header 
			FIELDTERMINATOR = ',', --separator
			TABLOCK --lock the whole table
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 's';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table:  bronze.erp_loc_a101 '
		TRUNCATE TABLE bronze.erp_loc_a101 ; --make the table empty
		PRINT '>> Inserting into table:  bronze.erp_loc_a101 '
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\User1\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2 , --skip the first row as its the header 
			FIELDTERMINATOR = ',', --separator
			TABLOCK --lock the whole table
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 's';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table:  bronze.erp_px_cat_g1v2 '
		TRUNCATE TABLE bronze.erp_px_cat_g1v2 ; --make the table empty
		PRINT '>> Inserting into table:  bronze.erp_px_cat_g1v2 '
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\User1\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2 , --skip the first row as its the header 
			FIELDTERMINATOR = ',', --separator
			TABLOCK --lock the whole table
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 's';

		SET @batch_end_time = GETDATE();
		PRINT '============================================='
		PRINT 'TOTAL LOAD DURATION:' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 's';
		PRINT '============================================='
		END TRY

		BEGIN CATCH
			PRINT '=================================================='
			PRINT 'error occured during loading BRONZE LAYER'
			PRINT 'error message' + ERROR_MESSAGE();
			PRINT 'error message' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT 'error message' + CAST(ERROR_STATE() AS NVARCHAR);
			PRINT '=================================================='
		END CATCH
END
