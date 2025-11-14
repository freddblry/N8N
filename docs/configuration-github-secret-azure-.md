# Configuration des Secrets GitHub pour Azure 🚀

![Status](https://img.shields.io/badge/status-complet-green)

## Table des matières 📖
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Cette documentation explique comment configurer des **Secrets GitHub** pour intégrer une application Azure dans vos workflows GitHub Actions. Les secrets permettent de stocker des informations sensibles (comme des identifiants, clés, tokens) de façon sécurisée, et ainsi automatiser les déploiements ou interactions avec Azure sans exposer ces données.

---

## Quick Start 🚀

1. Créez un **Service Principal Azure** pour votre application.
2. Récupérez les identifiants nécessaires (clientId, clientSecret, tenantId).
3. Ajoutez ces informations en tant que **GitHub Secrets** dans votre dépôt.
4. Utilisez-les dans vos GitHub Actions pour déployer ou interagir avec Azure.

---

## Installation ⚙️

### 1. Créer un Service Principal Azure

Ouvrez Azure CLI et exécutez :

```bash
az ad sp create-for-rbac --name "<NomDuServicePrincipal>" --role contributor --scopes /subscriptions/<VotreSubscriptionID>
```

Cette commande retourne un JSON contenant :

| Clé           | Description                       |
| ------------- | --------------------------------- |
| appId         | Identifiant client (clientId)    |
| password      | Secret client (clientSecret)     |
| tenant        | Identifiant du tenant (tenantId) |

> [!TIP] Gardez bien ces valeurs, elles seront utilisées dans GitHub.

---

## Usage 💡

### 2. Ajouter les Secrets dans GitHub

Dans votre dépôt GitHub :

1. Allez dans **Settings** > **Secrets and variables** > **Actions**.
2. Cliquez sur **New repository secret**.
3. Ajoutez les secrets suivants :

| Nom du Secret          | Valeur attendue                      | Exemple                       |
|-----------------------|------------------------------------|------------------------------|
| AZURE_CLIENT_ID       | `appId` du Service Principal       | `12345678-1234-1234-1234-123456789abc` |
| AZURE_CLIENT_SECRET   | `password` du Service Principal    | `abcdef12-3456-7890-abcd-ef1234567890`  |
| AZURE_TENANT_ID       | `tenant` du Service Principal      | `87654321-4321-4321-4321-cba987654321`  |
| AZURE_SUBSCRIPTION_ID | ID de votre abonnement Azure       | `00000000-0000-0000-0000-000000000000`  |

> [!IMPORTANT] Ne jamais exposer ces secrets dans le code ou logs.

---

## Examples 📊

### Exemple de workflow GitHub Actions pour déploiement Azure WebApp

```yaml
name: Deploy to Azure WebApp

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Login Azure CLI
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure WebApp
        uses: azure/webapps-deploy@v2
        with:
          app-name: "nom-de-votre-app"
          publish-profile: ${{ secrets.AZURE_PUBLISH_PROFILE }}
          package: .
```

> [!NOTE] Pour utiliser `azure/login@v1`, vous devez créer un secret unique `AZURE_CREDENTIALS` contenant un JSON avec les clés suivantes :

```json
{
  "clientId": "votre-client-id",
  "clientSecret": "votre-client-secret",
  "subscriptionId": "votre-subscription-id",
  "tenantId": "votre-tenant-id"
}
```

### Génération du secret JSON pour `AZURE_CREDENTIALS`

Exemple de commande bash pour créer le JSON :

```bash
echo '{
  "clientId": "'$AZURE_CLIENT_ID'",
  "clientSecret": "'$AZURE_CLIENT_SECRET'",
  "subscriptionId": "'$AZURE_SUBSCRIPTION_ID'",
  "tenantId": "'$AZURE_TENANT_ID'"
}' > azure-credentials.json
```

Copiez ensuite le contenu dans GitHub **Secrets** > **New repository secret** avec le nom `AZURE_CREDENTIALS`.

---

## FAQ ⚠️

| Question                                        | Réponse                                                                                  |
|------------------------------------------------|------------------------------------------------------------------------------------------|
| Comment récupérer mon Subscription ID Azure ?  | Dans le portail Azure : Abonnements > Sélectionnez votre abonnement > Copiez l'ID.       |
| Que faire si mon secret est compromis ?         | Révoquez les identifiants dans Azure et créez-en de nouveaux.                           |
| Puis-je utiliser plusieurs environnements ?    | Oui, créez des secrets par environnement (ex: DEV_AZURE_CLIENT_ID, PROD_AZURE_CLIENT_ID).|
| Comment tester si mes secrets fonctionnent ?   | Ajoutez un step GitHub Actions qui affiche une variable d'environnement non sensible.   |

> [!WARNING] Ne partagez jamais vos secrets en clair dans les issues, PR ou discussions publiques.

---

✅ Avec cette configuration, vous pourrez automatiser vos déploiements Azure en toute sécurité via GitHub Actions.