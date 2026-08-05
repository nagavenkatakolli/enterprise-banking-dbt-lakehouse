# Enterprise Banking Data Lakehouse (dbt + PostgreSQL)

An end-to-end dbt analytics engineering pipeline transforming raw operational banking, credit card, and loan data into a production-grade Medallion Architecture (Bronze → Silver → Gold).

Built with **dbt Core (1.12)** and **PostgreSQL**, this repository demonstrates scalable data modeling patterns including **Slowly Changing Dimensions (SCD Type 2)**, **High-Volume Incremental Processing** across 5M+ records, and automated data quality assertions.

---

## Architecture & Data Lineage

The pipeline follows the Medallion Architecture pattern (Bronze → Silver → Gold) to ensure strict separation between raw operational data, dimensional modeling, and business aggregations:


![dbt DAG Lineage Graph](docs/dag.png)


=================================================================================================================
[ RAW POSTGRES ]             [ STAGING (BRONZE) ]             [ CORE MARTS (SILVER) ]         [ ANALYTICS (GOLD) ]
=================================================================================================================

analytics.customers  ───►  stg_customers  ───►  snapshot_customers  ───►  dim_customers  ─────┐
                                                                                              │
analytics.accounts   ───►  stg_accounts   ─────────────────────────────►  dim_accounts   ─────┼──► mart_customer_360
                                                                                              │
analytics.cards      ───►  stg_cards      ─────────────────────────────►  dim_cards      ─────┤
                                                                                              │
analytics.txns       ───►  stg_transactions ───────────────────────────►  fct_transactions ──┤
                                                                                              │
analytics.card_txns  ───►  stg_card_transactions ──────────────────────►  fct_card_txns  ─────┘


---

##  Key Engineering Highlights

* **Medallion Staging Layer (Bronze):** Standardized schema ingestion across 10 source tables, handling string trimming, strict data type casting, and field renaming.
* **Slowly Changing Dimensions (SCD Type 2):** Configured automated dbt snapshots (`snapshot_customers`) using the `check` strategy on `city`, `state`, `credit_score`, and `email_address` to track point-in-time attribute drift while preserving historical audit trails.
* **High-Volume Incremental Facts (Silver):** Designed scalable incremental models (`fct_transactions` & `fct_card_transactions`) processing 5,000,000+ records using the `merge` strategy and `is_incremental()` macro—reducing routine run times down to **< 1 second** (`MERGE 0`).
* **Customer 360 Analytical Mart (Gold):** Rollup reporting model (`mart_customer_360`) consolidating multi-domain financial metrics—deposit balances, active loan liabilities, credit usage, and transaction velocity—per customer.
* **Automated Data Quality & Governance:** Declarative YAML test coverage enforcing primary key uniqueness (`unique`) and non-null constraints (`not_null`) across all core entities.

---

##  Repository Structure

```text
banking_dbt_lakehouse/
├── macros/                  # Custom dbt macros
├── models/
│   ├── staging/             # Bronze layer: raw source cleaning & renaming
│   └── marts/
│       ├── core/            # Silver layer: dim_*, fct_* (incremental models)
│       └── analytics/       # Gold layer: mart_customer_360
├── snapshots/               # SCD Type 2 tracking (snapshot_customers.sql)
├── tests/                   # Custom data assertions
├── dbt_project.yml          # Project configuration & materialization defaults
├── .gitignore               # Ignored target/, dbt-env/, and profiles.yml
└── README.md


Tech Stack & Prerequisites
Transformation Framework: dbt Core v1.12.0 (Adapter: dbt-postgres v1.11.0)

Database / Warehouse: PostgreSQL

Language: SQL / Jinja templates

Quickstart & Execution
Clone the repository:

Bash
git clone [https://github.com/nagavenkatakolli/enterprise-banking-dbt-lakehouse.git](https://github.com/nagavenkatakolli/enterprise-banking-dbt-lakehouse.git)
cd enterprise-banking-dbt-lakehouse
Configure Connection:
Ensure your local PostgreSQL connection credentials are set up in ~/.dbt/profiles.yml.

Run Pipeline Execution Steps:

Bash
# 1. Run SCD Type 2 Snapshots
dbt snapshot

# 2. Build Staging, Core Dimensions, and Incremental Fact Models
dbt run

# 3. Execute Data Quality Test Suite
dbt test

# 4. Generate and Serve Interactive Lineage Documentation
dbt docs generate
dbt docs serve

## CI/CD & Deployment Architecture

* **Local Data Lakehouse:** Local PostgreSQL instance acting as the execution engine for development (`dbt run`, `dbt snapshot`, `dbt test`).
* **Automated CI Pipeline:** GitHub Actions workflow executing `dbt parse` on every push/PR to validate project DAG structure, Jinja compilation, and schema syntax without requiring downstream warehouse credentials.