provider "azurerm" {
    skip_provider_registration = true
    features {}
}

resource "azurerm_resource_group" "TestRG" { 
   name ="TestResourceGroup"  
   location ="westus2"
}

resource "azurerm_virtual_network" "Vnet" {
    name = "TestVNET"
    address_space = ["10.2.0.0/16"]
    resource_group_name = azurerm_resource_group.TestRG.name
    location = azurerm_resource_group.TestRG.location
    tags = {
        "Name" = "TestVNET"
    }
}

resource "azurerm_subnet" "PublicSubnet1" {
    name = "Public"
    virtual_network_name = azurerm_virtual_network.Vnet.name
    resource_group_name = azurerm_resource_group.TestRG.name
    address_prefixes = ["10.2.0.0/24"]
}

resource "azurerm_subnet" "PrivateSubnet1" {
    name = "Private"
    virtual_network_name = azurerm_virtual_network.Vnet.name
    resource_group_name = azurerm_resource_group.TestRG.name
    address_prefixes = ["10.2.1.0/24"]
}

resource "azurerm_network_security_group" "OpenSG" {
    name = "OpenSG"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name

    security_rule {
        name = "Allow_Any_In"
        description = "Allow all traffic in"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    tags = {
        "Name" = "OpenSecurityGroup"
    }
}
resource "azurerm_network_security_group" "InternetSG" {
    name = "InternetSG"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name

    security_rule {
        name = "Allow_SSH"
        description = "Allow SSH access"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = 22
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "Allow_ICMP"
        description = "Allow ICMP access"
        priority = 150
        direction = "Inbound"
        access = "Allow"
        protocol = "Icmp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
 
    tags = {
        "Name" = "InternetSG"
    }
}
resource "azurerm_subnet_network_security_group_association" "public" {
    subnet_id = azurerm_subnet.PublicSubnet1.id
    network_security_group_id =azurerm_network_security_group.InternetSG.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
    subnet_id =azurerm_subnet.PrivateSubnet1.id
    network_security_group_id =azurerm_network_security_group.OpenSG.id
}

resource "azurerm_public_ip" "PublicIP" {
    name = "PublicIP"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name
    allocation_method = "Static"
}