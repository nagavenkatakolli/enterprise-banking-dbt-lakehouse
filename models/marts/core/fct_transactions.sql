{{
    config(
        materialized='incremental',
        unique_key='transaction_id',
        incremental_strategy='merge'
    )
}}

WITH stg_txns AS (
    SELECT * FROM {{ ref('stg_transactions') }}
)

SELECT
    transaction_id,
    account_id,
    transaction_timestamp,
    transaction_type,
    transaction_amount,
    transaction_channel,
    merchant_category,
    CAST(transaction_timestamp AS DATE) AS transaction_date
FROM stg_txns

{% if is_incremental() %}

  -- On incremental runs, process only records newer than the current max timestamp in the target table
  WHERE transaction_timestamp > (SELECT MAX(transaction_timestamp) FROM {{ this }})

{% endif %}