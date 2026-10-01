WITH customer_frequency AS
(
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS completed_orders
    FROM core.customers AS c

    LEFT JOIN analytics.v_completed_orders AS o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT
    completed_orders,
    COUNT(*) AS customers,

    CAST(
        100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(8,2)
    ) AS customer_pct

FROM customer_frequency

GROUP BY completed_orders

ORDER BY completed_orders;



/* repeat-purchase rate */

WITH customer_frequency AS
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
            THEN 1 ELSE 0
        END
    ) AS repeat_customers,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN completed_orders >= 2
                THEN 1 ELSE 0
            END
        )
        /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(8,2)
    ) AS repeat_purchase_rate_pct

FROM customer_frequency;