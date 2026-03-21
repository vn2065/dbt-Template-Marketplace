/*
  Monthly MRR fact table.
  One row per subscription per month.
  Join to dim_customers or dim_plans for analysis.

  Key metrics available:
  - MRR by movement type (new, expansion, contraction, churn, reactivation)
  - Net new MRR
  - Active subscription count
*/
with mrr_movements as (

    select * from {{ ref('int_mrr_movements') }}

),

subscriptions as (

    select
        subscription_id,
        plan_id,
        billing_interval

    from {{ ref('stg_subscriptions') }}

),

final as (

    select
        -- Keys
        {{ dbt_utils.generate_surrogate_key(['m.subscription_id', 'm.month_start']) }}
                                                    as mrr_id,
        m.subscription_id,
        m.customer_id,
        m.plan_id,
        m.month_start                               as mrr_month,

        -- MRR amounts
        m.mrr,
        m.prev_mrr,
        m.mrr_change,
        m.movement_type,

        -- Movement flags (useful for pivoting in BI tools)
        case when m.movement_type = 'new_business'  then m.mrr  else 0 end as new_business_mrr,
        case when m.movement_type = 'expansion'     then m.mrr_change else 0 end as expansion_mrr,
        case when m.movement_type = 'contraction'   then m.mrr_change else 0 end as contraction_mrr,
        case when m.movement_type = 'churn'         then m.mrr_change else 0 end as churned_mrr,
        case when m.movement_type = 'reactivation'  then m.mrr  else 0 end as reactivation_mrr,
        case when m.movement_type = 'retained'      then m.mrr  else 0 end as retained_mrr,

        -- Active subscription flag
        case when m.mrr > 0 then 1 else 0 end       as is_active_subscription,

        -- Plan metadata
        s.billing_interval,

        -- Date dimensions
        date_part('year', m.month_start)            as mrr_year,
        date_part('month', m.month_start)           as mrr_month_number,
        date_part('quarter', m.month_start)         as mrr_quarter

    from mrr_movements m
    left join subscriptions s using (subscription_id)

)

select * from final
