SELECT
    channel,

    SUM(spend_usd) AS spend_usd,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(leads) AS leads,

    CAST(
        100.0 * SUM(clicks)
        / NULLIF(SUM(impressions), 0)
        AS DECIMAL(8,2)
    ) AS ctr_pct,

    CAST(
        SUM(spend_usd)
        / NULLIF(SUM(clicks), 0)
        AS DECIMAL(12,2)
    ) AS cost_per_click,

    CAST(
        SUM(spend_usd)
        / NULLIF(SUM(leads), 0)
        AS DECIMAL(12,2)
    ) AS cost_per_lead,

    CAST(
        100.0 * SUM(leads)
        / NULLIF(SUM(clicks), 0)
        AS DECIMAL(8,2)
    ) AS click_to_lead_pct

FROM core.marketing_spend

GROUP BY channel

ORDER BY cost_per_lead;