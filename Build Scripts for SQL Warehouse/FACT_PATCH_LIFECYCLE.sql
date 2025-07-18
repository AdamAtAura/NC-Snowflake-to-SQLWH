USE SNOWFLAKE
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACT_PATCH_LIFECYCLE]') AND type in (N'U'))
DROP TABLE [dbo].FACT_PATCH_LIFECYCLE
GO

SELECT * 
INTO FACT_PATCH_LIFECYCLE
FROM OPENQUERY([NABLESNOWFLAKE], 'SELECT TENANT_DK
	  ,CUSTOMER_DK
	  ,SITE_DK
	  ,DEVICE_DK
	  ,DEVICE_PATCH_DK
	  ,PATCH_DK
	  ,NOT_INSTALLED_EARLIEST
	  ,NOT_INSTALLED_LATEST
	  ,APPROVAL_EARLIEST
	  ,APPROVAL_LATEST
	  ,DECLINED_EARLIEST
	  ,DECLINED_LATEST
	  ,NO_APPROVAL_EARLIEST
	  ,NO_APPROVAL_LATEST
	  ,NOT_APPROVED_EARLIEST
	  ,NOT_APPROVED_LATEST
	  ,ABORTED_EARLIEST
	  ,ABORTED_LATEST
	  ,FAILURE_EARLIEST
	  ,FAILURE_LATEST
	  ,INSTALLED_EARLIEST
	  ,INSTALLED_WITH_ERRORS_EARLIEST
	  ,INSTALLED_WITH_ERRORS_LATEST
	  ,APPROVAL_UNINSTALL_EARLIEST
	  ,APPROVAL_UNINSTALL_LATEST
	  ,INSTALLED_DETECTION_LATEST
	  ,UNINSTALL_DETECTION_LATEST
	  ,NOT_INSTALLED_DETECTION_LATEST
	  ,CAST(SUBSTRING(PENDING_INSTALLATION,1,8000) AS CHAR(8000)) AS PENDING_INSTALLATION
	  ,CAST(SUBSTRING(NON_ACTIONED,1,8000) AS CHAR(8000)) AS NON_ACTIONED
	  ,CAST(SUBSTRING(FAILED_NON_INSTALLATION,1,8000) AS CHAR(8000)) AS FAILED_NON_INSTALLATION
	  ,CAST(SUBSTRING(INSTALLATION_STATUS,1,8000) AS CHAR(8000)) AS INSTALLATION_STATUS
	  ,CAST(SUBSTRING(FAILED,1,8000) AS CHAR(8000)) AS FAILED
	  ,CAST(SUBSTRING(NOT_REQUIRED,1,8000) AS CHAR(8000)) AS NOT_REQUIRED
	  ,CAST(SUBSTRING(DECLINED,1,8000) AS CHAR(8000)) AS DECLINED
	  ,CAST(SUBSTRING(UNINSTALL,1,8000) AS CHAR(8000)) AS UNINSTALL
	  ,CAST(SUBSTRING(NOT_APPROVED,1,8000) AS CHAR(8000)) AS NOT_APPROVED
	  ,CAST(SUBSTRING(NO_APPROVAL,1,8000) AS CHAR(8000)) AS NO_APPROVAL
	  ,CAST(SUBSTRING(PATCH_REMOVED,1,8000) AS CHAR(8000)) AS PATCH_REMOVED
	  ,CAST(SUBSTRING(NON_PME_INSTALL,1,8000) AS CHAR(8000)) AS NON_PME_INSTALL
	  ,INSTALLED_DURATION
	  ,APPROVED_INSTALLED_DURATION
	  ,NUM_PATCHES
	  ,NUM_INSTALLED
	  ,NUM_NON_INSTALLED
	  ,NUM_PENDING
	  ,NUM_FAILED_INSTALL
	  ,NUM_FAILED
	  ,NUM_NOT_REQUIRED
	  ,NUM_DECLINED
	  ,NUM_UNINSTALL
	  ,NUM_NOT_APPROVED
	  ,NUM_NO_APPROVAL
	  ,NUM_REMOVED
	  ,NUM_NON_PME
	  ,CAST(SUBSTRING(PATCH_STATUS,1,8000) AS CHAR(8000)) AS PATCH_STATUS
	FROM SHARED_ANALYTICS_DATA.SHARED_DATA.FACT_PATCH_LIFECYCLE')
