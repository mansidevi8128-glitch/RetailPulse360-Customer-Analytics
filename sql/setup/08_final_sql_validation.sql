USE RetailPulse360;
GO

-- 1. Core row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM core.customers
UNION ALL
SELECT 'products', COUNT(*) FROM core.products
UNION ALL
SELECT 'orders', COUNT(*) FROM core.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM core.order_items
UNION ALL
SELECT 'web_sessions', COUNT(*) FROM core.web_sessions
UNION ALL
SELECT 'support_tickets', COUNT(*) FROM core.support_tickets
UNION ALL
SELECT 'marketing_spend', COUNT(*) FROM core.marketing_spend;


-- 2. Completed-order KPI reconciliation
SELECT
    COUNT(*) AS completed_orders,
    COUNT(DISTINCT customer_id) AS purchasing_customers,
    SUM(net_revenue_usd) AS revenue,
    SUM(profit_usd) AS profit,
    CAST(
        SUM(net_revenue_usd) / NULLIF(COUNT(*), 0)
        AS DECIMAL(14,2)
    ) AS aov
FROM analytics.v_completed_orders;


-- 3. Profit mismatches
SELECT COUNT(*) AS profit_mismatches
FROM core.orders
WHERE profit_usd <> net_revenue_usd - total_cost_usd;


-- 4. Invalid cancelled-order financials
SELECT COUNT(*) AS invalid_cancelled_orders
FROM core.orders
WHERE order_status = 'Cancelled'
  AND (
        net_revenue_usd <> 0
        OR total_cost_usd <> 0
        OR profit_usd <> 0
      );


-- 5. Future-date validation
DECLARE @snapshot_date DATE = '2026-05-31';

SELECT COUNT(*) AS future_orders
FROM core.orders
WHERE order_date > @snapshot_date;

SELECT COUNT(*) AS future_sessions
FROM core.web_sessions
WHERE session_date > @snapshot_date;

SELECT COUNT(*) AS future_tickets
FROM core.support_tickets
WHERE opened_date > @snapshot_date;


-- 6. Modeling feature-table grain
SELECT
    COUNT(*) AS feature_rows,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM analytics.v_customer_features_sql;


-- 7. Duplicate customers in feature table
SELECT
    customer_id,
    COUNT(*) AS row_count
FROM analytics.v_customer_features_sql
GROUP BY customer_id
HAVING COUNT(*) > 1;