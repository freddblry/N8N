# Guide de Migration SQL Server vers Azure SQL 🚀

![Status](https://img.shields.io/badge/status-complet-green) ![Azure](https://img.shields.io/badge/platform-Azure-blue)

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

La migration de SQL Server vers Azure SQL permet de bénéficier des avantages du cloud tels que la scalabilité, la haute disponibilité, et la gestion simplifiée. Ce guide couvre les étapes clés, outils recommandés et meilleures pratiques pour effectuer une migration réussie.

> [!TIP]  
> Azure SQL inclut plusieurs options : Azure SQL Database, Azure SQL Managed Instance, et SQL Server sur des Machines Virtuelles Azure. Choisissez selon vos besoins en compatibilité et gestion.

---

## Quick Start 🚀

1. **Analyser** la base existante avec [Data Migration Assistant (DMA)](https://docs.microsoft.com/en-us/sql/dma/dma-overview).
2. **Préparer** l’environnement Azure SQL adapté.
3. **Migrer** les données avec [Azure Database Migration Service (DMS)](https://docs.microsoft.com/en-us/azure/dms/dms-overview).
4. **Valider** la migration et effectuer les tests nécessaires.
5. **Basculer** la production vers Azure SQL.

---

## Installation ⚙️

### Outils requis

| Outil                         | Description                          | Lien officiel                                  |
|------------------------------|------------------------------------|------------------------------------------------|
| Data Migration Assistant (DMA) | Analyse compatibilité et rapport  | https://aka.ms/dma                              |
| Azure Database Migration Service (DMS) | Service de migration           | https://aka.ms/azuredms                         |
| Azure CLI                    | Gestion et déploiement Azure       | https://aka.ms/azurecli                         |
| SQL Server Management Studio (SSMS) | Gestion serveur SQL              | https://aka.ms/ssms                             |

### Étapes d'installation

```bash
# Installer Azure CLI (Linux/macOS)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Installer Azure CLI (Windows)
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
```

> [!IMPORTANT]  
> Assurez-vous que SQL Server Management Studio est à jour pour bénéficier des dernières fonctionnalités Azure SQL.

---

## Usage 🔧

### Analyse avec Data Migration Assistant

```bash
# Lancer DMA GUI ou en ligne de commande pour analyser la base
dma.exe /project:"MigrationProject.dmaproj" /report
```

- Identifiez les incompatibilités et fonctionnalités non supportées.
- Obtenez des recommandations de modifications.

### Préparation de la base Azure SQL

```bash
# Connexion Azure CLI
az login

# Création d’un serveur SQL Azure
az sql server create --name myazuresqlserver --resource-group myResourceGroup --location eastus --admin-user adminuser --admin-password 'YourPassword123!'

# Création de la base de données
az sql db create --resource-group myResourceGroup --server myazuresqlserver --name myazuresqldb --service-objective S0
```

### Migration avec Azure Database Migration Service

- Créez un projet migration dans le portail Azure.
- Configurez la source (SQL Server) et la cible (Azure SQL).
- Exécutez la migration (offline ou online).

> [!WARNING]  
> Pour les bases très volumineuses, privilégiez la migration en mode online pour minimiser le downtime.

---

## Examples 📊

### Exemple de script PowerShell pour migration simple

```powershell
# Variables
$resourceGroup = "myResourceGroup"
$serverName = "myazuresqlserver"
$databaseName = "myazuresqldb"

# Créer un groupe de ressources
az group create --name $resourceGroup --location eastus

# Créer un serveur SQL Azure
az sql server create --name $serverName --resource-group $resourceGroup --location eastus --admin-user adminuser --admin-password 'YourPassword123!'

# Créer une base de données
az sql db create --resource-group $resourceGroup --server $serverName --name $databaseName --service-objective S1
```

### Validation post-migration

```sql
-- Vérifier le nombre de lignes dans une table critique
SELECT COUNT(*) FROM dbo.Clients;
```

---

## FAQ 💡

| Question                                 | Réponse                                                                                 |
|------------------------------------------|----------------------------------------------------------------------------------------|
| Quelle est la différence entre Azure SQL Database et Managed Instance ? | Azure SQL Database est PaaS avec gestion simplifiée, Managed Instance offre plus de compatibilité avec SQL Server. |
| Comment gérer la sécurité après migration ? | Utilisez Azure Active Directory, chiffrement Transparent Data Encryption (TDE) et firewall Azure. |
| Puis-je migrer des bases avec des fonctionnalités non supportées ? | Certaines fonctionnalités spécifiques ne sont pas supportées, analysez-les avec DMA et adaptez le schéma. |
| Quel est le downtime attendu ?            | Cela dépend de la taille et du mode de migration (offline vs online). Online minimise le downtime. |

---

> [!TIP]  
> Documentez et testez chaque étape dans un environnement non productif avant la migration finale.  

✅ Migration efficace et sécurisée avec Azure SQL !