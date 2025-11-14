# SQL Server Scripts for DBA Experts 🚀⚙️

![SQL Server](https://img.shields.io/badge/SQL%20Server-Expert-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Last%20Update](https://img.shields.io/badge/last%20update-2024--06--01-brightgreen)

---

## Table des matières 📖

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Ce dépôt contient une collection de scripts SQL Server professionnels destinés aux administrateurs de bases de données (DBA) experts. Ces scripts couvrent la gestion, la maintenance, la surveillance et l’optimisation des bases SQL Server. Ils sont conçus pour être robustes, paramétrables et faciles à intégrer dans des procédures d’automatisation.

> [!TIP]  
> Ces scripts sont adaptés pour les environnements de production et incluent des commentaires détaillés pour faciliter leur compréhension et adaptation.

---

## Quick Start 🚀

1. Clonez ce dépôt sur votre machine :
   ```bash
   git clone https://github.com/votre-utilisateur/sqlserver-dba-scripts.git
   cd sqlserver-dba-scripts
   ```
2. Exécutez un script SQL dans SQL Server Management Studio (SSMS) ou via `sqlcmd`.
3. Paramétrez les variables selon votre environnement (voir section Usage).

---

## Installation ⚙️

Ces scripts ne requièrent pas d’installation spécifique, mais il est recommandé de respecter les prérequis suivants :

| Prérequis                      | Version recommandée          | Commentaire                                      |
|-------------------------------|-----------------------------|-------------------------------------------------|
| SQL Server                    | 2012 et supérieur            | Support complet des fonctions T-SQL modernes    |
| Outils client                 | SQL Server Management Studio | Pour exécution et débogage                       |
| Permissions                  | Rôle `sysadmin` ou `db_owner`| Nécessaire pour les opérations avancées         |

> [!IMPORTANT]  
> Toujours tester les scripts dans un environnement de pré-production avant exécution en production.

---

## Usage 💡

- Ouvrez le script dans SSMS ou un autre client SQL.
- Modifiez les paramètres en début de script (variables `@Param`).
- Exécutez le script.
- Analysez les résultats et logs générés.

### Exemple de paramètres classiques

```sql
DECLARE @DatabaseName SYSNAME = 'MaBase';
DECLARE @BackupPath NVARCHAR(255) = 'D:\Backups\MaBase\';
DECLARE @RetentionDays INT = 30;
```

### Conseils d’utilisation

- Centralisez vos scripts dans un répertoire sécurisé.
- Automatisez via SQL Agent ou PowerShell.
- Planifiez des sauvegardes régulières et vérifiez les logs.

---

## Examples 🔧

### 1. Vérification de l’espace disque et taille des bases

```sql
EXEC sp_MSforeachdb 
'USE ?; 
SELECT 
    DB_NAME() AS DatabaseName, 
    SUM(size) * 8 / 1024 AS SizeMB 
FROM sys.master_files 
GROUP BY DB_NAME()';
```

---

### 2. Script de sauvegarde complète avec rotation

```sql
DECLARE @DatabaseName SYSNAME = 'MaBase';
DECLARE @BackupPath NVARCHAR(255) = 'D:\Backups\MaBase\';
DECLARE @BackupFile NVARCHAR(500);
DECLARE @Date NVARCHAR(20) = FORMAT(GETDATE(), 'yyyyMMdd_HHmmss');

SET @BackupFile = @BackupPath + @DatabaseName + '_' + @Date + '.bak';

BACKUP DATABASE @DatabaseName TO DISK = @BackupFile WITH INIT, COMPRESSION;

-- Suppression des backups plus anciens que 30 jours
EXEC xp_delete_file 0, @BackupPath, 'bak', DATEADD(DAY, -30, GETDATE()), 1;
```

---

### 3. Surveillance des sessions bloquées

```sql
SELECT 
    blocking_session_id AS BlockingSession,
    session_id AS BlockedSession,
    wait_type,
    wait_time,
    wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
```

---

## FAQ ❓

| Question                              | Réponse                                                                                   |
|-------------------------------------|-------------------------------------------------------------------------------------------|
| Puis-je utiliser ces scripts sur toutes versions SQL Server ? | Recommandé à partir de SQL Server 2012, adaptez selon fonctionnalités disponibles.         |
| Ces scripts modifient-ils les données ? | Par défaut, non. Certains scripts de maintenance peuvent modifier la base (ex : sauvegarde).|
| Comment personnaliser un script ?   | Modifiez les variables en début de script et adaptez les chemins et noms de bases.         |
| Puis-je automatiser ces scripts ?   | Oui, via SQL Server Agent, PowerShell ou tout outil d’orchestration compatible.            |

> [!NOTE]  
> Pour toute question spécifique, ouvrez une issue sur le dépôt GitHub.

---

Merci d’utiliser ces scripts pour optimiser la gestion de vos bases SQL Server ! ✅