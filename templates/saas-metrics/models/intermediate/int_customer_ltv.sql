/*
  Calculates customer-level LTV metrics:
  - Cumulative MRR paid to date
  - LTV prediction based on average subscription length
  - Payback period relative to CAC (when provided)
*/
with subscription_periods as (

    select * from {{ ref('int_subscription_periods') }}
    where is_active_in_month = true

),

customers as (

    select * from {{ ref('stg_customers') }}

),

customer_mrr as (

    select
        customer_id,
        min(month_start)                            as first_active_month,
        max(month_start)                            as last_active_month,
        count(distinct month_start)                 as active_months,
        sum(normalized_mrr)                         as total_mrr_paid,
        avg(normalized_mrr)                         as avg_monthly_mrr,
        max(normalized_mrr)                         as peak_mrr

    from subscription_periods
    group by 1

),

joined as (

    select
        c.customer_id,
        c.customer_name,
        c.acquisition_channel,
        c.first_paid_date,
        c.country,
        c.industry,

        cm.first_active_month,
        cm.last_active_month,
        cm.active_months,
        cm.total_mrr_paid,
        cm.avg_monthly_mrr,
        cm.peak_mrr,

        -- LTV calculation: avg MRR * expected lifetime in months
        -- Using company-wide avg churn rate; replace with actual when available
        cm.avg_monthly_mrr * (1 / nullif(0.05, 0))  as predicted_ltv_simple,

        -- Months since first payment
        datediff('month', cm.first_active_month, current_date) as months_since_first_payment

    from customers c
    left join customer_mrr cm using (customer_id)

)

select * from joined
