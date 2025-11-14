output "storage_account_id" {
  description = "ID du compte de stockage Azure"
  value       = azurerm_storage_account.storage.id
}

output "storage_account_primary_connection_string" {
  description = "Chaîne de connexion primaire du compte de stockage"
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = azurerm_resource_group.rg.name
}
