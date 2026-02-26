ALTER TABLE store.store_product
ADD PRIMARY KEY (product_id);

ALTER TABLE store.store_sales_order_header
ADD PRIMARY KEY (sales_order_id);

ALTER TABLE store.store_sales_order_detail
ADD PRIMARY KEY (sales_order_detail_id);

ALTER TABLE store.store_sales_order_detail
ADD CONSTRAINT fk_salesorder
FOREIGN KEY (sales_order_id)
REFERENCES store.store_sales_order_header(sales_order_id);

ALTER TABLE store.store_sales_order_detail
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES store.store_product(product_id);
