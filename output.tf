output "vm-fqdn" {
  value = azurerm_public_ip.myterraformpublicip.fqdn
}

output "reachable_host_ip_address" {
  value = azurerm_public_ip.myterraformpublicip.ip_address
}