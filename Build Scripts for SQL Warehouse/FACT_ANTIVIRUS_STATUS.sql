USE SNOWFLAKE
GO

DECLARE @StartDate DATE
DECLARE @EndDate DATE
DECLARE @CurrentDate DATE
DECLARE @DATE_VAR VARCHAR(8)
DECLARE @SQL NVARCHAR(MAX)

SELECT @StartDate = DATEADD(DAY, 1, CONVERT(DATE, CAST(MAX(STATUS_DATE_DK) AS CHAR(8)), 112))
FROM FACT_ANTIVIRUS_STATUS
SET @EndDate = DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
IF @StartDate > @EndDate
BEGIN
    PRINT 'No new dates to process.'
    RETURN
END
SET @CurrentDate = @StartDate
WHILE @CurrentDate <= @EndDate
BEGIN
    SET @DATE_VAR = CONVERT(CHAR(8), @CurrentDate, 112) -- Format: YYYYMMDD

    SET @SQL = '
    INSERT INTO [dbo].[FACT_ANTIVIRUS_STATUS]
           ([TENANT_DK]
           ,[ANTIVIRUS_SECURITY_DK]
           ,[CUSTOMER_DK]
           ,[CUSTOMER_SK]
           ,[SITE_DK]
           ,[SITE_SK]
           ,[DEVICE_DK]
           ,[DEVICE_SK]
           ,[ANTIVIRUS_PRODUCT_DK]
           ,[ANTIVIRUS_PRODUCT_STATUS_DK]
           ,[ANTIVIRUS_STATUS_TIMESTAMP]
           ,[STATUS_DATE_DK]
           ,[NUM_DAYS_FROM_LAST_SCAN]
           ,[DEFINITIONS_AGE]
           ,[STATUS_COUNT]
           ,[NUM_SCANNING_ENABLED]
           ,[NUM_SCANNING_DISABLED]
           ,[NUM_DEFINITIONS_UP_TO_DATE]
           ,[NUM_DEFINITIONS_OUT_OF_DATE]
           ,[DSS_CREATED])
    SELECT * FROM OPENQUERY([NABLESNOWFLAKE], ''
        SELECT TENANT_DK
              ,ANTIVIRUS_SECURITY_DK
              ,CUSTOMER_DK
              ,CUSTOMER_SK
              ,SITE_DK
              ,SITE_SK
              ,DEVICE_DK
              ,DEVICE_SK
              ,ANTIVIRUS_PRODUCT_DK
              ,ANTIVIRUS_PRODUCT_STATUS_DK
              ,ANTIVIRUS_STATUS_TIMESTAMP
              ,STATUS_DATE_DK
              ,NUM_DAYS_FROM_LAST_SCAN
              ,DEFINITIONS_AGE
              ,STATUS_COUNT
              ,NUM_SCANNING_ENABLED
              ,NUM_SCANNING_DISABLED
              ,NUM_DEFINITIONS_UP_TO_DATE
              ,NUM_DEFINITIONS_OUT_OF_DATE
              ,DSS_CREATED
        FROM SHARED_ANALYTICS_DATA.SHARED_DATA.FACT_ANTIVIRUS_STATUS
        WHERE STATUS_DATE_DK = ''''' + @DATE_VAR + ''''''')'

    PRINT 'Running for date: ' + @DATE_VAR
    EXEC(@SQL)

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate)
END
