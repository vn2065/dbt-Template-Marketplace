with source as (

    select * from {{ ref('sample_transactions') }}

),

renamed as (

    select
        id                                              as transaction_id,
        account_id,
        user_id,
        transaction_type,
        cast(amount as numeric)                         as amount,
        abs(cast(amount as numeric))                    as amount_abs,
        currency,
        status,
        cast(created_at as timestamp)                   as created_at,
        cast(settled_at as timestamp)                   as settled_at,
        cast(created_at as date)                        as transaction_date,
        date_trunc('month', cast(created_at as date))   as transaction_month,
        merchant_category,
        merchant_name,
        country,
        payment_method,
        cast(risk_score as integer)                     as risk_score,
        cast(is_flagged as boolean)                     as is_flagged,

        -- Derived status flags
        status = 'settled'                              as is_settled,
        status = 'declined'                             as is_declined,
        status = 'pending'                              as is_pending,
        status in ('flagged', 'suspended')              as is_flagged_status,

        -- Transaction direction
        case
            when transaction_type in ('purchase', 'fee', 'interest')
                then 'debit'
            when transaction_type in ('refund', 'transfer_in', 'deposit')
                then 'credit'
            when transaction_type = 'transfer'
                then 'transfer'
            else 'other'
        end                                             as transaction_direction,

        -- Risk classification
        case
            when cast(risk_score as integer) >= {{ var('high_risk_score_threshold') }}
                then 'high'
            when cast(risk_score as integer) >= {{ var('medium_risk_score_threshold') }}
                then 'medium'
            else 'low'
        end                                             as risk_tier,

        -- Settlement lag
        datediff('day',
            cast(created_at as date),
            cast(settled_at as date)
        )                                               as settlement_days,

        -- Time dimensions
        date_part('hour', cast(created_at as timestamp)) as transaction_hour,
        date_part('dow', cast(created_at as date))      as day_of_week,
        date_part('year', cast(created_at as date))     as transaction_year,

        -- Metadata
        current_timestamp                               as _loaded_at

    from source

)

select * from renamed
