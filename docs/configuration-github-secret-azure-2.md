# Configuration GitHub Secrets pour Azure 🚀

![Status](https://img.shields.io/badge/status-stable-brightgreen)

## Table des matières 📖
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Cette documentation explique comment configurer des **Secrets GitHub** pour sécuriser les informations sensibles nécessaires à l'interaction avec les services Azure. Cela permet d'automatiser les déploiements et les actions CI/CD sans exposer vos identifiants.

---

## Quick Start 🚀

1. Créez un principal de service Azure (Service Principal) avec les droits adéquats.
2. Récupérez les informations nécessaires (ID client, ID locataire, secret).
3. Ajoutez ces informations comme secrets dans votre dépôt GitHub.
4. Configurez vos workflows GitHub Actions pour utiliser ces secrets.

---

## Installation ⚙️

### Prérequis

- Compte Azure actif
- Azure CLI installé ([Guide d'installation Azure CLI](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli))
- Accès administrateur au dépôt GitHub

---

## Usage

### Étape 1 : Connexion à Azure CLI

```bash
az login
```

### Étape 2 : Créer un principal de service Azure

```bash
az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth
```

> [!IMPORTANT]
> Remplacez `{subscription-id}` par l'ID de votre abonnement Azure.

Cette commande retourne un JSON contenant toutes les informations nécessaires (ID client, ID locataire, secret, subscriptionId).

### Étape 3 : Copier le JSON retourné

Exemple de sortie JSON :

```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

### Étape 4 : Ajouter le secret dans GitHub

1. Sur GitHub, allez dans votre dépôt > **Settings** > **Secrets and variables** > **Actions** > **New repository secret**
2. Nommez le secret `AZURE_CREDENTIALS`
3. Collez le JSON complet retourné par la commande `az ad sp create-for-rbac`

> [!TIP]
> Utiliser un seul secret JSON simplifie la gestion dans GitHub Actions.

---

## Examples 💡

### Exemple de workflow GitHub Actions utilisant le secret Azure

```yaml
name: Deploy to Azure

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Azure CLI command example
      run: az account show
```

---

## FAQ ❓

| Question                                      | Réponse                                                                                              |
|-----------------------------------------------|-----------------------------------------------------------------------------------------------------|
| Comment récupérer mon subscription ID Azure ? | `az account show --query id --output tsv`                                                          |
| Puis-je restreindre l'accès du principal ?    | Oui, en modifiant le rôle (`--role`) et la portée (`--scopes`) lors de la création du principal.     |
| Que faire si le secret expire ?                | Recréez un principal ou générez un nouveau secret, puis mettez à jour le secret GitHub.             |

> [!WARNING]
> Ne jamais exposer vos secrets dans les fichiers de code ou logs publics.

---

🔧 Cette documentation vous permet de sécuriser efficacement vos interactions entre GitHub et Azure, en automatisant les déploiements et autres tâches cloud.