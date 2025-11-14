variable "resource_group_name" {
  description = "The name of the Azure Resource Group to create."
  type        = string
  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90
    error_message = "resource_group_name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "westeurope"
  validation {
    condition     = length(var.location) > 0
    error_message = "location must not be empty."
  }
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "The name of the project or application."
  type        = string
  default     = "MyProject"
  validation {
    condition     = length(var.project_name) > 0
    error_message = "project_name must not be empty."
  }
}

variable "tags" {
  description = "Additional tags to be added to resources."
  type        = map(string)
  default     = {}
}
