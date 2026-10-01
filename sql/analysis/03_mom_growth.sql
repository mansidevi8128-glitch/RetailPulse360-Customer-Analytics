WITH monthly_kpis AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS month,

        SUM(net_revenue_usd) AS revenue,
        SUM(profit_usd) AS profit

    FROM analytics.v_completed_orders

    GROUP BY
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        )
),

previous_month AS
(
    SELECT
        month,
        revenue,
        profit,

        LAG(revenue) OVER (ORDER BY month)
            AS previous_revenue,

        LAG(profit) OVER (ORDER BY month)
            AS previous_profit

    FROM monthly_kpis
)

SELECT
    month,
    revenue,

    CAST(
        100.0 *
        (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0)
        AS DECIMAL(8,2)
    ) AS revenue_mom_pct,

    profit,

    CAST(
        100.0 *
        (profit - previous_profit)
        / NULLIF(previous_profit, 0)
        AS DECIMAL(8,2)
    ) AS profit_mom_pct

FROM previous_month

ORDER BY month;