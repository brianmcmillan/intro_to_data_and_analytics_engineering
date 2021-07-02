-- sales/etc/sql/BSAT_INVOICES_001_create.sql
------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS BSAT_INVOICES_001 (
  invoice_hkey TEXT
  ,provider_code TEXT
  ,load_dts TEXT
  ,insert_dts TEXT
  ,invoice_code TEXT
  ,stock_code TEXT
  ,invoice_date TEXT
  ,customer_code TEXT
  ,price NUMERIC
  ,quantity NUMERIC
  ,invoice_code_hkey TEXT
  ,stock_code_hkey TEXT
  ,customer_code_hkey TEXT
  ,PRIMARY KEY (invoice_hkey, load_dts)
);
