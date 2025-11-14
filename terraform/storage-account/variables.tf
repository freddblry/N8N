variable "prefix" {
  description = "Préfixe commun pour nommer les ressources"
  type        = string
  default     = "tf"
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 5
    error_message = "Le préfixe doit faire entre 2 et 5 caractères."
  }
}

variable "environment" {
  description = "Environnement cible, par exemple dev, staging, prod"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être l'un de : dev, staging, prod."
  }
}

variable "location" {
  description = "Emplacement Azure où les ressources seront déployées"
  type        = string
  default     = "France Central"
}

variable "project_name" {
  description = "Nom du projet ou de l'application"
  type        = string
  default     = "storage_project"
}

variable "account_tier" {
  description = "Le niveau de performance du compte de stockage"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Le niveau doit être Standard ou Premium."
  }
}

variable "account_replication_type" {
  description = "Type de réplication du compte de stockage"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RZRS"], var.account_replication_type)
    error_message = "La réplication doit être une des valeurs suivantes : LRS, GRS, RAGRS, ZRS, GZRS, RZRS."
  }
}

variable "tags" {
  description = "Tags additionnels à ajouter sur les ressources"
  type        = map(string)
  default     = {}
}