--etc/sql/INFO_WEEKLY_TOP_SALES_RANK_001_create.sql
------------------------------------------------------
CREATE VIEW IF NOT EXISTS INFO_WEEKLY_TOP_SALES_RANK_001 AS

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
,
--SELECT * FROM CTE_BASE;

CTE_SALES AS (
    SELECT
        --invoice_date,
        DATE(invoice_date, 'weekday 0', '-2 days') AS end_of_week_ssmtwtf,
        --invoice,
        stock_code,
        --description,
        --customer_id,
        --country,
        SUM(quantity) AS quantity,
        AVG(price) AS avg_price,
        ROUND(SUM(quantity) * SUM(price), 2) AS total_sales_revenue
    FROM CTE_BASE
    GROUP BY
        DATE(invoice_date, 'weekday 0', '-2 days'),
        stock_code
    ORDER BY 1,5 DESC
)
,
--SELECT * FROM CTE_SALES;

CTE_DESC AS (
    SELECT
        --row_number,
        stock_code,
        UPPER(description) AS preferred_description
        --invoice_date
    FROM (
        SELECT
            ROW_NUMBER () OVER (PARTITION BY
            stock_code
            ORDER BY
            invoice_date DESC
            ) AS row_number,
            stock_code,
            description,
            invoice_date
        FROM CTE_BASE
        ) A
    WHERE
    row_number = 1
    ORDER BY 1 ASC
)
,
--SELECT * FROM CTE_DESC

CTE_WEEKLY_SALES AS (
SELECT
    A.end_of_week_ssmtwtf,
    A.stock_code,
    B.preferred_description,
    A.quantity,
    A.avg_price,
    A.total_sales_revenue
FROM CTE_SALES A
    INNER JOIN CTE_DESC B
    ON (A.stock_code = B.stock_code)
ORDER BY 1,6 DESC
)
,
--SELECT * FROM CTE_WEEKLY_SALES;

CTE_WEEKLY_TOP_SALES_RANK  AS (
    SELECT
    RANK() OVER (PARTITION BY
        end_of_week_ssmtwtf
        ORDER BY
        total_sales_revenue DESC
    ) AS rank,
    end_of_week_ssmtwtf,
    stock_code,
    preferred_description,
    quantity,
    avg_price,
    total_sales_revenue
    FROM CTE_WEEKLY_SALES
)

--SELECT * FROM CTE_WEEKLY_TOP_SALES_RANK ;

SELECT
    end_of_week_ssmtwtf,
    rank,
    stock_code,
    preferred_description,
    quantity,
    ROUND(avg_price, 2) AS avg_price,
    total_sales_revenue
FROM CTE_WEEKLY_TOP_SALES_RANK
WHERE rank <= 10
ORDER BY 1,2;
