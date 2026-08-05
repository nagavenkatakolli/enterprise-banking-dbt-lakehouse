WITH source AS (
    SELECT * FROM {{ source('analytics', 'branches') }}
),

renamed AS (
    SELECT
        CAST(branch_id AS INT) AS branch_id,
        TRIM(branch_name) AS branch_name,
        TRIM(city) AS city,
        TRIM(state) AS state,
        CAST(opened_date AS DATE) AS branch_opened_date,
        TRIM(ifsc_code) AS ifsc_code,

        ROW_NUMBER() OVER (
            PARTITION BY branch_id 
            ORDER BY branch_name
        ) AS row_num

    FROM source
)

SELECT
    branch_id,
    branch_name,
    city,
    state,
    branch_opened_date,
    ifsc_code
FROM renamed
WHERE row_num = 1