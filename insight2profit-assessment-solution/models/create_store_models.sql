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
FROM raw.raw_product;

--Sales Order Header
CREATE TABLE store.store_sales_order_header AS
SELECT
    CAST(NULLIF(SalesOrderID, '') AS INT) AS sales_order_id,
    CAST(
        CASE 
            WHEN LENGTH(NULLIF(orderdate, '')) = 7 THEN orderdate || '-01'
            ELSE NULLIF(orderdate, '')
        END AS DATE
    ) AS order_date,
    CAST(NULLIF(ShipDate, '') AS DATE) AS ship_date,
    CAST(NULLIF(OnlineOrderFlag, '') AS BOOLEAN) AS online_order_flag,
    NULLIF(AccountNumber, '') AS account_number,
    CAST(NULLIF(CustomerID, '') AS INT) AS customer_id,
    CAST(NULLIF(SalesPersonID, '') AS INT) AS sales_person_id,
    CAST(NULLIF(Freight, '') AS NUMERIC(12,2)) AS freight
FROM raw.raw_sales_order_header;

--Sales Order Detail
CREATE TABLE store.store_sales_order_detail AS
SELECT
    CAST(NULLIF(SalesOrderID, '') AS INT) AS sales_order_id,
    CAST(NULLIF(SalesOrderDetailID, '') AS INT) AS sales_order_detail_id,
	CAST(NULLIF(OrderQty, '') AS INT) AS order_qty,
    CAST(NULLIF(ProductID, '') AS INT) AS product_id,
    CAST(NULLIF(UnitPrice, '') AS NUMERIC(12,2)) AS unit_price,
    CAST(NULLIF(UnitPriceDiscount, '') AS NUMERIC(12,2)) AS unit_price_discount
FROM raw.raw_sales_order_detail;
