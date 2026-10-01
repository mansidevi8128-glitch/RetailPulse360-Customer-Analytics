/*

R = days since last completed purchase - recency
F = completed orders in trailing 12 months - frequency
M = completed-order net revenue in trailing 12 months - monetary

*/

DECLARE @snapshot_date DATE = '2026-05-31';

DECLARE @start_12m DATE =
    DATEADD(
        DAY,
        1,
        DATEADD(YEAR, -1, @snapshot_date)
    );

WITH last_purchase AS
(
    SELECT
        customer_id,
        MAX(order_date) AS last_completed_order_date

    FROM analytics.v_completed_orders

    WHERE order_date <= @snapshot_date

    GROUP BY customer_id
),

twelve_month_orders AS
(
    SELECT
        customer_id,
        COUNT(*) AS frequency_12m,
        SUM(net_revenue_usd) AS monetary_12m

    FROM analytics.v_completed_orders

    WHERE order_date
          BETWEEN @start_12m
              AND @snapshot_date

    GROUP BY customer_id
)

SELECT
    c.customer_id,

    lp.last_completed_order_date,

    CASE
        WHEN lp.last_completed_order_date IS NOT NULL
        THEN DATEDIFF(
            DAY,
            lp.last_completed_order_date,
            @snapshot_date
        )
    END AS recency_days,

    COALESCE(t.frequency_12m, 0)
        AS frequency_12m,

    COALESCE(t.monetary_12m, 0)
        AS monetary_12m,

    CASE
        WHEN lp.last_completed_order_date IS NULL
        THEN 1 ELSE 0
    END AS never_purchased_flag

FROM core.customers AS c

LEFT JOIN last_purchase AS lp
    ON c.customer_id = lp.customer_id

LEFT JOIN twelve_month_orders AS t
    ON c.customer_id = t.customer_id

ORDER BY c.customer_id;