# SQL Server Scripts for DBA Experts ⚙️📊

![SQL Server Badge](https://img.shields.io/badge/SQL_Server-Expert-blue)
![DBA Badge](https://img.shields.io/badge/Role-DBA-green)
![Scripts Badge](https://img.shields.io/badge/Scripts-Powerful-orange)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## Table des matières

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
  - [Options Avancées](#options-avancées)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Bienvenue dans la documentation complète des scripts SQL Server pour DBA experts. Cette collection de scripts SQL vise à simplifier la gestion, la maintenance et le diagnostic des bases de données SQL Server dans des environnements professionnels et à forte charge.

Ces scripts sont conçus pour :

- Automatiser les tâches d'administration courantes
- Diagnostiquer les problèmes de performance
- Gérer la sécurité et les permissions
- Analyser l’espace disque et la fragmentation
- Optimiser les sauvegardes et restaurations

> [!TIP]  
> Ces scripts sont écrits pour SQL Server 2012 et versions supérieures. Testez toujours dans un environnement de développement avant mise en production.

---

## Quick Start

1. Téléchargez les scripts depuis le dépôt.
2. Connectez-vous à votre instance SQL Server via SSMS ou un outil CLI (sqlcmd).
3. Exécutez les scripts selon vos besoins.
4. Consultez les résultats directement dans SSMS ou exportez-les pour analyse.

> [!IMPORTANT]  
> Assurez-vous d’avoir les droits administratifs nécessaires (sysadmin ou équivalent) pour exécuter ces scripts.

---

## Installation

Ces scripts ne nécessitent pas d’installation spécifique. Toutefois, vous pouvez organiser votre environnement avec ces recommandations :

```bash
mkdir ~/sqlserver-scripts
cd ~/sqlserver-scripts
git clone https://github.com/votre-compte/sqlserver-dba-scripts.git .
```

⚙️ Pour automatiser leur exécution, vous pouvez utiliser le planificateur de tâches Windows ou SQL Server Agent.

Exemple d’ajout d’un job SQL Server Agent :

```sql
USE msdb;
GO
EXEC dbo.sp_add_job @job_name = N'AnalysePerformance';
EXEC dbo.sp_add_jobstep @job_name = N'AnalysePerformance',
    @step_name = N'ExecuteScript',
    @subsystem = N'TSQL',
    @command = N'EXEC dbo.ScriptAnalysePerformance;',
    @on_success_action = 1,
    @on_fail_action = 2;
EXEC dbo.sp_add_schedule @schedule_name = N'EveryNight',
    @freq_type = 4,  -- daily
    @active_start_time = 010000; -- 1 AM
EXEC dbo.sp_attach_schedule @job_name = N'AnalysePerformance',
    @schedule_name = N'EveryNight';
EXEC dbo.sp_add_jobserver @job_name = N'AnalysePerformance';
GO
```

---

## Usage

Les scripts sont prêts à l’emploi, mais vous pouvez affiner leur exécution avec des paramètres et options avancées.

### Exemple d'exécution basique

```sql
EXEC dbo.ScriptEtatServeur;
```

### Options avancées

| Option                | Description                                              | Exemple d’usage                                    |
|-----------------------|----------------------------------------------------------|---------------------------------------------------|
| @DatabaseName VARCHAR  | Cible une base spécifique                                | `EXEC dbo.ScriptEspaceDisque @DatabaseName='SalesDB';` |
| @IncludeIndexes BIT    | Inclut ou exclut les index dans le rapport              | `EXEC dbo.ScriptFragmentation @IncludeIndexes=1;`|
| @MaxDuration INT       | Filtre les requêtes longues (en secondes)               | `EXEC dbo.ScriptRequetesLentes @MaxDuration=30;` |
| @OutputToFile BIT      | Exporte le résultat dans un fichier CSV                  | Paramétrage via SQLCMD ou PowerShell (voir Tips) |

---

> [!TIP]  
> Pour des exports CSV automatisés, utilisez `sqlcmd` avec l’option `-o` :

```bash
sqlcmd -S serveur -d base -E -Q "EXEC dbo.ScriptEtatServeur" -o "etat_serveur.csv" -s"," -W
```

---

## Examples

### 1. Script Analyse de l’État du Serveur

```sql
CREATE PROCEDURE dbo.ScriptEtatServeur
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        sqlserver_start_time,
        cpu_count,
        physical_memory_kb / 1024 AS PhysicalMemoryMB,
        sqlserver_version = @@VERSION;
END
GO

-- Exécution
EXEC dbo.ScriptEtatServeur;
```

---

### 2. Script Analyse de la Fragmentation des Index

```sql
CREATE PROCEDURE dbo.ScriptFragmentation
    @IncludeIndexes BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dbschemas.name AS SchemaName,
        dbtables.name AS TableName,
        dbindexes.name AS IndexName,
        indexstats.avg_fragmentation_in_percent,
        indexstats.page_count
    FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS indexstats
    INNER JOIN sys.tables dbtables ON dbtables.object_id = indexstats.object_id
    INNER JOIN sys.schemas dbschemas ON dbtables.schema_id = dbschemas.schema_id
    INNER JOIN sys.indexes AS dbindexes ON dbindexes.object_id = indexstats.object_id
        AND indexstats.index_id = dbindexes.index_id
    WHERE (@IncludeIndexes = 1 OR dbindexes.index_id = 0)
      AND indexstats.page_count > 100
      AND indexstats.avg_fragmentation_in_percent > 10
    ORDER BY indexstats.avg_fragmentation_in_percent DESC;
END
GO

-- Exécution
EXEC dbo.ScriptFragmentation @IncludeIndexes = 1;
```

---

### 3. Script Surveillance Requêtes Longues

```sql
CREATE PROCEDURE dbo.ScriptRequetesLentes
    @MaxDuration INT = 60 -- secondes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 50
        r.session_id,
        r.status,
        r.start_time,
        r.total_elapsed_time/1000 AS DurationSeconds,
        SUBSTRING(t.text, (r.statement_start_offset/2)+1,
            ((CASE r.statement_end_offset 
                WHEN -1 THEN DATALENGTH(t.text)
                ELSE r.statement_end_offset END - r.statement_start_offset)/2)+1) AS QueryText
    FROM sys.dm_exec_requests r
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
    WHERE r.total_elapsed_time/1000 > @MaxDuration
    ORDER BY DurationSeconds DESC;
END
GO

-- Exécution
EXEC dbo.ScriptRequetesLentes @MaxDuration = 30;
```

---

## FAQ

### Q1: Peut-on utiliser ces scripts avec des versions antérieures à SQL Server 2012 ?  
> [!NOTE]  
> Certains scripts utilisent des vues dynamiques disponibles depuis SQL Server 2012. Ils peuvent ne pas fonctionner correctement sur des versions antérieures.

### Q2: Comment planifier l’exécution automatique ?  
> Utilisez SQL Server Agent pour créer des jobs avec ces scripts. Voir la section Installation pour un exemple.

### Q3: Puis-je exporter les résultats en CSV ou JSON ?  
> Oui, via `sqlcmd` ou PowerShell. Exemple PowerShell pour export CSV :

```powershell
Invoke-Sqlcmd -Query "EXEC dbo.ScriptEtatServeur" -Database "master" -ServerInstance "localhost" | Export-Csv -Path "etat_serveur.csv" -NoTypeInformation
```

### Q4: Que faire en cas d’erreur de permission ?  
> Assurez-vous que l’utilisateur SQL a les permissions `VIEW SERVER STATE` et `VIEW DATABASE STATE`, ou le rôle `sysadmin`.

---

> [!TIP]  
> Combinez ces scripts avec des outils de monitoring pour un diagnostic complet et proactif.

---

**🚀 Bonne administration SQL Server !**