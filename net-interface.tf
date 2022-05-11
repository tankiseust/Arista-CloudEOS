resource "azurerm_network_interface" "PublicInt" {
    name = "PublicInt"
    location                      = azurerm_resource_group.TestRG.location
    resource_group_name           = azurerm_resource_group.TestRG.name
    enable_accelerated_networking = true
    enable_ip_forwarding          = true

    ip_configuration {
        name = "PublicIPInt"
        subnet_id = azurerm_subnet.PublicSubnet1.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.2.0.10"
        public_ip_address_id = azurerm_public_ip.PublicIP.id
    }
}

resource "azurerm_network_interface" "PrivateInt" {
    name = "PrivateInt"
    location                      = azurerm_resource_group.TestRG.location
    resource_group_name           = azurerm_resource_group.TestRG.name
    enable_accelerated_networking = true
    enable_ip_forwarding          = true

    ip_configuration {
        name = "PrivateIPInt"
        subnet_id = azurerm_subnet.PrivateSubnet1.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.2.1.10"
    }
}

resource "azurerm_network_interface" "HostPrivateInt" {
    name = "HostPrivateInt"
    location                      = azurerm_resource_group.TestRG.location
    resource_group_name           = azurerm_resource_group.TestRG.name
    enable_accelerated_networking = true
    enable_ip_forwarding          = false

    ip_configuration {
        name = "HostPrivateIPInt"
        subnet_id = azurerm_subnet.PrivateSubnet1.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.2.1.11"
    }
}