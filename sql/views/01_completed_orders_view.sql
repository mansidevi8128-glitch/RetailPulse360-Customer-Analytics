CREATE OR ALTER VIEW analytics.v_completed_orders
AS

SELECT
    order_id,
    customer_id,
    order_date,
    sales_channel,
    payment_method,
    shipping_type,
    coupon_used,
    discount_pct,
    shipping_fee_usd,
    tax_amount_usd,
    gross_merchandise_value_usd,
    net_revenue_usd,
    total_cost_usd,
    profit_usd
FROM core.orders
WHERE order_status = 'Completed';
GO