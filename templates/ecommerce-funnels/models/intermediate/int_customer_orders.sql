/*
  Customer-level order aggregation.
  Used for RFM scoring and customer value calculation.
*/
with orders as (

    select * from {{ ref('stg_orders') }}
    where is_completed = true

),

order_items as (

    select * from {{ ref('stg_order_items') }}

),

customer_orders as (

    select
        o.customer_id,

        -- Recency
        max(o.order_date)                           as last_order_date,
        datediff('day', max(o.order_date), current_date)
                                                    as days_since_last_order,

        -- Frequency
        count(distinct o.order_id)                  as total_orders,

        -- Monetary
        sum(o.total_amount)                         as total_revenue,
        avg(o.total_amount)                         as avg_order_value,
        min(o.total_amount)                         as min_order_value,
        max(o.total_amount)                         as max_order_value,

        -- First order
        min(o.order_date)                           as first_order_date,

        -- Discount usage
        sum(case when o.has_discount then 1 else 0 end)
                                                    as discounted_orders,
        avg(case when o.has_discount then o.discount_amount else 0 end)
                                                    as avg_discount_amount,

        -- Channel preference
        max(o.channel)                              as most_recent_channel,

        -- Product diversity
        count(distinct oi.category)                 as distinct_categories_purchased,
        count(distinct oi.product_id)               as distinct_products_purchased

    from orders o
    left join order_items oi using (order_id)
    group by 1

)

select * from customer_orders
