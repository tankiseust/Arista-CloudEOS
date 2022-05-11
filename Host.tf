resource "azurerm_virtual_machine" "CloudEOSHost" {
    name = "CloudEOSHost"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name
    network_interface_ids = [azurerm_network_interface.HostPrivateInt.id]
    primary_network_interface_id = azurerm_network_interface.HostPrivateInt.id
    vm_size = "Standard_D2_v2"
    delete_os_disk_on_termination = true

    storage_image_reference {
        publisher = "arista-networks"
        offer = "cloudeos-router-payg"
        sku = "cloudeos-4_24_0-payg-free"
        version = "4.24.01"
    }

    storage_os_disk {
        name = "CloudEOSHostDisk1"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name = "CloudEOSHost"
        admin_username = "testuser"
        admin_password = "test!123456"
        custom_data = file("bootstraphost.cfg")
    }
 
    plan {
        name = "cloudeos-4_24_0-payg-free" 
        publisher = "arista-networks"
        product = "cloudeos-router-payg"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = true
        storage_uri = azurerm_storage_account.HostStorage.primary_blob_endpoint
    }
}

resource "azurerm_storage_account" "HostStorage" {
    name = "hostcloudeosstorage"
    location = azurerm_resource_group.TestRG.location
    resource_group_name = azurerm_resource_group.TestRG.name 
    account_tier = "Standard"
    account_replication_type = "LRS"
}