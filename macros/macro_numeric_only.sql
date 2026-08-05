{% macro is_numeric_only_macro(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }}::text ~ '[^0-9]'

{% endmacro %}