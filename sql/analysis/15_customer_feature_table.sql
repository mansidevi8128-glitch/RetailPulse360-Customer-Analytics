CREATE OR ALTER VIEW analytics.v_customer_features_sql
AS

WITH params AS
(
    SELECT
        CAST('2026-05-31' AS DATE)
            AS snapshot_date,

        CAST('2025-06-01' AS DATE)
            AS start_12m,

        CAST('2026-03-03' AS DATE)
            AS start_90d
),

last_purchase AS
(
    SELECT
        o.customer_id,
        MAX(o.order_date)
            AS last_completed_order_date

    FROM core.orders AS o

    CROSS JOIN params AS p

    WHERE o.order_status = 'Completed'
      AND o.order_date <= p.snapshot_date

    GROUP BY o.customer_id
),

orders_12m AS
(
    SELECT
        o.customer_id,

        COUNT(*) AS frequency_12m,

        SUM(o.net_revenue_usd)
            AS monetary_value_12m,

        AVG(o.net_revenue_usd)
            AS avg_order_value_12m,

        SUM(o.profit_usd)
            AS profit_12m,

        AVG(o.discount_pct)
            AS avg_discount_pct_12m

    FROM core.orders AS o

    CROSS JOIN params AS p

    WHERE o.order_status = 'Completed'
      AND o.order_date
          BETWEEN p.start_12m
              AND p.snapshot_date

    GROUP BY o.customer_id
),

refunds_12m AS
(
    SELECT
        o.customer_id,

        SUM(
            CASE
                WHEN o.order_status = 'Refunded'
                THEN 1 ELSE 0
            END
        ) AS refunded_orders_12m,

        COUNT(*) AS realized_orders_12m

    FROM core.orders AS o

    CROSS JOIN params AS p

    WHERE o.order_status
          IN ('Completed', 'Refunded')

      AND o.order_date
          BETWEEN p.start_12m
              AND p.snapshot_date

    GROUP BY o.customer_id
),

category_12m AS
(
    SELECT
        o.customer_id,

        COUNT(DISTINCT pr.category)
            AS category_diversity_12m

    FROM core.orders AS o

    INNER JOIN core.order_items AS oi
        ON o.order_id = oi.order_id

    INNER JOIN core.products AS pr
        ON oi.product_id = pr.product_id

    CROSS JOIN params AS p

    WHERE o.order_status = 'Completed'

      AND o.order_date
          BETWEEN p.start_12m
              AND p.snapshot_date

    GROUP BY o.customer_id
),

web_90d AS
(
    SELECT
        ws.customer_id,

        COUNT(*) AS web_sessions_90d,

        AVG(ws.session_minutes)
            AS avg_session_minutes_90d,

        SUM(ws.product_views)
            AS product_views_90d,

        SUM(ws.cart_adds)
            AS cart_adds_90d,

        CAST(
            SUM(CAST(ws.converted AS INT))
            * 1.0
            / NULLIF(COUNT(*), 0)
            AS DECIMAL(12,8)
        ) AS conversion_rate_90d,

        CAST(
            SUM(ws.cart_adds) * 1.0
            / NULLIF(SUM(ws.product_views), 0)
            AS DECIMAL(12,8)
        ) AS cart_add_rate_90d

    FROM core.web_sessions AS ws

    CROSS JOIN params AS p

    WHERE ws.session_date
          BETWEEN p.start_90d
              AND p.snapshot_date

    GROUP BY ws.customer_id
),

support_12m AS
(
    SELECT
        st.customer_id,

        COUNT(*) AS support_tickets_12m,

        AVG(st.resolution_hours)
            AS avg_resolution_hours_12m,

        AVG(CAST(st.csat_score AS DECIMAL(10,4)))
            AS avg_csat_12m,

        SUM(
            CASE
                WHEN st.issue_type = 'Refund Request'
                THEN 1 ELSE 0
            END
        ) AS refund_requests_12m

    FROM core.support_tickets AS st

    CROSS JOIN params AS p

    WHERE st.opened_date
          BETWEEN p.start_12m
              AND p.snapshot_date

    GROUP BY st.customer_id
)

SELECT
    c.customer_id,
    p.snapshot_date,

    c.region,
    c.acquisition_channel,
    c.preferred_device,
    c.loyalty_tier,

    DATEDIFF(
        DAY,
        c.signup_date,
        p.snapshot_date
    ) AS days_since_signup,

    CASE
        WHEN lp.last_completed_order_date IS NOT NULL
        THEN DATEDIFF(
            DAY,
            lp.last_completed_order_date,
            p.snapshot_date
        )
    END AS recency_days,

    COALESCE(o12.frequency_12m, 0)
        AS frequency_12m,

    COALESCE(o12.monetary_value_12m, 0)
        AS monetary_value_12m,

    COALESCE(o12.avg_order_value_12m, 0)
        AS avg_order_value_12m,

    COALESCE(o12.profit_12m, 0)
        AS profit_12m,

    CAST(
        COALESCE(o12.profit_12m, 0)
        /
        NULLIF(o12.monetary_value_12m, 0)
        AS DECIMAL(12,8)
    ) AS gross_margin_pct_12m,

    COALESCE(o12.avg_discount_pct_12m, 0)
        AS avg_discount_pct_12m,

    CAST(
        COALESCE(r.refunded_orders_12m, 0) * 1.0
        /
        NULLIF(r.realized_orders_12m, 0)
        AS DECIMAL(12,8)
    ) AS refund_rate_12m,

    COALESCE(cat.category_diversity_12m, 0)
        AS category_diversity_12m,

    COALESCE(w.web_sessions_90d, 0)
        AS web_sessions_90d,

    COALESCE(w.avg_session_minutes_90d, 0)
        AS avg_session_minutes_90d,

    COALESCE(w.product_views_90d, 0)
        AS product_views_90d,

    COALESCE(w.cart_adds_90d, 0)
        AS cart_adds_90d,

    COALESCE(w.conversion_rate_90d, 0)
        AS conversion_rate_90d,

    COALESCE(w.cart_add_rate_90d, 0)
        AS cart_add_rate_90d,

    COALESCE(s.support_tickets_12m, 0)
        AS support_tickets_12m,

    COALESCE(s.avg_resolution_hours_12m, 0)
        AS avg_resolution_hours_12m,

    COALESCE(s.avg_csat_12m, 0)
        AS avg_csat_12m,

    COALESCE(s.refund_requests_12m, 0)
        AS refund_requests_12m,

    m.churned_next_90d

FROM core.customers AS c

CROSS JOIN params AS p

LEFT JOIN last_purchase AS lp
    ON c.customer_id = lp.customer_id

LEFT JOIN orders_12m AS o12
    ON c.customer_id = o12.customer_id

LEFT JOIN refunds_12m AS r
    ON c.customer_id = r.customer_id

LEFT JOIN category_12m AS cat
    ON c.customer_id = cat.customer_id

LEFT JOIN web_90d AS w
    ON c.customer_id = w.customer_id

LEFT JOIN support_12m AS s
    ON c.customer_id = s.customer_id

LEFT JOIN analytics.customer_modeling_snapshot AS m
    ON c.customer_id = m.customer_id
   AND m.snapshot_date = p.snapshot_date;
GO



/* Validate */
SELECT
    COUNT(*) AS rows,
    COUNT(DISTINCT customer_id)
        AS distinct_customers
FROM analytics.v_customer_features_sql;


/* Check target */
SELECT
    churned_next_90d,
    COUNT(*) AS customers
FROM analytics.v_customer_features_sql
GROUP BY churned_next_90d;

/* duplicate check */
SELECT
    customer_id,
    COUNT(*) AS rows_per_customer
FROM analytics.v_customer_features_sql
GROUP BY customer_id
HAVING COUNT(*) > 1;