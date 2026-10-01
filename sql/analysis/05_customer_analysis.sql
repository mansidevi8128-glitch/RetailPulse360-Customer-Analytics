SELECT
    c.acquisition_channel,

    COUNT(DISTINCT c.customer_id)
        AS acquired_customers,

    COUNT(o.order_id)
        AS completed_orders,

    SUM(o.net_revenue_usd)
        AS revenue,

    SUM(o.profit_usd)
        AS profit,

    CAST(
        SUM(o.net_revenue_usd)
        / NULLIF(COUNT(DISTINCT c.customer_id), 0)
        AS DECIMAL(14,2)
    ) AS revenue_per_customer,

    CAST(
        SUM(o.profit_usd)
        / NULLIF(COUNT(DISTINCT c.customer_id), 0)
        AS DECIMAL(14,2)
    ) AS profit_per_customer

FROM core.customers AS c

LEFT JOIN analytics.v_completed_orders AS o
    ON c.customer_id = o.customer_id

GROUP BY c.acquisition_channel;