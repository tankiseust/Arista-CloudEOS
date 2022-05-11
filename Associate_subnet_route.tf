resource "azurerm_subnet_route_table_association" "publicRtSubnetMap" {
    subnet_id = azurerm_subnet.PublicSubnet1.id 
    route_table_id = azurerm_route_table.PublicRouteTable.id
}

resource "azurerm_subnet_route_table_association" "privateRtSubnetMap" {
    subnet_id = azurerm_subnet.PrivateSubnet1.id 
    route_table_id = azurerm_route_table.PrivateRouteTable.id
}