/*
===============================================================================
🧪 Script        : Quality_Checks_Silver.sql
🧑‍💻 Author       : Ranish T
📅 Created On     : [Add your date here]
📄 Description    : Performs data consistency, accuracy, and standardization checks
                  across the SILVER layer of the Data Warehouse.
===============================================================================
⚠️ WARNING:
    Run these checks AFTER loading data into the SILVER layer.
    Investigate and fix any discrepancies before proceeding to GOLD.
===============================================================================
*/

-- 👥 silver.crm_cust_info: Null/Duplicate PK
SELECT cst_id, COUNT(*) AS cnt
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 🧼 silver.crm_cust_info: Trim unwanted spaces
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- 🔄 silver.crm_cust_info: Marital status values
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;


-- 📦 silver.crm_prd_info: Null/Duplicate PK
SELECT prd_id, COUNT(*) AS cnt
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 🧼 silver.crm_prd_info: Trim product names
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 💰 silver.crm_prd_info: Cost check
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 🔄 silver.crm_prd_info: Product line values
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- ⏳ silver.crm_prd_info: Date sanity check
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- 💳 silver.crm_sales_details: Invalid dates (from Bronze)
SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) != 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- 📆 silver.crm_sales_details: Date relationships
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- ⚖️ silver.crm_sales_details: Sales consistency
SELECT DISTINCT sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


–— 👴 silver.erp_cust_az12: Birthdate range check
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- 🧼 silver.erp_cust_az12: Gender value check
SELECT DISTINCT gen
FROM silver.erp_cust_az12;


-- 🌍 silver.erp_loc_a101: Country consistency check
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- 🧩 silver.erp_px_cat_g1v2: Trim category fields
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- 🔄 silver.erp_px_cat_g1v2: Maintenance types
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;
