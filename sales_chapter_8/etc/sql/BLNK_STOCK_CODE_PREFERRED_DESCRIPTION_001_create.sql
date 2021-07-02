-- sales/etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_create.sql
---------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 (
stock_code_hkey TEXT
,provider_code TEXT
,load_dts TEXT
,insert_dts TEXT
,preferred_description TEXT
,PRIMARY KEY (stock_code_hkey)
);
