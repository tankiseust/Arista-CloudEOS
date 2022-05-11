output "PublicIP" {
    value =azurerm_public_ip.PublicIP.ip_address
}

output "HostIP" {
    value =azurerm_network_interface.HostPrivateInt.private_ip_address
}