variable "resource_group_name" {
  description = "Name of the resource group where the backend storage account will be created"
  type        = string
  validation {
    condition     = length(var.resource_group_name) >= 3 && length(var.resource_group_name) <= 90
    error_message = "resource_group_name must be between 3 and 90 characters."
  }
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "westeurope"
  validation {
    condition     = length(var.location) > 0
    error_message = "location must not be empty."
  }
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account to store the Terraform state. Must be globally unique and between 3-24 lowercase letters and numbers"
  type        = string
  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24 && can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "storage_account_name must be between 3 and 24 characters and contain only lowercase letters and numbers."
  }
}

variable "container_name" {
  description = "Name of the Azure Storage Container to store the Terraform state"
  type        = string
  default     = "tfstate"
  validation {
    condition     = length(var.container_name) > 0
    error_message = "container_name must not be empty."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
