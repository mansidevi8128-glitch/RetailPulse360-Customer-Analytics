CREATE INDEX IX_orders_customer_id
ON core.orders(customer_id);
GO

CREATE INDEX IX_orders_order_date
ON core.orders(order_date);
GO

CREATE INDEX IX_orders_status_date
ON core.orders(order_status, order_date)
INCLUDE (customer_id, net_revenue_usd, profit_usd);
GO

CREATE INDEX IX_order_items_order_id
ON core.order_items(order_id);
GO

CREATE INDEX IX_order_items_product_id
ON core.order_items(product_id);
GO

CREATE INDEX IX_web_sessions_customer_date
ON core.web_sessions(customer_id, session_date);
GO

CREATE INDEX IX_support_tickets_customer_date
ON core.support_tickets(customer_id, opened_date);
GO