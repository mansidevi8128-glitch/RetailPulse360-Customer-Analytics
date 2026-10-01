SELECT
    p.category,

    SUM(oi.line_revenue_usd)
        AS merchandise_revenue,

    SUM(oi.line_cost_usd)
        AS merchandise_cost,

    SUM(
        oi.line_revenue_usd
        - oi.line_cost_usd
    ) AS merchandise_gross_profit,

    SUM(oi.quantity)
        AS units_sold

FROM core.order_items AS oi

INNER JOIN core.orders AS o
    ON oi.order_id = o.order_id

INNER JOIN core.products AS p
    ON oi.product_id = p.product_id

WHERE o.order_status = 'Completed'

GROUP BY p.category

ORDER BY merchandise_revenue DESC;