# Fintech Analytics dbt Template

**Production-ready financial analytics with risk monitoring, transaction intelligence, and regulatory compliance support.**

## What's Included

### Models (10 total)

| Layer | Model | Description |
|-------|-------|-------------|
| Staging | `stg_transactions` | Cleaned transactions with risk signals and time dims |
| Staging | `stg_accounts` | Account records with KYC status and risk tier |
| Intermediate | `int_transaction_risk` | Risk enrichment with anomaly signals + composite score |
| Marts | `fct_transactions` | Transaction fact table with full risk context |
| Metrics | `monthly_fintech_metrics` | **Executive KPI table — start here** |
| Metrics | `risk_monitoring` | Account risk queue with recommended actions |

### Key Metrics

**Financial:**
- Total Payment Volume (TPV / GMV)
- Transaction count and growth
- Average transaction value
- Payment method mix (card / ACH / wire)
- Cross-border transaction volume

**Risk & Compliance:**
- Flagged transaction rate
- High-risk transaction count
- Composite risk scoring (behavioral + categorical)
- AML monitoring signals
- Account risk levels with recommended actions (monitor / EDD / SAR)
- Decline rate analysis

### Macros

- `is_high_risk_country()` — OFAC/sanctions country check
- `risk_score_to_tier()` — Normalize risk scores to high/medium/low
- `safe_decline_rate()` — Null-safe decline rate calculation
- `tpv_growth()` — TPV month-over-month growth
- `is_business_hours()` — Flag off-hours transactions
- `is_weekend()` — Weekend transaction flag

## Setup

### Connect your data sources

Typical sources for fintech analytics:

**Stripe / Adyen / Braintree (payments):**
```sql
select * from {{ source('stripe', 'charges') }}
```

**Core banking / ledger:**
```sql
select * from {{ source('core_banking', 'transactions') }}
```

**KYC/Identity:**
```sql
select * from {{ source('kyc_provider', 'verifications') }}
```

### Risk Thresholds

Adjust in `dbt_project.yml`:
```yaml
vars:
  high_risk_score_threshold: 75    # Score above this = high risk
  medium_risk_score_threshold: 50  # Score above this = medium risk
```

### Customize Risk Signals

In `int_transaction_risk.sql`, add your own signals:
```sql
-- Example: velocity check (more than 10 txns in 1 hour)
case
    when transaction_velocity_1h > 10 then 20
    else 0
end as velocity_risk_score
```

## Compliance Notes

> **Important:** This template provides analytical tooling for risk monitoring.
> It does not constitute legal compliance advice. Consult your compliance team
> for regulatory requirements specific to your jurisdiction and license.

Models are designed to support:
- **AML monitoring** — Suspicious pattern detection
- **KYC operations** — Account verification status tracking
- **SAR filing** — Suspicious Activity Report queuing
- **PCI DSS** — No raw card data stored in models

## Supported Regulatory Frameworks

Models are designed with these frameworks in mind:
- FinCEN / Bank Secrecy Act (BSA)
- PSD2 (EU payments)
- GDPR considerations (no PII in aggregated metrics)
- FCA (UK) transaction monitoring
