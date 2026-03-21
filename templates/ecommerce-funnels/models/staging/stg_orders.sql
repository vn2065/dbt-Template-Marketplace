with source as (

    select * from {{ ref('sample_orders') }}

),

renamed as (

    select
        id                                              as order_id,
        customer_id,
        status,
        cast(created_at as timestamp)                   as created_at,
        cast(completed_at as timestamp)                 as completed_at,
        cast(created_at as date)                        as order_date,
        cast(subtotal as numeric)                       as subtotal,
        cast(discount_amount as numeric)                as discount_amount,
        cast(shipping_amount as numeric)                as shipping_amount,
        cast(tax_amount as numeric)                     as tax_amount,
        cast(total_amount as numeric)                   as total_amount,
        currency,
        channel,
        coupon_code,

        -- Derived
        case when coupon_code is not null then true else false end
                                                        as has_discount,
        case when status = 'completed' then true else false end
                                                        as is_completed,

        date_trunc('month', cast(created_at as date))   as order_month,
        date_part('year', cast(created_at as date))     as order_year,
        date_part('quarter', cast(created_at as date))  as order_quarter,
        date_part('dow', cast(created_at as date))      as day_of_week,
        date_part('hour', cast(created_at as timestamp)) as hour_of_day,

        -- Metadata
        current_timestamp                               as _loaded_at

    from source

)

select * from renamed
