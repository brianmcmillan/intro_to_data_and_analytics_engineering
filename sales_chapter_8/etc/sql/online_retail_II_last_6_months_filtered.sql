-- sales/etc/sql/online_retail_II_last_6_months_filtered.sql
------------------------------------------------------

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
LIMIT 10
;
