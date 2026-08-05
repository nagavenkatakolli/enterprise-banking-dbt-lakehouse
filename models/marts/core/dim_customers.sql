WITH current_customers AS (
    SELECT *
    FROM {{ ref('snapshot_customers') }}
    WHERE dbt_valid_to IS NULL  -- Selects active record versions only
)

SELECT
    customer_id,
    customer_name,
    gender,
    date_of_birth,
    city,
    state,
    phone_number,
    email_address,
    occupation,
    annual_income,
    customer_join_date,
    credit_score,
    dbt_valid_from AS record_effective_date
FROM current_customers