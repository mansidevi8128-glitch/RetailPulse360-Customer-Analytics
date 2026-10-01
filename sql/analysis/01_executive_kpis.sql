SELECT
    COUNT(*) AS completed_orders,

    COUNT(DISTINCT customer_id) AS purchasing_customers,

    SUM(net_revenue_usd) AS revenue,

    SUM(profit_usd) AS profit,

    CAST(
        SUM(net_revenue_usd) / NULLIF(COUNT(*), 0)
        AS DECIMAL(14,2)
    ) AS aov,

    CAST(
        100.0 * SUM(profit_usd)
        / NULLIF(SUM(net_revenue_usd), 0)
        AS DECIMAL(8,2)
    ) AS profit_margin_pct

FROM analytics.v_completed_orders;