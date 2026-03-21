with source as (

    select * from {{ ref('sample_order_items') }}

),

renamed as (

    select
        id                                          as order_item_id,
        order_id,
        product_id,
        product_name,
        category,
        cast(quantity as integer)                   as quantity,
        cast(unit_price as numeric)                 as unit_price,
        cast(total_price as numeric)                as total_price,

        -- Metadata
        current_timestamp                           as _loaded_at

    from source

)

select * from renamed
