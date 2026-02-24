--STORE LAYER (Typed + Constraints Enforced - Basic Transformation)

--Product Table
CREATE TABLE store.store_product AS
SELECT
	CAST(ProductID AS INT) AS product_id,
    ProductDesc AS product_desc,
    CAST(ProductNumber AS VARCHAR(25)) AS product_number,
    CAST(MakeFlag AS BOOLEAN) AS make_flag,
    Color AS color,
    CAST(SafetyStockLevel AS SMALLINT) AS safety_stock_level,
    CAST(ReorderPoint AS SMALLINT) AS reorder_point,
    CAST(StandardCost AS NUMERIC(19,4)) AS standard_cost,
    CAST(ListPrice AS NUMERIC(19,4)) AS list_price,
    CAST(Size AS VARCHAR(5)) AS size,
    CAST(SizeUnitMeasureCode AS CHAR(3)) AS size_unit_measure_code,
    CAST(Weight AS NUMERIC(8,2)) AS weight,
    CAST(WeightUnitMeasureCode AS CHAR(3)) AS weight_unit_measure_code,
    CAST(ProductCategoryName AS VARCHAR(50)) AS product_category_name,
    CAST(ProductSubCategoryName AS VARCHAR(50)) AS product_sub_category_name
FROM raw.raw_product