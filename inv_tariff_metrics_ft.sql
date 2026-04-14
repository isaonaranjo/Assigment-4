{{ config(materialized='table') }}

/*
    Model : inv_tariff_metrics_ft
    Layer  : Gold
    Type   : Table
    Logic  : Total euros invoiced per tariff code,
             restricted to contracts belonging to "Individual" clients.
*/

SELECT
    c.tariff_code,
    SUM(i.total_import_euros) AS total_import_euros
FROM {{ source('eae', 'inv_invoice_ft') }}       AS i
JOIN {{ source('eae', 'con_contract_dim') }}      AS c
    ON i.contract_id = c.contract_id
JOIN {{ source('eae', 'con_client_type_dim') }}   AS ct
    ON c.client_type_id = ct.client_type_id
WHERE ct.client_type_description = 'Individual'
GROUP BY
    c.tariff_code
