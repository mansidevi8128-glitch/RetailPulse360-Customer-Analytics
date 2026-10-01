WITH monthly AS
(
    SELECT
        month,
        completed_orders,
        purchasing_customers,
        revenue,
        profit,
        aov
    FROM analytics.v_monthly_kpis
),

trend AS
(
    SELECT
        *,
        LAG(revenue) OVER (ORDER BY month)
            AS previous_month_revenue,

        LAG(profit) OVER (ORDER BY month)
            AS previous_month_profit
    FROM monthly
)

SELECT
    *,

    CAST(
        100.0 *
        (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0)
        AS DECIMAL(8,2)
    ) AS revenue_mom_pct,

    CAST(
        100.0 *
        (profit - previous_month_profit)
        / NULLIF(previous_month_profit, 0)
        AS DECIMAL(8,2)
    ) AS profit_mom_pct

FROM trend
ORDER BY month;