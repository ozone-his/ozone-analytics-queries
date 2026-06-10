SELECT 
    sol.id AS sale_order_line_id,
    so.name AS sale_order_name,
    sol.sequence,
    sol.product_id AS product_id,
    pt.name AS product_name,
    pp.default_code AS product_code,
    irp.name AS product_external_id,
    sol.product_uom_qty AS quantity,
    sol.price_unit AS unit_price,
    cost_at_line.unit_cost,
    sol.price_subtotal AS subtotal,
    cost_at_line.unit_cost * sol.product_uom_qty AS line_cost,
    sol.price_total AS total,
    sol.create_date AS line_creation_date,
    sol.write_date AS line_last_modified_date,
    rp.name AS customer_name,
    `rp`.`ref` AS customer_uuid,
    rp.email AS customer_email,
    rp.phone AS customer_phone,
    so.invoice_status AS invoicing_status
FROM 
    sale_order_line sol
LEFT JOIN 
    sale_order so ON sol.order_id = so.id
LEFT JOIN 
    product_product pp ON sol.product_id = pp.id
LEFT JOIN 
    product_template pt ON pp.product_tmpl_id = pt.id
LEFT JOIN 
    res_partner rp ON so.partner_id = rp.id
LEFT JOIN 
    ir_model_data irp ON (irp.model = 'product.product' AND irp.res_id = pp.id)
LEFT JOIN (
    SELECT
        sale_order_line_id,
        unit_cost
    FROM (
        SELECT
            sol_cost.id AS sale_order_line_id,
            COALESCE(
                CAST(REGEXP_EXTRACT(svl.description, 'to ([0-9]+([.][0-9]+)?)[)]', 1) AS NUMERIC),
                svl.unit_cost
            ) AS unit_cost,
            ROW_NUMBER() OVER (
                PARTITION BY sol_cost.id
                ORDER BY svl.create_date DESC, svl.id DESC
            ) AS row_num
        FROM
            sale_order_line sol_cost
        JOIN
            stock_valuation_layer svl ON svl.product_id = sol_cost.product_id
                AND svl.company_id = sol_cost.company_id
                AND svl.create_date <= sol_cost.create_date
        WHERE
            sol_cost.product_id IS NOT NULL
    ) ranked_costs
    WHERE row_num = 1
) cost_at_line ON cost_at_line.sale_order_line_id = sol.id
