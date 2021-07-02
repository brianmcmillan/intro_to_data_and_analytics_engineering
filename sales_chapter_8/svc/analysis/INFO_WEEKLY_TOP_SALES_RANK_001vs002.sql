SELECT *
  FROM (
    SELECT
      CASE WHEN A.total_sales_revenue != B.total_sales_revenue
        THEN 1 ELSE 0 END AS revenue_not_equal_flag
      ,A.end_of_week_ssmtwtf
      ,A.stock_code
      ,A.rank
      ,B.rank
      ,CAST(A.quantity AS INT) AS quantity
      ,B.quantity
      ,A.avg_price
      ,B.avg_price
      ,A.total_sales_revenue
      ,B.total_sales_revenue
      ,A.preferred_description
      ,B.preferred_description
    FROM INFO_WEEKLY_TOP_SALES_RANK_001 A
    LEFT JOIN INFO_WEEKLY_TOP_SALES_RANK_002 B
    ON (
      A.end_of_week_ssmtwtf = B.end_of_week_ssmtwtf
      AND A.stock_code = B.stock_code
      )
    WHERE A.stock_code = '85099B'

    UNION ALL

    SELECT
      CASE WHEN A.total_sales_revenue != B.total_sales_revenue
        THEN 1 ELSE 0 END AS revenue_not_equal_flag
      ,A.end_of_week_ssmtwtf
      ,A.stock_code
      ,A.rank
      ,B.rank
      ,CAST(A.quantity AS INT) AS quantity
      ,B.quantity
      ,A.avg_price
      ,B.avg_price
      ,A.total_sales_revenue
      ,B.total_sales_revenue
      ,A.preferred_description
      ,B.preferred_description
    FROM INFO_WEEKLY_TOP_SALES_RANK_002 A
    LEFT JOIN INFO_WEEKLY_TOP_SALES_RANK_001 B
    ON (
      A.end_of_week_ssmtwtf = B.end_of_week_ssmtwtf
      AND A.stock_code = B.stock_code
      )
    WHERE A.stock_code = '85099B' AND B.preferred_description IS NULL
) A
WHERE revenue_not_equal_flag = 1
ORDER BY end_of_week_ssmtwtf DESC
