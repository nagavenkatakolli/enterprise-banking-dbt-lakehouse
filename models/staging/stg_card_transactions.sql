WITH source AS (
    SELECT * FROM {{ source('analytics', 'card_transactions') }}
),

renamed AS (
    SELECT
        CAST(card_txn_id AS INT) AS card_transaction_id,
        CAST(card_id AS INT) AS card_id,
        CAST(amount AS NUMERIC(18, 2)) AS transaction_amount,
        LOWER(TRIM(merchant_category)) AS merchant_category,
        CAST(is_fraud AS INT) AS is_fraud_flag,
        CAST(txn_date AS TIMESTAMP) AS transaction_timestamp

    FROM source
)

SELECT * FROM renamed