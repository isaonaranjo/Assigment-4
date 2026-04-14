{{ config(materialized='table') }}

/*
    Model : inv_monthly_kpi_ft
    Layer  : Gold
    Type   : Table
    Logic  : Number of distinct invoiced contracts and total euros invoiced
             aggregated by calendar month of the invoice date.
*/

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m')  AS invoice_month,
    COUNT(DISTINCT contract_id)         AS distinct_contracts,
    SUM(total_import_euros)             AS total_import_euros
FROM {{ source('eae', 'inv_invoice_ft') }}
GROUP BY
    DATE_FORMAT(invoice_date, '%Y-%m')
