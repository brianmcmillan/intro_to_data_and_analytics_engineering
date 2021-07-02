--RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001_row_count.sql
------------------------------------------------------
WITH CTE_BASE AS (
  SELECT DISTINCT
  provider_code,
  load_dts,
  --invoice as raw_invoice,
  REPLACE(invoice, 'C', '') AS invoice,
  stock_code,
  description,
  invoice_date,
  quantity,
  price,
  customer_id,
  country
  FROM RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001
  WHERE
      invoice_date >= (
          SELECT DATE(MAX(invoice_date), '-6 months', 'localtime')
          FROM RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001
          ) AND
      UPPER(description) NOT LIKE '%MANUAL%' AND
      UPPER(description) NOT LIKE '%POSTAGE%'
)

--SELECT * FROM CTE_BASE;
SELECT
    row_number() OVER (PARTITION BY
            invoice,
            stock_code,
            price,
            --quantity,
            --invoice_date,
            --description
        ORDER BY
            invoice DESC
        ) AS row_number,
    invoice_date,
    --raw_invoice,
    invoice,
    stock_code,
    description,
    customer_id,
    country,
    quantity,
    price
FROM CTE_BASE
--WHERE
--raw_invoice LIKE 'C%'
--    invoice = '556277' --AND
--     stock_code = '23203'
--ORDER BY 4 desc


-- CTE_SALES AS (
--     SELECT
        --invoice_date,
--         DATE(invoice_date, 'weekday 0', '-2 days') AS end_of_week_ssmtwtf,
        --invoice,
--         stock_code,
        --description,
        --customer_id,
        --country,
--         SUM(quantity) AS quantity,
--         SUM(price) AS price,
--         ROUND(SUM(quantity) * SUM(price), 2) AS total_sales_revenue
--     FROM CTE_BASE
--     GROUP BY
--         DATE(invoice_date, 'weekday 0', '-2 days'),
--         stock_code
--     ORDER BY 1,5 DESC
-- )
-- 
-- SELECT * FROM CTE_SALES;

;
