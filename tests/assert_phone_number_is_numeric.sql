{{config(enabled=false)}}
-- Fails if any phone_number contains non-digit characters
SELECT
    customer_id,
    phone_number
FROM {{ ref('stage_customers') }}
WHERE phone_number ~ '[^0-9]'