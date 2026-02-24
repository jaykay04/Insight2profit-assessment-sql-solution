select * from raw.raw_product;

select * from raw.raw_sales_order_detail;

select * from raw.raw_sales_order_header;

SELECT COUNT(*) FROM raw.raw_product;
SELECT COUNT(*) FROM store.store_product;

select * from store.store_product
where product_id = 884;

delete from store.store_product
where product_category_name is null;

select * from store.store_product;

Drop table publish.publish_product;

SELECT product_id, COUNT(*)
FROM store.store_product
GROUP BY product_id
HAVING COUNT(*) > 1;

--Removing duplicates to allow primary key constrain on product id
--Keeping records with more information
WITH duplicate_registry AS (
    SELECT 
        ctid, 
        ROW_NUMBER() OVER (
            PARTITION BY product_id 
            ORDER BY product_category_name DESC, product_sub_category_name DESC
        ) as occurrence_number
    FROM store.store_product
)
DELETE FROM store.store_product
WHERE ctid IN (
    SELECT ctid 
    FROM duplicate_registry 
    WHERE occurrence_number > 1
);
