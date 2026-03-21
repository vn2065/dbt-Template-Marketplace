# Gumroad Listing: eCommerce Funnels dbt Template

## Product Title
eCommerce Analytics dbt Template — Funnels, RFM, Cohorts & Product Analytics

## Price
$129

## Short Description
Production-ready dbt project for eCommerce. Get purchase funnels, RFM customer segmentation, cohort analysis, and product performance dashboards. Works with Shopify, WooCommerce, and any custom schema.

---

## Full Listing Description

**Your eCommerce data team's unfair advantage.**

Most eCommerce companies have the data but not the models. This template gives you a complete analytics layer in a weekend — not a quarter.

### What you get

**12 models across 4 layers:**
- Staging: orders, order items, sessions
- Intermediate: customer aggregations, RFM scoring
- Marts: order fact table, customer dimension with lifecycle
- Metrics: monthly KPI table, product analytics

**RFM Customer Segmentation (ready to export to your ESP):**

| Segment | Description |
|---------|-------------|
| Champions | Bought recently, buy often, spend the most |
| Loyal Customers | Regular buyers worth nurturing |
| Potential Loyalists | Recent with potential |
| New Customers | First purchase |
| At Risk | Slipping away — act fast |
| Can't Lose | High value, gone quiet — call them |
| Lost | Need aggressive win-back |

**Executive eCommerce metrics:**
- Gross & Net Revenue
- Total Orders, AOV (Average Order Value)
- Session Conversion Rate
- Customer Lifetime Value
- Repeat Purchase Rate
- Discount Rate & Discount Sensitivity
- Revenue Per Visitor
- Month-over-month growth rates

**Product Analytics:**
- Best sellers by revenue and volume
- Category performance
- Revenue share (product and category level)
- First/last sold dates

**Funnel Analysis:**
- Session → Product view → Add to cart → Purchase
- Conversion rates by channel and device
- Drop-off identification

---

### Who this is for

- Analytics engineers at DTC / eCommerce brands
- Consultants building client analytics stacks
- Agencies managing multiple Shopify stores
- BI teams needing a clean semantic layer

---

### Data sources

Works out of the box with sample data. Adapt staging models for:
- **Shopify** (via Fivetran or Airbyte connector)
- **WooCommerce**
- **Magento**
- **Any custom order management system**

---

### FAQ

**Does this include Shopify-specific models?**
The staging layer maps to common eCommerce schemas. A Shopify mapping guide is included.

**Can I add more funnel steps?**
Yes — the funnel analysis file is designed to be extended. Add any event-based funnel steps.

**Does it handle returns/refunds?**
Yes — refunds are handled in `stg_orders` and excluded from revenue metrics correctly.

---

## Tags
dbt, ecommerce analytics, RFM, customer segmentation, Shopify analytics, purchase funnel, cohort analysis, dbt template, data engineering
