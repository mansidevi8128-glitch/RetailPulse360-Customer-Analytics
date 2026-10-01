SELECT
    c.customer_id,

    COUNT(o.order_id)
        AS completed_orders,

    MAX(o.order_date)
        AS last_order_date,

    SUM(o.net_revenue_usd)
        AS lifetime_revenue,

    SUM(o.profit_usd)
        AS lifetime_profit,

    CAST(
        SUM(o.net_revenue_usd)
        / NULLIF(COUNT(o.order_id), 0)
        AS DECIMAL(14,2)
    ) AS aov

FROM core.customers AS c

LEFT JOIN analytics.v_completed_orders AS o
    ON c.customer_id = o.customer_id

GROUP BY c.customer_id;