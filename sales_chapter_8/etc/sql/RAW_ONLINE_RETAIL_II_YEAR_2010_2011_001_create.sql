-- sales/etc/sql/RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001_create.sql
----------------------------------------------------------
CREATE TABLE IF NOT EXISTS RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001 AS

WITH CTE_SOURCE AS (
    SELECT DISTINCT *
    FROM "SRC_online_retail_II_-_Year_2010-2011_001"
    )
,
CTE_BASE AS (
    SELECT
        "provider_code",
        "load_dts",
        "Invoice" AS invoice,
        "StockCode" AS stock_code,
        "Description" description,
        CAST("Quantity" AS NUMERIC) AS quantity,
        "InvoiceDate" AS invoice_date,
        CAST("Price" AS NUMERIC) AS price,
        "Customer ID" AS customer_id,
        "Country" AS country
    FROM CTE_SOURCE
    )

SELECT * FROM CTE_BASE
;
