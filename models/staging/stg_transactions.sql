WITH source AS (
    SELECT * FROM {{ source('analytics', 'transactions') }}
),

renamed AS (
    SELECT
        CAST(transaction_id AS INT) AS transaction_id,
        CAST(account_id AS INT) AS account_id,
        CAST(txn_date AS TIMESTAMP) AS transaction_timestamp,
        LOWER(TRIM(txn_type)) AS transaction_type,
        CAST(amount AS NUMERIC(18, 2)) AS transaction_amount,
        LOWER(TRIM(channel)) AS transaction_channel,
        LOWER(TRIM(merchant_category)) AS merchant_category,
        CAST(reversal_of_txn_id AS INT) AS reversal_of_txn_id

    FROM source
)

SELECT * FROM renamed