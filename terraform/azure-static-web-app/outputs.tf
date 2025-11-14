output "static_web_app_default_hostname" {
  description = "URL par défaut de l'Azure Static Web App"
  value       = azurerm_static_site.static_web_app.default_hostname
}

output "static_web_app_id" {
  description = "ID de la ressource Azure Static Web App"
  value       = azurerm_static_site.static_web_app.id
}

output "resource_group_name" {
  description = "Nom du groupe de ressources utilisé"
  value       = azurerm_resource_group.staticwebapp_rg.name
}
