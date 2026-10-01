DECLARE @snapshot_date DATE = '2026-05-31';

DECLARE @start_12m DATE =
    DATEADD(
        DAY,
        1,
        DATEADD(YEAR, -1, @snapshot_date)
    );

WITH customer_value AS
(
    SELECT
        c.customer_id,
        c.acquisition_channel,

        COUNT(o.order_id)
            AS completed_orders_12m,

        COALESCE(
            SUM(o.net_revenue_usd),
            0
        ) AS revenue_12m,

        COALESCE(
            SUM(o.profit_usd),
            0
        ) AS profit_12m

    FROM core.customers AS c

    LEFT JOIN analytics.v_completed_orders AS o
        ON c.customer_id = o.customer_id
       AND o.order_date BETWEEN @start_12m
                            AND @snapshot_date

    GROUP BY
        c.customer_id,
        c.acquisition_channel
)

SELECT
    acquisition_channel,

    COUNT(*) AS customers,

    SUM(
        CASE
            WHEN completed_orders_12m > 0
            THEN 1 ELSE 0
        END
    ) AS purchasing_customers_12m,

    SUM(completed_orders_12m)
        AS completed_orders_12m,

    SUM(revenue_12m)
        AS revenue_12m,

    SUM(profit_12m)
        AS profit_12m,

    CAST(
        SUM(revenue_12m)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(14,2)
    ) AS revenue_per_customer_12m,

    CAST(
        SUM(profit_12m)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(14,2)
    ) AS profit_per_customer_12m

FROM customer_value

GROUP BY acquisition_channel

ORDER BY revenue_per_customer_12m DESC;