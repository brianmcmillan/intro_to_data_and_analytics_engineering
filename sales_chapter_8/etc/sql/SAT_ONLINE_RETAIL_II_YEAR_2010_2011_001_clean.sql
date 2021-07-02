-- sales/etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_clean.sql
------------------------------------------------------------------
SELECT load_extension('/Users/brianmcmillan/projects/sales/etc/software/sqlite3/sha1');

WITH CTE_SOURCE AS (
  SELECT
  rowid
  ,provider_code
  ,hash_diff
  FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
)
,
--SELECT * FROM CTE_SOURCE;

CTE_TARGET AS (
SELECT
rowid
,provider_code
,SHA1(UPPER(
    TRIM(COALESCE(invoice, ''))||','||
    TRIM(COALESCE(StockCode, ''))||','||
    TRIM(COALESCE(Description, ''))||','||
    TRIM(COALESCE(Quantity, ''))||','||
    TRIM(COALESCE(InvoiceDate, ''))||','||
    TRIM(COALESCE(Price, ''))||','||
    TRIM(COALESCE("Customer ID", ''))||','||
    TRIM(COALESCE(Country, ''))
    )) AS hash_diff
FROM "SRC_online_retail_II_-_Year_2010-2011_002"
)
,
--SELECT * FROM CTE_TARGET;

CTE_DELETE AS (
SELECT
A.rowid
FROM CTE_TARGET A
INNER JOIN CTE_SOURCE B
ON (
A.provider_code = B.provider_code AND
A.hash_diff = B.hash_diff
)
WHERE B.rowid IS NOT NULL
)

--SELECT * FROM CTE_DELETE;

DELETE FROM "SRC_online_retail_II_-_Year_2010-2011_002"
WHERE
rowid IN (SELECT rowid FROM CTE_DELETE) OR
provider_code = 'provider_code'
