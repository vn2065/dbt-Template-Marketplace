# dbt Template Marketplace

Production-ready dbt project templates for specific industries. Buy once, deploy in minutes.

## Available Templates

| Template | Industry | Price | What You Get |
|----------|----------|-------|--------------|
| **SaaS Metrics** | SaaS / Subscriptions | $149 | MRR, ARR, Churn, LTV, CAC, NPS analytics |
| **eCommerce Funnels** | eCommerce / Retail | $129 | Funnel analysis, cohorts, RFM, product analytics |
| **Fintech Analytics** | Finance / Fintech | $179 | Transaction risk, revenue recognition, portfolio analytics |

## Why Buy a Template?

- **Save 40-80 hours** of dbt modeling work
- **Production-ready** — tested, documented, and following dbt best practices
- **Industry-standard metrics** — stakeholders immediately recognize and trust the numbers
- **Fully customizable** — every model is yours to modify

## Template Features (All Templates)

- Staging, intermediate, and mart layers following dbt best practices
- Full test coverage (not_null, unique, accepted_values, relationships)
- Column-level documentation on every model
- Pre-built exposures for BI tools (Looker, Tableau, Metabase)
- Seed files with sample data for local development
- Macro library for common transformations
- GitHub Actions CI/CD workflow
- Setup guide and video walkthrough

## Quick Start

```bash
# 1. Clone or download your purchased template
git clone <your-template-repo>

# 2. Install dependencies
pip install dbt-core dbt-<your-adapter>

# 3. Configure your profile
cp profiles.yml.example ~/.dbt/profiles.yml
# Edit with your warehouse credentials

# 4. Install dbt packages
dbt deps

# 5. Run with sample data
dbt seed
dbt run
dbt test

# 6. View docs
dbt docs generate && dbt docs serve
```

## Supported Warehouses

All templates are adapter-agnostic and tested on:
- Snowflake
- BigQuery
- Databricks / Spark
- Redshift
- DuckDB (local dev)

## Purchase

Visit our [Gumroad Store](https://your-gumroad-url) to purchase templates.

## Support

- Email: support@your-domain.com
- Documentation: Included with each template
- Updates: 12 months of free updates included

## License

Each template is licensed for use in a single organization. See `LICENSE.md` in each template for details.
