output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = azurerm_public_ip.bastion.ip_address
}

output "app_vm_public_ip" {
  description = "Public IP address of the application VM"
  value       = azurerm_public_ip.app_vm.ip_address
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
  value       = var.ssh_public_key == "" ? tls_private_key.main.private_key_pem : null
  sensitive   = true
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://${azurerm_public_ip.app_vm.ip_address}:5000"
}
