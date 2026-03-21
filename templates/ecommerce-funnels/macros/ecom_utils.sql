{% macro safe_conversion_rate(converted, total) %}
    case
        when {{ total }} > 0
        then {{ converted }} * 1.0 / {{ total }}
        else null
    end
{% endmacro %}


{% macro rfm_segment_label(rfm_segment_col) %}
    case {{ rfm_segment_col }}
        when 'champions'         then '🏆 Champions'
        when 'loyal_customers'   then '💛 Loyal Customers'
        when 'potential_loyalists' then '🌱 Potential Loyalists'
        when 'new_customers'     then '🆕 New Customers'
        when 'at_risk'           then '⚠️ At Risk'
        when 'cant_lose'         then '🚨 Can\'t Lose'
        when 'lost'              then '💤 Lost'
        else '❓ Other'
    end
{% endmacro %}


{% macro order_value_tier(aov_column) %}
    case
        when {{ aov_column }} >= 200  then 'high_aov'
        when {{ aov_column }} >= 75   then 'mid_aov'
        else 'low_aov'
    end
{% endmacro %}


{% macro days_since(date_column) %}
    datediff('day', {{ date_column }}, current_date)
{% endmacro %}


{% macro cohort_period(first_date, activity_date, period='month') %}
    datediff('{{ period }}', {{ first_date }}, {{ activity_date }})
{% endmacro %}
