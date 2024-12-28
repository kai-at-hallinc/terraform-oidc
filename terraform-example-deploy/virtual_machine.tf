data "azurerm_resource_group" "dev" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "dev_vnet" {
  name                = "dev-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.dev.location
  resource_group_name = data.azurerm_resource_group.dev.name
}

resource "azurerm_subnet" "dev_subnet" {
  name                 = "internal_network"
  resource_group_name  = data.azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.dev_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "dev_nic" {
  name                = "dev-nic"
  location            = data.azurerm_resource_group.dev.location
  resource_group_name = data.azurerm_resource_group.dev.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "dev_vm" {
  name                = "dev-machine"
  resource_group_name = data.azurerm_resource_group.dev.name
  location            = data.azurerm_resource_group.dev.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.dev_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.main.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}