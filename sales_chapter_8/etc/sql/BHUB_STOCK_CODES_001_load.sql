-- sales/etc/sql/BHUB_STOCK_CODES_001_load.sql
----------------------------------------------------------

DELETE FROM BHUB_STOCK_CODES_001;

WITH CTE_BASE AS (
  SELECT DISTINCT
  stock_code_hkey
  ,provider_code
  ,load_dts
  ,UPPER(TRIM(COALESCE(A.stock_code, ''))) AS stock_code
  FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 A
  ORDER BY 4 ASC
)

INSERT INTO BHUB_STOCK_CODES_001 (
  stock_code_hkey
  ,provider_code
  ,load_dts
  ,insert_dts
  ,stock_code
  )
  SELECT
  stock_code_hkey
  ,provider_code
  ,load_dts
  ,strftime('%Y-%m-%dT%H:%M:%fZ', 'now') AS insert_dts
  ,stock_code
  FROM CTE_BASE;
