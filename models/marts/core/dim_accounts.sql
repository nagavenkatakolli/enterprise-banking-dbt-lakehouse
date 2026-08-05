WITH accounts AS (
    SELECT * FROM {{ ref('stg_accounts') }}
),

branches AS (
    SELECT * FROM {{ ref('stg_branches') }}
)

SELECT
    a.account_id,
    a.customer_id,
    a.branch_id,
    b.branch_name,
    b.city AS branch_city,
    b.state AS branch_state,
    a.account_type,
    a.balance_amount,
    a.account_open_date,
    a.account_status
FROM accounts a
LEFT JOIN branches b ON a.branch_id = b.branch_id