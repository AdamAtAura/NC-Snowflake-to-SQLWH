USE SNOWFLAKE
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIM_ANTIVIRUS_PRODUCT_STATUS]') AND type in (N'U'))
DROP TABLE [dbo].[DIM_ANTIVIRUS_PRODUCT_STATUS]
GO

SELECT * 
INTO DIM_ANTIVIRUS_PRODUCT_STATUS
FROM OPENQUERY([NABLESNOWFLAKE], 'SELECT ANTIVIRUS_PRODUCT_STATUS_DK
	  ,DEFINITIONS_UP_TO_DATE
	  ,CAST(SUBSTRING(DEFINITION_AGE_STATUS,1,8000) AS CHAR(8000)) AS DEFINITION_AGE_STATUS
	  ,SCANNING_ENABLED
	  ,CAST(SUBSTRING(SCAN_AGE_STATUS,1,8000) AS CHAR(8000)) AS SCAN_AGE_STATUS
	FROM SHARED_ANALYTICS_DATA.SHARED_DATA.DIM_ANTIVIRUS_PRODUCT_STATUS')
