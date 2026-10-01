WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(*) AS completed_orders
    FROM analytics.v_completed_orders
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS purchasing_customers,

    SUM(
        CASE
            WHEN completed_orders >= 2
            THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN completed_orders >= 2
                THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(8,2)
    ) AS repeat_customer_rate_pct

FROM customer_orders;