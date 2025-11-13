# Guide Ansible pour les Nuls 🚀

![Status](https://img.shields.io/badge/status-stable-brightgreen) ![License](https://img.shields.io/badge/license-MIT-blue) ![Ansible](https://img.shields.io/badge/tool-Ansible-red)

## Table des matières 📖
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Ansible est un outil open source d'automatisation IT simple et puissant. Il permet la gestion de configurations, le déploiement d'applications et l'automatisation de tâches complexes sur plusieurs serveurs, sans agents.

### Pourquoi utiliser Ansible ? 💡
- Configuration déclarative facile à lire
- Pas besoin d’installer des agents sur les serveurs
- Extensible avec des modules intégrés et personnalisés
- Communauté active et nombreux rôles disponibles

---

## Quick Start 🚀

Pour commencer rapidement avec Ansible :

1. Installer Ansible sur votre machine locale.
2. Créer un fichier d’inventaire listant vos serveurs.
3. Définir un playbook YAML décrivant les tâches à exécuter.
4. Lancer Ansible avec la commande `ansible-playbook`.

---

## Installation ⚙️

### Sous Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install ansible -y
```

### Sous macOS avec Homebrew

```bash
brew install ansible
```

### Vérification

```bash
ansible --version
```

> [!TIP]
> Utilisez un environnement virtuel Python pour isoler votre installation si nécessaire.

---

## Usage 🔧

### Concepts clés

| Terme         | Description                                 |
|---------------|---------------------------------------------|
| Inventory     | Liste des hôtes et groupes de serveurs      |
| Playbook     | Fichier YAML avec la définition des tâches  |
| Module       | Unité d’action, ex : copier un fichier      |
| Role         | Collection de tâches réutilisables           |

### Exemple d’inventaire simple

```ini
[webservers]
192.168.1.10
192.168.1.11

[dbservers]
192.168.1.20
```

### Exemple de commande ad-hoc

```bash
ansible webservers -m ping
```

---

## Examples 📊

### Exemple de Playbook basique

```yaml
---
- name: Installer Apache sur les serveurs web
  hosts: webservers
  become: yes

  tasks:
    - name: Installer Apache
      apt:
        name: apache2
        state: present
      when: ansible_os_family == "Debian"

    - name: Démarrer Apache
      service:
        name: apache2
        state: started
        enabled: yes
```

### Exemple d’exécution

```bash
ansible-playbook -i inventory.ini playbook.yml
```

---

## FAQ ⚠️

> [!IMPORTANT]
> **Q : Ansible nécessite-t-il un agent sur les serveurs ?**  
> R : Non, Ansible utilise SSH pour communiquer avec les machines cibles.

> [!NOTE]
> **Q : Puis-je utiliser Ansible pour Windows ?**  
> R : Oui, Ansible supporte la gestion de machines Windows via WinRM.

> [!TIP]
> **Q : Comment gérer les mots de passe SSH ?**  
> R : Utilisez des clés SSH sans mot de passe ou intégrez `ssh-agent` pour une meilleure sécurité.

---

✅ Avec ce guide, vous êtes prêt à automatiser vos infrastructures rapidement et efficacement avec Ansible!