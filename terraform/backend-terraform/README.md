# Terraform Azure Backend

## Description

Ce projet Terraform déploie une infrastructure Azure pour stocker l'état Terraform (tfstate) dans un backend sécurisé en utilisant un compte de stockage Azure Blob Storage. Il est conçu pour gérer les environnements `dev`, `staging` et `prod`.

## Architecture

```mermaid
flowchart TD
    A[GitHub Actions CI/CD] --> B[Terraform Backend Deployment]
    B --> C[Azure Resource Group]
    B --> D[Storage Account]
    B --> E[Storage Container (Blob)]
    style B fill:#f9f,stroke:#333,stroke-width:1px
    style C fill:#bbf,stroke:#333,stroke-width:1px
    style D fill:#bbf,stroke:#333,stroke-width:1px
    style E fill:#bbf,stroke:#333,stroke-width:1px
```

## Prérequis

- Azure CLI installé et configuré
- Terraform CLI version >= 1.3.0
- Un Service Principal Azure avec les permissions suivantes :
  - Contributor ou Owner sur le groupe de ressource backend
  - Permissions sur le compte de stockage pour accéder aux blobs
- Variables d'environnement ou secrets GitHub Actions configurés (voir ci-dessous)

## Installation

1. Clonez ce dépôt
2. Modifiez `terraform.tfvars` à partir de `terraform.tfvars.example` avec vos valeurs
3. Initialisez Terraform :

```bash
terraform init
```

4. Appliquez la configuration :

```bash
terraform apply
```

## Configuration des variables

- `resource_group_name`: nom du groupe de ressource
- `location`: région Azure
- `storage_account_name`: nom unique du compte de stockage
- `container_name`: nom du container blob
- `environment`: `dev`, `staging` ou `prod`
- `tags`: map de tags additionnels

## Configuration des secrets GitHub Actions

Dans les settings du dépôt GitHub, configurez les secrets suivants :

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

## Commandes Terraform

- `terraform init` : initialise le backend et les providers
- `terraform plan` : affiche le plan d'exécution
- `terraform apply` : applique les modifications
- `terraform destroy` : détruit l'infrastructure

## Exemples d'utilisation

```bash
terraform workspace new dev
terraform workspace select dev
terraform plan
terraform apply
```

## Troubleshooting

- Assurez-vous que le compte de stockage ne soit pas déjà utilisé
- Vérifiez que les permissions du Service Principal soient correctes
- Utilisez `terraform validate` pour vérifier la syntaxe

## Coûts estimés Azure

- Ressource Group : Gratuit
- Storage Account (Standard LRS) : environ 1-2 EUR/mois selon la taille
- Storage Container : Gratuit

Pensez à nettoyer les ressources avec `terraform destroy` pour éviter les coûts inutiles.
