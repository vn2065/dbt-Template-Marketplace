/*
  Calculates MRR movements month-over-month per subscription.
  Movement types:
    - new_business: First month of a subscription
    - expansion: MRR increased from previous month
    - contraction: MRR decreased (but not to 0)
    - churn: Subscription ended
    - reactivation: Subscription restarted after a gap
    - retained: No change in MRR
*/
with subscription_periods as (

    select * from {{ ref('int_subscription_periods') }}
    where is_active_in_month = true

),

with_lag as (

    select
        *,
        lag(normalized_mrr) over (
            partition by customer_id, plan_id
            order by month_start
        ) as prev_mrr,

        lag(month_start) over (
            partition by customer_id, plan_id
            order by month_start
        ) as prev_month

    from subscription_periods

),

movement_classified as (

    select
        subscription_id,
        customer_id,
        plan_id,
        month_start,
        normalized_mrr                                      as mrr,
        coalesce(prev_mrr, 0)                               as prev_mrr,
        normalized_mrr - coalesce(prev_mrr, 0)              as mrr_change,

        case
            when prev_month is null
                then 'new_business'
            when prev_month < dateadd('month', -1, month_start)
                then 'reactivation'
            when normalized_mrr > prev_mrr
                then 'expansion'
            when normalized_mrr < prev_mrr
                then 'contraction'
            else 'retained'
        end                                                 as movement_type

    from with_lag

),

-- Churn events: subscriptions that existed last month but not this month
churned as (

    select distinct
        sp.subscription_id,
        sp.customer_id,
        sp.plan_id,
        dateadd('month', 1, sp.month_start)                 as month_start,
        0                                                   as mrr,
        sp.normalized_mrr                                   as prev_mrr,
        -1 * sp.normalized_mrr                              as mrr_change,
        'churn'                                             as movement_type

    from subscription_periods sp
    left join subscription_periods sp2
        on  sp.subscription_id = sp2.subscription_id
        and sp2.month_start = dateadd('month', 1, sp.month_start)

    where sp2.subscription_id is null
      and sp.is_churned_in_month = false  -- exclude months that are already the churn month

)

select * from movement_classified
union all
select * from churned
