-- sales/etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_load.sql
---------------------------------------------------------------------
SELECT load_extension('/Users/brianmcmillan/projects/sales/etc/software/sqlite3/sha1');

DELETE FROM BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001;

WITH
CTE_BASE AS (
  SELECT DISTINCT
    stock_code_hkey
    ,UPPER(TRIM(COALESCE(stock_code, ''))) AS stock_code
    ,REPLACE(REPLACE(REPLACE(REPLACE(TRIM(UPPER(description))
      , 'N0', 'NO')
      , '  ', ' ')
      , '*', '')
      , 'VIPPASSPORT', 'VIP PASSPORT') AS description
  FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
  WHERE description != ''
  ORDER BY 1 ASC
)
,
--SELECT * FROM CTE_BASE;

CTE_FILTER_BUS_SKU AS (
  SELECT
    stock_code
    ,description
    ,CASE WHEN
    stock_code LIKE 'S'
    OR stock_code LIKE 'POST'
    OR stock_code LIKE 'PADS'
    OR stock_code LIKE 'M'
    --OR stock_code LIKE 'GIFT_0001_%'
    OR (stock_code LIKE 'GIFT_0001_%' AND description LIKE 'DOTCOMGIFTSHOP%')
    OR stock_code LIKE 'DOT'
    OR stock_code LIKE 'D'
    OR stock_code LIKE 'CRUK'
    OR stock_code LIKE 'C2'
    OR stock_code LIKE 'BANK CHARGES'
    OR stock_code LIKE 'B'
    OR stock_code LIKE 'AMAZONFEE'
    OR stock_code LIKE '23574' --PACKING CHARGE
    OR stock_code LIKE '23444'
    THEN 0 ELSE 1 END AS invalid_description_flag
  FROM CTE_BASE
  WHERE invalid_description_flag = 0
)
,
--SELECT * FROM CTE_FILTER_BUS_SKU

CTE_FILTER_DOTCOM AS (
  SELECT
    stock_code
    ,description
    ,CASE WHEN
    description LIKE '%DOTCOM%'
    THEN 1 ELSE 0 END AS invalid_description_flag
  FROM CTE_BASE
  WHERE invalid_description_flag = 1
)
,
--SELECT *
--FROM CTE_FILTER_DOTCOM A
--INNER JOIN CTE_BASE B
--ON (A.stock_code = B.stock_code)

CTE_FILTER_AMAZON AS (
  SELECT
    stock_code
    ,description
    ,CASE WHEN
    description LIKE '%AMAZON%'
    THEN 1 ELSE 0 END AS invalid_description_flag
  FROM CTE_BASE
  WHERE invalid_description_flag = 1
)
,
-- SELECT *
-- FROM CTE_FILTER_AMAZON A
-- INNER JOIN CTE_BASE B
-- ON (A.stock_code = B.stock_code)

CTE_FILTER_EBAY AS (
  SELECT
    stock_code
    ,description
    ,CASE WHEN
    description LIKE '%EBAY%'
    THEN 1 ELSE 0 END AS invalid_description_flag
  FROM CTE_BASE
  WHERE invalid_description_flag = 1
)
,
-- SELECT *
-- FROM CTE_FILTER_EBAY A
-- INNER JOIN CTE_BASE B
-- ON (A.stock_code = B.stock_code)

CTE_FILTER_GIFTSHOP AS (
  SELECT
    stock_code
    ,description
    ,CASE WHEN
    description LIKE '%GIFTSHOP%'
    THEN 0 ELSE 1 END AS invalid_description_flag
  FROM CTE_BASE
  WHERE invalid_description_flag = 0
)
,
--SELECT *
--FROM CTE_FILTER_GIFTSHOP A
--INNER JOIN CTE_BASE B
--ON (A.stock_code = B.stock_code)

CTE_FILTER_DEFECTS AS (
  SELECT
    stock_code
    ,description
    ,CASE WHEN
    description LIKE '%WET%'
    OR description LIKE '%GIVEN AWAY%'
    OR description LIKE 'CHECK'
    OR description LIKE '%DAMAGE%'
    OR description LIKE '%?%'
    OR description LIKE '%MISSING%'
    OR description LIKE '%ADJUST%'
    OR description LIKE '%WRONG%'
    OR description LIKE '%MYSTERY%'
    OR description LIKE '%FOUND%'
    OR description LIKE '%PUT ASIDE%'
    OR description LIKE '%BREAKAGE%'
    OR description LIKE 'HISTORIC COMPUTER DIFFERENCE%'
    OR description LIKE '%SAMPLE%'
    OR description LIKE '%QUICK FIX%'
    OR description LIKE '%DESTROYED%'
    OR description LIKE '%SOLD AS %'
    OR description LIKE 'MIA%'
    OR description LIKE 'LOST IN SPACE'
    OR description LIKE 'ON CARGO ORDER'
    OR description LIKE 'BROKEN'
    OR description LIKE '%RETURNED%'
    OR description LIKE 'UNSALEABLE%'
    OR description LIKE '%THROW% AWAY%'
    OR description LIKE '%SMASHED%'
    OR description LIKE 'LOST'
    OR description LIKE '%MOULDY%'
    OR description LIKE '%OOPS%'
    OR description LIKE '%MAILOUT%'
    OR description LIKE '%TEST%'
    OR description LIKE '%PROBLEM%'
    OR description LIKE '%CANT MA%AGE%'
    OR description LIKE '%MIX%UP%'
    OR description LIKE '%WEBSITE FIXED%'
    OR description LIKE '%ONLINE RETAIL%'
    OR description LIKE '%PUSH ORDER%'
    OR description LIKE 'SOLD AS SET%DOTCOM%'
    OR description LIKE 'SOLD AS 22467'
    OR description LIKE '%SHOWROOM%'
    OR description LIKE '%ERROR%'
    OR description LIKE 'NOT RCVD%'
    OR description LIKE 'INCORRECT%'
    OR description LIKE 'FBA'
    OR description LIKE 'FAULTY'
    OR description LIKE 'DOTCOMSTOCK'
    OR description LIKE 'DOTCOM SOLD%'
    OR description LIKE 'DOTCOM SET'
    OR description LIKE 'DOTCOM SALES'
    OR description LIKE 'DOTCOM'
    OR description LIKE 'DISPLAY'
    OR description LIKE 'DID A CREDIT%'
    OR description LIKE 'DAGAMED'
    OR description LIKE 'CRUSHED%'
    OR description LIKE 'CRACKED'
    OR description LIKE 'COUNTED'
    OR description LIKE 'CAN%T FIND'
    OR description LIKE 'CAME CODED AS%'
    OR description LIKE 'AMAZON SOLD SETS'
    OR description LIKE 'AMAZON SALES'
    OR description LIKE 'AMAZON'
    OR description LIKE 'ALLOCATE STOCK%'
    OR description LIKE 'ADD STOCK%'
    OR description LIKE '20713'
    OR description LIKE '%STOCK CHECK%'
    OR description LIKE '%SOLD IN SET%'
    OR description LIKE '%CREDIT%'
    OR description LIKE '%TEMP FIX%'
    OR description LIKE '%MARKED AS%'
    THEN 1 ELSE 0 END AS invalid_description_flag
  FROM CTE_BASE
  WHERE invalid_description_flag = 1
  ORDER BY 2 DESC
)
,
--SELECT *
--FROM CTE_FILTER_DEFECTS A
--INNER JOIN CTE_BASE B
--ON (A.stock_code = B.stock_code)

CTE_UNION_INVALID_DESC AS (
  SELECT * FROM CTE_FILTER_BUS_SKU
      UNION
  SELECT * FROM CTE_FILTER_DOTCOM
      UNION
  SELECT * FROM CTE_FILTER_AMAZON
      UNION
  SELECT * FROM CTE_FILTER_GIFTSHOP
      UNION
  SELECT * FROM CTE_FILTER_EBAY
      UNION
  SELECT * FROM CTE_FILTER_DEFECTS
)
,
--SELECT * FROM CTE_UNION_INVALID_DESC;

CTE_SINGLE_DESCRIPTION AS (
  SELECT
    stock_code
    ,description
  FROM (
    SELECT
      ROW_NUMBER() OVER (PARTITION BY
      stock_code
      ORDER BY
      LENGTH(description) DESC
      ) AS row_number
      ,stock_code
      ,description
    FROM (
      SELECT
        A.stock_code AS stock_code
        ,A.description AS description
        -- ,B.description AS description2
        -- ,B.invalid_description_flag
      FROM CTE_BASE A
      LEFT JOIN CTE_UNION_INVALID_DESC B
        ON (
        A.stock_code = B.stock_code AND
        A.description = B.description
        )
      WHERE B.invalid_description_flag IS NULL
    UNION
      SELECT
        stock_code
        ,description
      FROM CTE_UNION_INVALID_DESC
      WHERE invalid_description_flag = 0
    ) A
   ) B
  WHERE row_number = 1
  ORDER BY 1 DESC
)
,
--SELECT * FROM CTE_SINGLE_DESCRIPTION;

CTE_DESC_ALL_SKUS AS (
  SELECT DISTINCT
    A.stock_code
    --,B.stock_code
    ,COALESCE(B.description, A.stock_code) AS description
  FROM CTE_BASE A
  LEFT JOIN CTE_SINGLE_DESCRIPTION B
  ON (A.stock_code = B.stock_code)
)
,
--SELECT * FROM CTE_DESC_ALL_SKUS;

CTE_SKU_LOAD_DTS AS (
  SELECT DISTINCT
    stock_code
    ,MIN(load_dts) AS load_dts
  FROM SAT_ONLINE_RETAIL_II_YEAR_2010_2011_001
  GROUP BY stock_code
)
,
--SELECT * FROM CTE_SKU_LOAD_DTS;

CTE_TARGET AS (
  SELECT
    SHA1(UPPER(TRIM(COALESCE(A.stock_code, '')))) AS stock_code_hkey
    ,'sales/etc/sql/BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001_load.sql' AS provider_code
    ,load_dts
    ,A.description AS preferred_description
  FROM CTE_DESC_ALL_SKUS A
  INNER JOIN CTE_SKU_LOAD_DTS B
  ON (A.stock_code = B.stock_code)
)

--SELECT * FROM CTE_TARGET;

INSERT INTO BLNK_STOCK_CODE_PREFERRED_DESCRIPTION_001 (
  stock_code_hkey
  ,provider_code
  ,load_dts
  ,insert_dts
  ,preferred_description
)
SELECT
  stock_code_hkey
  ,provider_code
  ,load_dts
  ,strftime('%Y-%m-%dT%H:%M:%fZ', 'now') AS insert_dts
  ,preferred_description
FROM CTE_TARGET;
