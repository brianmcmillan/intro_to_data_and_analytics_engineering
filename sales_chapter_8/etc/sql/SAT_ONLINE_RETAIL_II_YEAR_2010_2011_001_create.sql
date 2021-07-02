-- sales/etc/sql/SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001_create.sql
------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001 (
  provider_code TEXT
  ,hash_diff TEXT
  ,load_dts TEXT
  ,insert_dts TEXT
  ,invoice TEXT
  ,stock_code TEXT
  ,description TEXT
  ,quantity NUMERIC
  ,invoice_date TEXT
  ,price NUMERIC
  ,customer_id TEXT
  ,country TEXT
  ----
  ,invoice_code_hkey TEXT
  ,stock_code_hkey TEXT
  ,customer_code_hkey TEXT
  ,country_code_hkey TEXT
  ,PRIMARY KEY(provider_code, hash_diff)
  );
