with source as (

    select * from {{ ref('sample_events') }}

),

renamed as (

    select
        id                                          as event_id,
        customer_id,
        event_type,
        cast(occurred_at as timestamp)              as occurred_at,
        cast(occurred_at as date)                   as occurred_date,
        properties,

        -- Extract common property fields
        {{ dbt_utils.safe_cast(
            dbt_utils.get_column_values_from_json('properties', 'mrr'),
            'numeric'
        ) }}                                        as event_mrr,
        {{ dbt_utils.safe_cast(
            dbt_utils.get_column_values_from_json('properties', 'mrr_change'),
            'numeric'
        ) }}                                        as mrr_change,

        -- Event classification
        case
            when event_type in ('subscription_created', 'trial_converted')
                then 'new_business'
            when event_type = 'plan_upgraded'
                then 'expansion'
            when event_type = 'plan_downgraded'
                then 'contraction'
            when event_type in ('subscription_cancelled', 'subscription_paused')
                then 'churn'
            else 'other'
        end                                         as event_category,

        -- Metadata
        current_timestamp                           as _loaded_at

    from source

)

select * from renamed
