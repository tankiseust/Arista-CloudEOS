resource "azurerm_route_table" "PublicRouteTable" {
    name = "PublicRT"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name
    disable_bgp_route_propagation = false

    route {
        address_prefix = "0.0.0.0/0"
        name = "default_route"
        next_hop_type = "Internet"
    }
}

resource "azurerm_route_table" "PrivateRouteTable" {
    name = "PrivateRT"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name
    disable_bgp_route_propagation = false

    route {
        address_prefix = "0.0.0.0/0"
        name = "default_route"
        next_hop_type = "VirtualAppliance"
        next_hop_in_ip_address = "10.2.0.10"
    }
}