-- sales/etc/sql/INFO_SALES_LAST_6_MONTHS_FILTERED_001_create.sql
----------------------------------------------------------
CREATE TABLE IF NOT EXISTS INFO_SALES_LAST_6_MONTHS_FILTERED_001 AS

WITH CTE_SOURCE AS (
  SELECT Description AS description
  ,SUM(Quantity) AS quantity
  ,ROUND(AVG(Price),2) AS price
  ,ROUND(SUM(Quantity * Price),2) AS total_sales_revenue
  FROM 'SRC_online_retail_II_-_Year_2010-2011_001'
  WHERE InvoiceDate >= (
  SELECT DATE(MAX(InvoiceDate), '-6 months', 'localtime')
  FROM 'SRC_online_retail_II_-_Year_2010-2011_001'
  )
  GROUP BY Description
  ORDER BY 4 DESC
  LIMIT 100
    )

SELECT * FROM CTE_SOURCE
;
