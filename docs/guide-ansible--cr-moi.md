# Guide Ansible pour les Nuls 🚀

![Status](https://img.shields.io/badge/status-stable-brightgreen) ![License](https://img.shields.io/badge/license-MIT-blue) ![Ansible](https://img.shields.io/badge/ansible-automation-red)

## Table des matières 📖
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Ansible est un outil d'automatisation open source utilisé pour la gestion des configurations, le déploiement d'applications et l'orchestration IT.  
Il permet d'automatiser facilement des tâches répétitives sur plusieurs serveurs sans agent.

> [!TIP]  
> Ansible utilise SSH pour communiquer avec les machines distantes, ce qui évite l'installation d'agents supplémentaires.

---

## Quick Start 🚀

1. Installer Ansible (voir section Installation)
2. Créer un fichier d'inventaire (`hosts`)
3. Rédiger un playbook YAML
4. Exécuter le playbook avec la commande `ansible-playbook`

---

## Installation ⚙️

### Sur Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install ansible -y
ansible --version
```

### Sur macOS (avec Homebrew)

```bash
brew install ansible
ansible --version
```

### Sur Windows

> [!WARNING]  
> Windows ne supporte pas nativement Ansible. Utilisez WSL (Windows Subsystem for Linux) ou une VM Linux.

---

## Usage 🔧

### Inventaire (hosts)

Fichier listant les serveurs cibles :

```ini
[webservers]
web1.example.com
web2.example.com

[dbservers]
db1.example.com
```

### Commande ad-hoc (exemple : ping)

```bash
ansible all -m ping -i hosts
```

### Playbook simple

```yaml
---
- name: Installer Apache sur les webservers
  hosts: webservers
  become: yes
  tasks:
    - name: Installer Apache
      apt:
        name: apache2
        state: present
```

> [!IMPORTANT]  
> Les playbooks sont des fichiers YAML décrivant les étapes à exécuter sur les hôtes.

---

## Examples 📊

| Tâche                 | Commande/Playbook Exemple                                             | Description                             |
|-----------------------|----------------------------------------------------------------------|---------------------------------------|
| Vérifier la connexion | `ansible all -m ping -i hosts`                                       | Teste la connectivité SSH              |
| Copier un fichier     | `ansible all -m copy -a "src=/local/file dest=/remote/file" -i hosts`| Copie un fichier sur les hôtes         |
| Redémarrer un service | Playbook utilisant le module `service`                              | Redémarre un service sur les serveurs  |

### Exemple : Redémarrer Apache

```yaml
---
- name: Redémarrer Apache sur les webservers
  hosts: webservers
  become: yes
  tasks:
    - name: Redémarrer Apache
      service:
        name: apache2
        state: restarted
```

---

## FAQ 💡

**Q : Ansible nécessite-t-il un agent sur les serveurs ?**  
A : Non, Ansible utilise SSH pour se connecter sans agent.

**Q : Comment gérer les mots de passe SSH ?**  
A : Utilisez des clés SSH pour une authentification sans mot de passe.

**Q : Puis-je exécuter Ansible sur Windows ?**  
A : Oui via WSL ou en utilisant une machine virtuelle Linux.

**Q : Quelle est la différence entre un module et un playbook ?**  
A : Un module est une unité fonctionnelle (ex: `apt`, `copy`), un playbook est un script YAML orchestrant plusieurs tâches.

---

> [!TIP]  
> Pour aller plus loin, consultez la documentation officielle d’[Ansible](https://docs.ansible.com/ansible/latest/index.html).