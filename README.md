# dbt Template Marketplace

Production-ready dbt project templates for specific industries. Free and open source.

## Available Templates

| Template | Industry | Price | What You Get |
|----------|----------|-------|--------------|
| **SaaS Metrics** | SaaS / Subscriptions | Free | MRR, ARR, Churn, LTV, CAC, NPS analytics |
| **eCommerce Funnels** | eCommerce / Retail | Free | Funnel analysis, cohorts, RFM, product analytics |
| **Fintech Analytics** | Finance / Fintech | Free | Transaction risk, revenue recognition, portfolio analytics |

## Why Use These Templates?

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
# 1. Clone the repo
git clone <this-repo>

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

## Support

- Open an issue on GitHub for bugs or questions
- Documentation: included in each template's README

## License

MIT — free to use, modify, and distribute. See `LICENSE` for details.
