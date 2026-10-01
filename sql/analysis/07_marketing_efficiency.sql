SELECT
    issue_type,

    COUNT(*) AS ticket_count,

    AVG(resolution_hours)
        AS avg_resolution_hours,

    AVG(CAST(csat_score AS DECIMAL(10,2)))
        AS avg_csat,

    SUM(CAST(refunded AS INT))
        AS refund_related_tickets

FROM core.support_tickets

GROUP BY issue_type

ORDER BY ticket_count DESC;