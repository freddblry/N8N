# Azure SQL Database Guide 🚀

![Status](https://img.shields.io/badge/status-stable-brightgreen) ![Azure](https://img.shields.io/badge/platform-Azure-blue)

## Table of Contents 📖
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Azure SQL Database is a fully managed relational database service by Microsoft Azure. It offers scalable, intelligent, and secure SQL database solutions in the cloud.

Key features include:
- High availability with built-in redundancy
- Automated backups and updates
- Advanced security with encryption and threat detection
- Elastic scalability and performance tuning
- Integration with Azure ecosystem and tools

---

## Quick Start 🚀

1. Create an Azure SQL Database instance via the Azure Portal.
2. Configure firewall rules to allow client access.
3. Connect using SQL Server Management Studio (SSMS) or Azure Data Studio.
4. Start running queries and managing your database.

> [!TIP] Use Azure CLI for quick database creation:
> ```bash
> az sql server create -l eastus -g myResourceGroup -n myServer -u adminUser -p Password123!
> az sql db create -g myResourceGroup -s myServer -n myDatabase --service-objective S0
> ```

---

## Installation ⚙️

Azure SQL Database is a Platform as a Service (PaaS), so no local installation is needed. However, you must set up tools to interact with the database:

| Tool                 | Description                           | Installation Command                    |
|----------------------|-----------------------------------|----------------------------------------|
| SQL Server Management Studio (SSMS) | Microsoft’s official database management tool | Download from https://aka.ms/ssms |
| Azure Data Studio     | Cross-platform data management tool | Download from https://aka.ms/azuredatastudio |
| Azure CLI            | Command line interface for Azure   | ```bash curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash``` |

---

## Usage 💡

### Connecting to Azure SQL Database

```bash
sqlcmd -S tcp:<server-name>.database.windows.net,1433 -d <database-name> -U <username> -P <password>
```

### Basic SQL Query Example:

```sql
SELECT TOP 10 * FROM dbo.Customers ORDER BY CustomerID;
```

### Managing Firewall Rules

Allow your client IP to access the database:

```bash
az sql server firewall-rule create \
    --resource-group myResourceGroup \
    --server myServer \
    --name AllowMyIP \
    --start-ip-address <your-ip> \
    --end-ip-address <your-ip>
```

---

## Examples 📊

### Create a New Database

```bash
az sql db create -g myResourceGroup -s myServer -n newDatabase --service-objective S1
```

### Export Database to BACPAC File

```bash
az sql db export -g myResourceGroup -s myServer -n myDatabase \
    --storage-key <storage-key> --storage-key-type StorageAccessKey \
    --storage-uri https://mystorageaccount.blob.core.windows.net/backups/myDatabase.bacpac \
    --admin-user adminUser --admin-password Password123!
```

### Scale Up Database Performance Tier

```bash
az sql db update -g myResourceGroup -s myServer -n myDatabase --service-objective P1
```

---

## FAQ ⚠️

| Question                                  | Answer                                                        |
|-------------------------------------------|---------------------------------------------------------------|
| What is the difference between Azure SQL Database and SQL Server? | Azure SQL Database is a managed cloud service; SQL Server is an on-premises software. |
| Can I restore my database to a previous point in time? | Yes, Azure SQL Database supports point-in-time restore up to 35 days. |
| How do I secure my Azure SQL Database?   | Use firewall rules, always encrypted data, and enable threat detection. |
| Is there a free tier available?           | Yes, Azure offers a free 12-month tier with limited usage.     |

> [!IMPORTANT] Always use strong passwords and enable multi-factor authentication for your Azure account to protect your databases.

---

Thank you for using Azure SQL Database! For more info, visit the official documentation: https://docs.microsoft.com/azure/azure-sql/