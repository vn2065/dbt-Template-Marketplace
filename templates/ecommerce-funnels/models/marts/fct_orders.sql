/*
  Order fact table. One row per order.
  The primary grain for revenue analysis.
*/
with orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select
        order_id,
        count(*)                    as item_count,
        count(distinct product_id)  as unique_products,
        count(distinct category)    as unique_categories,
        listagg(category, ', ')
            within group (order by category)
                                    as categories_purchased

    from {{ ref('stg_order_items') }}
    group by 1

),

final as (

    select
        -- Keys
        o.order_id,
        o.customer_id,

        -- Dates
        o.order_date,
        o.order_month,
        o.order_year,
        o.order_quarter,
        o.day_of_week,
        o.hour_of_day,

        -- Status
        o.status,
        o.is_completed,

        -- Revenue
        o.subtotal,
        o.discount_amount,
        o.shipping_amount,
        o.tax_amount,
        o.total_amount,
        o.currency,
        o.has_discount,
        o.coupon_code,

        -- Channel
        o.channel,

        -- Order composition
        coalesce(oi.item_count, 0)          as item_count,
        coalesce(oi.unique_products, 0)     as unique_products,
        coalesce(oi.unique_categories, 0)   as unique_categories,
        oi.categories_purchased

    from orders o
    left join order_items oi using (order_id)

)

select * from final
