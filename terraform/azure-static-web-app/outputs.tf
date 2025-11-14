output "static_web_app_url" {
  description = "URL of the Azure Static Web App"
  value       = azurerm_static_site.this.default_hostname
}

output "static_web_app_id" {
  description = "Resource ID of the Azure Static Web App"
  value       = azurerm_static_site.this.id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.this.name
}
