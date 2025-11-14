resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location

  tags = merge({
    Environment = var.environment
    Project     = var.project_name
  }, var.tags)
}

resource "azurerm_storage_account" "storage" {
  name                     = lower("${var.prefix}${var.environment}sa")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = merge({
    Environment = var.environment
    Project     = var.project_name
  }, var.tags)

  enable_https_traffic_only = true
}