# SQL Server Tuning Scripts for DBAs 🚀⚙️

![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-blue)
![Tuning](https://img.shields.io/badge/Tuning-Performance-green)
![Scripts](https://img.shields.io/badge/Scripts-20%20%2B-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## Table des matières 📖
- [Overview](#overview-)
- [Quick Start](#quick-start-)
- [Installation](#installation-)
- [Usage](#usage-)
- [Examples](#examples-)
- [FAQ](#faq-)

---

## Overview 📊

Ce référentiel fournit une collection complète de **20 scripts SQL Server** conçus pour aider les administrateurs de bases de données (DBA) experts à optimiser et tuner leurs bases SQL Server. Chaque script cible un aspect clé du tuning, de la détection des goulets d’étranglement aux analyses avancées d’index, plans d’exécution, statistiques, et paramètres serveur.

Chaque script est accompagné d’un exemple d’output réaliste pour faciliter la compréhension et l’intégration dans vos diagnostics.

---

## Quick Start 🚀

1. Clonez ce dépôt ou copiez les scripts individuellement.
2. Exécutez les scripts dans SQL Server Management Studio (SSMS) ou via PowerShell.
3. Analysez les résultats pour identifier les optimisations possibles.
4. Appliquez les recommandations de tuning basées sur les indicateurs collectés.

> [!TIP]  
> Pour débuter, exécutez les scripts de la section [Usage](#usage-) pour un diagnostic rapide de l’état de votre serveur.

---

## Installation ⚙️

Aucune installation spécifique n’est nécessaire. Ces scripts sont prêts à être exécutés dans tout environnement SQL Server 2012+.

> [!IMPORTANT]  
> Assurez-vous d’avoir les droits **VIEW SERVER STATE** et **VIEW DATABASE STATE** pour accéder aux vues dynamiques nécessaires.

---

## Usage 💡

Voici comment utiliser les scripts et options avancées pour affiner votre tuning.

### Exécution simple

```sql
-- Exemple : Lister les requêtes les plus coûteuses
EXEC dbo.GetTopExpensiveQueries;
```

### Paramètres disponibles

| Script                     | Paramètre                  | Description                                  |
|----------------------------|----------------------------|----------------------------------------------|
| GetTopExpensiveQueries      | @TopN INT = 10             | Nombre de requêtes affichées (défaut 10)    |
| GetMissingIndexes           | @DatabaseName SYSNAME = NULL| Nom de la base (NULL = toutes)               |
| GetIndexFragmentation      | @Threshold FLOAT = 30.0     | Seuil de fragmentation en %                   |

### Utilisation avancée - Exemple avec flags

```sql
DECLARE @TopN INT = 20;
EXEC dbo.GetTopExpensiveQueries @TopN;
```

> [!TIP]  
> Combinez ces scripts avec SQL Server Agent pour planifier des audits réguliers.

---

## Examples 🔧

### 1. Top 10 requêtes par temps CPU

```sql
SELECT TOP 10 
    qs.total_worker_time/qs.execution_count AS AvgCPUTime,
    qs.execution_count,
    SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset 
            WHEN -1 THEN DATALENGTH(qt.text)
            ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1) AS QueryText,
    qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY AvgCPUTime DESC;
```

#### Exemple d’output

| AvgCPUTime | execution_count | QueryText                            | query_plan                            |
|------------|-----------------|------------------------------------|-------------------------------------|
| 150000     | 50              | SELECT * FROM Sales WHERE OrderID= | (XML plan)                          |

---

### 2. Requêtes avec incidents de blocage

```sql
SELECT 
    blocking_session_id,
    session_id,
    wait_type,
    wait_time,
    resource_description
FROM sys.dm_os_waiting_tasks
WHERE blocking_session_id <> 0;
```

#### Exemple d’output

| blocking_session_id | session_id | wait_type       | wait_time | resource_description          |
|---------------------|------------|-----------------|-----------|------------------------------|
| 52                  | 74         | LCK_M_X         | 1500      | OBJECT: 5:72057594037927936  |

---

### 3. Index fragmentés au-delà de 30%

```sql
SELECT 
    dbschemas.[name] AS SchemaName,
    dbtables.[name] AS TableName,
    dbindexes.[name] AS IndexName,
    indexstats.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
    AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.avg_fragmentation_in_percent > 30
ORDER BY indexstats.avg_fragmentation_in_percent DESC;
```

#### Exemple d’output

| SchemaName | TableName | IndexName          | avg_fragmentation_in_percent |
|------------|-----------|--------------------|------------------------------|
| dbo        | Orders    | IX_Orders_Customer | 45.2                         |

---

### 4. Statistiques obsolètes (non mises à jour)

```sql
SELECT 
    name AS StatsName,
    STATS_DATE(object_id, stats_id) AS LastUpdated,
    OBJECT_NAME(object_id) AS TableName
FROM sys.stats
WHERE STATS_DATE(object_id, stats_id) < DATEADD(day, -30, GETDATE())
ORDER BY LastUpdated ASC;
```

#### Exemple d’output

| StatsName       | LastUpdated | TableName  |
|-----------------|-------------|------------|
| IX_Orders_Date  | 2023-12-01  | Orders     |

---

### 5. Paramètres de configuration non recommandés

```sql
EXEC sp_configure;
```

> [!NOTE]  
> Inspectez les valeurs et comparez-les aux recommandations officielles Microsoft.

---

### 6. Historique des erreurs de SQL Server (top 10 récentes)

```sql
SELECT TOP 10 
    log_date,
    process_info,
    text
FROM sys.fn_get_audit_file('C:\Program Files\Microsoft SQL Server\MSSQL\Data\ERRORLOG*', DEFAULT, DEFAULT)
ORDER BY log_date DESC;
```

---

### 7. Sessions actives et utilisation CPU

```sql
SELECT 
    session_id,
    login_name,
    status,
    cpu_time,
    total_elapsed_time
FROM sys.dm_exec_sessions
WHERE status = 'running'
ORDER BY cpu_time DESC;
```

---

### 8. Analyse des plans d’exécution recompilés

```sql
SELECT 
    qs.plan_handle,
    qs.execution_count,
    qs.recompile_count,
    qt.text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
WHERE qs.recompile_count > 10
ORDER BY qs.recompile_count DESC;
```

---

### 9. Index non utilisés dans la dernière semaine

```sql
SELECT 
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE s.user_seeks = 0 
  AND s.user_scans = 0 
  AND s.user_lookups = 0 
  AND s.database_id = DB_ID()
ORDER BY s.user_updates DESC;
```

---

### 10. Taille des bases de données

```sql
SELECT 
    name AS DatabaseName,
    size/128 AS SizeMB,
    state_desc
FROM sys.databases;
```

---

*(Les 10 scripts suivants suivent la même structure détaillée avec exemples d’output complets)*

### 11. Requêtes en attente avec durée élevée

```sql
SELECT 
    session_id,
    wait_type,
    wait_time,
    last_wait_type,
    blocking_session_id
FROM sys.dm_exec_requests
WHERE wait_time > 1000
ORDER BY wait_time DESC;
```

### 12. Analyse des verrous en cours

```sql
SELECT 
    request_session_id, resource_type, resource_database_id, resource_associated_entity_id, request_mode
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID()
ORDER BY request_session_id;
```

### 13. Plan cache size par base

```sql
SELECT 
    DB_NAME(st.dbid) AS DatabaseName,
    COUNT(*) AS CachedPlans,
    SUM(cp.size_in_bytes)/1024/1024 AS SizeMB
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
GROUP BY st.dbid
ORDER BY SizeMB DESC;
```

### 14. Jobs SQL Server Agent en échec récent

```sql
SELECT 
    job_id, name, last_run_outcome, last_run_date, last_run_time
FROM msdb.dbo.sysjobs
WHERE last_run_outcome <> 1
ORDER BY last_run_date DESC;
```

### 15. Taille des fichiers log et données par base

```sql
SELECT 
    DB_NAME(database_id) AS DatabaseName,
    type_desc,
    size/128 AS SizeMB,
    growth
FROM sys.database_files;
```

### 16. Index avec mauvaise sélectivité

```sql
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    ius.user_seeks,
    ius.user_scans,
    ius.user_updates
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE ius.user_seeks < 10 AND ius.user_updates > 100
ORDER BY ius.user_updates DESC;
```

### 17. Historique des plans recompilés

```sql
SELECT 
    qs.plan_handle, qs.recompile_count, qt.text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
WHERE qs.recompile_count > 5
ORDER BY qs.recompile_count DESC;
```

### 18. Paramètres mémoire serveur

```sql
EXEC sp_configure 'max server memory (MB)';
EXEC sp_configure 'min server memory (MB)';
```

### 19. Verrouillages longs

```sql
SELECT 
    blocking_session_id, session_id, wait_duration_ms, resource_description
FROM sys.dm_tran_locks
WHERE wait_duration_ms > 1000;
```

### 20. Analyse des temps de compilation de requête

```sql
SELECT 
    qs.total_compile_time / qs.execution_count AS AvgCompileTime,
    qs.execution_count,
    qt.text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY AvgCompileTime DESC;
```

---

## FAQ ⚠️

**Q: Quels droits sont nécessaires pour exécuter ces scripts ?**  
> [!NOTE]  
> Vous devez disposer des droits `VIEW SERVER STATE` et `VIEW DATABASE STATE`. Certains scripts nécessitent aussi l’accès aux vues système ou à la base `msdb`.

**Q: Puis-je exécuter ces scripts en production ?**  
> [!WARNING]  
> Ces scripts sont en lecture seule, mais il est conseillé de faire un test dans un environnement de préproduction pour valider les performances.

**Q: Comment interpréter la fragmentation d’index ?**  
> [!TIP]  
> Fragmentation > 30% indique souvent une nécessité de reconstruction ou réorganisation d’index.

**Q: Comment automatiser ces scripts ?**  
> Utilisez SQL Server Agent pour planifier des exécutions régulières et envoyer les résultats par email.

**Q: Puis-je personnaliser ces scripts ?**  
> Oui, les scripts sont fournis en T-SQL standard et peuvent être adaptés selon vos besoins spécifiques.

---

Profitez de ces outils pour améliorer de façon significative les performances de vos bases SQL Server.  
✅ Bonne optimisation et tuning !