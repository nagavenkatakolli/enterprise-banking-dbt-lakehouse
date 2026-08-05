{% snapshot snapshot_customers %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols=['city', 'state', 'phone_number', 'email_address', 'credit_score']
    )
}}

SELECT 
    customer_id,
    customer_name,
    gender,
    date_of_birth,
    city,
    state,
    phone_number,
    email_address,
    occupation,
    annual_income,
    customer_join_date,
    credit_score
FROM {{ ref('stg_customers') }}

{% endsnapshot %}