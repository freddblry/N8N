output "resource_group_name" {
  description = "The name of the resource group created for backend storage"
  value       = azurerm_resource_group.tfstate_rg.name
}

output "storage_account_name" {
  description = "The name of the storage account used for the backend"
  value       = azurerm_storage_account.tfstate_sa.name
}

output "storage_container_name" {
  description = "The name of the storage container used for the backend"
  value       = azurerm_storage_container.tfstate_container.name
}
