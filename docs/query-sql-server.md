# SQL Server Essential Queries 📊

![Status](https://img.shields.io/badge/Status-Active-green) ![SQL Server](https://img.shields.io/badge/Platform-SQL%20Server-blue) ![Documentation](https://img.shields.io/badge/Docs-Complete-brightgreen)

## Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

## Overview 📖
This documentation provides a concise collection of the most important and commonly used SQL Server queries. It covers data selection, insertion, updates, deletion, joins, aggregation, transactions, and more to help you efficiently manage and interact with your SQL Server databases.

## Quick Start 🚀
- Use `SELECT` to query data.
- Use `INSERT INTO` to add data.
- Use `UPDATE` to modify existing data.
- Use `DELETE` to remove data.
- Use `JOIN` to combine tables.
- Use `GROUP BY` for aggregation.
- Use transactions for data integrity.

> [!TIP]
> Always backup your database before running `UPDATE` or `DELETE` queries.

## Installation ⚙️
SQL Server must be installed and running on your machine or server. Use Microsoft's official installer or container images for setup.

```bash
# Example: Installing SQL Server on Ubuntu
sudo apt-get update
sudo apt-get install -y mssql-server
sudo /opt/mssql/bin/mssql-conf setup
sudo systemctl start mssql-server
```

> [!IMPORTANT]
> Ensure you have proper permissions and a SQL Server client like SQL Server Management Studio (SSMS) or Azure Data Studio to run these queries.

## Usage 🔧

### Basic Query Syntax
```sql
SELECT column1, column2 FROM table_name WHERE condition;
```

### Common Query Types

| Query Type       | Description                        | Example                         |
|------------------|----------------------------------|--------------------------------|
| SELECT           | Retrieve data                    | `SELECT * FROM Employees;`     |
| INSERT           | Add new data                    | `INSERT INTO Employees VALUES (...);` |
| UPDATE           | Modify existing data            | `UPDATE Employees SET Salary = 5000 WHERE Id=1;` |
| DELETE           | Remove data                    | `DELETE FROM Employees WHERE Id=1;` |
| JOIN             | Combine rows from multiple tables | `SELECT * FROM A JOIN B ON A.Id = B.AId;` |
| AGGREGATE        | Summarize data                 | `SELECT COUNT(*) FROM Employees;` |

## Examples 💡

### 1. Select all columns and rows
```sql
SELECT * FROM Employees;
```

### 2. Select specific columns with a condition
```sql
SELECT FirstName, LastName FROM Employees WHERE Department = 'Sales';
```

### 3. Insert a new record
```sql
INSERT INTO Employees (FirstName, LastName, Department, Salary) 
VALUES ('John', 'Doe', 'Marketing', 4500);
```

### 4. Update records
```sql
UPDATE Employees SET Salary = Salary * 1.05 WHERE Department = 'Sales';
```

### 5. Delete records
```sql
DELETE FROM Employees WHERE Id = 10;
```

### 6. Inner Join example
```sql
SELECT e.FirstName, d.DepartmentName 
FROM Employees e
INNER JOIN Departments d ON e.DepartmentId = d.Id;
```

### 7. Aggregate with GROUP BY
```sql
SELECT Department, COUNT(*) AS EmployeeCount 
FROM Employees 
GROUP BY Department;
```

### 8. Using Transactions
```sql
BEGIN TRANSACTION;

UPDATE Accounts SET Balance = Balance - 100 WHERE AccountId = 1;
UPDATE Accounts SET Balance = Balance + 100 WHERE AccountId = 2;

COMMIT;
```

> [!WARNING]
> Always use `BEGIN TRANSACTION` and `COMMIT`/`ROLLBACK` for multiple related changes to maintain data integrity.

## FAQ ❓

**Q1: How to limit the number of rows returned?**  
Use `TOP` keyword:  
```sql
SELECT TOP 10 * FROM Employees;
```

**Q2: How to find duplicate rows?**  
```sql
SELECT ColumnName, COUNT(*) 
FROM TableName 
GROUP BY ColumnName 
HAVING COUNT(*) > 1;
```

**Q3: How to perform a case-insensitive search?**  
Use `COLLATE` for case-insensitivity:  
```sql
SELECT * FROM Employees WHERE FirstName COLLATE SQL_Latin1_General_CP1_CI_AS = 'john';
```

**Q4: Can I run multiple queries in one batch?**  
Yes, separate queries by semicolon `;`.

**Q5: How to check SQL Server version?**  
```sql
SELECT @@VERSION;
```

---

For more detailed scenarios, refer to Microsoft's official SQL Server documentation or your database administrator. ✅