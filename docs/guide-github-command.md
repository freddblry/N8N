# Guide Complet des Commandes GitHub 🚀

![GitHub](https://img.shields.io/badge/Platform-GitHub-181717?logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen)

---

## Table des matières 📖

- [Overview](#overview-)
- [Quick Start](#quick-start-)
- [Installation](#installation-)
- [Usage](#usage-)
- [Examples](#examples-)
- [FAQ](#faq-)

---

## Overview 📖

GitHub est une plateforme de gestion de versions et de collaboration basée sur Git. Ce guide présente les commandes essentielles pour interagir avec GitHub via Git en ligne de commande, facilitant ainsi la gestion de vos projets.

> [!TIP]
> Ce guide s'adresse aux utilisateurs souhaitant maîtriser les commandes GitHub courantes pour gérer efficacement leurs dépôts.

---

## Quick Start 🚀

1. Configurez Git avec vos informations utilisateur.
2. Clonez un dépôt GitHub.
3. Effectuez des modifications.
4. Poussez vos changements sur GitHub.

---

## Installation ⚙️

Pour utiliser GitHub en ligne de commande, vous devez installer Git.

### Installation Git

| Système       | Commande d'installation                                         |
|---------------|-----------------------------------------------------------------|
| Windows       | Télécharger depuis [git-scm.com](https://git-scm.com/download/win) |
| macOS         | ```bash brew install git```                                      |
| Linux (Debian)| ```bash sudo apt-get install git```                             |

### Vérification

```bash
git --version
```

---

## Usage 🔧

### Configuration initiale

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

### Commandes GitHub essentielles

| Commande                     | Description                                                  |
|-----------------------------|--------------------------------------------------------------|
| `git clone <url>`            | Clone un dépôt GitHub localement                              |
| `git status`                | Affiche l'état des fichiers dans le dépôt                    |
| `git add <fichier>`          | Ajoute un fichier à l'index pour le prochain commit          |
| `git commit -m "message"`   | Enregistre les modifications avec un message                 |
| `git push origin <branche>` | Envoie les commits vers GitHub                               |
| `git pull origin <branche>` | Récupère et fusionne les changements depuis GitHub           |
| `git branch`                | Liste les branches locales                                    |
| `git checkout <branche>`     | Change de branche                                            |
| `git merge <branche>`        | Fusionne une branche dans la branche courante                |

> [!IMPORTANT]
> Assurez-vous d’être sur la bonne branche avant de pousser vos modifications.

---

## Examples 💡

### Cloner un dépôt

```bash
git clone https://github.com/username/mon-projet.git
cd mon-projet
```

### Ajouter un fichier et faire un commit

```bash
git add README.md
git commit -m "Ajout du fichier README"
```

### Envoyer les modifications sur la branche principale

```bash
git push origin main
```

### Mettre à jour votre dépôt local avec les dernières modifications

```bash
git pull origin main
```

### Créer et basculer sur une nouvelle branche

```bash
git checkout -b nouvelle-fonctionnalite
```

---

## FAQ ⚠️

### Q: Comment annuler un commit local ?

```bash
git reset --soft HEAD~1
```

> [!WARNING]
> Cette commande annule le dernier commit mais conserve les modifications dans l’index.

### Q: Puis-je récupérer un fichier supprimé ?

```bash
git checkout HEAD -- chemin/du/fichier
```

### Q: Comment lister toutes les branches distantes ?

```bash
git branch -r
```

### Q: Comment fusionner une branche sans créer un commit de merge ?

```bash
git merge --no-ff <branche>
```

---

✅ Ce guide vous aidera à maîtriser les commandes essentielles pour travailler efficacement avec GitHub via la ligne de commande. Bon codage !