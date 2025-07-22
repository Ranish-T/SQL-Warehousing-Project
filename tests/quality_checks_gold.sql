/*
===============================================================================
🔍 Script        : Quality_Checks.sql
🧑‍💻 Author       : Ranish T
📅 Created On     : [Add your date here]
📄 Description    : Performs integrity and relationship checks in Gold Layer.
===============================================================================
✅ This script checks:
    - Uniqueness of surrogate keys in dimension tables
    - Referential integrity between fact and dimension tables
    - Relationship validity for analytics
===============================================================================
⚠️ Usage Notes:
    - If the checks return rows, it indicates issues like duplicates or broken links.
    - Investigate and resolve any discrepancies before proceeding.
===============================================================================
*/

-- 📦 Checking gold.dim_customers
-- 🎯 Check: Uniqueness of customer_key
-- ✅ Expectation: No duplicate rows
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- 🛍️ Checking gold.dim_products
-- 🎯 Check: Uniqueness of product_key
-- ✅ Expectation: No duplicate rows
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- 📊 Checking gold.fact_sales integrity
-- 🎯 Check: Referential integrity between fact and dimension tables
-- ✅ Expectation: No NULLs in joined keys
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
