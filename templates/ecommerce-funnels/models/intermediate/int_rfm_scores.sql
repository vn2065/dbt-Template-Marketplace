/*
  RFM (Recency, Frequency, Monetary) scoring.

  Scores each customer 1-5 on each dimension using ntile().
  Combined RFM score drives customer segment assignment.

  Segments:
    Champions     — Best customers (R5, F4-5, M4-5)
    Loyal         — High frequency, decent recency
    Potential     — Recent but low frequency
    At Risk       — Good history but inactive recently
    Lost          — Low scores across the board
*/
with customer_orders as (

    select * from {{ ref('int_customer_orders') }}

),

rfm_base as (

    select
        customer_id,
        days_since_last_order,
        total_orders,
        total_revenue

    from customer_orders

),

rfm_scored as (

    select
        customer_id,
        days_since_last_order,
        total_orders,
        total_revenue,

        -- Recency: LOWER days = better = higher score
        ntile(5) over (order by days_since_last_order desc) as r_score,

        -- Frequency: HIGHER orders = better
        ntile(5) over (order by total_orders asc)           as f_score,

        -- Monetary: HIGHER revenue = better
        ntile(5) over (order by total_revenue asc)          as m_score

    from rfm_base

),

rfm_segmented as (

    select
        *,
        r_score + f_score + m_score                         as rfm_total,
        concat(r_score, f_score, m_score)                   as rfm_cell,

        case
            when r_score >= 4 and f_score >= 4 and m_score >= 4
                then 'champions'
            when r_score >= 3 and f_score >= 3
                then 'loyal_customers'
            when r_score >= 4 and f_score <= 2
                then 'new_customers'
            when r_score >= 3 and f_score >= 2 and m_score >= 3
                then 'potential_loyalists'
            when r_score >= 2 and f_score >= 3 and m_score >= 3
                then 'at_risk'
            when r_score = 1 and f_score >= 3
                then 'cant_lose'
            when r_score <= 2 and f_score <= 2
                then 'lost'
            else 'others'
        end                                                 as rfm_segment

    from rfm_scored

)

select * from rfm_segmented
