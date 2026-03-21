/*
  Monthly eCommerce executive dashboard table.
  One row per month. Key KPIs for growth and health.
*/
with orders as (

    select * from {{ ref('fct_orders') }}

),

sessions as (

    select * from {{ ref('stg_sessions') }}

),

monthly_orders as (

    select
        order_month,

        -- Revenue
        sum(case when is_completed then total_amount else 0 end)
                                                    as gross_revenue,
        sum(case when is_completed then discount_amount else 0 end)
                                                    as total_discounts,
        sum(case when is_completed then total_amount else 0 end)
            - sum(case when is_completed then discount_amount else 0 end)
                                                    as net_revenue,

        -- Orders
        count(distinct case when is_completed then order_id end)
                                                    as completed_orders,
        count(distinct order_id)                    as total_orders,
        count(distinct case when not is_completed then order_id end)
                                                    as abandoned_orders,

        -- Customers
        count(distinct case when is_completed then customer_id end)
                                                    as purchasing_customers,

        -- AOV
        sum(case when is_completed then total_amount else 0 end)
            / nullif(count(distinct case when is_completed then order_id end), 0)
                                                    as avg_order_value,

        -- Discounting
        count(distinct case when is_completed and has_discount then order_id end)
                                                    as discounted_orders,

        -- Channel breakdown
        count(distinct case when is_completed and channel = 'web' then order_id end)
                                                    as web_orders,
        count(distinct case when is_completed and channel = 'mobile' then order_id end)
                                                    as mobile_orders

    from orders
    group by 1

),

monthly_sessions as (

    select
        date_trunc('month', session_date)           as session_month,
        count(distinct session_id)                  as total_sessions,
        count(distinct case when converted then session_id end)
                                                    as converted_sessions,
        count(distinct user_id)                     as unique_visitors,
        count(distinct case when channel_group = 'paid' then session_id end)
                                                    as paid_sessions,
        count(distinct case when channel_group = 'organic' then session_id end)
                                                    as organic_sessions

    from sessions
    group by 1

),

with_prior as (

    select
        o.*,
        s.total_sessions,
        s.converted_sessions,
        s.unique_visitors,
        s.paid_sessions,
        s.organic_sessions,

        -- Conversion rate
        s.converted_sessions * 1.0
            / nullif(s.total_sessions, 0)           as session_conversion_rate,

        lag(o.gross_revenue) over (order by o.order_month)
                                                    as prior_gross_revenue,
        lag(o.completed_orders) over (order by o.order_month)
                                                    as prior_completed_orders,
        lag(o.purchasing_customers) over (order by o.order_month)
                                                    as prior_purchasing_customers

    from monthly_orders o
    left join monthly_sessions s
        on o.order_month = s.session_month

)

select
    order_month,
    gross_revenue,
    total_discounts,
    net_revenue,
    completed_orders,
    abandoned_orders,
    purchasing_customers,
    avg_order_value,
    discounted_orders,
    discounted_orders * 1.0 / nullif(completed_orders, 0)
                                                    as discount_rate,
    web_orders,
    mobile_orders,
    total_sessions,
    unique_visitors,
    session_conversion_rate,
    paid_sessions,
    organic_sessions,

    -- Growth rates
    case
        when prior_gross_revenue > 0
        then (gross_revenue - prior_gross_revenue) / prior_gross_revenue
        else null
    end                                             as revenue_growth_rate,

    case
        when prior_completed_orders > 0
        then (completed_orders - prior_completed_orders) * 1.0
             / prior_completed_orders
        else null
    end                                             as order_growth_rate,

    -- Revenue per visitor
    gross_revenue / nullif(unique_visitors, 0)      as revenue_per_visitor

from with_prior
order by order_month
