{% macro is_high_risk_country(country_col) %}
    {{ country_col }} in ('RU', 'IR', 'KP', 'BY', 'CU', 'VE', 'MM', 'SD')
{% endmacro %}


{% macro risk_score_to_tier(score_col) %}
    case
        when {{ score_col }} >= {{ var('high_risk_score_threshold') }}   then 'high'
        when {{ score_col }} >= {{ var('medium_risk_score_threshold') }}  then 'medium'
        else 'low'
    end
{% endmacro %}


{% macro safe_decline_rate(declined_col, total_col) %}
    case
        when {{ total_col }} > 0
        then {{ declined_col }} * 1.0 / {{ total_col }}
        else null
    end
{% endmacro %}


{% macro tpv_growth(current_tpv, prior_tpv) %}
    case
        when {{ prior_tpv }} > 0
        then ({{ current_tpv }} - {{ prior_tpv }}) / {{ prior_tpv }}
        else null
    end
{% endmacro %}


{% macro format_currency(amount_col, currency='USD') %}
    concat('{{ currency }} ', to_char({{ amount_col }}, 'FM999,999,999.00'))
{% endmacro %}


{% macro is_weekend(date_col) %}
    date_part('dow', {{ date_col }}) in (0, 6)
{% endmacro %}


{% macro is_business_hours(ts_col) %}
    date_part('hour', {{ ts_col }}) between 8 and 18
    and not {{ is_weekend(ts_col) }}
{% endmacro %}
