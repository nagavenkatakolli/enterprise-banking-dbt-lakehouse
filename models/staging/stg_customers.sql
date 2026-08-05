with source as (
    select * from {{ source('analytics', 'customers') }}
),

renamed as (
    select
        -- Keys & Identifiers
        cast(customer_id as integer) as customer_id,

        -- Contact & Demographics
        trim(name) as customer_name,
        gender,
        cast(date_of_birth as date) as date_of_birth,
        trim(city) as city,
        trim(state) as state,
        phone as phone_number,
        lower(trim(email)) as email_address,
        trim(occupation) as occupation,

        -- Financial Attributes & Dates
        cast(annual_income as numeric(12, 2)) as annual_income,
        cast(join_date as date) as customer_join_date,
        cast(credit_score as integer) as credit_score

    from source
)

select * from renamed