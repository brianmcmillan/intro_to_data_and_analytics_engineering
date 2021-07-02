-- sales/etc/sql/BHUB_STOCK_CODES_001_create.sql
----------------------------------------------------------
CREATE TABLE IF NOT EXISTS BHUB_STOCK_CODES_001 (
stock_code_hkey TEXT
,provider_code TEXT
,load_dts TEXT
,insert_dts TEXT
,stock_code TEXT
,PRIMARY KEY (stock_code_hkey)
);
