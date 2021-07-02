-- sales/etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_load.sql
------------------------------------------------------------------
SELECT load_extension('/Users/brianmcmillan/projects/sales/etc/software/sqlite3/sha1');

WITH CTE_SOURCE AS (
  SELECT DISTINCT
      provider_code
      ,SHA1(UPPER(TRIM(COALESCE(invoice,''))||','||
          TRIM(COALESCE(StockCode,''))||','||
          TRIM(COALESCE(Description,''))||','||
          TRIM(COALESCE(Quantity,''))||','||
          TRIM(COALESCE(InvoiceDate,''))||','||
          TRIM(COALESCE(Price,''))||','||
          TRIM(COALESCE("Customer ID",''))||','||
          TRIM(COALESCE(Country,'')))
        ) AS hash_diff
      ,load_dts
      ,CAST(NULL AS TEXT) AS insert_dts
      ,Invoice AS invoice
      ,StockCode AS stock_code
      ,Description AS description
      ,CAST(Quantity AS NUMERIC) AS quantity
      ,InvoiceDate AS invoice_date
      ,CAST(Price AS NUMERIC) AS price
      ,"Customer ID" AS customer_id
      ,Country AS country
      ----
      ,SHA1(UPPER(TRIM(COALESCE(invoice,'')))) AS invoice_code_hkey
      ,SHA1(UPPER(TRIM(COALESCE(StockCode,'')))) AS stock_code_hkey
      ,SHA1(UPPER(TRIM(COALESCE("Customer ID",'')))) AS customer_code_hkey
      ,SHA1(UPPER(TRIM(COALESCE(Country,'')))) AS country_code_hkey
  FROM 'SRC_online_retail_II_-_Year_2010-2011_002'
  WHERE provider_code != 'provider_code'
)
,
--SELECT * FROM CTE_SOURCE;

CTE_TARGET AS (
SELECT
    provider_code
    ,hash_diff
    ,load_dts
    ,insert_dts
    ,invoice
    ,stock_code
    ,description
    ,quantity
    ,invoice_date
    ,price
    ,customer_id
    ,country
    ,invoice_code_hkey
    ,stock_code_hkey
    ,customer_code_hkey
    ,country_code_hkey
FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
)
,
--SELECT * FROM CTE_TARGET;

CTE_INSERT AS (
SELECT
    A.provider_code
    ,A.hash_diff
    ----
    --,B.provider_code
    --,B.hash_diff
    ----
    ,A.load_dts
    ,strftime('%Y-%m-%dT%H:%M:%fZ', 'now') AS insert_dts
    ,A.invoice
    ,A.stock_code
    ,A.description
    ,A.quantity
    ,A.invoice_date
    ,A.price
    ,A.customer_id
    ,A.country
    ,A.invoice_code_hkey
    ,A.stock_code_hkey
    ,A.customer_code_hkey
    ,A.country_code_hkey
FROM CTE_SOURCE A
LEFT JOIN CTE_TARGET B
ON (
    A.provider_code = B.provider_code AND
    A.hash_diff = B.hash_diff
)
WHERE B.hash_diff IS NULL
)
--SELECT * FROM CTE_INSERT;

INSERT INTO "SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001" (
  provider_code
  ,hash_diff
  ,load_dts
  ,insert_dts
  ,invoice
  ,stock_code
  ,description
  ,quantity
  ,invoice_date
  ,price
  ,customer_id
  ,country
  ,invoice_code_hkey
  ,stock_code_hkey
  ,customer_code_hkey
  ,country_code_hkey
)
  SELECT
  provider_code
  ,hash_diff
  ,load_dts
  ,insert_dts
  ,invoice
  ,stock_code
  ,description
  ,quantity
  ,invoice_date
  ,price
  ,customer_id
  ,country
  ,invoice_code_hkey
  ,stock_code_hkey
  ,customer_code_hkey
  ,country_code_hkey
  FROM CTE_INSERT;
