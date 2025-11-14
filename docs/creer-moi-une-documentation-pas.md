# Guide pas à pas pour configurer GitHub Actions 🚀

![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-Enabled-brightgreen)

## Table des matières
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

## Overview

GitHub Actions est une solution d'automatisation CI/CD intégrée à GitHub qui permet de créer des workflows personnalisés pour tester, construire et déployer vos projets automatiquement.

> [!TIP]  
> Automatiser vos processus améliore la qualité et accélère les déploiements.

## Quick Start

1. Créez un fichier workflow dans `.github/workflows/`.
2. Définissez les événements déclencheurs (ex: `push`, `pull_request`).
3. Ajoutez des jobs composés d’étapes pour construire, tester ou déployer.

> [!IMPORTANT]  
> Le fichier workflow doit être au format YAML et respecter la syntaxe GitHub Actions.

## Installation

GitHub Actions ne nécessite pas d'installation externe, mais voici les prérequis :

- Un dépôt GitHub (public ou privé)
- Droits suffisants pour créer des workflows (collaborateur ou propriétaire)
- Un fichier YAML dans `.github/workflows/`

### Exemple : Création du dossier et fichier

```bash
mkdir -p .github/workflows
touch .github/workflows/ci.yml
```

## Usage

1. Éditez le fichier YAML pour définir votre workflow.
2. Commitez et poussez sur votre dépôt GitHub.
3. GitHub détectera automatiquement le workflow et l'exécutera selon les déclencheurs.

### Structure de base d’un workflow

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Installer Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      - name: Installer les dépendances
        run: pip install -r requirements.txt
      - name: Lancer les tests
        run: pytest
```

> [!TIP]  
> Utilisez `runs-on` pour choisir l’environnement (Ubuntu, Windows, macOS).

## Examples

| Objectif           | Exemple de déclencheur          | Actions clés                      |
|--------------------|--------------------------------|---------------------------------|
| Intégration continue | `push` sur `main`              | Checkout, Installer dépendances, Tests unitaires |
| Déploiement        | `release` ou `push` sur `main` | Build, déploiement sur serveur  |
| Linting            | `pull_request`                  | Analyse de code statique         |

### Exemple : Workflow de déploiement simple

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Déployer sur serveur
        run: ssh user@server 'bash deploy.sh'
```

## FAQ

### Q: Peut-on exécuter plusieurs jobs en parallèle ?  
✅ Oui, définissez plusieurs jobs au même niveau dans le fichier YAML.

### Q: Comment sécuriser les secrets ?  
> [!IMPORTANT]  
> Utilisez les GitHub Secrets dans les paramètres du dépôt et référez-vous via `${{ secrets.MY_SECRET }}`.

### Q: Peut-on utiliser des actions personnalisées ?  
✅ Oui, vous pouvez utiliser des actions publiques ou créer vos propres actions dans un dépôt.

### Q: Comment voir les logs d’exécution ?  
Accédez à l’onglet **Actions** de votre dépôt GitHub, sélectionnez le workflow et le job pour consulter les logs détaillés.

---

💡 Pour plus d’informations, consultez la documentation officielle : [GitHub Actions Docs](https://docs.github.com/actions) 📖