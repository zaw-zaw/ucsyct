#Creating Virtual Network and Subnet for VM01
resource "azurerm_virtual_network" "VNET01" {
  name                = "ZZL-VNET01"
  resource_group_name = azurerm_resource_group.RG01.name
  location            = azurerm_resource_group.RG01.location
  address_space       = ["172.16.0.0/16"]
}
resource "azurerm_subnet" "Subnet01" {
  name                 = "ZZL-Subnet01"
  resource_group_name  = azurerm_resource_group.RG01.name
  virtual_network_name = azurerm_virtual_network.VNET01.name
  address_prefixes     = ["172.16.10.0/24"]
}

#Creating Public ip 
resource "azurerm_public_ip" "PublicIP01" {
  name                = "ZZL-PublicIP01"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  allocation_method = "Dynamic"
}

#Network Security Group
resource "azurerm_network_security_group" "NSG01" {
  name = "ZZL-NSG01"
  location = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name
  
  security_rule  {
    access = "Allow"
    direction = "Inbound"
    name = "allow-ssh"
    priority = 100
    protocol = "Tcp"
    source_address_prefix = "*"
    destination_port_range     = "22"
    source_port_range = "*"
    destination_address_prefix = "*"
  } 
}
#Creating Network INT for Private and Public Subnet
resource "azurerm_network_interface" "VMNIC01" {
  name                = "VMNIC01"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PublicIP01.id
  }
}

#Associating VMNIC and NSG
resource "azurerm_network_interface_security_group_association" "Assocate01" {
  network_interface_id = azurerm_network_interface.VMNIC01.id
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
    azurerm_network_interface.VMNIC01.id,
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

