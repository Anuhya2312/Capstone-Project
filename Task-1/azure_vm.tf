# Public IPs for each VM
resource "azurerm_public_ip" "azure_vm_ip" {
  name                = "azure-vm-ip"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interfaces
resource "azurerm_network_interface" "azure_vm_nic" {
  name                = "azure-vm-nic"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "azurevmipcfg"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_vm_ip.id
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Ubuntu Virtual Machines
resource "azurerm_linux_virtual_machine" "azure_vm" {
  name                = "AzureVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "East US"
  size                = "Standard_B2ms"
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"
  network_interface_ids = [azurerm_network_interface.azure_vm_nic.id]

os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name  = "azurevm"
  disable_password_authentication = false
}

# Output Public IP
output "vm_public_ip" {
  value = azurerm_public_ip.azure_vm_ip.ip_address
}
