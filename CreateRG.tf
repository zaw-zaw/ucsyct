data "azurerm_subscription" "current" {
}
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

resource "azurerm_resource_group" "RG01" {
  name     = "ZZL-RG01"
  location = "Southeast Asia"
}
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
resource "azurerm_public_ip" "PublicIP" {
  name                = "ZZL-PublicIP"
  location            = azurerm_resource_group.RG01.location
  resource_group_name = azurerm_resource_group.RG01.name

  allocation_method = "Dynamic"
}

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
#Creating SSH KEY Pair
#resource "azurerm_ssh_public_key" "SSHPublicKey" {
#    name = "ZZL-Azure-Key01"
#    resource_group_name = azurerm_resource_group.RG01.name
#    location = azurerm_resource_group.RG01.location
#    public_key = file("./ZZL-AZ.pub")
#}


