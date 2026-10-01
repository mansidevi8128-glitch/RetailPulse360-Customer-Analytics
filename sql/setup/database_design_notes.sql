/*
RetailPulse 360
Relational Database Design

TABLE GRAINS

1. customers
   Grain: One row per customer
   PK: customer_id

2. products
   Grain: One row per product
   PK: product_id

3. orders
   Grain: One row per order
   PK: order_id
   FK: customer_id -> customers.customer_id

4. order_items
   Grain: One row per order line item
   PK: order_item_id
   FK: order_id -> orders.order_id
   FK: product_id -> products.product_id

5. web_sessions
   Grain: One row per web session
   PK: session_id
   FK: customer_id -> customers.customer_id

6. support_tickets
   Grain: One row per support ticket
   PK: ticket_id
   FK: customer_id -> customers.customer_id

7. marketing_spend
   Grain: One row per month and channel
   PK: (month, channel)

8. customer_modeling_snapshot
   Grain: One row per customer at snapshot date 2026-05-31
   FK: customer_id -> customers.customer_id

IMPORTANT ANALYTICAL RULE:
Do not sum order-level revenue after joining orders to
order_items because one order can have multiple line items,
causing revenue duplication.
*/