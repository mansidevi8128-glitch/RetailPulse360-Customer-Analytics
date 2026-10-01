/* High value:
top 25% by trailing-12-month completed-order revenue.

Declining engagement:
recent 90-day web sessions are at least 50% lower
than the immediately preceding 90 days.

Minimum prior engagement:
at least 2 sessions. */

DECLARE @snapshot_date DATE = '2026-05-31';

DECLARE @start_12m DATE =
    DATEADD(DAY, 1, DATEADD(YEAR, -1, @snapshot_date));

DECLARE @recent_start DATE =
    DATEADD(DAY, -89, @snapshot_date);

DECLARE @prior_start DATE =
    DATEADD(DAY, -179, @snapshot_date);

DECLARE @prior_end DATE =
    DATEADD(DAY, -90, @snapshot_date);


WITH customer_value AS
(
    SELECT
        c.customer_id,

        COALESCE(
            SUM(o.net_revenue_usd),
            0
        ) AS revenue_12m

    FROM core.customers AS c

    LEFT JOIN analytics.v_completed_orders AS o
        ON c.customer_id = o.customer_id
       AND o.order_date BETWEEN @start_12m
                            AND @snapshot_date

    GROUP BY c.customer_id
),

engagement AS
(
    SELECT
        c.customer_id,

        SUM(
            CASE
                WHEN ws.session_date
                     BETWEEN @prior_start
                         AND @prior_end
                THEN 1 ELSE 0
            END
        ) AS prior_sessions_90d,

        SUM(
            CASE
                WHEN ws.session_date
                     BETWEEN @recent_start
                         AND @snapshot_date
                THEN 1 ELSE 0
            END
        ) AS recent_sessions_90d,

        SUM(
            CASE
                WHEN ws.session_date
                     BETWEEN @recent_start
                         AND @snapshot_date
                THEN ws.product_views
                ELSE 0
            END
        ) AS recent_product_views,

        SUM(
            CASE
                WHEN ws.session_date
                     BETWEEN @recent_start
                         AND @snapshot_date
                THEN ws.cart_adds
                ELSE 0
            END
        ) AS recent_cart_adds

    FROM core.customers AS c

    LEFT JOIN core.web_sessions AS ws
        ON c.customer_id = ws.customer_id

    GROUP BY c.customer_id
),

scored AS
(
    SELECT
        cv.customer_id,
        cv.revenue_12m,
        e.prior_sessions_90d,
        e.recent_sessions_90d,
        e.recent_product_views,
        e.recent_cart_adds,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (
                ORDER BY cv.revenue_12m
            )
            OVER () AS revenue_p75

    FROM customer_value AS cv

    INNER JOIN engagement AS e
        ON cv.customer_id = e.customer_id
)

SELECT
    customer_id,
    revenue_12m,
    prior_sessions_90d,
    recent_sessions_90d,

    CAST(
        100.0 *
        (prior_sessions_90d - recent_sessions_90d)
        / NULLIF(prior_sessions_90d, 0)
        AS DECIMAL(8,2)
    ) AS session_decline_pct,

    recent_product_views,
    recent_cart_adds

FROM scored

WHERE revenue_12m >= revenue_p75
  AND prior_sessions_90d >= 2
  AND recent_sessions_90d
      <= prior_sessions_90d * 0.50

ORDER BY revenue_12m DESC;