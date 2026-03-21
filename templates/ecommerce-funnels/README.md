# eCommerce Funnels dbt Template

**Full-stack eCommerce analytics: funnels, RFM, cohorts, and product performance.**

## What's Included

### Models (12 total)

| Layer | Model | Description |
|-------|-------|-------------|
| Staging | `stg_orders` | Cleaned order records with derived date fields |
| Staging | `stg_order_items` | Line-item level order data |
| Staging | `stg_sessions` | Web/app sessions with channel attribution |
| Intermediate | `int_customer_orders` | Customer-level order aggregations |
| Intermediate | `int_rfm_scores` | RFM scoring (Recency, Frequency, Monetary) |
| Marts | `fct_orders` | Order fact table with enrichment |
| Marts | `dim_customers_ecom` | Customer dimension with RFM and lifecycle stage |
| Metrics | `monthly_ecommerce_metrics` | **Executive KPI table — start here** |
| Metrics | `product_analytics` | Product-level performance and rankings |

### Key Metrics

- **Revenue**: Gross, net, by channel, by category
- **Orders**: Volume, AOV, abandoned cart rate
- **Customers**: New vs. repeat, lifecycle stages, LTV
- **RFM Segments**: Champions, Loyal, At Risk, Lost, etc.
- **Funnel**: Session → purchase conversion (analysis file)
- **Products**: Best sellers, category share, revenue rank
- **Cohorts**: Repeat purchase analysis (analysis file)

## Setup

### Connect your data sources

Replace `from {{ ref('sample_...') }}` in staging models with your sources:

**Shopify:**
```sql
select * from {{ source('shopify', 'orders') }}
```

**WooCommerce / custom:**
```sql
select * from {{ source('your_database', 'orders') }}
```

### Map your schema

The key fields to map are:
- `orders`: id, customer_id, status, created_at, total_amount, channel
- `order_items`: id, order_id, product_id, quantity, unit_price
- `sessions`: id, user_id, started_at, channel, converted

## Segments Available

### RFM Segments (for email campaigns)
| Segment | Description | Action |
|---------|-------------|--------|
| Champions | Best customers | Loyalty rewards, early access |
| Loyal Customers | Regular buyers | Upsell, referral program |
| Potential Loyalists | Recent with potential | Onboarding sequence |
| New Customers | First purchase | Welcome series |
| At Risk | Slipping away | Win-back campaign |
| Can't Lose | High value, gone quiet | Personal outreach |
| Lost | Haven't bought in 6+ months | Re-engagement offer |

### Lifecycle Stages
- **New** (1 order, <90 days)
- **Active** (2+ orders, <90 days)
- **At Risk** (91-180 days since last order)
- **Lapsed** (180+ days)
