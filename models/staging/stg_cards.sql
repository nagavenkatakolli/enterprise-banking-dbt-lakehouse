WITH source AS (
    SELECT * FROM {{ source('analytics', 'cards') }}
),

renamed AS (
    SELECT
        CAST(card_id AS INT) AS card_id,
        CAST(customer_id AS INT) AS customer_id,
        CAST(account_id AS INT) AS account_id,
        LOWER(TRIM(card_type)) AS card_type,
        CAST(issue_date AS DATE) AS card_issue_date,
        CAST(expiry_date AS DATE) AS card_expiry_date,
        CAST(credit_limit AS NUMERIC(18, 2)) AS credit_limit,
        LOWER(TRIM(status)) AS card_status

    FROM source
)

SELECT * FROM renamed