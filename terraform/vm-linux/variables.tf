variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "iac"
  validation {
    condition     = length(var.prefix) <= 10
    error_message = "prefix must be 10 characters or less"
  }
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of 'dev', 'staging', or 'prod'"
  }
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "Size of the Azure Linux VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
  validation {
    condition     = length(var.admin_username) >= 3
    error_message = "admin_username must be at least 3 characters"
  }
}

variable "admin_password" {
  description = "Admin password for the VM (use a secure string)"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters"
  }
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Project = "TerraformAzureVM"
    Owner   = "DevOps Team"
  }
}

variable "devops_agent_pat" {
  description = "Personal Access Token (PAT) for Azure DevOps agent registration"
  type        = string
  sensitive   = true
}

variable "devops_organization_url" {
  description = "Azure DevOps organization URL"
  type        = string
  default     = "https://dev.azure.com/yourorganization"
}

variable "backend_resource_group" {
  description = "Resource group name for Terraform backend storage"
  type        = string
  default     = "tfstate-rg"
}

variable "backend_storage_account" {
  description = "Storage account name for Terraform backend"
  type        = string
  default     = "tfstatestorageacct"
}

variable "backend_container" {
  description = "Container name for Terraform backend"
  type        = string
  default     = "tfstate"
}
