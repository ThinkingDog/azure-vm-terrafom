resource "azurerm_resource_group" "myterraformgroup" {
  name     = "myTerrformDemo-rg"
  location = "eastus"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "myterraformnic" {
  name                      = "myNIC"
  location                  = "eastus"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = "eastus"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_machine" "myterraformvm" {
  name                  = "myVM"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDz+B7XV58v0+k03zAydNUAowQvYqsTD6ZEcX/ZTYbQVl9uc44j+QkM0G5OeD4vWXGcq5Z73lWzk1cs2xCv39t9lkyPkda/VF9adJpRaEaFGQTWBQQcotTLCPzTTn2B5ZXi67Bl4nH8X/FVkQvYl9y3t5klz3n0OCtDeYYabiIk3COyMXCSkPxoQywxEfNW3D2zn+r8b8VaO//P9uFFE3xTXAYbTDmFkrvnAGp6rfA+WRW0bP4tpBUnNz5ozqsqcFGRDYBMawqJGABDZeAd84gFAmnQXNdto8LXkp9EGNU+mC1yHf07S52+K5nhhBBV41hjk79GcUFnl7wcZ2G06dGMk8onWfpaN7hQC8w+/kT1paZmvMyPiFkLcvS+xhrtmZFmhvIjRM3iKzDJ8zCDsPg5EOYhGxq94XUDe40LgvQdIRpvM6xTNDj1OJsQ1wQe76+nxH6SH6nfjW6g7vRXToxoFL/HgYBHBrs64jv4/+YltHRjQdybRBvtASzsDMhy7qN0wVNp8HyyIczXnJ3nTjHftWer+7VgQkDoCRsKvBzBPsdfvagfQgjDxJqfB2EkOJNp0yluMUE4uBjqCLhSYWZxbrOytuzPrcw0pi4Swh8WaIR75g+a4tH6SREYKvs0J7o+e0WwJLT+O+q/ZK0mZeJseJ+/BBC/0n4PkoQoOWE2Xw== nukdcbear@gmail.com"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

