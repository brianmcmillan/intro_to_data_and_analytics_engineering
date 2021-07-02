-- sales/etc/sql/BHUB_INVOICE_CODES_001_load.sql
----------------------------------------------------------

DELETE FROM BHUB_INVOICE_CODES_001;

WITH CTE_BASE AS (
SELECT DISTINCT
invoice_code_hkey
,provider_code
,load_dts
,CASE WHEN UPPER(TRIM(COALESCE(A.invoice, ''))) LIKE 'C%'
  THEN REPLACE(invoice, 'C', '')
  ELSE UPPER(TRIM(COALESCE(A.invoice, '')))
  END AS invoice_code
FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 A
ORDER BY 4 ASC
)

INSERT INTO BHUB_INVOICE_CODES_001 (
invoice_code_hkey
,provider_code
,load_dts
,insert_dts
,invoice_code
)
SELECT
invoice_code_hkey
,provider_code
,load_dts
,strftime('%Y-%m-%dT%H:%M:%fZ', 'now') AS insert_dts
,invoice_code
FROM CTE_BASE;
