-- sales/etc/sql/online_retail_II_last_6_months_filtered_002.sql
------------------------------------------------------

SELECT description
,SUM(quantity) AS quantity
,ROUND(AVG(price),2) AS price
,ROUND(SUM(quantity * price),2) AS total_sales_revenue
FROM 'RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001'
WHERE invoice_date >= (
SELECT DATE(MAX(invoice_date), '-6 months', 'localtime')
FROM 'RAW_ONLINE_RETAIL_II_YEAR_2010_2011_001'
) AND
UPPER(description) NOT LIKE '%MANUAL%' AND
UPPER(description) NOT LIKE '%POSTAGE%'
GROUP BY description
ORDER BY 4 DESC
LIMIT 10
;
