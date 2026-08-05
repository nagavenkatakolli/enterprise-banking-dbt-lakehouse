WITH customers AS (
    SELECT * FROM {{ ref('dim_customers') }}
),

accounts AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT account_id) AS total_accounts,
        COALESCE(SUM(balance_amount), 0) AS total_deposit_balance
    FROM {{ ref('dim_accounts') }}
    GROUP BY 1
),

transactions AS (
    SELECT 
        a.customer_id,
        COUNT(t.transaction_id) AS total_transaction_count,
        COALESCE(SUM(t.transaction_amount), 0) AS total_transaction_volume
    FROM {{ ref('fct_transactions') }} t
    JOIN {{ ref('dim_accounts') }} a ON t.account_id = a.account_id
    GROUP BY 1
),

loans AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT loan_id) AS total_loans,
        COALESCE(SUM(principal_amount), 0) AS total_loan_balance
    FROM {{ ref('stg_loans') }}
    GROUP BY 1
)

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    c.credit_score,
    c.annual_income,
    COALESCE(a.total_accounts, 0) AS total_accounts,
    COALESCE(a.total_deposit_balance, 0) AS total_deposit_balance,
    COALESCE(l.total_loans, 0) AS total_loans,
    COALESCE(l.total_loan_balance, 0) AS total_loan_balance,
    COALESCE(t.total_transaction_count, 0) AS total_transaction_count,
    COALESCE(t.total_transaction_volume, 0) AS total_transaction_volume
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN loans l ON c.customer_id = l.customer_id
LEFT JOIN transactions t ON c.customer_id = t.customer_id