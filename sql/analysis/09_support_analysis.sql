SELECT
    issue_type,

    COUNT(*) AS ticket_count,

    CAST(
        AVG(resolution_hours)
        AS DECIMAL(10,2)
    ) AS avg_resolution_hours,

    CAST(
        AVG(CAST(csat_score AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS avg_csat,

    SUM(
        CASE
            WHEN refunded = 1
            THEN 1 ELSE 0
        END
    ) AS refund_related_tickets,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN refunded = 1
                THEN 1 ELSE 0
            END
        )
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(8,2)
    ) AS refund_related_pct

FROM core.support_tickets

GROUP BY issue_type

ORDER BY ticket_count DESC;


/* Priority-level analysis */

SELECT
    priority,
    COUNT(*) AS tickets,

    CAST(
        AVG(resolution_hours)
        AS DECIMAL(10,2)
    ) AS avg_resolution_hours,

    CAST(
        AVG(CAST(csat_score AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS avg_csat

FROM core.support_tickets

GROUP BY priority

ORDER BY tickets DESC;