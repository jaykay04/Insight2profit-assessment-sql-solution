/* ============================================================
   DATA QUALITY CHECKS (NON-DESTRUCTIVE)
   Purpose: Identify data issues without modifying data
============================================================ */

-- Row Count Validation
SELECT 
    'raw_product' AS table_name,
    COUNT(*) AS row_count
FROM raw.raw_product

UNION ALL

SELECT 
    'store_product' AS table_name,
    COUNT(*) AS row_count
FROM store.store_product;



-- NULL Checks – Critical Fields
SELECT COUNT(*) AS null_product_id_count
FROM store.store_product
WHERE product_id IS NULL;



-- Duplicate ProductId Detection
SELECT 
    product_id,
    COUNT(*) AS duplicate_count
FROM store.store_product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Creating a Dedupe View
CREATE OR REPLACE VIEW store.v_store_product_deduplicated AS
WITH ranked_products AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY product_id
               ORDER BY
                   (CASE WHEN product_category_name IS NOT NULL THEN 1 ELSE 0 END +
                    CASE WHEN product_sub_category_name IS NOT NULL THEN 1 ELSE 0 END
                   ) DESC
           ) AS rn
    FROM store.store_product
)
SELECT *
FROM ranked_products
WHERE rn = 1;



-- Referential Integrity Check
SELECT COUNT(*) AS orphan_product_references
FROM store.store_sales_order_detail d
LEFT JOIN store.store_product p
    ON d.product_id = p.product_id
WHERE p.product_id IS NULL;
