{{
    config(
        materialized='incremental',
        unique_key='card_transaction_id',
        incremental_strategy='merge'
    )
}}

WITH stg_card_txns AS (
    SELECT * FROM {{ ref('stg_card_transactions') }}
)

SELECT
    card_transaction_id,
    card_id,
    transaction_timestamp,
    merchant_category,
    transaction_amount,
    is_fraud_flag,
    CAST(transaction_timestamp AS DATE) AS transaction_date
FROM stg_card_txns

{% if is_incremental() %}

  WHERE transaction_timestamp > (SELECT MAX(transaction_timestamp) FROM {{ this }})

{% endif %}