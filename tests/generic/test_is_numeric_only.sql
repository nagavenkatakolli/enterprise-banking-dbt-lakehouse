{% test is_numeric_only(model, column_name) %}

{# Turn Error into warning if >10 failures, fail if >100 #}
{{ config(
    severity = 'warn',
    error_if = '>100',
    warn_if = '>10'
) }}

SELECT *
FROM {{ model }}
WHERE {{ column_name }}::text ~ '[^0-9]'

{% endtest %}