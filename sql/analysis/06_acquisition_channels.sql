SELECT
    COUNT(*) AS refunded_orders,

    SUM(total_cost_usd) AS refund_cost_exposure,

    AVG(total_cost_usd) AS avg_refund_cost

FROM core.orders

WHERE order_status = 'Refunded';




SELECT
    CAST(
        100.0 *
        SUM(
            CASE
                WHEN order_status = 'Refunded'
                THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN order_status
                         IN ('Completed','Refunded')
                    THEN 1
                    ELSE 0
                END
            ),
            0
        )
        AS DECIMAL(8,2)
    ) AS refund_rate_pct

FROM core.orders;