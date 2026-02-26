--PUBLISH MODEL (Business Transformations based on Business Requirements Specification)

--Publish Product Table
CREATE TABLE publish.publish_product AS
SELECT
    product_id,
    product_desc,
	product_number,
	make_flag,
	COALESCE(Color, 'N/A') AS Color,  -- Replace NULL Color with 'N/A'
	safety_stock_level,
	reorder_point,
	standard_cost,
	list_price,
	size,
	size_unit_measure_code,
	weight,
	weight_unit_measure_code,
    -- Enhance ProductCategoryName if NULL
    CASE
        WHEN product_category_name IS NOT NULL THEN product_category_name

        WHEN product_sub_category_name IN
            ('Gloves','Shorts','Socks','Tights','Vests')
            THEN 'Clothing'

        WHEN product_sub_category_name IN
            ('Locks','Lights','Headsets','Helmets','Pedals','Pumps')
            THEN 'Accessories'

        WHEN product_sub_category_name ILIKE '%Frames%'
            OR product_sub_category_name IN ('Wheels','Saddles')
            THEN 'Components'

        ELSE 'Others'
    END AS product_category_name,

    product_sub_category_name

FROM store.store_product;

--Publish Order Table
CREATE TABLE publish.publish_orders AS
SELECT
    d.*,

    -- Include header fields except sales_order_id
    h.order_date,
    h.ship_date,
    h.online_order_flag,
	h.account_number,
	h.customer_id,
	h.sales_person_id,
    h.Freight AS TotalOrderFreight,

    -- Revenue Calculation
    d.order_qty * (d.unit_price - d.unit_price_discount)
        AS total_line_extended_price,

    -- Business Day Calculation
    (
        SELECT COUNT(*)
        FROM generate_series(h.order_date, h.ship_date, interval '1 day') AS g(day)
        WHERE EXTRACT(DOW FROM g.day) NOT IN (0,6)
    ) - 1
        AS lead_time_in_business_days

FROM store.store_sales_order_detail d
JOIN store.store_sales_order_header h
ON d.sales_order_id = h.sales_order_id;
