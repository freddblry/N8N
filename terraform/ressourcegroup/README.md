# Terraform Azure Resource Group

## Description

Ce projet Terraform déploie un Resource Group Azure configurable pour différents environnements (dev, test, prod) avec une gestion des tags et des bonnes pratiques d'IaC.

## Architecture

```mermaid
flowchart TD
  A[Terraform Configuration] --> B[Azure Resource Group]
  B --> C[Azure Resources (non inclus ici)]
```

## Prérequis

- [Azure CLI](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- [Terraform CLI >= 1.3.0](https://developer.hashicorp.com/terraform/downloads)
- Un Service Principal Azure avec les permissions nécessaires pour gérer les Resource Groups
  - `Contributor` role sur la subscription ou scope approprié

## Installation

1. Clonez ce dépôt.
2. Configurez vos variables dans `terraform.tfvars` ou via des variables d'environnement.
3. Connectez-vous à Azure : `az login`
4. Initialisez Terraform : `terraform init`

## Configuration des variables

- `resource_group_name` : nom du Resource Group (max 90 caractères).
- `location` : région Azure, ex: `France Central`.
- `environment` : `dev`, `test` ou `prod`.
- `tags` : map de tags additionnels.

## Configuration des secrets GitHub Actions

Dans les settings du dépôt GitHub, ajoutez les secrets suivants :

- `ARM_CLIENT_ID` : ID du Service Principal
- `ARM_CLIENT_SECRET` : Secret du Service Principal
- `ARM_SUBSCRIPTION_ID` : ID de la subscription Azure
- `ARM_TENANT_ID` : ID du tenant Azure

## Commandes Terraform

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Exemple d'utilisation

```bash
terraform apply -var='resource_group_name=rg-myproject-dev' -var='location=France Central' -var='environment=dev'
```

## Dépannage

- Vérifiez que vous êtes connecté à Azure avec un compte/service principal ayant les droits.
- Assurez-vous que les variables sont correctement définies.
- Utilisez `terraform validate` pour valider la configuration.

## Coûts estimés

Le coût principal est lié au Resource Group qui est gratuit. Les coûts dépendront des ressources que vous ajouterez dans ce Resource Group.

Pour plus d'informations sur les coûts Azure, consultez [Azure Pricing](https://azure.microsoft.com/en-us/pricing/).
