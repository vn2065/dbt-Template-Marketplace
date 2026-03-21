/*
  Expands subscriptions into monthly periods.
  Each row represents one month a subscription was active.
  Used as the foundation for MRR calculations.
*/
with subscriptions as (

    select * from {{ ref('stg_subscriptions') }}

),

-- Build a spine of all months between the earliest start and today
date_spine as (

    {{ dbt_utils.date_spine(
        datepart="month",
        start_date="cast('" ~ var('start_date') ~ "' as date)",
        end_date="current_date"
    ) }}

),

months as (

    select
        cast(date_month as date) as month_date,
        date_trunc('month', cast(date_month as date)) as month_start,
        last_day(cast(date_month as date)) as month_end

    from date_spine

),

-- Cross join subscriptions to months, keeping only active periods
subscription_months as (

    select
        s.subscription_id,
        s.customer_id,
        s.plan_id,
        s.status,
        s.normalized_mrr,
        s.currency,
        s.billing_interval,
        s.started_date,
        s.ended_date,
        m.month_start,

        -- Is this subscription active in this month?
        case
            when s.started_date <= m.month_end
             and (s.ended_date is null or s.ended_date >= m.month_start)
            then true
            else false
        end as is_active_in_month,

        -- First month flag
        case
            when date_trunc('month', s.started_date) = m.month_start
            then true
            else false
        end as is_new_in_month,

        -- Last month flag (churned)
        case
            when s.status = 'churned'
             and date_trunc('month', s.ended_date) = m.month_start
            then true
            else false
        end as is_churned_in_month

    from subscriptions s
    cross join months m
    where m.month_start >= date_trunc('month', s.started_date)
      and m.month_start <= coalesce(
            date_trunc('month', s.ended_date),
            date_trunc('month', current_date)
        )

)

select * from subscription_months
