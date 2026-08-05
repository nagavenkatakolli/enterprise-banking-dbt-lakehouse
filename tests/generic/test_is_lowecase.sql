{% test is_validaname (model,column_name) %}
    
SELECT *
FROM {{ model }}
-- Fails if name contains invalid characters or numbers
WHERE {{ column_name }} ~ '[0-9]'

{% endtest %}