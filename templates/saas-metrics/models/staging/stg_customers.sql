with source as (

    select * from {{ ref('sample_customers') }}

),

renamed as (

    select
        id                                          as customer_id,
        name                                        as customer_name,
        email,
        company,
        industry,
        country,
        cast(created_at as date)                    as created_date,
        sales_rep,
        acquisition_channel,
        cast(first_paid_at as date)                 as first_paid_date,

        -- Derived fields
        case
            when country in ('US', 'CA', 'UK', 'AU', 'DE', 'FR', 'NL', 'SE')
                then 'tier_1'
            else 'tier_2'
        end                                         as country_tier,

        -- Metadata
        current_timestamp                           as _loaded_at

    from source

)

select * from renamed
