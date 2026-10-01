# RetailPulse 360 — SQL Server Analysis

## Objective

Build a relational SQL Server analytics layer for RetailPulse 360
and answer key questions around revenue, profitability,
customer behavior, refunds, retention and marketing efficiency.

---

## Database Architecture

CSV Files
    ↓
stg schema
    ↓
core schema
    ↓
analytics schema
    ↓
business analysis / modeling

### stg

Raw landing layer used for controlled CSV ingestion.

### core

Trusted relational layer containing:

- primary keys
- foreign keys
- NOT NULL constraints
- CHECK constraints
- validated financial fields

### analytics

Reusable analytical objects including:

- completed-order view
- monthly KPI view
- customer feature table

---

## KPI Definitions

### Revenue

Completed-order net revenue.

### Profit

Completed-order profit.

### AOV

Revenue / completed orders.

### Refund Rate

Refunded orders /
(Completed + Refunded orders).

Cancelled orders are excluded from realized-order calculations.

---

## SQL Analysis

1. Data-quality validation
2. Monthly KPIs
3. Month-over-month growth
4. Category profitability
5. Regional performance
6. Acquisition-channel customer value
7. Repeat purchase
8. Refund behavior
9. Support performance
10. RFM
11. Cohort retention
12. High-value customers with declining engagement
13. Sales-channel performance
14. Marketing efficiency
15. Customer modeling feature table

---

## SQL Techniques Demonstrated

- relational database design
- primary and foreign keys
- composite keys
- CHECK constraints
- transactions
- staging tables
- CTEs
- conditional aggregation
- window functions
- LAG
- RANK
- PERCENTILE_CONT
- cohort analysis
- RFM analysis
- analytical views
- indexing
- NULL handling
- date arithmetic

---

## Important Analytical Safeguards

Order-level revenue is never directly aggregated after joining
orders to order_items because this would duplicate revenue for
multi-item orders.

Product/category analysis uses line-item merchandise metrics.

Refunded transactions are analyzed separately from completed-order
revenue.

All modeling features use information available on or before
2026-05-31.

The churn target is synthetic.

---

## Key Findings

See `SQL_ANALYSIS_SUMMARY.md`.