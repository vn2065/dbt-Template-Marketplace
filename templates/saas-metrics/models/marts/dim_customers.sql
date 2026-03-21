/*
  Customer dimension table. One row per customer.
  Includes current subscription status, LTV metrics, and segmentation.
*/
with customers as (

    select * from {{ ref('stg_customers') }}

),

ltv as (

    select * from {{ ref('int_customer_ltv') }}

),

current_subscription as (

    select
        customer_id,
        max(plan_id)                                as current_plan_id,
        sum(normalized_mrr)                         as current_mrr,
        count(*)                                    as active_subscription_count

    from {{ ref('stg_subscriptions') }}
    where is_active = true
    group by 1

),

final as (

    select
        -- Keys
        c.customer_id,

        -- Customer info
        c.customer_name,
        c.email,
        c.company,
        c.industry,
        c.country,
        c.country_tier,
        c.acquisition_channel,
        c.sales_rep,
        c.created_date,
        c.first_paid_date,

        -- Current subscription
        cs.current_plan_id,
        coalesce(cs.current_mrr, 0)                 as current_mrr,
        coalesce(cs.current_mrr, 0) * 12            as current_arr,
        coalesce(cs.active_subscription_count, 0)   as active_subscription_count,

        case
            when cs.customer_id is not null then 'active'
            else 'churned'
        end                                         as customer_status,

        -- LTV
        coalesce(ltv.total_mrr_paid, 0)             as total_mrr_paid,
        coalesce(ltv.active_months, 0)              as active_months,
        ltv.predicted_ltv_simple,

        -- Segmentation
        case
            when coalesce(cs.current_mrr, 0) >= 500  then 'enterprise'
            when coalesce(cs.current_mrr, 0) >= 100  then 'mid_market'
            when coalesce(cs.current_mrr, 0) > 0     then 'smb'
            else 'churned'
        end                                         as customer_segment,

        -- Engagement (months active as % of total months since signup)
        coalesce(ltv.active_months, 0) * 1.0
            / nullif(datediff('month', c.first_paid_date, current_date), 0)
                                                    as engagement_rate

    from customers c
    left join current_subscription cs using (customer_id)
    left join ltv using (customer_id)

)

select * from final
