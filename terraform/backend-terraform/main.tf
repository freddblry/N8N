terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = var.container_name
    key                  = "${var.environment}.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "tfstate_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = merge({
    Environment = var.environment
    ManagedBy   = "Terraform"
  }, var.tags)
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = azurerm_resource_group.tfstate_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false

  tags = merge({
    Environment = var.environment
    ManagedBy   = "Terraform"
  }, var.tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"

  tags = merge({
    Environment = var.environment
    ManagedBy   = "Terraform"
  }, var.tags)
}
