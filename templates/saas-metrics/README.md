# SaaS Metrics dbt Template

**Production-ready SaaS analytics in minutes, not weeks.**

## What's Included

### Models (16 total)

| Layer | Model | Description |
|-------|-------|-------------|
| Staging | `stg_subscriptions` | Cleaned subscription records with normalized MRR |
| Staging | `stg_customers` | Customer records with enrichment fields |
| Staging | `stg_events` | Product & subscription events |
| Intermediate | `int_subscription_periods` | Subscriptions expanded into monthly periods |
| Intermediate | `int_mrr_movements` | Month-over-month MRR movement classification |
| Intermediate | `int_customer_ltv` | Customer-level LTV calculations |
| Marts | `fct_mrr` | Subscription × month MRR fact table |
| Marts | `fct_churn` | Churned subscription details |
| Marts | `dim_customers` | Customer dimension with current status & LTV |
| Metrics | `monthly_saas_metrics` | **Executive KPI table — start here** |

### Key Metrics Calculated

- **MRR / ARR** — Total and by segment
- **MRR Waterfall** — New, Expansion, Contraction, Churn, Reactivation
- **Net New MRR** — Month-over-month MRR change
- **Logo Churn Rate** — Customer count churn
- **Revenue Churn Rate** — MRR-based churn
- **Net Revenue Retention (NRR)** — Expansion minus churn
- **Gross Revenue Retention (GRR)** — MRR retained before expansion
- **Quick Ratio** — Growth efficiency metric
- **Customer LTV** — Cumulative and predicted
- **Cohort Retention** — Via analysis file

### Macros

- `arr_from_mrr()` — Convert MRR to ARR
- `mrr_to_tier()` — Segment customers by MRR
- `safe_churn_rate()` — Null-safe churn calculation
- `safe_nrr()` — Net revenue retention
- `quick_ratio()` — SaaS quick ratio
- `cohort_month()` — Date truncation helper
- `months_active()` — Tenure calculation

## Setup

### 1. Configure your data sources

The staging models read from seeds (sample data) by default. To connect to your actual data sources, replace the `from {{ ref('sample_...') }}` in each staging model with your source tables:

```sql
-- Replace this:
select * from {{ ref('sample_subscriptions') }}

-- With your source:
select * from {{ source('stripe', 'subscriptions') }}
```

Add your sources to a `_sources.yml` file:

```yaml
version: 2
sources:
  - name: stripe
    database: raw
    schema: stripe
    tables:
      - name: subscriptions
      - name: customers
```

### 2. Configure your profile

```bash
cp profiles.yml.example ~/.dbt/profiles.yml
# Edit with your warehouse credentials
```

### 3. Install packages & run

```bash
dbt deps
dbt seed          # load sample data
dbt run
dbt test
dbt docs generate && dbt docs serve
```

### 4. Connect your BI tool

Point your BI tool at the `metrics` schema. The `monthly_saas_metrics` table is
designed to be the primary data source for your MRR dashboard.

**Recommended visualizations:**
- MRR Waterfall chart (new + expansion + contraction + churn)
- ARR over time line chart
- Cohort retention heatmap (use `analyses/cohort_retention.sql`)
- NRR / GRR trend
- Quick Ratio over time

## Customization Guide

### Adding a new plan tier

Update `stg_subscriptions.sql`:
```sql
-- In the accepted_values test:
values: ['plan_starter', 'plan_pro', 'plan_enterprise', 'plan_your_new_plan']
```

### Changing customer segmentation

Edit `dim_customers.sql`, look for `customer_segment`:
```sql
case
    when coalesce(cs.current_mrr, 0) >= 2000  then 'enterprise'   -- adjust thresholds
    when coalesce(cs.current_mrr, 0) >= 500   then 'mid_market'
    ...
```

### Adding CAC data for LTV/CAC ratio

Add a `marketing_spend` seed or source, then in `int_customer_ltv.sql`:
```sql
-- Join to your CAC data
left join cac_by_channel using (acquisition_channel)
-- Then calculate:
cm.total_mrr_paid / nullif(cac.cac_amount, 0)  as ltv_cac_ratio
```

## Support

Questions? Email support@your-domain.com or check the documentation site.
