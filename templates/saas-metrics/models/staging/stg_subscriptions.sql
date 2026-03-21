with source as (

    select * from {{ ref('sample_subscriptions') }}

),

renamed as (

    select
        id                                          as subscription_id,
        customer_id,
        plan_id,
        status,
        cast(started_at as date)                    as started_date,
        cast(ended_at as date)                      as ended_date,
        cast(mrr_amount as numeric)                 as mrr_amount,
        currency,
        billing_interval,

        -- Derived fields
        case
            when billing_interval = 'monthly' then mrr_amount
            when billing_interval = 'annual'  then mrr_amount / 12
            else mrr_amount
        end                                         as normalized_mrr,

        case
            when status = 'active' and ended_at is null then true
            else false
        end                                         as is_active,

        -- Metadata
        current_timestamp                           as _loaded_at

    from source

)

select * from renamed
