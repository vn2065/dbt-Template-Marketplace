/*
  Executive SaaS metrics summary. One row per month.
  Aggregates all key SaaS KPIs for easy reporting.

  Metrics included:
  - MRR (and ARR)
  - MRR movements (new, expansion, contraction, churn, reactivation)
  - Net new MRR
  - Customer counts and net new customers
  - Churn rate (logo and revenue)
  - Expansion revenue
  - Quick Ratio
*/
with mrr as (

    select * from {{ ref('fct_mrr') }}

),

monthly_summary as (

    select
        mrr_month,

        -- Active MRR
        sum(case when movement_type != 'churn' then mrr else 0 end)
                                                    as ending_mrr,
        sum(case when movement_type != 'churn' then mrr else 0 end) * 12
                                                    as ending_arr,

        -- Customer counts
        count(distinct case when movement_type != 'churn' then customer_id end)
                                                    as active_customers,
        count(distinct case when movement_type = 'new_business' then customer_id end)
                                                    as new_customers,
        count(distinct case when movement_type = 'churn' then customer_id end)
                                                    as churned_customers,

        -- Active subscriptions
        sum(is_active_subscription)                 as active_subscriptions,

        -- MRR movements
        sum(new_business_mrr)                       as new_business_mrr,
        sum(expansion_mrr)                          as expansion_mrr,
        sum(contraction_mrr)                        as contraction_mrr,
        sum(churned_mrr)                            as churned_mrr,
        sum(reactivation_mrr)                       as reactivation_mrr,
        sum(retained_mrr)                           as retained_mrr,

        -- Net new MRR
        sum(new_business_mrr)
            + sum(expansion_mrr)
            + sum(contraction_mrr)
            + sum(churned_mrr)
            + sum(reactivation_mrr)                 as net_new_mrr

    from mrr
    group by 1

),

with_prior_month as (

    select
        *,
        lag(ending_mrr) over (order by mrr_month)   as prior_mrr,
        lag(active_customers) over (order by mrr_month) as prior_customers

    from monthly_summary

),

final as (

    select
        mrr_month,

        -- Volume metrics
        ending_mrr,
        ending_arr,
        active_customers,
        new_customers,
        churned_customers,
        active_subscriptions,

        -- MRR movement waterfall
        new_business_mrr,
        expansion_mrr,
        contraction_mrr,
        churned_mrr,
        reactivation_mrr,
        retained_mrr,
        net_new_mrr,

        -- Growth metrics
        ending_mrr - coalesce(prior_mrr, 0)         as mrr_growth_abs,
        case
            when prior_mrr > 0
            then (ending_mrr - prior_mrr) / prior_mrr
            else null
        end                                         as mrr_growth_rate,

        -- Churn rates
        case
            when prior_customers > 0
            then churned_customers * 1.0 / prior_customers
            else null
        end                                         as logo_churn_rate,

        case
            when prior_mrr > 0
            then abs(churned_mrr) * 1.0 / prior_mrr
            else null
        end                                         as revenue_churn_rate,

        -- Net revenue retention (NRR)
        case
            when prior_mrr > 0
            then (prior_mrr + expansion_mrr + contraction_mrr + churned_mrr) / prior_mrr
            else null
        end                                         as net_revenue_retention,

        -- Gross revenue retention (GRR)
        case
            when prior_mrr > 0
            then (prior_mrr + contraction_mrr + churned_mrr) / prior_mrr
            else null
        end                                         as gross_revenue_retention,

        -- Quick Ratio: (new + expansion + reactivation) / (contraction + churn)
        case
            when abs(contraction_mrr) + abs(churned_mrr) > 0
            then (new_business_mrr + expansion_mrr + reactivation_mrr)
                 / (abs(contraction_mrr) + abs(churned_mrr))
            else null
        end                                         as quick_ratio,

        -- Date dimensions
        date_part('year', mrr_month)                as mrr_year,
        date_part('quarter', mrr_month)             as mrr_quarter,
        date_part('month', mrr_month)               as mrr_month_number

    from with_prior_month

)

select * from final
