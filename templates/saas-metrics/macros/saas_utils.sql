{% macro arr_from_mrr(mrr_column) %}
    ({{ mrr_column }} * 12)
{% endmacro %}


{% macro mrr_to_tier(mrr_column) %}
    case
        when {{ mrr_column }} >= 1000  then 'enterprise'
        when {{ mrr_column }} >= 200   then 'mid_market'
        when {{ mrr_column }} >= 50    then 'smb'
        when {{ mrr_column }} > 0      then 'micro'
        else 'no_revenue'
    end
{% endmacro %}


{% macro safe_churn_rate(churned_col, prior_col) %}
    case
        when {{ prior_col }} > 0
        then {{ churned_col }} * 1.0 / {{ prior_col }}
        else null
    end
{% endmacro %}


{% macro safe_nrr(prior_mrr, expansion, contraction, churned) %}
    case
        when {{ prior_mrr }} > 0
        then ({{ prior_mrr }} + {{ expansion }} + {{ contraction }} + {{ churned }})
             / {{ prior_mrr }}
        else null
    end
{% endmacro %}


{% macro quick_ratio(new_mrr, expansion_mrr, reactivation_mrr, contraction_mrr, churned_mrr) %}
    case
        when abs({{ contraction_mrr }}) + abs({{ churned_mrr }}) > 0
        then ({{ new_mrr }} + {{ expansion_mrr }} + {{ reactivation_mrr }})
             / (abs({{ contraction_mrr }}) + abs({{ churned_mrr }}))
        else null
    end
{% endmacro %}


{% macro cohort_month(date_column) %}
    date_trunc('month', {{ date_column }})
{% endmacro %}


{% macro months_active(start_date, end_date=None) %}
    {% if end_date %}
        datediff('month', {{ start_date }}, {{ end_date }})
    {% else %}
        datediff('month', {{ start_date }}, current_date)
    {% endif %}
{% endmacro %}
