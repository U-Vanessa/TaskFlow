variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralindia"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "taskflow"
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "dev"
}

variable "vnet_cidr" {
  description = "CIDR block for Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet (bastion)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_app_cidr" {
  description = "CIDR block for private subnet (app VM)"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_db_cidr" {
  description = "CIDR block for private subnet (database)"
  type        = string
  default     = "10.0.11.0/24"
}

variable "bastion_vm_size" {
  description = "VM size for bastion host"
  type        = string
  default     = "Standard_B1s"
}

variable "app_vm_size" {
  description = "VM size for application VM"
  type        = string
  default     = "Standard_B1s"
}

variable "ssh_public_key" {
  description = "SSH public key for VMs (leave empty to auto-generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file for VMs (alternative to ssh_public_key)"
  type        = string
  default     = ""
}

variable "trusted_ssh_cidr" {
  description = "Trusted CIDR for SSH access (e.g., your IP address/32). Must be set for secure SSH access."
  type        = string
  default     = ""

  validation {
    condition     = var.trusted_ssh_cidr == "" || can(cidrnetmask(var.trusted_ssh_cidr))
    error_message = "The trusted_ssh_cidr must be a valid CIDR block (e.g., '10.0.0.0/8' or '203.0.113.50/32')."
  }
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "taskflow"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "taskflowadmin"
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}
