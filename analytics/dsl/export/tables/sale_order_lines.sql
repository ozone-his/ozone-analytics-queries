-- GENERATED from the analytics `sale_order_lines` table by development/seed/
-- generate-export-tables.py. The export query does SELECT t.* from it, so the two
-- must match column for column. Do not edit by hand; re-run the generator.

CREATE TABLE sale_order_lines (
    sale_order_line_id BIGINT,
    sale_order_name STRING,
    sequence INT,
    product_id INT,
    product_name STRING,
    product_code STRING,
    product_external_id STRING,
    quantity DECIMAL(18,6),
    unit_price DECIMAL(18,6),
    subtotal DECIMAL(18,6),
    total DECIMAL(18,6),
    line_creation_date TIMESTAMP,
    line_last_modified_date TIMESTAMP,
    customer_name STRING,
    customer_uuid STRING,
    customer_email STRING,
    customer_phone STRING,
    invoicing_status STRING
)
