/*
  eCommerce customer dimension.
  Includes RFM scores, order history summary, and customer lifecycle stage.
*/
with rfm as (

    select * from {{ ref('int_rfm_scores') }}

),

orders as (

    select * from {{ ref('int_customer_orders') }}

),

final as (

    select
        -- Keys
        o.customer_id,

        -- Order history
        o.first_order_date,
        o.last_order_date,
        o.days_since_last_order,
        o.total_orders,
        o.total_revenue,
        o.avg_order_value,
        o.discounted_orders,
        o.distinct_categories_purchased,
        o.distinct_products_purchased,
        o.most_recent_channel,

        -- RFM
        r.r_score,
        r.f_score,
        r.m_score,
        r.rfm_total,
        r.rfm_cell,
        r.rfm_segment,

        -- Customer value tier
        case
            when o.total_revenue >= 500  then 'high_value'
            when o.total_revenue >= 100  then 'mid_value'
            else 'low_value'
        end                                     as value_tier,

        -- Lifecycle stage
        case
            when o.total_orders = 1
             and o.days_since_last_order <= 90  then 'new'
            when o.total_orders >= 2
             and o.days_since_last_order <= 90  then 'active'
            when o.days_since_last_order between 91 and 180
                                                then 'at_risk'
            when o.days_since_last_order > 180  then 'lapsed'
            else 'unknown'
        end                                     as lifecycle_stage,

        -- Purchase frequency label
        case
            when o.total_orders >= 10   then 'very_frequent'
            when o.total_orders >= 5    then 'frequent'
            when o.total_orders >= 2    then 'repeat'
            else 'one_time'
        end                                     as frequency_segment,

        -- Discount sensitivity
        case
            when o.total_orders > 0
             and o.discounted_orders * 1.0 / o.total_orders >= 0.5
                                                then 'discount_driven'
            else 'not_discount_driven'
        end                                     as discount_sensitivity

    from orders o
    left join rfm r using (customer_id)

)

select * from final
