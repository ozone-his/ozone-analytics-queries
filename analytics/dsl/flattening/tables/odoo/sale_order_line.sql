CREATE TABLE `sale_order_line` (
    `id` INT,
    `order_id` INTEGER,
    `sequence` INTEGER,
    `product_id` INTEGER,
    `product_uom_qty` NUMERIC,
    `price_unit` NUMERIC,
    `price_subtotal` NUMERIC,
    `price_total` NUMERIC,
    `create_date` TIMESTAMP,
    `write_date` TIMESTAMP,
    PRIMARY KEY (`id`) NOT ENFORCED
)