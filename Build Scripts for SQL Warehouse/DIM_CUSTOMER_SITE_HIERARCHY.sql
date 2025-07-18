USE SNOWFLAKE
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIM_CUSTOMER_SITE_HIERARCHY]') AND type in (N'U'))
DROP TABLE [dbo].[DIM_CUSTOMER_SITE_HIERARCHY]
GO

SELECT * 
INTO DIM_CUSTOMER_SITE_HIERARCHY
FROM OPENQUERY([NABLESNOWFLAKE], 'SELECT TENANT_DK
	  ,DEVICE_DK
	  ,CAST(SUBSTRING(DEVICE_NAME,1,8000) AS CHAR(8000)) AS DEVICE_NAME
	  ,CAST(SUBSTRING(CUSTOMER_NAME,1,8000) AS CHAR(8000)) AS CUSTOMER_NAME
	  ,CAST(SUBSTRING(SITE_NAME,1,8000) AS CHAR(8000)) AS SITE_NAME
	FROM SHARED_ANALYTICS_DATA.SHARED_DATA.DIM_CUSTOMER_SITE_HIERARCHY')
