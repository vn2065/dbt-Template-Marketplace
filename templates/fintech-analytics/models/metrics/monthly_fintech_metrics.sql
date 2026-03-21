/*
  Monthly fintech KPI dashboard. One row per month.
  Covers transaction volume, revenue, risk, and growth metrics.
*/
with transactions as (

    select * from {{ ref('fct_transactions') }}

),

monthly as (

    select
        transaction_month,

        -- Volume
        count(distinct transaction_id)              as total_transactions,
        count(distinct case when is_settled then transaction_id end)
                                                    as settled_transactions,
        count(distinct case when is_declined then transaction_id end)
                                                    as declined_transactions,
        count(distinct account_id)                  as active_accounts,

        -- Revenue (TPV - Total Payment Volume)
        sum(case when is_settled and amount > 0 then amount else 0 end)
                                                    as gross_tpv,
        sum(case when is_settled then amount_abs else 0 end)
                                                    as net_tpv,

        -- Average transaction
        avg(case when is_settled then amount_abs else null end)
                                                    as avg_transaction_value,

        -- Risk metrics
        count(distinct case when is_flagged then transaction_id end)
                                                    as flagged_transactions,
        count(distinct case when risk_tier = 'high' then transaction_id end)
                                                    as high_risk_transactions,
        sum(case when is_flagged then amount_abs else 0 end)
                                                    as flagged_transaction_value,

        -- Decline rate
        count(distinct case when is_declined then transaction_id end) * 1.0
            / nullif(count(distinct transaction_id), 0)
                                                    as decline_rate,

        -- Flag rate
        count(distinct case when is_flagged then transaction_id end) * 1.0
            / nullif(count(distinct transaction_id), 0)
                                                    as flag_rate,

        -- Payment methods
        count(distinct case when payment_method = 'card' then transaction_id end)
                                                    as card_transactions,
        count(distinct case when payment_method = 'ach' then transaction_id end)
                                                    as ach_transactions,
        count(distinct case when payment_method = 'wire' then transaction_id end)
                                                    as wire_transactions,

        -- Cross-border
        count(distinct case when is_foreign_transaction then transaction_id end)
                                                    as cross_border_transactions,
        sum(case when is_foreign_transaction then amount_abs else 0 end)
                                                    as cross_border_volume

    from transactions
    group by 1

),

with_prior as (

    select
        *,
        lag(gross_tpv) over (order by transaction_month)    as prior_tpv,
        lag(total_transactions) over (order by transaction_month)
                                                            as prior_transaction_count,
        lag(active_accounts) over (order by transaction_month)
                                                            as prior_active_accounts

    from monthly

)

select
    transaction_month,
    total_transactions,
    settled_transactions,
    declined_transactions,
    active_accounts,
    gross_tpv,
    net_tpv,
    avg_transaction_value,

    -- Risk
    flagged_transactions,
    high_risk_transactions,
    flagged_transaction_value,
    decline_rate,
    flag_rate,

    -- Payment mix
    card_transactions,
    ach_transactions,
    wire_transactions,
    card_transactions * 1.0 / nullif(total_transactions, 0)
                                                    as card_mix_pct,

    -- Cross-border
    cross_border_transactions,
    cross_border_volume,
    cross_border_volume / nullif(gross_tpv, 0)      as cross_border_pct,

    -- Growth
    case
        when prior_tpv > 0
        then (gross_tpv - prior_tpv) / prior_tpv
        else null
    end                                             as tpv_growth_rate,

    case
        when prior_transaction_count > 0
        then (total_transactions - prior_transaction_count) * 1.0
             / prior_transaction_count
        else null
    end                                             as transaction_count_growth_rate

from with_prior
order by transaction_month
