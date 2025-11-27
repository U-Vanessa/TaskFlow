output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

# NOTE: Public IPs removed from VMs per Checkov security requirements.
# Use Azure Bastion service for secure remote access.

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = azurerm_network_interface.bastion.private_ip_address
}

output "app_vm_private_ip" {
  description = "Private IP address of the application VM"
  value       = azurerm_network_interface.app_vm.private_ip_address
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = azurerm_container_registry.main.login_server
}

output "acr_name" {
  description = "ACR registry name"
  value       = azurerm_container_registry.main.name
}

output "db_fqdn" {
  description = "Fully qualified domain name of the database"
  value       = azurerm_postgresql_flexible_server.main.fqdn
  sensitive   = true
}

output "db_host" {
  description = "Database host address"
  value       = azurerm_postgresql_flexible_server.main.fqdn
  sensitive   = true
}

output "ssh_private_key" {
  description = "SSH private key (if auto-generated)"
  value       = var.ssh_public_key == "" && var.ssh_public_key_path == "" ? tls_private_key.main.private_key_pem : null
  sensitive   = true
}

