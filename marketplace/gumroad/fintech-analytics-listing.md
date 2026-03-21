# Gumroad Listing: Fintech Analytics dbt Template

## Product Title
Fintech Analytics dbt Template — Transactions, Risk Monitoring & AML

## Price
$179

## Short Description
Production-ready dbt project for fintech analytics. Transaction intelligence, risk scoring, AML monitoring signals, TPV reporting, and compliance-ready account risk queuing. Stripe, Adyen, and custom schemas supported.

---

## Full Listing Description

**The analytics layer your compliance team has been asking for.**

Fintech analytics is different. You need transaction intelligence, not just revenue reporting. This template gives you production-grade models for both.

### What you get

**10 models across 4 layers:**
- Staging: transactions (with risk signals), accounts (with KYC status)
- Intermediate: composite risk scoring with anomaly detection
- Marts: transaction fact table with full risk context
- Metrics: monthly KPI dashboard, risk monitoring queue

**Financial reporting:**
- Total Payment Volume (TPV / GMV)
- Transaction count and growth rate
- Average transaction value
- Decline rate analysis
- Payment method mix (card / ACH / wire / crypto)
- Cross-border volume and rate
- Month-over-month growth

**Risk & Compliance monitoring:**

Composite risk scoring considers:
- Raw transaction risk score
- Unusually large amount (3x account average)
- Foreign transaction for domestic account
- High-risk merchant category (gambling, crypto)
- Off-hours transactions
- Unverified KYC status

**Account risk queue with recommended actions:**
| Risk Level | Action |
|------------|--------|
| Critical | Immediate review (unverified + flagged) |
| High (score ≥ 80) | File SAR |
| High (score ≥ 60) | Enhanced Due Diligence |
| Flagged transactions | Monitor |

**AML-aware design:**
- High-risk country flagging (OFAC-aware)
- Velocity anomaly signals (extensible)
- Suspicious activity pattern detection
- Structuring detection framework

---

### Who this is for

- Analytics engineers at neobanks, payment processors, or fintech startups
- Data teams supporting compliance and risk operations
- Consultants building financial data products
- Fraud/risk analysts needing a clean data layer

---

### Important disclaimer

> This template provides analytical tooling to support risk monitoring workflows.
> It does not constitute legal compliance advice. Consult qualified compliance
> counsel for regulatory requirements specific to your jurisdiction, license type,
> and transaction volumes.

---

### Data sources

Designed to connect to:
- **Stripe** (charges, disputes, payouts)
- **Adyen** (transactions, risk signals)
- **Braintree** / **Square**
- **Core banking** / ledger systems
- **Custom payment infrastructure**

---

### FAQ

**Is this PCI compliant?**
Models are designed to never store raw card data. Compliance with PCI DSS depends on your full data stack architecture.

**Can I extend the risk scoring?**
Yes — the composite score formula in `int_transaction_risk.sql` is fully documented and extensible.

**Does it include SAR filing logic?**
The `risk_monitoring` model flags accounts that meet SAR-worthy thresholds. Actual SAR filing workflows depend on your compliance tooling.

---

## Tags
dbt, fintech analytics, AML, transaction monitoring, risk scoring, TPV, payment analytics, compliance analytics, fraud detection, dbt template
