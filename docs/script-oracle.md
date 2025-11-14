# Oracle DBA Essential Scripts 📊⚙️

![Status](https://img.shields.io/badge/status-stable-brightgreen) ![Oracle](https://img.shields.io/badge/database-Oracle-red)

## Table des matières
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Ce document fournit une collection des scripts Oracle les plus utilisés par les DBA pour la gestion et le diagnostic des bases de données. Chaque script inclut les paramètres `SET` permettant un affichage optimal dans SQL*Plus ou SQLcl.

---

## Quick Start 🚀

1. Ouvrez SQL*Plus ou SQLcl.
2. Connectez-vous en tant que DBA.
3. Copiez-collez le script souhaité.
4. Exécutez-le pour obtenir des informations claires et formatées.

---

## Installation

> [!TIP]  
> Aucun module externe n'est nécessaire. Ces scripts sont exécutés directement dans SQL*Plus / SQLcl.

```bash
sqlplus / as sysdba
```

---

## Usage

> [!IMPORTANT]  
> Veillez à toujours utiliser les commandes `SET` en début de script pour garantir un affichage conforme, notamment :

```sql
SET LINESIZE 150
SET PAGESIZE 100
SET TRIMSPOOL ON
SET TRIMOUT ON
SET FEEDBACK ON
SET HEADING ON
```

---

## Examples

### 1. Vérification de la version Oracle et de l'instance

```sql
SET LINESIZE 150
SET PAGESIZE 50
SET FEEDBACK OFF
SET HEADING ON

SELECT banner FROM v$version WHERE banner LIKE 'Oracle%';
SELECT instance_name, status, version FROM v$instance;
```

---

### 2. Espace libre dans les tablespaces

```sql
SET LINESIZE 150
SET PAGESIZE 50
SET TRIMSPOOL ON
SET FEEDBACK ON

SELECT
    df.tablespace_name,
    df.file_name,
    df.bytes / 1024 / 1024 AS total_mb,
    fs.free_bytes / 1024 / 1024 AS free_mb,
    ROUND((fs.free_bytes / df.bytes) * 100, 2) AS pct_free
FROM
    (SELECT tablespace_name, file_name, bytes FROM dba_data_files) df
JOIN
    (SELECT file_id, SUM(bytes) free_bytes FROM dba_free_space GROUP BY file_id) fs
ON df.file_name = (SELECT file_name FROM dba_data_files WHERE file_id = fs.file_id)
ORDER BY pct_free;
```

---

### 3. Sessions actives et leur activité

```sql
SET LINESIZE 150
SET PAGESIZE 50
SET TRIMSPOOL ON

SELECT
    s.sid,
    s.serial#,
    s.username,
    s.status,
    s.osuser,
    s.machine,
    s.program,
    s.sql_id,
    q.sql_text
FROM v$session s
LEFT JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.status = 'ACTIVE'
ORDER BY s.username;
```

---

### 4. Surveillance des verrous (locks)

```sql
SET LINESIZE 150
SET PAGESIZE 50
SET FEEDBACK ON

SELECT
    l.session_id,
    s.sid,
    s.serial#,
    s.username,
    l.locked_mode,
    o.object_name,
    o.object_type
FROM v$locked_object l
JOIN dba_objects o ON l.object_id = o.object_id
JOIN v$session s ON l.session_id = s.sid
ORDER BY s.username;
```

---

### 5. Taille des segments par schéma

```sql
SET LINESIZE 150
SET PAGESIZE 50
SET TRIMSPOOL ON

SELECT
    owner,
    segment_type,
    segment_name,
    SUM(bytes) / 1024 / 1024 AS size_mb
FROM dba_segments
GROUP BY owner, segment_type, segment_name
ORDER BY size_mb DESC;
```

---

### 6. Liste des jobs DBMS_SCHEDULER actifs

```sql
SET LINESIZE 150
SET PAGESIZE 50
SET FEEDBACK ON

SELECT
    job_name,
    enabled,
    state,
    repeat_interval,
    last_start_date,
    next_run_date
FROM dba_scheduler_jobs
WHERE enabled = 'TRUE'
ORDER BY next_run_date;
```

---

## FAQ 💡

> [!QUESTION] **Comment améliorer la lisibilité des résultats dans SQL*Plus ?**  
> Utilisez toujours les commandes `SET` en début de votre session ou script pour ajuster la taille des lignes (`LINESIZE`), du nombre de lignes par page (`PAGESIZE`), et activez `TRIMSPOOL` et `TRIMOUT` pour éviter les espaces superflus.

> [!QUESTION] **Ces scripts peuvent-ils être utilisés sur toutes les versions d'Oracle ?**  
> Ces scripts sont compatibles avec Oracle 11g, 12c, 18c, 19c et versions ultérieures. Certaines vues ou colonnes peuvent varier selon la version.

> [!QUESTION] **Puis-je automatiser ces scripts ?**  
> Oui, vous pouvez les intégrer dans des jobs SQL*Plus batch ou via des scripts shell/PowerShell appelant SQL*Plus.

---

✅ Cette documentation est conçue pour vous aider à gérer efficacement votre base Oracle avec des scripts fiables et bien formatés.  
Bonne administration ! 🚀