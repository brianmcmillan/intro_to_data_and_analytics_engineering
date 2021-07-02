-- sales/etc/sql/BSAT_INVOICES_001_load.sql
------------------------------------------------------------------
SELECT load_extension('/Users/brianmcmillan/projects/sales/etc/software/sqlite3/sha1');

DELETE FROM BSAT_INVOICES_001;

WITH
CTE_BASE AS (
  SELECT
    'sales/etc/sql/BSAT_INVOICES_001_load.sql' AS provider_code
    ,load_dts
    ,CASE WHEN invoice LIKE 'C%' THEN REPLACE(invoice, 'C', '') ELSE invoice END AS invoice_code
    ,DATE(invoice_date, 'UTC') AS invoice_date
    ,UPPER(stock_code) AS stock_code
    ,customer_id AS customer_code
    ,price
    ,quantity
    ,invoice_code_hkey
    ,stock_code_hkey
    ,customer_code_hkey
  FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
)
,
--SELECT * FROM CTE_BASE;

CTE_AGG AS (
  SELECT
    invoice_code
    ,stock_code
    ,invoice_date
    ,quantity
    ,MAX(quantity) OVER (PARTITION BY
        invoice_code
        ,stock_code
        ORDER BY
        invoice_date DESC
    ) AS max_quantity
    ,price
    ,MIN(price) OVER (PARTITION BY
        invoice_code
        ,stock_code
        ORDER BY
        invoice_date DESC
    ) AS min_price
    ----
    ,customer_code
    ,invoice_code_hkey
    ,stock_code_hkey
    ,customer_code_hkey
    ,provider_code
    ,load_dts
  FROM CTE_BASE
)
,
--SELECT * FROM CTE_AGG

CTE_TARGET AS (
  SELECT DISTINCT
    SHA1(UPPER(
    TRIM(COALESCE(invoice_code, ''))||','||
    TRIM(COALESCE(stock_code, '')) ))AS invoice_hkey
    ,provider_code
    ,load_dts
    ----
    ,invoice_code
    ,stock_code
    ,invoice_date
    ,customer_code
    ,min_price AS price
    ,max_quantity AS quantity
    ,SHA1(UPPER(TRIM(COALESCE(invoice_code, '')))) AS invoice_code_hkey
    ,stock_code_hkey
    ,customer_code_hkey
  FROM CTE_AGG
)

--SELECT * FROM CTE_TARGET;

INSERT INTO BSAT_INVOICES_001 (
  invoice_hkey
  ,provider_code
  ,load_dts
  ,insert_dts
  ,invoice_code
  ,stock_code
  ,invoice_date
  ,customer_code
  ,price
  ,quantity
  ,invoice_code_hkey
  ,stock_code_hkey
  ,customer_code_hkey
)

SELECT
  invoice_hkey
  ,provider_code
  ,load_dts
  ,strftime('%Y-%m-%dT%H:%M:%fZ', 'now') AS insert_dts
  ,invoice_code
  ,stock_code
  ,invoice_date
  ,customer_code
  ,price
  ,quantity
  ,invoice_code_hkey
  ,stock_code_hkey
  ,customer_code_hkey
FROM CTE_TARGET
