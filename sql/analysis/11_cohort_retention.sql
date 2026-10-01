/*
cohort month = month of customer's first completed purchase
Retention = customer has at least one completed purchase in later month
*/

WITH completed_orders AS
(
    SELECT
        customer_id,

        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS activity_month

    FROM analytics.v_completed_orders
),

first_purchase AS
(
    SELECT
        customer_id,
        MIN(activity_month) AS cohort_month

    FROM completed_orders

    GROUP BY customer_id
),

customer_activity AS
(
    SELECT DISTINCT
        customer_id,
        activity_month

    FROM completed_orders
),

cohort_sizes AS
(
    SELECT
        cohort_month,
        COUNT(*) AS cohort_customers

    FROM first_purchase

    GROUP BY cohort_month
),

retention_counts AS
(
    SELECT
        fp.cohort_month,

        DATEDIFF(
            MONTH,
            fp.cohort_month,
            ca.activity_month
        ) AS month_number,

        COUNT(DISTINCT ca.customer_id)
            AS retained_customers

    FROM first_purchase AS fp

    INNER JOIN customer_activity AS ca
        ON fp.customer_id = ca.customer_id

    WHERE ca.activity_month >= fp.cohort_month

    GROUP BY
        fp.cohort_month,

        DATEDIFF(
            MONTH,
            fp.cohort_month,
            ca.activity_month
        )
)

SELECT
    rc.cohort_month,
    rc.month_number,
    cs.cohort_customers,
    rc.retained_customers,

    CAST(
        100.0 * rc.retained_customers
        / NULLIF(cs.cohort_customers, 0)
        AS DECIMAL(8,2)
    ) AS retention_rate_pct

FROM retention_counts AS rc

INNER JOIN cohort_sizes AS cs
    ON rc.cohort_month = cs.cohort_month

ORDER BY
    rc.cohort_month,
    rc.month_number;