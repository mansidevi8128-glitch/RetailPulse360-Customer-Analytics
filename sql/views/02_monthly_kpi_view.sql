CREATE OR ALTER VIEW analytics.v_monthly_kpis
AS

SELECT
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    ) AS month,

    COUNT(*) AS completed_orders,

    COUNT(DISTINCT customer_id) AS purchasing_customers,

    SUM(net_revenue_usd) AS revenue,

    SUM(profit_usd) AS profit,

    CAST(
        SUM(net_revenue_usd) / NULLIF(COUNT(*), 0)
        AS DECIMAL(14,2)
    ) AS aov

FROM analytics.v_completed_orders

GROUP BY
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    );
GO