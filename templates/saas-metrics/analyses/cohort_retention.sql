/*
  Cohort Retention Analysis
  Shows monthly retention by acquisition cohort.

  Output: cohort month × months_since_start grid
  with % of original cohort still active.

  Usage: Run with `dbt compile` then execute in your warehouse.
*/
with customer_cohorts as (

    select
        customer_id,
        date_trunc('month', first_paid_date)    as cohort_month

    from {{ ref('dim_customers') }}
    where first_paid_date is not null

),

mrr_by_customer_month as (

    select distinct
        customer_id,
        mrr_month

    from {{ ref('fct_mrr') }}
    where movement_type != 'churn'

),

cohort_data as (

    select
        cc.cohort_month,
        cc.customer_id,
        m.mrr_month,
        datediff('month', cc.cohort_month, m.mrr_month) as months_since_start

    from customer_cohorts cc
    join mrr_by_customer_month m using (customer_id)

),

cohort_sizes as (

    select
        cohort_month,
        count(distinct customer_id) as cohort_size

    from customer_cohorts
    group by 1

),

retention as (

    select
        cd.cohort_month,
        cd.months_since_start,
        count(distinct cd.customer_id) as retained_customers,
        cs.cohort_size

    from cohort_data cd
    join cohort_sizes cs using (cohort_month)
    group by 1, 2, cs.cohort_size

)

select
    cohort_month,
    cohort_size,
    months_since_start,
    retained_customers,
    retained_customers * 1.0 / cohort_size  as retention_rate

from retention
order by cohort_month, months_since_start
