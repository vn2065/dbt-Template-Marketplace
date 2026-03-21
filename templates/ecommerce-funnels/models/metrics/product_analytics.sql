/*
  Product-level performance analytics.
  One row per product. Identifies best sellers, margin contributors,
  and category performance.
*/
with order_items as (

    select * from {{ ref('stg_order_items') }}

),

orders as (

    select order_id, order_date, order_month, is_completed, channel
    from {{ ref('fct_orders') }}
    where is_completed = true

),

product_metrics as (

    select
        oi.product_id,
        oi.product_name,
        oi.category,

        -- Sales volume
        count(distinct o.order_id)                  as orders_containing_product,
        sum(oi.quantity)                             as total_units_sold,

        -- Revenue
        sum(oi.total_price)                         as total_revenue,
        avg(oi.unit_price)                          as avg_unit_price,
        avg(oi.total_price)                         as avg_revenue_per_order,

        -- Dates
        min(o.order_date)                           as first_sold_date,
        max(o.order_date)                           as last_sold_date,

        -- Customer reach
        count(distinct o.order_id)                  as unique_orders,

        -- Channel breakdown
        count(distinct case when o.channel = 'web' then o.order_id end)
                                                    as web_orders,
        count(distinct case when o.channel = 'mobile' then o.order_id end)
                                                    as mobile_orders

    from order_items oi
    join orders o using (order_id)
    group by 1, 2, 3

),

with_ranks as (

    select
        *,
        rank() over (order by total_revenue desc)   as revenue_rank,
        rank() over (order by total_units_sold desc) as volume_rank,
        rank() over (
            partition by category
            order by total_revenue desc
        )                                           as category_revenue_rank,

        -- Revenue share within category
        total_revenue / sum(total_revenue) over (
            partition by category
        )                                           as category_revenue_share,

        -- Revenue share overall
        total_revenue / sum(total_revenue) over ()  as overall_revenue_share

    from product_metrics

)

select * from with_ranks
