with source as (

    select * from {{ ref('sample_sessions') }}

),

renamed as (

    select
        id                                              as session_id,
        customer_id,
        anonymous_id,
        coalesce(customer_id, anonymous_id)             as user_id,
        cast(started_at as timestamp)                   as started_at,
        cast(ended_at as timestamp)                     as ended_at,
        cast(started_at as date)                        as session_date,
        channel,
        utm_source,
        utm_medium,
        utm_campaign,
        device_type,
        landing_page,
        cast(converted as boolean)                      as converted,

        -- Derived
        datediff('second', cast(started_at as timestamp),
                 cast(ended_at as timestamp))           as session_duration_seconds,
        customer_id is not null                         as is_identified,

        -- Channel grouping
        case
            when channel = 'paid_search'     then 'paid'
            when channel = 'paid_social'     then 'paid'
            when channel = 'organic'         then 'organic'
            when channel = 'email'           then 'email'
            when channel = 'referral'        then 'referral'
            when channel = 'direct'          then 'direct'
            else 'other'
        end                                             as channel_group,

        -- Metadata
        current_timestamp                               as _loaded_at

    from source

)

select * from renamed
