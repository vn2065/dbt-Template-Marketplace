with source as (

    select * from {{ ref('sample_accounts') }}

),

renamed as (

    select
        id                                              as account_id,
        user_id,
        account_type,
        status,
        cast(opened_at as date)                         as opened_date,
        cast(closed_at as date)                         as closed_date,
        cast(balance as numeric)                        as balance,
        currency,
        cast(credit_limit as numeric)                   as credit_limit,
        country,
        kyc_status,
        risk_tier,

        -- Derived
        status = 'active'                               as is_active,
        kyc_status = 'verified'                         as is_kyc_verified,

        case
            when balance >= 10000 then 'high_balance'
            when balance >= 1000  then 'mid_balance'
            else 'low_balance'
        end                                             as balance_tier,

        -- Days since opened
        datediff('day', cast(opened_at as date), current_date)
                                                        as account_age_days,

        -- Metadata
        current_timestamp                               as _loaded_at

    from source

)

select * from renamed
