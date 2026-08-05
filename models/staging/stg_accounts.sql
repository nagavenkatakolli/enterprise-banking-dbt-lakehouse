WITH source AS (
    SELECT * FROM {{ source('analytics', 'accounts') }}
),

renamed AS (
    SELECT
        CAST(account_id AS INT) AS account_id,
        CAST(customer_id AS INT) AS customer_id,
        CAST(branch_id AS INT) AS branch_id,
        LOWER(TRIM(account_type)) AS account_type,
        CAST(balance AS NUMERIC(18, 2)) AS balance_amount,
        CAST(open_date AS DATE) AS account_open_date,
        LOWER(TRIM(status)) AS account_status,

        ROW_NUMBER() OVER (
            PARTITION BY account_id 
            ORDER BY open_date DESC
        ) AS row_num

    FROM source
)

SELECT
    account_id,
    customer_id,
    branch_id,
    account_type,
    balance_amount,
    account_open_date,
    account_status
FROM renamed
WHERE row_num = 1