ARNAU OLIVA, 
HYERIM HONG
Mª ISABEL ORTIZ

# DBT Gold Layer Models — Operations Team

## Overview

This project contains three dbt transformation models that build aggregated tables and views in the **gold layer** of the Data Warehouse. They are designed to help the Operations team obtain insights from invoice and contract data without writing complex queries.

---

## Project Structure

```
dm4bi_lab3/
├── models/
│   ├── sources.yml
│   ├── inv_tariff_metrics_ft.sql
│   ├── inv_monthly_kpi_ft.sql
│   └── inv_province_metrics_ft.sql
├── macros/
├── logs/
├── target/
├── dbt_project.yml
└── profiles.yml
```

---

## Source Tables (Raw Layer — MySQL)

| Table | Description |
|---|---|
| `inv_invoice_ft` | Invoice fact table — one row per invoice |
| `con_contract_dim` | Contract dimension — tariff, power, zipcode info |
| `con_client_type_dim` | Client type dimension — Individual, Company, etc. |
| `inv_doc_type_dim` | Document type dimension — Normal, Cancellation |

---

## Models

### 1. `inv_tariff_metrics_ft` — Table

**Purpose:** Total euros invoiced per electricity tariff code, restricted to **Individual** clients only.

**Key columns:**
- `tariff_code` — The electricity tariff (e.g. 20TD)
- `total_import_euros` — Sum of all invoiced amounts for that tariff

**Joins:** `inv_invoice_ft` → `con_contract_dim` → `con_client_type_dim`

---

### 2. `inv_monthly_kpi_ft` — Table

**Purpose:** Monthly KPIs showing how many distinct contracts were invoiced and the total revenue per month.

**Key columns:**
- `invoice_month` — Year-month of the invoice date (format: `YYYY-MM`)
- `distinct_contracts` — Number of unique contracts invoiced that month
- `total_import_euros` — Total euros invoiced that month

**Source:** `inv_invoice_ft` only (no joins needed)

---

### 3. `inv_province_metrics_ft` — View

**Purpose:** Average active energy (kWh) invoiced per contract, grouped by **province** (first 2 digits of the zipcode).

**Key columns:**
- `province_code` — First 2 digits of the zero-padded zipcode (e.g. `08` for Barcelona)
- `avg_energy_active_kwh` — Average energy consumed across all invoices in that province

> **Note:** The `zipcode` field is stored as an integer in the source, so leading zeros are restored using `LPAD` before extracting the province prefix.

**Joins:** `inv_invoice_ft` → `con_contract_dim`

---

## Setup & Usage

### 1. Prerequisites

```bash
pip install dbt-mysql
```

### 2. Configure your connection

Edit `profiles.yml` or set the following environment variables:

```bash
export DB_HOST=localhost
export DB_USER=your_user
export DB_PASSWORD=your_password
export DB_NAME=eae
```

### 3. Place model files

Copy the three `.sql` files into the `models/` folder of the project, alongside `sources.yml`.

### 4. Run the models

```bash
# Run all models
dbt run

# Run a specific model
dbt run --select inv_tariff_metrics_ft
```

### 5. Test & document

```bash
dbt test
dbt docs generate
dbt docs serve
```

---

## Grading Criteria

| Criteria | Points |
|---|---|
| SQL statements | 5 |
| Model files and correct syntax | 4 |
| Table and view configuration | 1 |
| **Total** | **10** |

---

*Assignment: A.4 — DBT Transformations | EAE Business School Barcelona*
