CREATE TABLE stock_valuation_layer (
    `id` INT,
    `product_id` INTEGER,
    `company_id` INTEGER,
    `create_date` TIMESTAMP,
    `description` VARCHAR,
    `unit_cost` NUMERIC,
    PRIMARY KEY (`id`) NOT ENFORCED
)
