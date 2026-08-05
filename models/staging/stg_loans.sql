WITH source AS (
    SELECT * FROM {{ source('analytics', 'loans') }}
),

renamed AS (
    SELECT
        -- Keys & Identifiers
        CAST(loan_id AS INT) AS loan_id,
        CAST(customer_id AS INT) AS customer_id,

        -- Loan Terms & Financial Metrics
        LOWER(TRIM(loan_type)) AS loan_type,
        CAST(loan_amount AS NUMERIC(18, 2)) AS principal_amount,
        CAST(interest_rate AS NUMERIC(5, 4)) AS interest_rate,
        CAST(term_months AS INT) AS loan_term_months,
        LOWER(TRIM(status)) AS loan_status,

        -- Dates
        CAST(start_date AS DATE) AS loan_start_date

    FROM source
)

SELECT * FROM renamed