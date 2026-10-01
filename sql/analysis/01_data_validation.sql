/* Row counts  */

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


/* Duplicate-key validation  */

SELECT
    'customers' AS table_name,
    COUNT(*) AS duplicate_keys
FROM
(
    SELECT customer_id
    FROM core.customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
    'products',
    COUNT(*)
FROM
(
    SELECT product_id
    FROM core.products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM
(
    SELECT order_id
    FROM core.orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
    'order_items',
    COUNT(*)
FROM
(
    SELECT order_item_id
    FROM core.order_items
    GROUP BY order_item_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
    'web_sessions',
    COUNT(*)
FROM
(
    SELECT session_id
    FROM core.web_sessions
    GROUP BY session_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
    'support_tickets',
    COUNT(*)
FROM
(
    SELECT ticket_id
    FROM core.support_tickets
    GROUP BY ticket_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
    'marketing_spend',
    COUNT(*)
FROM
(
    SELECT month, channel
    FROM core.marketing_spend
    GROUP BY month, channel
    HAVING COUNT(*) > 1
) AS d;


/* Missing-value profile  */

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS null_customer_id,
    SUM(CASE WHEN signup_date IS NULL THEN 1 ELSE 0 END)
        AS null_signup_date,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END)
        AS null_state,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END)
        AS null_region,
    SUM(CASE WHEN acquisition_channel IS NULL THEN 1 ELSE 0 END)
        AS null_acquisition_channel
FROM core.customers;
