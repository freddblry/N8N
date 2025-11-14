# Configuration des Secrets GitHub 🔐

![Status](https://img.shields.io/badge/Status-Actif-brightgreen)

## Table des matières
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

## Overview 📖

Les **Secrets GitHub** permettent de stocker de manière sécurisée des informations sensibles (tokens, clés API, mots de passe) nécessaires dans vos workflows GitHub Actions. Ces secrets sont chiffrés et ne sont pas exposés dans les logs.

## Quick Start 🚀

1. Accédez à votre dépôt GitHub.
2. Ouvrez l’onglet **Settings**.
3. Cliquez sur **Secrets and variables** > **Actions**.
4. Cliquez sur **New repository secret**.
5. Saisissez un nom et la valeur du secret.
6. Enregistrez.

## Installation ⚙️

> [!NOTE]  
> Aucun logiciel à installer, la configuration se fait directement via l’interface GitHub.

### Étapes détaillées

| Étape | Action                                      | Description                                        |
|-------|---------------------------------------------|--------------------------------------------------|
| 1     | Accéder au dépôt                            | Connectez-vous et ouvrez votre dépôt GitHub.     |
| 2     | Ouvrir les paramètres                       | Cliquez sur **Settings** dans la barre supérieure. |
| 3     | Naviguer aux secrets                        | Sélectionnez **Secrets and variables** puis **Actions**. |
| 4     | Ajouter un secret                           | Cliquez sur **New repository secret**.           |
| 5     | Nommer et définir la valeur                 | Entrez un nom en MAJUSCULES (ex: `API_KEY`) et la valeur. |
| 6     | Sauvegarder                                | Cliquez sur **Add secret** pour valider.         |

## Usage 🔧

Pour utiliser un secret dans un workflow GitHub Actions, référencez-le avec la syntaxe:

```yaml
${{ secrets.NOM_DU_SECRET }}
```

Exemple dans un fichier `.github/workflows/ci.yml` :

```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Afficher la clé API (sécurisé)
        run: echo "Clé API utilisée"
```

> [!IMPORTANT]  
> Ne jamais afficher directement les secrets dans les logs (`echo ${{ secrets.API_KEY }}`) pour éviter toute fuite.

## Examples 💡

### Exemple 1: Utilisation d’un token GitHub

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Déployer avec token
        env:
          GITHUB_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
        run: ./deploy.sh
```

### Exemple 2: Clé API pour un service externe

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Tester avec API externe
        env:
          SERVICE_API_KEY: ${{ secrets.SERVICE_API_KEY }}
        run: python test_api.py
```

## FAQ 📊

| Question                         | Réponse                                                  |
|---------------------------------|----------------------------------------------------------|
| Puis-je modifier un secret ?     | Non, il faut supprimer puis recréer le secret.           |
| Combien de secrets puis-je avoir ? | Jusqu’à 100 secrets par dépôt.                           |
| Les secrets sont-ils accessibles dans les forks ? | Non, les secrets ne sont pas passés aux workflows des forks. |
| Puis-je utiliser les secrets dans les workflows de l’organisation ? | Oui, en configurant les secrets au niveau organisation. |

> [!WARNING]  
> Faites attention aux permissions de vos workflows, un accès non contrôlé pourrait compromettre vos secrets.

---

🔗 Pour plus d’informations, consultez la documentation officielle GitHub:  
https://docs.github.com/en/actions/security-guides/encrypted-secrets