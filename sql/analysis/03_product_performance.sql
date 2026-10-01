SELECT
    c.region,

    COUNT(*) AS completed_orders,

    COUNT(DISTINCT o.customer_id)
        AS purchasing_customers,

    SUM(o.net_revenue_usd)
        AS revenue,

    SUM(o.profit_usd)
        AS profit,

    CAST(
        SUM(o.net_revenue_usd)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(14,2)
    ) AS aov

FROM analytics.v_completed_orders AS o

INNER JOIN core.customers AS c
    ON o.customer_id = c.customer_id

GROUP BY c.region

ORDER BY revenue DESC;