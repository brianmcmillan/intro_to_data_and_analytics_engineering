-- sales/etc/sql/BHUB_INVOICE_CODES_001_create.sql
----------------------------------------------------------

CREATE TABLE IF NOT EXISTS BHUB_INVOICE_CODES_001 (
invoice_code_hkey TEXT
,provider_code TEXT
,load_dts TEXT
,insert_dts TEXT
,invoice_code TEXT
,PRIMARY KEY (invoice_code_hkey)
);
