terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "staticwebapp_rg" {
  name     = "${var.project_prefix}-${var.environment}-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_static_site" "static_web_app" {
  name                = "${var.project_prefix}-${var.environment}-swa"
  location            = azurerm_resource_group.staticwebapp_rg.location
  resource_group_name = azurerm_resource_group.staticwebapp_rg.name

  sku_name = "Standard"

  repository_url      = var.repository_url
  branch              = var.repository_branch

  build_properties {
    app_location         = var.app_location
    api_location         = var.api_location
    app_artifact_location = var.app_artifact_location
  }

  tags = var.tags
}
