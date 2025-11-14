# Configuration des Secrets GitHub pour Azure 🚀

![Status](https://img.shields.io/badge/status-stable-brightgreen)

## Table des matières
- [Overview](#overview-📖)
- [Quick Start](#quick-start-⚡)
- [Installation](#installation-⚙️)
- [Usage](#usage-💡)
- [Examples](#examples-🔧)
- [FAQ](#faq-❓)

---

## Overview 📖

Cette documentation détaille la procédure pas à pas pour configurer des secrets GitHub destinés à une intégration sécurisée avec Azure. Les secrets GitHub permettent de stocker en toute sécurité des informations sensibles telles que les identifiants Azure, utilisées dans les workflows GitHub Actions.

---

## Quick Start ⚡

1. Créez un **Service Principal** Azure
2. Récupérez les informations d'identification (ID application, secret, tenant)
3. Ajoutez ces valeurs en tant que secrets dans votre dépôt GitHub
4. Utilisez ces secrets dans vos workflows GitHub Actions pour déployer sur Azure

---

## Installation ⚙️

### 1. Création du Service Principal Azure

Utilisez Azure CLI pour créer un Service Principal avec le rôle nécessaire :

```bash
az ad sp create-for-rbac --name "<nom-du-sp>" --role contributor --scopes /subscriptions/<subscription-id> --sdk-auth
```

> [!TIP]  
> Remplacez `<nom-du-sp>` et `<subscription-id>` par vos valeurs Azure.

Cette commande retournera un JSON contenant toutes les informations d'authentification nécessaires.

### 2. Ajout des secrets dans GitHub

- Rendez-vous dans votre dépôt GitHub
- Cliquez sur **Settings > Secrets and variables > Actions > New repository secret**
- Ajoutez un secret nommé `AZURE_CREDENTIALS` avec la valeur JSON obtenue à l'étape précédente

| Secret Name     | Description                                   |
|-----------------|-----------------------------------------------|
| `AZURE_CREDENTIALS` | JSON d'authentification du Service Principal |

> [!IMPORTANT]  
> Ne partagez jamais vos secrets publiquement.

---

## Usage 💡

Intégrez le secret dans un workflow GitHub Actions pour authentifier une action Azure :

```yaml
name: Azure Deployment

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Login to Azure
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure Web App
        uses: azure/webapps-deploy@v2
        with:
          app-name: <nom-de-votre-app>
          slot-name: production
          publish-profile: ${{ secrets.AZURE_PUBLISH_PROFILE }}
```

---

## Examples 🔧

### Exemple complet de création et ajout de secret

```bash
# Création du Service Principal
az ad sp create-for-rbac --name "my-github-sp" --role contributor --scopes /subscriptions/12345678-1234-1234-1234-123456789abc --sdk-auth > azure-credentials.json

# Affiche le contenu (à copier)
cat azure-credentials.json
```

Copiez le contenu affiché, puis créez le secret dans GitHub sous le nom `AZURE_CREDENTIALS`.

---

## FAQ ❓

| Question                                        | Réponse                                                          |
|------------------------------------------------|-----------------------------------------------------------------|
| Que faire si mes secrets sont compromis ?       | Révoquez le Service Principal dans Azure et recréez-en un nouveau. Changez aussi les secrets GitHub immédiatement. |
| Puis-je utiliser plusieurs secrets Azure ?      | Oui, vous pouvez ajouter plusieurs secrets et les référencer dans différents workflows. |
| Comment vérifier que l'authentification fonctionne ? | Ajoutez une étape de test dans votre workflow pour lister les ressources Azure accessibles. |

> [!WARNING]  
> La gestion sécurisée des secrets est critique pour éviter des fuites de données sensibles.

---

✅ Vous êtes maintenant prêt à sécuriser vos workflows GitHub avec Azure !