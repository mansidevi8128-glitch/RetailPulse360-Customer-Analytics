SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM core.customers

UNION ALL

SELECT 'products', COUNT(*)
FROM core.products

UNION ALL

SELECT 'orders', COUNT(*)
FROM core.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM core.order_items

UNION ALL

SELECT 'web_sessions', COUNT(*)
FROM core.web_sessions

UNION ALL

SELECT 'support_tickets', COUNT(*)
FROM core.support_tickets

UNION ALL

SELECT 'marketing_spend', COUNT(*)
FROM core.marketing_spend

UNION ALL

SELECT 'customer_modeling_snapshot', COUNT(*)
FROM analytics.customer_modeling_snapshot;





SELECT
    'customers' AS table_name,
    (SELECT COUNT(*) FROM stg.customers)  AS staging_rows,
    (SELECT COUNT(*) FROM core.customers) AS core_rows

UNION ALL

SELECT
    'orders',
    (SELECT COUNT(*) FROM stg.orders),
    (SELECT COUNT(*) FROM core.orders)

UNION ALL

SELECT
    'order_items',
    (SELECT COUNT(*) FROM stg.order_items),
    (SELECT COUNT(*) FROM core.order_items);






SELECT COUNT(*) AS orphan_orders
FROM core.orders AS o
LEFT JOIN core.customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;




SELECT COUNT(*) AS orphan_order_items
FROM core.order_items AS oi
LEFT JOIN core.orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;





SELECT COUNT(*) AS profit_mismatches
FROM core.orders
WHERE profit_usd <> net_revenue_usd - total_cost_usd;




SELECT COUNT(*) AS invalid_cancelled_orders
FROM core.orders
WHERE order_status = 'Cancelled'
  AND
  (
      net_revenue_usd <> 0
      OR total_cost_usd <> 0
      OR profit_usd <> 0
  );





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