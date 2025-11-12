resource "azurerm_resource_group" "rg" {
  name     = "rg-upgrad"
  location = "East US"
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Cloud       = "Azure"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-upgrad"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Cloud       = "Azure"
  }
}

resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.2.0/24"]
}

output "azure_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "azure_rg_name" {
  description = "Azure Resource Group Name"
  value       = azurerm_resource_group.rg.name
}
