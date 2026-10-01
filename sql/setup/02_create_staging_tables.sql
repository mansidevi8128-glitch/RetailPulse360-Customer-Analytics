USE RetailPulse360;
GO

CREATE TABLE stg.customers
(
    customer_id          VARCHAR(50)  NULL,
    signup_date          VARCHAR(50)  NULL,
    state                VARCHAR(50)  NULL,
    region               VARCHAR(100) NULL,
    acquisition_channel  VARCHAR(100) NULL,
    preferred_device     VARCHAR(100) NULL,
    loyalty_tier         VARCHAR(100) NULL
);
GO


SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'stg'
ORDER BY TABLE_NAME;


SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'stg'
  AND TABLE_NAME = 'customers'
ORDER BY ORDINAL_POSITION;



SELECT COUNT(*) AS row_count
FROM stg.customers;



CREATE TABLE stg.products
(
    product_id       VARCHAR(50)  NULL,
    category         VARCHAR(100) NULL,
    subcategory      VARCHAR(100) NULL,
    base_price_usd   VARCHAR(50)  NULL,
    unit_cost_usd    VARCHAR(50)  NULL
);
GO




CREATE TABLE stg.orders
(
    order_id                     VARCHAR(50)  NULL,
    customer_id                  VARCHAR(50)  NULL,
    order_date                   VARCHAR(50)  NULL,
    sales_channel                VARCHAR(100) NULL,
    payment_method               VARCHAR(100) NULL,
    shipping_type                VARCHAR(100) NULL,
    coupon_used                  VARCHAR(50)  NULL,
    discount_pct                 VARCHAR(50)  NULL,
    order_status                 VARCHAR(100) NULL,
    shipping_fee_usd             VARCHAR(50)  NULL,
    tax_amount_usd               VARCHAR(50)  NULL,
    gross_merchandise_value_usd  VARCHAR(50)  NULL,
    net_revenue_usd              VARCHAR(50)  NULL,
    total_cost_usd               VARCHAR(50)  NULL,
    profit_usd                   VARCHAR(50)  NULL
);
GO




CREATE TABLE stg.order_items
(
    order_item_id     VARCHAR(50) NULL,
    order_id          VARCHAR(50) NULL,
    product_id        VARCHAR(50) NULL,
    quantity          VARCHAR(50) NULL,
    unit_price_usd    VARCHAR(50) NULL,
    discount_pct      VARCHAR(50) NULL,
    line_revenue_usd  VARCHAR(50) NULL,
    line_cost_usd     VARCHAR(50) NULL
);
GO




CREATE TABLE stg.web_sessions
(
    session_id        VARCHAR(50)  NULL,
    customer_id       VARCHAR(50)  NULL,
    session_date      VARCHAR(50)  NULL,
    device            VARCHAR(100) NULL,
    traffic_source    VARCHAR(100) NULL,
    pages_viewed      VARCHAR(50)  NULL,
    session_minutes   VARCHAR(50)  NULL,
    product_views     VARCHAR(50)  NULL,
    cart_adds         VARCHAR(50)  NULL,
    checkout_started  VARCHAR(50)  NULL,
    converted         VARCHAR(50)  NULL
);
GO





CREATE TABLE stg.support_tickets
(
    ticket_id          VARCHAR(50)  NULL,
    customer_id        VARCHAR(50)  NULL,
    opened_date        VARCHAR(50)  NULL,
    issue_type         VARCHAR(100) NULL,
    priority           VARCHAR(100) NULL,
    resolution_hours   VARCHAR(50)  NULL,
    csat_score         VARCHAR(50)  NULL,
    refunded           VARCHAR(50)  NULL
);
GO




CREATE TABLE stg.marketing_spend
(
    month        VARCHAR(50)  NULL,
    channel      VARCHAR(100) NULL,
    spend_usd    VARCHAR(50)  NULL,
    impressions  VARCHAR(50)  NULL,
    clicks       VARCHAR(50)  NULL,
    leads        VARCHAR(50)  NULL
);
GO




CREATE TABLE stg.customer_modeling_snapshot
(
    customer_id                 VARCHAR(50)  NULL,
    snapshot_date               VARCHAR(50)  NULL,
    region                      VARCHAR(100) NULL,
    acquisition_channel         VARCHAR(100) NULL,
    preferred_device            VARCHAR(100) NULL,
    loyalty_tier                VARCHAR(100) NULL,
    days_since_signup           VARCHAR(50)  NULL,
    recency_days                VARCHAR(50)  NULL,
    frequency_12m               VARCHAR(50)  NULL,
    monetary_value_12m          VARCHAR(50)  NULL,
    avg_order_value_12m         VARCHAR(50)  NULL,
    profit_12m                  VARCHAR(50)  NULL,
    gross_margin_pct_12m        VARCHAR(50)  NULL,
    avg_discount_pct_12m        VARCHAR(50)  NULL,
    refund_rate_12m             VARCHAR(50)  NULL,
    category_diversity_12m      VARCHAR(50)  NULL,
    web_sessions_90d            VARCHAR(50)  NULL,
    avg_session_minutes_90d     VARCHAR(50)  NULL,
    product_views_90d           VARCHAR(50)  NULL,
    cart_adds_90d               VARCHAR(50)  NULL,
    conversion_rate_90d         VARCHAR(50)  NULL,
    cart_add_rate_90d           VARCHAR(50)  NULL,
    support_tickets_12m         VARCHAR(50)  NULL,
    avg_resolution_hours_12m    VARCHAR(50)  NULL,
    avg_csat_12m                VARCHAR(50)  NULL,
    refund_requests_12m         VARCHAR(50)  NULL,
    churned_next_90d            VARCHAR(50)  NULL
);
GO




SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'stg'
ORDER BY TABLE_NAME;




SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM stg.customers

UNION ALL

SELECT 'products', COUNT(*)
FROM stg.products

UNION ALL

SELECT 'orders', COUNT(*)
FROM stg.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM stg.order_items

UNION ALL

SELECT 'web_sessions', COUNT(*)
FROM stg.web_sessions

UNION ALL

SELECT 'support_tickets', COUNT(*)
FROM stg.support_tickets

UNION ALL

SELECT 'marketing_spend', COUNT(*)
FROM stg.marketing_spend

UNION ALL

SELECT 'customer_modeling_snapshot', COUNT(*)
FROM stg.customer_modeling_snapshot;









USE RetailPulse360;
GO

DROP TABLE IF EXISTS stg.orders;
GO

CREATE TABLE stg.orders
(
    order_id                     VARCHAR(9)    NULL,
    customer_id                  VARCHAR(7)    NULL,
    order_date                   DATE          NULL,
    sales_channel                VARCHAR(20)   NULL,
    payment_method               VARCHAR(20)   NULL,
    shipping_type                VARCHAR(20)   NULL,
    coupon_used                  TINYINT       NULL,
    discount_pct                 DECIMAL(5,2)  NULL,
    order_status                 VARCHAR(15)   NULL,
    shipping_fee_usd             DECIMAL(12,2) NULL,
    tax_amount_usd               DECIMAL(12,2) NULL,
    gross_merchandise_value_usd  DECIMAL(12,2) NULL,
    net_revenue_usd              DECIMAL(12,2) NULL,
    total_cost_usd               DECIMAL(12,2) NULL,
    profit_usd                   DECIMAL(12,2) NULL
);
GO





USE RetailPulse360;
GO

DROP TABLE IF EXISTS stg.order_items;
GO

CREATE TABLE stg.order_items
(
    order_item_id     VARCHAR(11)   NULL,
    order_id          VARCHAR(9)    NULL,
    product_id        VARCHAR(5)    NULL,
    quantity          INT           NULL,
    unit_price_usd    DECIMAL(12,2) NULL,
    discount_pct      DECIMAL(5,2)  NULL,
    line_revenue_usd  DECIMAL(12,2) NULL,
    line_cost_usd     DECIMAL(12,2) NULL
);
GO





USE RetailPulse360;
GO

DROP TABLE IF EXISTS stg.web_sessions;
GO

CREATE TABLE stg.web_sessions
(
    session_id        VARCHAR(10)   NULL,
    customer_id       VARCHAR(7)    NULL,
    session_date      DATE          NULL,
    device            VARCHAR(10)   NULL,
    traffic_source    VARCHAR(20)   NULL,
    pages_viewed      INT           NULL,
    session_minutes   DECIMAL(8,2)  NULL,
    product_views     INT           NULL,
    cart_adds         INT           NULL,
    checkout_started  TINYINT       NULL,
    converted         TINYINT       NULL
);
GO





DROP TABLE IF EXISTS stg.support_tickets;
GO

CREATE TABLE stg.support_tickets
(
    ticket_id          VARCHAR(8)   NULL,
    customer_id        VARCHAR(7)   NULL,
    opened_date        DATE         NULL,
    issue_type         VARCHAR(30)  NULL,
    priority           VARCHAR(10)  NULL,
    resolution_hours   DECIMAL(8,2) NULL,
    csat_score         TINYINT      NULL,
    refunded           TINYINT      NULL
);
GO





USE RetailPulse360;
GO

DROP TABLE IF EXISTS stg.marketing_spend;
GO

CREATE TABLE stg.marketing_spend
(
    month        DATE          NULL,
    channel      VARCHAR(20)   NULL,
    spend_usd    DECIMAL(14,2) NULL,
    impressions  BIGINT        NULL,
    clicks       BIGINT        NULL,
    leads        BIGINT        NULL
);
GO





USE RetailPulse360;
GO

DROP TABLE IF EXISTS stg.customer_modeling_snapshot;
GO

CREATE TABLE stg.customer_modeling_snapshot
(
    customer_id                   VARCHAR(7)   NULL,
    snapshot_date                 DATE         NULL,
    region                        VARCHAR(10)  NULL,
    acquisition_channel           VARCHAR(20)  NULL,
    preferred_device              VARCHAR(10)  NULL,
    loyalty_tier                  VARCHAR(10)  NULL,

    days_since_signup             INT          NULL,

    recency_days                  FLOAT        NULL,
    frequency_12m                 FLOAT        NULL,

    monetary_value_12m            FLOAT        NULL,
    avg_order_value_12m           FLOAT        NULL,
    profit_12m                    FLOAT        NULL,

    gross_margin_pct_12m          FLOAT        NULL,
    avg_discount_pct_12m          FLOAT        NULL,
    refund_rate_12m               FLOAT        NULL,

    category_diversity_12m        FLOAT        NULL,

    web_sessions_90d              FLOAT        NULL,
    avg_session_minutes_90d       FLOAT        NULL,
    product_views_90d             FLOAT        NULL,
    cart_adds_90d                 FLOAT        NULL,
    conversion_rate_90d           FLOAT        NULL,
    cart_add_rate_90d             FLOAT        NULL,

    support_tickets_12m           FLOAT        NULL,
    avg_resolution_hours_12m      FLOAT        NULL,
    avg_csat_12m                  FLOAT        NULL,
    refund_requests_12m           FLOAT        NULL,

    churned_next_90d              TINYINT      NULL
);
GO