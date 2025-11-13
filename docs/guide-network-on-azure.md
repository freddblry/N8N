# Guide Complet sur le Network Azure 🚀⚙️

![Azure Networking](https://img.shields.io/badge/Azure-Networking-blue) ![Status](https://img.shields.io/badge/Status-Complete-green)

## Table des matières 📖
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [FAQ](#faq)

---

## Overview

Azure Networking permet de connecter, sécuriser et gérer les ressources cloud à travers un ensemble complet de services réseau. Il offre des fonctionnalités telles que la gestion des réseaux virtuels, la sécurité, la connectivité hybride et la surveillance.

### Principaux services Azure Networking
| Service                | Description                                         | Usage principal            |
|------------------------|-----------------------------------------------------|----------------------------|
| Azure Virtual Network   | Réseau privé isolé dans Azure                       | Segmentation et isolation  |
| Azure VPN Gateway       | VPN pour connexions sécurisées                      | Connexion hybride          |
| Azure ExpressRoute      | Connexion privée dédiée                             | Haute bande passante       |
| Azure Load Balancer     | Répartition de charge                              | Haute disponibilité        |
| Azure Application Gateway | Proxy applicatif avec WAF                          | Sécurité applicative       |
| Azure Network Security Groups (NSG) | Filtrage du trafic réseau                 | Sécurité réseau            |

> [!TIP] Maîtriser ces services est essentiel pour architecturer des environnements cloud sécurisés et performants.

---

## Quick Start 🚀

1. **Créer un Virtual Network (VNet)**  
2. **Déployer des sous-réseaux (subnets)**  
3. **Configurer les groupes de sécurité réseau (NSG)**  
4. **Mettre en place une passerelle VPN ou ExpressRoute si besoin**  

---

## Installation ⚙️

Azure Networking est un service natif, aucune installation locale n'est nécessaire. Cependant, vous devez configurer les ressources via :

- **Azure Portal**  
- **Azure CLI**  
- **Azure PowerShell**  
- **Templates ARM / Bicep**

### Exemple d'installation via Azure CLI

```bash
# Créer un groupe de ressources
az group create --name MonGroupeRessources --location francecentral

# Créer un réseau virtuel avec un sous-réseau
az network vnet create \
  --resource-group MonGroupeRessources \
  --name MonVNet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name MonSubnet \
  --subnet-prefix 10.0.1.0/24
```

> [!IMPORTANT] Remplacez les noms et plages d’adresses IP selon vos besoins d’architecture.

---

## Usage 💡

### Gestion des réseaux virtuels

- Segmentation des ressources via sous-réseaux  
- Application des règles via NSG (Network Security Groups)  
- Connexion entre VNets avec Peering  

### Sécurité et contrôle de trafic

| Fonctionnalité                | Description                                  | Commande CLI exemple                       |
|------------------------------|----------------------------------------------|--------------------------------------------|
| NSG                          | Autoriser ou bloquer le trafic réseau         | `az network nsg create` et `az network nsg rule create` |
| Firewall Azure               | Protection avancée avec inspection de paquets | Configuration via Azure Portal              |
| Application Gateway WAF      | Protection contre attaques applicatives       | Configuration dans Application Gateway     |

---

## Examples 📊

### Exemple: Ajouter une règle NSG pour autoriser le port 80

```bash
az network nsg rule create \
  --resource-group MonGroupeRessources \
  --nsg-name MonNSG \
  --name AutoriserHTTP \
  --protocol Tcp \
  --priority 100 \
  --destination-port-ranges 80 \
  --access Allow \
  --direction Inbound
```

### Exemple: Configurer un peering entre deux VNets

```bash
# Peering VNet1 vers VNet2
az network vnet peering create \
  --name PeeringVNet1VersVNet2 \
  --resource-group MonGroupeRessources \
  --vnet-name VNet1 \
  --remote-vnet VNet2 \
  --allow-vnet-access

# Peering VNet2 vers VNet1
az network vnet peering create \
  --name PeeringVNet2VersVNet1 \
  --resource-group MonGroupeRessources \
  --vnet-name VNet2 \
  --remote-vnet VNet1 \
  --allow-vnet-access
```

> [!NOTE] Le peering est bidirectionnel : créez les deux liens pour la communication entre VNets.

---

## FAQ ⚠️

### Q1: Quelle est la différence entre VPN Gateway et ExpressRoute ?
- **VPN Gateway** utilise Internet pour des connexions sécurisées via VPN.  
- **ExpressRoute** offre une connexion privée dédiée, plus rapide et fiable.

### Q2: Puis-je utiliser plusieurs sous-réseaux dans un VNet ?  
✅ Oui, un VNet peut contenir plusieurs sous-réseaux, chacun avec sa propre plage d'adresses IP.

### Q3: Comment sécuriser le trafic inter-VM dans un même VNet ?  
Utilisez les NSG pour définir des règles précises de filtrage au niveau des sous-réseaux ou des interfaces réseau.

### Q4: Peut-on connecter un VNet Azure à un réseau local ?  
Oui, via VPN Gateway ou ExpressRoute.

---

> [!TIP] Pour approfondir, consultez la documentation officielle Microsoft Azure Networking :  
> https://learn.microsoft.com/azure/networking/  

---

✅ Ce guide vous permettra de maîtriser la configuration et la sécurisation du réseau dans Azure, optimisant ainsi vos déploiements cloud.