variable "project_prefix" {
  description = "Préfixe utilisé pour nommer les ressources Azure"
  type        = string
  validation {
    condition     = length(var.project_prefix) >= 3 && length(var.project_prefix) <= 12
    error_message = "Le préfixe du projet doit contenir entre 3 et 12 caractères."
  }
}

variable "environment" {
  description = "Environnement de déploiement (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être l'un des suivants : dev, staging, prod."
  }
}

variable "location" {
  description = "Région Azure où déployer les ressources"
  type        = string
  default     = "France Central"
}

variable "tags" {
  description = "Tags à appliquer à toutes les ressources"
  type        = map(string)
  default     = {
    "project"     = "static-web-app"
    "environment" = "dev"
  }
}

variable "repository_url" {
  description = "URL du repository GitHub contenant le code de l'application"
  type        = string
  validation {
    condition     = can(regex("https://github.com/.+/.+", var.repository_url))
    error_message = "L'URL du repository doit être une URL valide GitHub HTTPS."
  }
}

variable "repository_branch" {
  description = "Branche GitHub à utiliser pour le déploiement"
  type        = string
  default     = "main"
}

variable "app_location" {
  description = "Chemin relatif vers le dossier de l'application frontend"
  type        = string
  default     = "./"
}

variable "api_location" {
  description = "Chemin relatif vers le dossier de l'API (fonctionnalités backend)"
  type        = string
  default     = ""
}

variable "app_artifact_location" {
  description = "Chemin relatif vers le dossier des artefacts générés après build"
  type        = string
  default     = "build"
}
