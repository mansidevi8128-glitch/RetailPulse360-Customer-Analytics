WITH customer_base AS
(
    SELECT
        region,
        COUNT(*) AS total_customers
    FROM core.customers
    GROUP BY region
),

completed_metrics AS
(
    SELECT
        c.region,

        COUNT(*) AS completed_orders,

        COUNT(DISTINCT o.customer_id)
            AS purchasing_customers,

        SUM(o.net_revenue_usd)
            AS revenue,

        SUM(o.profit_usd)
            AS profit

    FROM analytics.v_completed_orders AS o

    INNER JOIN core.customers AS c
        ON o.customer_id = c.customer_id

    GROUP BY c.region
),

refund_metrics AS
(
    SELECT
        c.region,

        SUM(
            CASE
                WHEN o.order_status = 'Refunded'
                THEN 1 ELSE 0
            END
        ) AS refunded_orders,

        COUNT(*) AS realized_orders

    FROM core.orders AS o

    INNER JOIN core.customers AS c
        ON o.customer_id = c.customer_id

    WHERE o.order_status
          IN ('Completed', 'Refunded')

    GROUP BY c.region
)

SELECT
    cb.region,
    cb.total_customers,
    cm.purchasing_customers,
    cm.completed_orders,
    cm.revenue,
    cm.profit,

    CAST(
        cm.revenue
        / NULLIF(cm.completed_orders, 0)
        AS DECIMAL(14,2)
    ) AS aov,

    CAST(
        100.0 * rm.refunded_orders
        / NULLIF(rm.realized_orders, 0)
        AS DECIMAL(8,2)
    ) AS refund_rate_pct

FROM customer_base AS cb

JOIN completed_metrics AS cm
    ON cb.region = cm.region

JOIN refund_metrics AS rm
    ON cb.region = rm.region

ORDER BY cm.revenue DESC;