# Configuration des Secrets GitHub pour Azure 🚀

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

GitHub Secrets permet de stocker de manière sécurisée des informations sensibles comme des clés d'API, des tokens d'accès, ou des identifiants. Cette documentation explique comment configurer des secrets dans un dépôt GitHub pour déployer des applications sur Microsoft Azure.

> [!TIP]  
> Utiliser les secrets GitHub évite d'exposer vos clés Azure dans le code source.

---

## Quick Start

1. Créez un service principal Azure pour l'authentification.
2. Récupérez les identifiants nécessaires (`clientId`, `clientSecret`, `tenantId`, `subscriptionId`).
3. Ajoutez ces valeurs comme secrets dans votre dépôt GitHub.
4. Configurez votre workflow GitHub Actions pour utiliser ces secrets.

---

## Installation

### Étape 1 : Créer un service principal Azure

```bash
az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth
```

> [!IMPORTANT]  
> Remplacez `{subscription-id}` par l'ID de votre abonnement Azure.

Cette commande retourne un JSON avec les informations d'identification.

### Étape 2 : Ajouter les secrets dans GitHub

1. Dans votre dépôt GitHub, allez dans **Settings > Secrets and variables > Actions**.
2. Cliquez sur **New repository secret**.
3. Ajoutez les secrets suivants avec les valeurs respectives du JSON :

| Nom du secret           | Description                         |
|------------------------|-----------------------------------|
| `AZURE_CREDENTIALS`     | JSON complet retourné par Azure CLI|
| `AZURE_SUBSCRIPTION_ID` | ID de l'abonnement Azure          |
| `AZURE_TENANT_ID`       | ID du locataire Azure             |
| `AZURE_CLIENT_ID`       | ID du client du service principal |
| `AZURE_CLIENT_SECRET`   | Secret du service principal       |

---

## Usage

### Exemple de workflow GitHub Actions pour déployer sur Azure

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

    - name: Login to Azure
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Deploy Azure Web App
      uses: azure/webapps-deploy@v2
      with:
        app-name: 'mon-app-azure'
        slot-name: 'production'
        publish-profile: ${{ secrets.AZURE_PUBLISH_PROFILE }}
        package: '.'
```

> [!TIP]  
> Le secret `AZURE_PUBLISH_PROFILE` peut être généré depuis le portail Azure sous l'onglet "Déploiement Center".

---

## Examples

Voici un tableau comparatif des méthodes d'authentification possibles pour Azure dans GitHub Actions :

| Méthode                  | Avantages                            | Inconvénients                    |
|--------------------------|------------------------------------|---------------------------------|
| Service Principal (JSON) | Sécurisé, facile à renouveler       | Nécessite gestion du JSON       |
| Publish Profile          | Simple pour déploiement Web Apps    | Moins flexible pour d'autres services |
| Managed Identities       | Automatique sur Azure VM/Service    | Limité aux ressources Azure     |

---

## FAQ ❓

**Q : Comment renouveler un secret expiré ?**  
A : Il faut recréer un service principal ou générer un nouveau publish profile, puis mettre à jour le secret dans GitHub.

**Q : Puis-je utiliser les secrets dans plusieurs workflows ?**  
A : Oui, les secrets sont accessibles dans tous les workflows du dépôt.

**Q : Les secrets sont-ils visibles par tous les collaborateurs ?**  
A : Non, seuls les utilisateurs avec accès admin au dépôt peuvent gérer les secrets.

---

💡 Pour toute question supplémentaire, consultez la documentation officielle GitHub Actions et Microsoft Azure.  
🚀 Bonne configuration !