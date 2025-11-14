# SQL Server Tuning Scripts for DBAs 🚀⚙️

[![SQL Server](https://img.shields.io/badge/DB-SQL%20Server-blue)](https://docs.microsoft.com/en-us/sql/sql-server/)
[![Tuning](https://img.shields.io/badge/Performance-Tuning-green)](https://docs.microsoft.com/en-us/sql/relational-databases/performance/)
[![Scripts](https://img.shields.io/badge/Scripts-Powerful-orange)](https://github.com/)

---

## Table des matières

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Cette documentation fournit une collection complète de **20 scripts SQL Server** destinés aux DBA experts pour réaliser un tuning efficace des bases de données. Ces scripts couvrent l’analyse des performances, la surveillance, l’optimisation des requêtes, la gestion des index, la configuration serveur et bien plus.

> [!NOTE]  
> Ces scripts sont conçus pour SQL Server 2012 et versions ultérieures. Ils doivent être exécutés avec des privilèges suffisants (souvent sysadmin ou db_owner).

---

## Quick Start

1. Connectez-vous à votre instance SQL Server avec SQL Server Management Studio (SSMS).
2. Copiez-collez les scripts dans une nouvelle requête.
3. Exécutez les scripts pour analyser ou modifier la configuration.
4. Consultez les résultats pour détecter les points de tuning.
5. Appliquez les recommandations adaptées.

> [!TIP]  
> Toujours tester les scripts dans un environnement de préproduction avant de les appliquer en production.

---

## Installation

Aucun package à installer. Ces scripts sont des requêtes T-SQL exécutables directement dans SSMS ou via sqlcmd.

Pour automatiser :

```bash
sqlcmd -S <server_name> -d <database_name> -U <user> -P <password> -i tuning_script.sql -o output.log
```

> [!IMPORTANT]  
> Assurez-vous d’avoir les droits nécessaires et de sauvegarder votre base avant toute modification.

---

## Usage

Les scripts sont divisés en catégories pour une utilisation ciblée.

### 1. Analyse des performances

- Vérification des requêtes lentes
- Analyse des plans d’exécution
- Surveillance des verrous et blocages

### 2. Gestion des index

- Identification des index manquants
- Analyse des index inutilisés
- Reconstruction des index fragmentés

### 3. Configuration serveur

- Paramètres mémoire et CPU
- Analyse du cache de procédures
- Statistiques de disque

### Options avancées

| Flag / Paramètre          | Description                               | Exemple                            |
|--------------------------|-------------------------------------------|----------------------------------|
| @TopNQueries INT          | Limite le nombre de requêtes affichées   | EXEC dbo.GetTopQueries @TopNQueries=10 |
| @ThresholdMs INT          | Définit le seuil de durée des requêtes   | EXEC dbo.GetLongRunningQueries @ThresholdMs=1000 |
| @RebuildThreshold FLOAT  | Seuil de fragmentation pour rebuild      | EXEC dbo.RebuildIndexes @RebuildThreshold=30.0 |

> [!TIP]  
> Utilisez les paramètres pour filtrer et cibler précisément vos analyses.

---

## Examples

### Script 1 : Top 10 requêtes les plus coûteuses CPU 📊

```sql
SELECT TOP 10
    total_worker_time/1000 AS CPU_ms,
    execution_count,
    avg_cpu_time = total_worker_time / execution_count,
    SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(qt.text)
            ELSE qs.statement_end_offset
          END - qs.statement_start_offset)/2) + 1) AS query_text,
    qt.dbid, qt.objectid
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY total_worker_time DESC;
```

---

### Script 2 : Analyse des verrous en cours ⚠️

```sql
SELECT
    request_session_id AS SessionID,
    resource_type AS ResourceType,
    resource_description AS ResourceDesc,
    request_mode AS LockMode,
    request_status AS Status,
    wait_duration_ms AS WaitTime_ms
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID()
ORDER BY wait_duration_ms DESC;
```

---

### Script 3 : Index fragmentés > 30% - Reconstruction recommandée ✅

```sql
SELECT 
    dbschemas.[name] AS SchemaName,
    dbtables.[name] AS TableName,
    dbindexes.[name] AS IndexName,
    indexstats.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
    AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.avg_fragmentation_in_percent > 30
ORDER BY indexstats.avg_fragmentation_in_percent DESC;
```

---

### Script 4 : Rebuild d’un index spécifique 🔧

```sql
ALTER INDEX [IX_YourIndex] ON dbo.YourTable REBUILD WITH (FILLFACTOR = 80);
```

---

### Script 5 : Requête pour détecter les procédures stockées recompilées fréquemment 💡

```sql
SELECT 
    DB_NAME(st.dbid) AS DatabaseName,
    OBJECT_SCHEMA_NAME(st.objectid, st.dbid) AS SchemaName,
    OBJECT_NAME(st.objectid, st.dbid) AS ProcName,
    qs.recompile_count
FROM sys.dm_exec_cached_plans AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) AS st
WHERE qs.recompile_count > 10
ORDER BY qs.recompile_count DESC;
```

---

### Script 6 : Monitoring mémoire buffer pool 📖

```sql
SELECT
    (physical_memory_in_use_kb / 1024) AS PhysicalMemoryMB,
    (database_pages * 8) / 1024 AS DatabaseCacheMB,
    (total_pages * 8) / 1024 AS TotalCacheMB
FROM sys.dm_os_buffer_descriptors
CROSS JOIN sys.dm_os_sys_memory
WHERE database_id = DB_ID();
```

---

### Script 7 : Analyse des statistiques obsolètes 🕵️‍♂️

```sql
SELECT 
    object_name(s.object_id) AS TableName,
    s.name AS StatsName,
    STATS_DATE(s.object_id, s.stats_id) AS LastUpdated
FROM sys.stats s
WHERE STATS_DATE(s.object_id, s.stats_id) < DATEADD(DAY, -30, GETDATE())
ORDER BY LastUpdated;
```

---

### Script 8 : Paramètres CPU et Affinité du serveur ⚙️

```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'affinity mask';
EXEC sp_configure 'max degree of parallelism';
```

---

### Script 9 : Requête pour détecter les index non utilisés 📉

```sql
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks + s.user_scans + s.user_lookups + s.user_updates AS TotalUsage
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE s.database_id = DB_ID()
AND (s.user_seeks + s.user_scans + s.user_lookups + s.user_updates) = 0
ORDER BY TableName;
```

---

### Script 10 : Historique des verrous bloquants sur 24h ⏳

```sql
SELECT 
    blocking_session_id, session_id,
    wait_time, wait_type, resource_description,
    COUNT(*) AS BlockingCount
FROM sys.dm_os_waiting_tasks
WHERE wait_type LIKE '%LCK%'
AND wait_time > 1000
AND blocking_session_id IS NOT NULL
GROUP BY blocking_session_id, session_id, wait_time, wait_type, resource_description
ORDER BY BlockingCount DESC;
```

---

### Script 11 : Rebuild automatique des index fragmentés > seuil choisi

```sql
DECLARE @RebuildThreshold FLOAT = 30.0;

DECLARE cur CURSOR FOR
SELECT 
    QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.name) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
JOIN sys.tables t ON i.object_id = t.object_id
WHERE ips.avg_fragmentation_in_percent > @RebuildThreshold
    AND i.type_desc IN ('CLUSTERED', 'NONCLUSTERED');

OPEN cur;
DECLARE @TableName NVARCHAR(128), @IndexName NVARCHAR(128), @Frag FLOAT;
FETCH NEXT FROM cur INTO @TableName, @IndexName, @Frag;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Rebuilding index ' + @IndexName + ' on table ' + @TableName + ' with fragmentation ' + CAST(@Frag AS VARCHAR(10)) + '%';
    EXEC('ALTER INDEX ' + QUOTENAME(@IndexName) + ' ON ' + @TableName + ' REBUILD;');
    FETCH NEXT FROM cur INTO @TableName, @IndexName, @Frag;
END

CLOSE cur;
DEALLOCATE cur;
```

---

### Script 12 : Affichage des requêtes en attente d’exécution (queued requests) 🚦

```sql
SELECT 
    r.session_id,
    r.status,
    r.command,
    r.wait_type,
    r.wait_time,
    r.cpu_time,
    r.total_elapsed_time,
    SUBSTRING(t.text, (r.statement_start_offset/2)+1, 
        ((CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(t.text) ELSE r.statement_end_offset END - r.statement_start_offset)/2)+1) AS query_text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.status = 'suspended'
ORDER BY r.wait_time DESC;
```

---

### Script 13 : Liste des bases avec leur taille et espace libre 📏

```sql
EXEC sp_MSforeachdb 
'USE [?];
 SELECT
    DB_NAME() AS DatabaseName,
    SUM(size) * 8 / 1024 AS SizeMB,
    SUM(CASE WHEN type_desc = ''ROWS'' THEN size ELSE 0 END) * 8 / 1024 AS DataMB,
    SUM(CASE WHEN type_desc = ''LOG'' THEN size ELSE 0 END) * 8 / 1024 AS LogMB
 FROM sys.database_files;';
```

---

### Script 14 : Historique des erreurs SQL Server (Log SQL) 📜

```sql
EXEC xp_readerrorlog 0, 1, N'error', NULL, NULL, NULL, N'desc';
```

---

### Script 15 : Requête pour détecter la mauvaise utilisation des index (updates fréquents) 🔄

```sql
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    user_updates
FROM sys.dm_db_index_usage_stats AS s
JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE s.database_id = DB_ID()
AND user_updates > 1000
ORDER BY user_updates DESC;
```

---

### Script 16 : Vérification de la configuration MAXDOP optimale selon le nombre de CPU 🖥️

```sql
SELECT cpu_count, hyperthread_ratio, cpu_count / hyperthread_ratio AS PhysicalCPUs
FROM sys.dm_os_sys_info;
-- Recommandé : MAXDOP = PhysicalCPUs (max 8)
```

---

### Script 17 : Affichage des statistiques de compilation de requêtes 🛠️

```sql
SELECT 
    object_name(st.objectid, st.dbid) AS ObjectName,
    qs.execution_count,
    qs.total_worker_time,
    qs.total_elapsed_time,
    qs.total_logical_reads
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_worker_time DESC;
```

---

### Script 18 : Vérification du plan cache pour les plans volumineux 🔍

```sql
SELECT 
    cp.size_in_bytes / 1024 AS SizeKB,
    cp.usecounts,
    SUBSTRING(st.text, (cp.statement_start_offset/2)+1,
        ((CASE cp.statement_end_offset WHEN -1 THEN DATALENGTH(st.text) ELSE cp.statement_end_offset END - cp.statement_start_offset)/2)+1) AS QueryText
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
WHERE cp.size_in_bytes > 1024 * 50 -- plans > 50KB
ORDER BY cp.size_in_bytes DESC;
```

---

### Script 19 : Analyse des requêtes avec scans complets sur tables volumineuses 🧐

```sql
SELECT 
    qt.text,
    qs.execution_count,
    qs.total_logical_reads,
    qt.dbid,
    qt.objectid
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
WHERE qs.total_logical_reads > 100000
ORDER BY qs.total_logical_reads DESC;
```

---

### Script 20 : Détecter les plans compilés fréquemment (recompilations) ♻️

```sql
SELECT 
    DB_NAME(st.dbid) AS DatabaseName,
    OBJECT_SCHEMA_NAME(st.objectid, st.dbid) AS SchemaName,
    OBJECT_NAME(st.objectid, st.dbid) AS ObjectName,
    qs.execution_count,
    qs.recompile_count
FROM sys.dm_exec_cached_plans qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
WHERE qs.recompile_count > 10
ORDER BY qs.recompile_count DESC;
```

---

## FAQ

### Q1: Puis-je exécuter ces scripts directement en production ?

> [!WARNING]  
> Bien que ces scripts soient sûrs pour l’analyse, toute modification (ex : rebuild index) doit être testée en environnement de staging avant.

---

### Q2: Comment automatiser l’exécution régulière ?

> [!TIP]  
> Utilisez SQL Server Agent pour planifier des jobs exécutant ces scripts et exporter les résultats dans des fichiers ou tables dédiées.

---

### Q3: Que faire si un script prend trop de temps ?

> [!NOTE]  
> Limitez les résultats avec les paramètres (ex : TOP, seuils). Analysez la charge du serveur et exécutez les scripts hors des heures de pointe.

---

### Q4: Comment interpréter les résultats d’index fragmentés ?

> [!TIP]  
> Fragmentation > 30% : Rebuild conseillé  
> Fragmentation 5-30% : Reorganize recommandé  
> Fragmentation < 5% : Pas d’action nécessaire

---

### Q5: Peut-on adapter ces scripts à d’autres versions SQL Server ?

> [!IMPORTANT]  
> Ces scripts sont compatibles SQL Server 2012+. Certaines DMV peuvent différer sur versions antérieures. Toujours vérifier la documentation officielle.

---

Merci d’avoir choisi ce guide pour optimiser vos bases SQL Server. Votre performance en dépend ! ✅🔧🚀