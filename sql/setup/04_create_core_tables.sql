USE RetailPulse360;
GO

CREATE TABLE core.customers
(
    customer_id         VARCHAR(7)  NOT NULL,
    signup_date         DATE        NOT NULL,
    state               CHAR(2)     NOT NULL,
    region              VARCHAR(10) NOT NULL,
    acquisition_channel VARCHAR(20) NOT NULL,
    preferred_device    VARCHAR(10) NOT NULL,
    loyalty_tier        VARCHAR(10) NOT NULL,

    CONSTRAINT PK_customers
        PRIMARY KEY (customer_id),

    CONSTRAINT CK_customers_region
        CHECK (region IN ('Midwest', 'Northeast', 'South', 'West')),

    CONSTRAINT CK_customers_device
        CHECK (preferred_device IN ('Desktop', 'Mobile', 'Tablet')),

    CONSTRAINT CK_customers_loyalty_tier
        CHECK (loyalty_tier IN ('Bronze', 'Silver', 'Gold', 'Platinum')),

    CONSTRAINT CK_customers_acquisition_channel
        CHECK (
            acquisition_channel IN
            (
                'Affiliate',
                'Email',
                'Organic Search',
                'Paid Search',
                'Paid Social',
                'Referral'
            )
        )
);
GO






CREATE TABLE core.products
(
    product_id      VARCHAR(5)    NOT NULL,
    category        VARCHAR(30)   NOT NULL,
    subcategory     VARCHAR(30)   NOT NULL,
    base_price_usd  DECIMAL(14,2) NOT NULL,
    unit_cost_usd   DECIMAL(14,2) NOT NULL,

    CONSTRAINT PK_products
        PRIMARY KEY (product_id),

    CONSTRAINT CK_products_base_price
        CHECK (base_price_usd >= 0),

    CONSTRAINT CK_products_unit_cost
        CHECK (unit_cost_usd >= 0)
);
GO




CREATE TABLE core.orders
(
    order_id                     VARCHAR(9)    NOT NULL,
    customer_id                  VARCHAR(7)    NOT NULL,
    order_date                   DATE          NOT NULL,
    sales_channel                VARCHAR(20)   NOT NULL,
    payment_method               VARCHAR(20)   NOT NULL,
    shipping_type                VARCHAR(20)   NOT NULL,
    coupon_used                  BIT           NOT NULL,
    discount_pct                 DECIMAL(5,2)  NOT NULL,
    order_status                 VARCHAR(15)   NOT NULL,
    shipping_fee_usd             DECIMAL(14,2) NOT NULL,
    tax_amount_usd               DECIMAL(14,2) NOT NULL,
    gross_merchandise_value_usd  DECIMAL(14,2) NOT NULL,
    net_revenue_usd              DECIMAL(14,2) NOT NULL,
    total_cost_usd               DECIMAL(14,2) NOT NULL,
    profit_usd                   DECIMAL(14,2) NOT NULL,

    CONSTRAINT PK_orders
        PRIMARY KEY (order_id),

    CONSTRAINT FK_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id),

    CONSTRAINT CK_orders_coupon
        CHECK (coupon_used IN (0,1)),

    CONSTRAINT CK_orders_discount
        CHECK (discount_pct BETWEEN 0 AND 100),

    CONSTRAINT CK_orders_status
        CHECK (order_status IN ('Completed', 'Refunded', 'Cancelled')),

    CONSTRAINT CK_orders_sales_channel
        CHECK (
            sales_channel IN ('Website', 'Mobile App', 'Marketplace')
        ),

    CONSTRAINT CK_orders_payment_method
        CHECK (
            payment_method IN ('Card', 'PayPal', 'Digital Wallet', 'BNPL')
        ),

    CONSTRAINT CK_orders_shipping_type
        CHECK (
            shipping_type IN ('Standard', 'Express', 'Free Standard')
        ),

    CONSTRAINT CK_orders_nonnegative_values
        CHECK
        (
            shipping_fee_usd >= 0
            AND tax_amount_usd >= 0
            AND gross_merchandise_value_usd >= 0
            AND net_revenue_usd >= 0
            AND total_cost_usd >= 0
        ),

    CONSTRAINT CK_orders_profit
        CHECK (
            profit_usd = net_revenue_usd - total_cost_usd
        ),

    CONSTRAINT CK_orders_cancelled_financials
        CHECK
        (
            order_status <> 'Cancelled'
            OR
            (
                net_revenue_usd = 0
                AND total_cost_usd = 0
                AND profit_usd = 0
            )
        )
);
GO






CREATE TABLE core.order_items
(
    order_item_id    VARCHAR(11)   NOT NULL,
    order_id         VARCHAR(9)    NOT NULL,
    product_id       VARCHAR(5)    NOT NULL,
    quantity         INT           NOT NULL,
    unit_price_usd   DECIMAL(14,2) NOT NULL,
    discount_pct     DECIMAL(5,2)  NOT NULL,
    line_revenue_usd DECIMAL(14,2) NOT NULL,
    line_cost_usd    DECIMAL(14,2) NOT NULL,

    CONSTRAINT PK_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES core.orders(order_id),

    CONSTRAINT FK_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES core.products(product_id),

    CONSTRAINT CK_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT CK_order_items_discount
        CHECK (discount_pct BETWEEN 0 AND 100),

    CONSTRAINT CK_order_items_values
        CHECK
        (
            unit_price_usd >= 0
            AND line_revenue_usd >= 0
            AND line_cost_usd >= 0
        )
);
GO




CREATE TABLE core.web_sessions
(
    session_id       VARCHAR(10)  NOT NULL,
    customer_id      VARCHAR(7)   NOT NULL,
    session_date     DATE         NOT NULL,
    device           VARCHAR(10)  NOT NULL,
    traffic_source   VARCHAR(20)  NOT NULL,
    pages_viewed     INT          NOT NULL,
    session_minutes  DECIMAL(8,2) NOT NULL,
    product_views    INT          NOT NULL,
    cart_adds        INT          NOT NULL,
    checkout_started BIT          NOT NULL,
    converted        BIT          NOT NULL,

    CONSTRAINT PK_web_sessions
        PRIMARY KEY (session_id),

    CONSTRAINT FK_web_sessions_customers
        FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id),

    CONSTRAINT CK_web_sessions_device
        CHECK (device IN ('Desktop', 'Mobile', 'Tablet')),

    CONSTRAINT CK_web_sessions_pages
        CHECK (pages_viewed >= 1),

    CONSTRAINT CK_web_sessions_minutes
        CHECK (session_minutes >= 0),

    CONSTRAINT CK_web_sessions_product_views
        CHECK (product_views >= 0),

    CONSTRAINT CK_web_sessions_cart_adds
        CHECK (cart_adds >= 0),

    CONSTRAINT CK_web_sessions_cart_product_funnel
        CHECK (cart_adds <= product_views),

    CONSTRAINT CK_web_sessions_conversion_funnel
        CHECK
        (
            converted = 0
            OR checkout_started = 1
        )
);
GO





CREATE TABLE core.support_tickets
(
    ticket_id         VARCHAR(8)   NOT NULL,
    customer_id       VARCHAR(7)   NOT NULL,
    opened_date       DATE         NOT NULL,
    issue_type        VARCHAR(30)  NOT NULL,
    priority          VARCHAR(10)  NOT NULL,
    resolution_hours  DECIMAL(8,2) NOT NULL,
    csat_score        TINYINT      NOT NULL,
    refunded          BIT          NOT NULL,

    CONSTRAINT PK_support_tickets
        PRIMARY KEY (ticket_id),

    CONSTRAINT FK_support_tickets_customers
        FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id),

    CONSTRAINT CK_support_priority
        CHECK (priority IN ('Low', 'Medium', 'High')),

    CONSTRAINT CK_support_csat
        CHECK (csat_score BETWEEN 1 AND 5),

    CONSTRAINT CK_support_resolution
        CHECK (resolution_hours >= 0)
);
GO





CREATE TABLE core.marketing_spend
(
    month       DATE          NOT NULL,
    channel     VARCHAR(20)   NOT NULL,
    spend_usd   DECIMAL(14,2) NOT NULL,
    impressions BIGINT        NOT NULL,
    clicks      BIGINT        NOT NULL,
    leads       BIGINT        NOT NULL,

    CONSTRAINT PK_marketing_spend
        PRIMARY KEY (month, channel),

    CONSTRAINT CK_marketing_spend
        CHECK (spend_usd >= 0),

    CONSTRAINT CK_marketing_funnel
        CHECK
        (
            impressions >= 0
            AND clicks >= 0
            AND leads >= 0
            AND clicks <= impressions
            AND leads <= clicks
        )
);
GO





CREATE TABLE analytics.customer_modeling_snapshot
(
    customer_id                 VARCHAR(7)    NOT NULL,
    snapshot_date               DATE          NOT NULL,

    region                      VARCHAR(10)   NOT NULL,
    acquisition_channel         VARCHAR(20)   NOT NULL,
    preferred_device            VARCHAR(10)   NOT NULL,
    loyalty_tier                VARCHAR(10)   NOT NULL,

    days_since_signup           INT           NOT NULL,
    recency_days                INT           NOT NULL,
    frequency_12m               INT           NOT NULL,

    monetary_value_12m          DECIMAL(14,2) NOT NULL,
    avg_order_value_12m         DECIMAL(14,2) NOT NULL,
    profit_12m                  DECIMAL(14,2) NOT NULL,

    gross_margin_pct_12m        DECIMAL(12,8) NOT NULL,
    avg_discount_pct_12m        DECIMAL(10,6) NOT NULL,
    refund_rate_12m             DECIMAL(12,8) NOT NULL,

    category_diversity_12m      INT           NOT NULL,

    web_sessions_90d            INT           NOT NULL,
    avg_session_minutes_90d     DECIMAL(10,4) NOT NULL,
    product_views_90d           INT           NOT NULL,
    cart_adds_90d               INT           NOT NULL,
    conversion_rate_90d         DECIMAL(12,8) NOT NULL,
    cart_add_rate_90d           DECIMAL(12,8) NOT NULL,

    support_tickets_12m         INT           NOT NULL,
    avg_resolution_hours_12m    DECIMAL(10,4) NOT NULL,
    avg_csat_12m                DECIMAL(10,6) NOT NULL,
    refund_requests_12m         INT           NOT NULL,

    churned_next_90d            BIT           NOT NULL,

    CONSTRAINT PK_customer_modeling_snapshot
        PRIMARY KEY (customer_id, snapshot_date),

    CONSTRAINT FK_modeling_snapshot_customers
        FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id),

    CONSTRAINT CK_modeling_snapshot_churn
        CHECK (churned_next_90d IN (0,1))
);
GO





