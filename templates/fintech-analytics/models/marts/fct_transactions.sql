/*
  Transaction fact table. One row per transaction.
  Primary grain for financial reporting and risk analytics.
*/
with risk as (

    select * from {{ ref('int_transaction_risk') }}

),

final as (

    select
        -- Keys
        {{ dbt_utils.generate_surrogate_key(['transaction_id']) }}
                                                    as txn_key,
        transaction_id,
        account_id,
        user_id,

        -- Transaction details
        transaction_type,
        amount,
        amount_abs,
        currency,
        status,
        is_settled,
        is_declined,

        -- Dates
        created_at,
        transaction_date,
        transaction_month,
        transaction_hour,
        day_of_week,

        -- Merchant
        merchant_category,
        merchant_name,
        country,
        payment_method,

        -- Risk
        risk_score,
        risk_tier,
        composite_risk_score,
        is_flagged,
        is_unusually_large,
        is_foreign_transaction,
        is_high_risk_merchant,
        is_unusual_hours,

        -- Account context
        account_type,
        account_risk_tier,
        is_kyc_verified,
        account_age_days,

        -- Categorization
        case
            when merchant_category = 'gambling'         then 'regulated'
            when merchant_category = 'crypto'           then 'regulated'
            when merchant_category in ('retail', 'food', 'software')
                                                        then 'standard'
            when merchant_category in ('travel', 'luxury')
                                                        then 'high_value'
            else 'other'
        end                                             as merchant_category_group

    from risk

)

select * from final
