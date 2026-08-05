SELECT
    card_id,
    customer_id,
    account_id,
    card_type,
    card_issue_date,
    card_expiry_date,
    credit_limit,
    card_status,
    CASE 
        WHEN card_expiry_date < CURRENT_DATE THEN TRUE 
        ELSE FALSE 
    END AS is_expired_flag
FROM {{ ref('stg_cards') }}