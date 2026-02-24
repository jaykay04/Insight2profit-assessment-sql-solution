--RAW TABLES (Landing Layer - No Data Type Enforcement)

CREATE TABLE IF NOT EXISTS raw.raw_product (
    ProductID TEXT,
	ProductDesc TEXT,
	ProductNumber TEXT,
	MakeFlag TEXT,
    Color TEXT,
	SafetyStockLevel TEXT,
	ReorderPoint TEXT,
	StandardCost TEXT,
	ListPrice TEXT,
	Size TEXT,
	SizeUnitMeasureCode TEXT,
	Weight TEXT,
	WeightUnitMeasureCode TEXT,
    ProductCategoryName TEXT,
    ProductSubCategoryName TEXT
);

CREATE TABLE IF NOT EXISTS raw.raw_sales_order_header (
    SalesOrderID TEXT,
    OrderDate TEXT,
    ShipDate TEXT,
	OnlineOrderFlag TEXT,
	AccountNumber TEXT,
	CustomerID TEXT,
	SalesPersonID TEXT,
    Freight TEXT
);

CREATE TABLE IF NOT EXISTS raw.raw_sales_order_detail (
    SalesOrderID TEXT,
    SalesOrderDetailID TEXT,
	OrderQty TEXT,
    ProductID TEXT,
    UnitPrice TEXT,
    UnitPriceDiscount TEXT
);
