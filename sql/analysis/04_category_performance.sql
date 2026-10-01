WITH category_metrics AS
(
    SELECT
        p.category,

        SUM(oi.line_revenue_usd)
            AS merchandise_revenue,

        SUM(oi.line_cost_usd)
            AS merchandise_cost,

        SUM(
            oi.line_revenue_usd
            - oi.line_cost_usd
        ) AS merchandise_profit

    FROM core.order_items AS oi

    INNER JOIN core.orders AS o
        ON oi.order_id = o.order_id

    INNER JOIN core.products AS p
        ON oi.product_id = p.product_id

    WHERE o.order_status = 'Completed'

    GROUP BY p.category
)

SELECT
    category,
    merchandise_revenue,
    merchandise_profit,

    CAST(
        100.0 * merchandise_profit
        / NULLIF(merchandise_revenue, 0)
        AS DECIMAL(8,2)
    ) AS gross_margin_pct,

    RANK() OVER (
        ORDER BY merchandise_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY merchandise_profit DESC
    ) AS profit_rank,

    RANK() OVER (
        ORDER BY
            merchandise_profit
            / NULLIF(merchandise_revenue, 0)
            DESC
    ) AS margin_rank

FROM category_metrics

ORDER BY revenue_rank;