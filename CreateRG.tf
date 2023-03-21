data "azurerm_subscription" "current" {
}
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

resource "azurerm_resource_group" "RG01" {
  name     = "ZZL-RG01"
  location = "Southeast Asia"
}

#Creating SSH KEY Pair
#resource "azurerm_ssh_public_key" "SSHPublicKey" {
#    name = "ZZL-Azure-Key01"
#    resource_group_name = azurerm_resource_group.RG01.name
#    location = azurerm_resource_group.RG01.location
#    public_key = file("./ZZL-AZ.pub")
#}


