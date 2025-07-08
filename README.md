# NC-Snowflake-to-SQLWH

A set of scripts and configuration steps to establish a local SQL Server data warehouse copy of N-Central data hosted in Snowflake, enabling internal reporting and analysis.

---

## 🧰 Environment Overview

This guide assumes:

- A Windows Server environment running SQL Server.
- Public IP whitelisting configured in Snowflake to allow inbound connectivity from your server.
- A dedicated Snowflake user for reporting access to N-Central data.

---

## ✅ Prerequisites

### 1. Install the Snowflake ODBC Driver

Download and install the latest ODBC driver:  
🔗 [Snowflake ODBC Driver for Windows](https://docs.snowflake.com/en/developer-guide/odbc/odbc-windows)

---

### 2. Configure ODBC DSN via Registry

After installing the driver, create an ODBC connection by adding a registry entry with the appropriate values.

> **Note:** We set `default_varchar_size` to a large value to accommodate wide string fields. This avoids issues caused by the inability to alter field sizes in the shared Snowflake schema.

<details>
<summary><strong>📋 Registry Example (.reg file)</strong></summary>

```reg
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\NAbleSnowflake]
"Driver"="SnowflakeDSIIDriver"
"AUTHENTICATOR"=""
"DATABASE"="SHARED_ANALYTICS_DATA"
"NO_PROXY"=""
"PROXY"=""
"ROLE"="<your_snowflake_role>"
"SCHEMA"="SHARED_DATA"
"SERVER"="<your_snowflake_server>"
"TRACING"="4"
"UID"="<your_reporting_username>"
"WAREHOUSE"="WH_xxxxxxxx_xxxx_xxxx_xxxx_xxxxxxxxxxxx"
"default_varchar_size"="16777216"
```

</details>

---

## 🧩 SQL Server Configuration

### 1. Create a Linked Server

Open **SQL Server Management Studio (SSMS)** and follow these steps:

1. Expand **Server Objects > Linked Servers**.
2. Right-click **Linked Servers > New Linked Server...**
3. Set the following:

- **Linked server**: `NABLESNOWFLAKE` (or your preferred name)
- **Provider**: `Microsoft OLE DB Provider for ODBC Drivers`
- **Product name**: `Snowflake`
- **Data source**: The name of your ODBC DSN (e.g., `NAbleSnowflake`)
- **Provider string**: *(leave blank)*
- **Catalog**: *(optional)*

---

### 2. Configure Security

For each login that needs access, map your **local SQL Server login** to the **Snowflake remote login**.

Choose one of the following options:

#### Option A – Individual Mappings

- Add your SQL login.
- Tick **Impersonate** if supported by your ODBC configuration.
- Otherwise, configure as:

```text
Remote Login: <your_snowflake_username>
With Password: <your_password>
```

#### Option B – Global Mapping

- Select **"Be made using this security context"**.
- Enter credentials that apply to all connections:

```text
Remote Login: <your_snowflake_username>
With Password: <your_password>
```

⚠️ **Security Tip**: Avoid storing plaintext credentials in production. Use secure mechanisms like Credential objects or Managed Identity where possible.

---

### 3. Name the Linked Server

We recommend naming the linked server:

```text
NABLESNOWFLAKE
```

This name is assumed in the included scripts. If you choose a different name, remember to update all script references accordingly.

---

### 4. Execution & Scheduling

To make your data warehouse sync nightly:

1. Create a **blank SQL Server database** to hold the imported Snowflake data.  
   Example:
   ```sql
   CREATE DATABASE SNOWFLAKE;
   ```

2. Use **SQL Server Agent** to schedule the import scripts:

- Each job can run a different script (e.g. import customers, devices, etc.).
- Set the job frequency (e.g. nightly at 01:00).
- Ensure the SQL Agent account has permission to query the linked server.

Example job step:

```sql
TRUNCATE TABLE dbo.NCentralDevices;

INSERT INTO dbo.NCentralDevices
SELECT *
FROM OPENQUERY(NABLESNOWFLAKE, 'SELECT * FROM SHARED_DATA.DEVICES');
```

You can also test connectivity with a simple query:

```sql
SELECT CURRENT_DATE, CURRENT_USER, CURRENT_ROLE
FROM OPENQUERY(NABLESNOWFLAKE, 'SELECT CURRENT_DATE, CURRENT_USER, CURRENT_ROLE');
```

---

## ⚠️ Important Notes

- Monitor your Snowflake credit usage, especially during setup and testing.  
  During early development, we burned through the default 10-credit allocation rather quickly due to repeated loads.

---

## 🛠️ Credits

This basic design was written by AdamG at Aura Technology.
