WITH completed AS
(
    SELECT
        sales_channel,

        COUNT(*) AS completed_orders,

        COUNT(DISTINCT customer_id)
            AS purchasing_customers,

        SUM(net_revenue_usd) AS revenue,
        SUM(profit_usd) AS profit

    FROM analytics.v_completed_orders

    GROUP BY sales_channel
),

refunds AS
(
    SELECT
        sales_channel,

        SUM(
            CASE
                WHEN order_status = 'Refunded'
                THEN 1 ELSE 0
            END
        ) AS refunded_orders,

        COUNT(*) AS realized_orders

    FROM core.orders

    WHERE order_status
          IN ('Completed', 'Refunded')

    GROUP BY sales_channel
)

SELECT
    c.sales_channel,
    c.completed_orders,
    c.purchasing_customers,
    c.revenue,
    c.profit,

    CAST(
        c.revenue
        / NULLIF(c.completed_orders, 0)
        AS DECIMAL(14,2)
    ) AS aov,

    CAST(
        100.0 * c.profit
        / NULLIF(c.revenue, 0)
        AS DECIMAL(8,2)
    ) AS profit_margin_pct,

    CAST(
        100.0 * r.refunded_orders
        / NULLIF(r.realized_orders, 0)
        AS DECIMAL(8,2)
    ) AS refund_rate_pct

FROM completed AS c

INNER JOIN refunds AS r
    ON c.sales_channel = r.sales_channel

ORDER BY c.revenue DESC;