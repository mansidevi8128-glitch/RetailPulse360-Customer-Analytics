USE RetailPulse360;
GO

SET XACT_ABORT ON;
GO

BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO core.customers
    (
        customer_id,
        signup_date,
        state,
        region,
        acquisition_channel,
        preferred_device,
        loyalty_tier
    )
    SELECT
        customer_id,
        signup_date,
        state,
        region,
        acquisition_channel,
        preferred_device,
        loyalty_tier
    FROM stg.customers;


    INSERT INTO core.products
    (
        product_id,
        category,
        subcategory,
        base_price_usd,
        unit_cost_usd
    )
    SELECT
        product_id,
        category,
        subcategory,
        base_price_usd,
        unit_cost_usd
    FROM stg.products;


    INSERT INTO core.orders
    (
        order_id,
        customer_id,
        order_date,
        sales_channel,
        payment_method,
        shipping_type,
        coupon_used,
        discount_pct,
        order_status,
        shipping_fee_usd,
        tax_amount_usd,
        gross_merchandise_value_usd,
        net_revenue_usd,
        total_cost_usd,
        profit_usd
    )
    SELECT
        order_id,
        customer_id,
        order_date,
        sales_channel,
        payment_method,
        shipping_type,
        CAST(coupon_used AS BIT),
        discount_pct,
        order_status,
        shipping_fee_usd,
        tax_amount_usd,
        gross_merchandise_value_usd,
        net_revenue_usd,
        total_cost_usd,
        profit_usd
    FROM stg.orders;


    INSERT INTO core.order_items
    SELECT *
    FROM stg.order_items;


    INSERT INTO core.web_sessions
    SELECT
        session_id,
        customer_id,
        session_date,
        device,
        traffic_source,
        pages_viewed,
        session_minutes,
        product_views,
        cart_adds,
        CAST(checkout_started AS BIT),
        CAST(converted AS BIT)
    FROM stg.web_sessions;


    INSERT INTO core.support_tickets
    SELECT
        ticket_id,
        customer_id,
        opened_date,
        issue_type,
        priority,
        resolution_hours,
        csat_score,
        CAST(refunded AS BIT)
    FROM stg.support_tickets;


    INSERT INTO core.marketing_spend
    SELECT *
    FROM stg.marketing_spend;


    INSERT INTO analytics.customer_modeling_snapshot
    SELECT
        customer_id,
        snapshot_date,
        region,
        acquisition_channel,
        preferred_device,
        loyalty_tier,
        days_since_signup,
        CAST(recency_days AS INT),
        CAST(frequency_12m AS INT),
        monetary_value_12m,
        avg_order_value_12m,
        profit_12m,
        gross_margin_pct_12m,
        avg_discount_pct_12m,
        refund_rate_12m,
        CAST(category_diversity_12m AS INT),
        CAST(web_sessions_90d AS INT),
        avg_session_minutes_90d,
        CAST(product_views_90d AS INT),
        CAST(cart_adds_90d AS INT),
        conversion_rate_90d,
        cart_add_rate_90d,
        CAST(support_tickets_12m AS INT),
        avg_resolution_hours_12m,
        avg_csat_12m,
        CAST(refund_requests_12m AS INT),
        CAST(churned_next_90d AS BIT)
    FROM stg.customer_modeling_snapshot;


    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO