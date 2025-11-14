terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    # Backend configuration should be set here or in a separate backend.tf file
    # e.g. storage_account_name, container_name, key, resource_group_name
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_static_site" "this" {
  name                = "${var.prefix}-${var.environment}-staticwebapp"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku_tier            = var.sku_tier
  repository_url      = var.repository_url
  branch              = var.branch
  repository_token    = var.github_token

  tags = var.tags

  build_properties {
    app_location      = var.app_location
    api_location      = var.api_location
    output_location   = var.output_location
  }
}
