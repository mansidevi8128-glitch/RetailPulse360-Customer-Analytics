/* Category */

WITH category_orders AS
(
    SELECT DISTINCT
        o.order_id,
        o.order_status,
        p.category

    FROM core.orders AS o

    INNER JOIN core.order_items AS oi
        ON o.order_id = oi.order_id

    INNER JOIN core.products AS p
        ON oi.product_id = p.product_id

    WHERE o.order_status
          IN ('Completed', 'Refunded')
)

SELECT
    category,

    SUM(
        CASE
            WHEN order_status = 'Refunded'
            THEN 1 ELSE 0
        END
    ) AS refunded_orders,

    COUNT(*) AS realized_orders,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN order_status = 'Refunded'
                THEN 1 ELSE 0
            END
        )
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(8,2)
    ) AS refund_rate_pct

FROM category_orders

GROUP BY category

ORDER BY refund_rate_pct DESC;


/* Channel */

SELECT
    sales_channel,

    SUM(
        CASE WHEN order_status = 'Refunded'
             THEN 1 ELSE 0 END
    ) AS refunded_orders,

    COUNT(*) AS realized_orders,

    CAST(
        100.0 *
        SUM(
            CASE WHEN order_status = 'Refunded'
                 THEN 1 ELSE 0 END
        )
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(8,2)
    ) AS refund_rate_pct

FROM core.orders

WHERE order_status IN ('Completed', 'Refunded')

GROUP BY sales_channel

ORDER BY refund_rate_pct DESC;


/* Month */

SELECT
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    ) AS month,

    SUM(
        CASE WHEN order_status = 'Refunded'
             THEN 1 ELSE 0 END
    ) AS refunded_orders,

    COUNT(*) AS realized_orders,

    CAST(
        100.0 *
        SUM(
            CASE WHEN order_status = 'Refunded'
                 THEN 1 ELSE 0 END
        )
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(8,2)
    ) AS refund_rate_pct

FROM core.orders

WHERE order_status IN ('Completed', 'Refunded')

GROUP BY
    DATEFROMPARTS(
        YEAR(order_date),
        MONTH(order_date),
        1
    )

ORDER BY month;