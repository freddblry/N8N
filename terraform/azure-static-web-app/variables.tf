variable "prefix" {
  description = "Prefix used for naming all resources"
  type        = string
  default     = "azstatic"
  validation {
    condition     = length(var.prefix) > 0
    error_message = "Prefix cannot be empty"
  }
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "westeurope"
}

variable "sku_tier" {
  description = "SKU tier for the Azure Static Web App"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "SKU tier must be either 'Free' or 'Standard'"
  }
}

variable "repository_url" {
  description = "GitHub repository URL for the static web app"
  type        = string
  validation {
    condition     = length(var.repository_url) > 0
    error_message = "Repository URL must be provided"
  }
}

variable "branch" {
  description = "Branch of the repository to deploy from"
  type        = string
  default     = "main"
}

variable "github_token" {
  description = "GitHub personal access token with repo access for Static Web App deployment"
  type        = string
  sensitive   = true
}

variable "app_location" {
  description = "Location of the app source code relative to the repository root"
  type        = string
  default     = "/"
}

variable "api_location" {
  description = "Location of the API source code relative to the repository root (empty if none)"
  type        = string
  default     = ""
}

variable "output_location" {
  description = "Location of the build output relative to the app_location"
  type        = string
  default     = "build"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "AzureStaticWebApp"
  }
}
