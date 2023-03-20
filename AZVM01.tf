#Creating Network INT for Private and Public Subnet
resource "azurerm_network_interface" "VMNIC" {
  name                = "VMNIC01"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PublicIP.id
  }
}

#Associating VMNIC and NSG
resource "azurerm_network_interface_security_group_association" "Assocate" {
  network_interface_id = azurerm_network_interface.VMNIC.id
  network_security_group_id = azurerm_network_security_group.NSG01.id
}

#Creating New VM
resource "azurerm_linux_virtual_machine" "TestVM01" {
  name                = "TestVM01"
  resource_group_name = azurerm_resource_group.RG01.name
  location            = azurerm_resource_group.RG01.location
  size                = "Standard_B1s"
  admin_username      = "zzl"
  network_interface_ids = [
    azurerm_network_interface.VMNIC.id,
  ]

  admin_ssh_key {
    username   = "zzl"
    public_key = file("./ZZL-AZ.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

