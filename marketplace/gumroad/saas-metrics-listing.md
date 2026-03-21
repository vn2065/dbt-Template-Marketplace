# Gumroad Listing: SaaS Metrics dbt Template

## Product Title
SaaS Metrics dbt Template — MRR, Churn, NRR, LTV in Minutes

## Price
$149

## Short Description (for search/preview)
Production-ready dbt project for SaaS analytics. Get MRR waterfall, churn rates, NRR, quick ratio, and cohort retention out of the box. Works with Snowflake, BigQuery, Redshift, and Databricks.

---

## Full Listing Description

**Stop rebuilding the same SaaS metrics from scratch.**

If you've ever joined a new company and spent your first 3 weeks rebuilding MRR models, this template is for you.

### What you get

A complete, production-ready dbt project with:

**16 models across 4 layers:**
- Staging: subscriptions, customers, events
- Intermediate: monthly expansion logic, MRR movement attribution, LTV
- Marts: MRR fact table, churn fact table, customer dimension
- Metrics: monthly executive KPI table with every metric investors ask about

**Every SaaS metric that matters:**
- Monthly / Annual Recurring Revenue (MRR / ARR)
- MRR Waterfall — New Business, Expansion, Contraction, Churn, Reactivation
- Net New MRR
- Net Revenue Retention (NRR) — with 100%+ tracking
- Gross Revenue Retention (GRR)
- Logo Churn Rate
- Revenue Churn Rate
- SaaS Quick Ratio
- Customer LTV (cumulative and predicted)
- Cohort retention analysis

**Full test coverage:**
Every model has not_null, unique, accepted_values, and relationships tests. Run `dbt test` and catch schema issues before they reach your dashboards.

**BI-ready:**
The `monthly_saas_metrics` table drops directly into Looker, Tableau, Metabase, or Mode. No transformations needed.

**CI/CD:**
Includes GitHub Actions workflow that runs `dbt run` + `dbt test` on every PR using DuckDB (no warehouse credentials required).

---

### Who this is for

- **Analytics engineers** who are sick of reinventing the wheel
- **Data engineers** who need to get a SaaS analytics layer running fast
- **Consultants** who work with multiple SaaS clients
- **Startups** who need investor-grade metrics without a full data team

---

### What's NOT included

This template assumes you already have:
- Raw subscription/billing data (Stripe, Chargebee, Recurly, etc.)
- A running data warehouse
- Basic dbt knowledge

Connecting to your source data takes about 30 minutes.

---

### FAQ

**What adapters does it support?**
Adapter-agnostic SQL. Tested on Snowflake and DuckDB. Minor syntax adjustments may be needed for BigQuery (use `DATE_TRUNC` syntax) or Redshift.

**Can I use this for multiple clients?**
Each license covers one organization. Purchase multiple licenses for agency use.

**What if my subscription data looks different?**
The staging layer is designed to be easy to adapt. Detailed mapping guide included.

**Do I need to know dbt?**
Yes — basic dbt knowledge required. If you can run `dbt run` and understand refs, you'll be fine.

---

### What you'll receive

- ZIP file with complete dbt project
- Setup guide (PDF)
- Schema mapping worksheet
- Lifetime access to updates

---

## Tags
dbt, data engineering, analytics engineering, SaaS metrics, MRR, ARR, churn, NRR, recurring revenue, Snowflake, BigQuery, dbt template
