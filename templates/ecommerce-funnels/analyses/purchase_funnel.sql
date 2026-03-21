/*
  Purchase Funnel Analysis
  Tracks conversion through key funnel steps.
  Connects sessions → product views → cart adds → checkout → purchase.

  Customize the funnel steps based on your event schema.
*/
with sessions as (

    select
        session_id,
        user_id,
        session_date,
        channel_group,
        device_type,
        converted

    from {{ ref('stg_sessions') }}

),

-- Step 1: All sessions (top of funnel)
step_sessions as (
    select
        date_trunc('month', session_date)   as month,
        channel_group,
        device_type,
        count(distinct session_id)          as sessions
    from sessions
    group by 1, 2, 3
),

-- Step 2: Converted sessions (placed an order)
step_conversions as (
    select
        date_trunc('month', session_date)   as month,
        channel_group,
        device_type,
        count(distinct session_id)          as converted_sessions
    from sessions
    where converted = true
    group by 1, 2, 3
)

select
    s.month,
    s.channel_group,
    s.device_type,
    s.sessions                              as step_1_sessions,
    coalesce(c.converted_sessions, 0)       as step_2_purchases,

    -- Conversion rates
    coalesce(c.converted_sessions, 0) * 1.0
        / nullif(s.sessions, 0)             as session_to_purchase_rate

from step_sessions s
left join step_conversions c
    using (month, channel_group, device_type)

order by month, channel_group
