# Guide Complet des Commandes GitHub pour les Nuls 🚀

![GitHub](https://img.shields.io/badge/GitHub-v2.0-blue) ![Status](https://img.shields.io/badge/Status-Stable-green) ![License](https://img.shields.io/badge/License-MIT-yellow)

## Table des matières 📖

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

GitHub est une plateforme de gestion de versions basée sur Git qui permet de collaborer efficacement sur des projets de développement. Ce guide complet est destiné aux débutants souhaitant maîtriser toutes les commandes GitHub essentielles pour gérer leurs projets, effectuer des sauvegardes, collaborer et déployer leur code. 

> [!TIP]  
> Ce guide couvre toutes les commandes Git les plus courantes et leurs explications simples pour vous aider à démarrer sans stress.

---

## Quick Start 🚀

Voici un aperçu rapide des commandes Git de base pour commencer à utiliser GitHub :

| Commande                      | Description                                  |
|------------------------------|----------------------------------------------|
| `git init`                   | Initialise un nouveau dépôt Git local        |
| `git clone <url>`            | Clone un dépôt distant sur votre machine     |
| `git status`                 | Affiche l’état actuel du dépôt                |
| `git add <fichier>`          | Ajoute un fichier à la zone de staging       |
| `git commit -m "message"`    | Enregistre les changements avec un message   |
| `git push`                   | Envoie les commits vers le dépôt distant     |
| `git pull`                   | Récupère et fusionne les modifications distantes |

---

## Installation ⚙️

### Installer Git

> [!IMPORTANT]  
> Git doit être installé pour utiliser GitHub en local.

- **Windows** : Téléchargez le programme d’installation sur [git-scm.com](https://git-scm.com/download/win).
- **macOS** : Utilisez Homebrew :  
  ```bash
  brew install git
  ```
- **Linux** : Utilisez le gestionnaire de paquets de votre distribution, par exemple :  
  ```bash
  sudo apt-get install git
  ```

### Configurer Git

Configurez votre nom d’utilisateur et votre adresse email :

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

---

## Usage 🔧

### Initialiser un dépôt

```bash
git init
```

### Cloner un dépôt existant

```bash
git clone https://github.com/utilisateur/projet.git
```

### Vérifier l’état des fichiers

```bash
git status
```

### Ajouter des fichiers à la zone de staging

```bash
git add fichier.txt
git add .           # ajoute tous les fichiers modifiés
```

### Faire un commit

```bash
git commit -m "Message décrivant les changements"
```

### Voir l’historique des commits

```bash
git log
```

### Envoyer les commits vers GitHub

```bash
git push origin main
```

### Récupérer les modifications depuis GitHub

```bash
git pull origin main
```

### Créer une nouvelle branche

```bash
git branch nouvelle-branche
git checkout nouvelle-branche
```

ou en une seule commande :

```bash
git checkout -b nouvelle-branche
```

### Fusionner une branche dans la branche courante

```bash
git merge nom-branche
```

### Supprimer une branche locale

```bash
git branch -d nom-branche
```

---

## Examples 💡

### Exemple 1 : Créer un nouveau projet GitHub depuis zéro

```bash
mkdir mon-projet
cd mon-projet
git init
echo "# Mon Projet" > README.md
git add README.md
git commit -m "Premier commit avec README"
git remote add origin https://github.com/utilisateur/mon-projet.git
git push -u origin main
```

### Exemple 2 : Cloner un projet et créer une branche de fonctionnalité

```bash
git clone https://github.com/utilisateur/projet-exemple.git
cd projet-exemple
git checkout -b fonctionnalite-xyz
# modifiez les fichiers
git add .
git commit -m "Ajout fonctionnalité xyz"
git push origin fonctionnalite-xyz
```

### Exemple 3 : Résoudre un conflit de fusion

```bash
git pull origin main
# Si conflit:
# Editez les fichiers conflictuels pour résoudre le conflit
git add fichiers-resolus
git commit -m "Résolution des conflits"
git push origin main
```

---

## FAQ 📊

### Q1: Quelle est la différence entre `git pull` et `git fetch` ?

- `git fetch` télécharge les changements distants sans les appliquer.
- `git pull` télécharge *et* fusionne les changements dans la branche courante.

### Q2: Comment annuler un commit local ?

```bash
git reset --soft HEAD~1  # annule le dernier commit en gardant les modifications en staging
git reset --hard HEAD~1  # annule le dernier commit et supprime les modifications
```

> [!WARNING]  
> Utilisez `--hard` avec précaution, car il supprime les modifications non sauvegardées.

### Q3: Comment voir les différences entre fichiers ?

```bash
git diff             # différences non stagées
git diff --staged    # différences entre staging et dernier commit
```

### Q4: Comment cloner un dépôt privé ?

Vous devez configurer un accès SSH ou utiliser un token d’accès personnel :

```bash
git clone git@github.com:utilisateur/projet-prive.git
```

ou

```bash
git clone https://<token>@github.com/utilisateur/projet-prive.git
```

### Q5: Comment annuler un fichier ajouté à la zone de staging ?

```bash
git reset fichier.txt
```

---

> [!TIP]  
> Pour plus de détails, consultez la documentation officielle Git : https://git-scm.com/doc

✅ Vous êtes maintenant équipé pour gérer efficacement vos projets avec GitHub ! Bonne collaboration !