-----PERFORM DATA CLEANSING AND TRANSFORMATIONS, QUALITY CHECKS, DATA VALIDATION ------
---TABLE : silver.crm_cust_info

-- CHECK FOR DUPLICATES OR NULLS IN PRIMARY KEY 
--EXPECTED RESULT :NONE
--SELECT 
--cst_id,
--count(*)
--from silver.crm_cust_info
--group by cst_id 
--HAVING count(*) > 1 OR cst_id IS NULL;

--CHECK FOR UNWANTED SPACES IN STRING VALUES
--EXPECTATIONS: NO RESULTS
--SELECT 
--cst_firstname 
--FROM 
--silver.crm_cust_info 
--WHERE cst_firstname != TRIM(cst_firstname);

--CHECK THE CONSISTENCY OF VALUES IN LOW CARDINALITY ROWS
-- AND STANDARDIZATION
--SELECT DISTINCT cst_gndr 
--FROM 
--bronze.crm_cust_info;


---TABLE: silver.crm_prd_info

-- CHECK FOR DUPLICATES OR NULLS IN PRIMARY KEY 
--EXPECTED RESULT :NONE
--SELECT 
--prd_key,
--count(*)
--from silver.crm_prd_info
--group by prd_key 
--HAVING count(*) > 1 OR prd_key IS NULL;

--CHECK FOR STANDARDIZATION 
--SELECT DISTINCT prd_line
--FROM silver.crm_prd_info


--CHECK FOR UNWANTED SPACES IN STRING VALUES
--EXPECTATIONS: NO RESULTS
--SELECT 
--prd_nm 
--FROM 
--silver.crm_prd_info 
--WHERE prd_nm != TRIM(prd_nm);

--CHECK FOR INVALID DATE ORDERS
--SELECT 
--* 
--FROM silver.crm_prd_info 
--WHERE prd_end_dt < prd_start_dt;


---TABLE : silver.crm_sales_details
--CHECK IF PRODUCT KEY FROM SALES IS MAPPED TO PRODUCT KEY FROM PRODUCT INFO
--EXPECTED RESULT:NONE
--SELECT 
--	sls_ord_num,
--	sls_prd_key,
--	sls_cust_id,
--	sls_order_dt,
--	sls_ship_dt,
--	sls_due_dt,
--	sls_sales,
--	sls_quantity,
--	sls_price
--FROM bronze.crm_sales_details
--WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

--CHECK IF CUSTOMER ID FROM SALES IS MAPPED TO CUSTOMER ID FROM CUSTOMER INFO 
--EXPECTED RESULT:NONE
--SELECT 
--	sls_ord_num,
--	sls_prd_key,
--	sls_cust_id,
--	sls_order_dt,
--	sls_ship_dt,
--	sls_due_dt,
--	sls_sales,
--	sls_quantity,
--	sls_price
--FROM bronze.crm_sales_details
--WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

--CHECK FOR INVALID DATES FROM BRONZE 
--SELECT 
--sls_order_dt 
--FROM bronze.crm_sales_details
--WHERE sls_order_dt <= 0 or LEN(sls_order_dt) != 8
--OR sls_order_dt > 20500101 or sls_order_dt < 1900101;

--CHECK IF SHIPPING DATE IS AFTER ORDER DATE or ORDER DATE IS BEFORE DUE DATE 
--EXPECTED RESULT:NONE
--SELECT 
--*
--FROM silver.crm_sales_details
--WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;

--CHECK DATA CONSISTENCY 
-- SALES = QUANTITY * PRICE 
-- VALUES MUST BE NOT NULL , ZERO OR NEGATIVE
--SELECT 
--sls_sales,
--sls_quantity,
--sls_price 
--FROM bronze.crm_sales_details
--WHERE sls_sales != sls_quantity * sls_price 
--OR sls_sales IS NULL OR sls_quantity is NULL OR sls_price IS NULL 
--OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0; 


--- TABLE: silver.erp_cust_az12

--CHECK IF WE CAN CONNECT cid KEY FROM erp_cust_az12 WITH cst_key FROM crm_cust_info
--EXPECTED RESULT:NONE
--SELECT 
--CASE WHEN cid LIKE 'NAS%' 
--	THEN SUBSTRING(cid,4,LEN(cid))
--	ELSE cid 
--END as cid,
--bdate,
--gen 
--FROM bronze.erp_cust_az12
--WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
--	ELSE cid 
--END NOT IN (SELECT DISTINCT cst_key from silver.crm_cust_info);

--CHECK IF BDATE IS OUT OF RANGE
--SELECT DISTINCT 
--bdate 
--FROM silver.erp_cust_az12
--WHERE bdate < '1924-01-01' OR bdate > GETDATE();

--CHECK CONSISTENCY 
--SELECT DISTINCT gen 
--FROM silver.erp_cust_az12;


--- TABLE: silver.erp_loc_a101

--MATCH cid key from bronze.erp_loc_a101 WITH cst_key from silver.crm_cust_info
--SELECT REPlACE(cid,'-','') AS cid,
--		cntry
--FROM bronze.erp_loc_a101
--WHERE REPlACE(cid,'-','') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

--DATA CONSISTENCY 
--SELECT DISTINCT 
--cntry 
--FROM silver.erp_loc_a101;



--- TABLE : silver.erp_px_cat_g1v2
--MATCH id key from bronze.erp_px_cat_g1v2 WITH cat_id from silver.crm_prd_info
--SELECT 
--	id 
--	FROM bronze.erp_px_cat_g1v2 
--	WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);
