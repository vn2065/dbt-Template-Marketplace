/*
  Churn fact table. One row per churned subscription.
  Enables cohort-based churn analysis, churn reason reporting,
  and survival analysis.
*/
with subscriptions as (

    select * from {{ ref('stg_subscriptions') }}
    where status = 'churned'

),

customers as (

    select * from {{ ref('stg_customers') }}

),

events as (

    select
        customer_id,
        occurred_at,
        properties,
        event_type

    from {{ ref('stg_events') }}
    where event_type = 'subscription_cancelled'

),

final as (

    select
        -- Keys
        {{ dbt_utils.generate_surrogate_key(['s.subscription_id']) }} as churn_id,
        s.subscription_id,
        s.customer_id,
        s.plan_id,

        -- Dates
        s.started_date,
        s.ended_date                                as churned_date,
        date_trunc('month', s.ended_date)           as churn_month,

        -- Duration
        datediff('month', s.started_date, s.ended_date)
                                                    as subscription_length_months,

        -- Revenue impact
        s.normalized_mrr                            as churned_mrr,
        s.normalized_mrr * 12                       as churned_arr,

        -- Churn reason (from cancellation event)
        -- Replace with your actual cancellation reason field
        null                                        as churn_reason,

        -- Customer attributes at time of churn
        c.acquisition_channel,
        c.industry,
        c.country,
        c.country_tier,

        -- Cohort (month customer first paid)
        date_trunc('month', c.first_paid_date)      as acquisition_cohort,

        -- Was this a long-tenured customer?
        case
            when datediff('month', s.started_date, s.ended_date) >= 12
                then 'long_tenure'
            when datediff('month', s.started_date, s.ended_date) >= 3
                then 'mid_tenure'
            else 'short_tenure'
        end                                         as tenure_segment

    from subscriptions s
    left join customers c using (customer_id)

)

select * from final
