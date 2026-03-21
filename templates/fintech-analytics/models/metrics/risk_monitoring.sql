/*
  Risk monitoring dashboard.
  Identifies accounts and transactions requiring review.

  Use cases:
  - AML (Anti-Money Laundering) monitoring
  - Fraud operations queue
  - Compliance reporting
  - Risk team daily briefing
*/
with transactions as (

    select * from {{ ref('fct_transactions') }}

),

accounts as (

    select * from {{ ref('stg_accounts') }}

),

-- Account-level risk aggregation
account_risk as (

    select
        account_id,
        count(distinct transaction_id)              as total_transactions,
        count(distinct case when is_flagged then transaction_id end)
                                                    as flagged_count,
        count(distinct case when risk_tier = 'high' then transaction_id end)
                                                    as high_risk_count,
        sum(case when is_flagged then amount_abs else 0 end)
                                                    as flagged_amount,
        max(composite_risk_score)                   as max_risk_score,
        avg(composite_risk_score)                   as avg_risk_score,
        count(distinct country)                     as distinct_countries,
        max(transaction_date)                       as last_transaction_date,
        count(distinct case when is_foreign_transaction then transaction_id end)
                                                    as foreign_transaction_count,
        count(distinct case when is_high_risk_merchant then transaction_id end)
                                                    as high_risk_merchant_count

    from transactions
    group by 1

),

final as (

    select
        a.account_id,
        a.user_id,
        a.account_type,
        a.status,
        a.kyc_status,
        a.is_kyc_verified,
        a.risk_tier,
        a.country,
        a.balance,
        a.opened_date,
        a.account_age_days,

        -- Risk metrics
        ar.total_transactions,
        ar.flagged_count,
        ar.high_risk_count,
        ar.flagged_amount,
        ar.max_risk_score,
        ar.avg_risk_score,
        ar.distinct_countries,
        ar.last_transaction_date,
        ar.foreign_transaction_count,
        ar.high_risk_merchant_count,

        -- Flag rates
        ar.flagged_count * 1.0 / nullif(ar.total_transactions, 0)
                                                    as flag_rate,

        -- Overall account risk assessment
        case
            when not a.is_kyc_verified
             and ar.flagged_count > 0               then 'critical'
            when ar.max_risk_score >= 80
             or ar.flagged_count >= 3               then 'high'
            when ar.max_risk_score >= 60
             or ar.flagged_count >= 1               then 'medium'
            else 'low'
        end                                         as account_risk_level,

        -- Action recommendation
        case
            when not a.is_kyc_verified
             and ar.flagged_count > 0               then 'immediate_review'
            when a.status = 'suspended'             then 'escalate_to_compliance'
            when ar.max_risk_score >= 80            then 'file_sar'
            when ar.max_risk_score >= 60            then 'enhanced_due_diligence'
            when ar.flagged_count > 0               then 'monitor'
            else 'no_action'
        end                                         as recommended_action

    from accounts a
    left join account_risk ar using (account_id)

)

select * from final
order by max_risk_score desc nulls last
