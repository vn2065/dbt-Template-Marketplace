/*
  Transaction risk analysis intermediate model.
  Enriches transactions with account-level context,
  behavioral anomaly signals, and composite risk scoring.

  Used to power:
  - Fraud detection dashboards
  - SAR (Suspicious Activity Report) queues
  - Risk-based customer tiering
*/
with transactions as (

    select * from {{ ref('stg_transactions') }}

),

accounts as (

    select * from {{ ref('stg_accounts') }}

),

-- Calculate per-account transaction stats for anomaly detection
account_stats as (

    select
        account_id,
        avg(amount_abs)                             as avg_transaction_amount,
        stddev(amount_abs)                          as stddev_transaction_amount,
        count(*)                                    as total_transactions,
        count(distinct merchant_category)           as distinct_categories,
        count(distinct country)                     as distinct_countries,
        max(amount_abs)                             as max_transaction_amount

    from transactions
    where is_settled = true
    group by 1

),

enriched as (

    select
        t.transaction_id,
        t.account_id,
        t.user_id,
        t.transaction_type,
        t.amount,
        t.amount_abs,
        t.currency,
        t.status,
        t.created_at,
        t.transaction_date,
        t.transaction_month,
        t.merchant_category,
        t.merchant_name,
        t.country,
        t.payment_method,
        t.risk_score,
        t.risk_tier,
        t.is_flagged,
        t.is_settled,
        t.is_declined,

        -- Account context
        a.account_type,
        a.kyc_status,
        a.is_kyc_verified,
        a.account_age_days,
        a.risk_tier                                 as account_risk_tier,
        a.balance,

        -- Anomaly signals
        case
            when t.amount_abs > coalesce(ast.avg_transaction_amount, 0) * 3
            then true else false
        end                                         as is_unusually_large,

        case
            when t.country != 'US'
             and a.country = 'US'
            then true else false
        end                                         as is_foreign_transaction,

        case
            when t.merchant_category in ('gambling', 'crypto', 'wire')
            then true else false
        end                                         as is_high_risk_merchant,

        case
            when t.transaction_hour between 0 and 5
            then true else false
        end                                         as is_unusual_hours,

        -- Composite risk score (weighted)
        t.risk_score
            + case when t.amount_abs > coalesce(ast.avg_transaction_amount, 0) * 3
                   then 10 else 0 end
            + case when t.country != 'US' and a.country = 'US'
                   then 5 else 0 end
            + case when t.merchant_category in ('gambling', 'crypto')
                   then 15 else 0 end
            + case when t.transaction_hour between 0 and 5
                   then 5 else 0 end
            + case when not a.is_kyc_verified
                   then 20 else 0 end              as composite_risk_score

    from transactions t
    left join accounts a using (account_id)
    left join account_stats ast using (account_id)

)

select * from enriched
