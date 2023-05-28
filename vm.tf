resource "azurerm_public_ip" "ip-aulatarefa-cloud" {
  name                = "ip-aulatarefa-cloud"
  resource_group_name = azurerm_resource_group.rg-aulatarefa-cloud.name
  location            = azurerm_resource_group.rg-aulatarefa-cloud.location
  allocation_method   = "Static"

  tags = {
    
    environment = "Aula Tarefa Impacta"
  }
}

resource "azurerm_network_interface" "nic-aulatarefa-cloud" {
  name                = "nic-aulatarefa-cloud"
  location            = azurerm_resource_group.rg-aulatarefa-cloud.location
  resource_group_name = azurerm_resource_group.rg-aulatarefa-cloud.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-aulatarefa-cloud.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-aulatarefa-cloud.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-aulatarefa-cloud" {
  name                            = "vm-aulatarefa-cloud"
  resource_group_name             = azurerm_resource_group.rg-aulatarefa-cloud.name
  location                        = azurerm_resource_group.rg-aulatarefa-cloud.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Teste@1234!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic-aulatarefa-cloud.id,
  ]

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

resource "azurerm_network_interface_security_group_association" "nic-nsg-aulatarefa-cloud" {
  network_interface_id      = azurerm_network_interface.nic-aulatarefa-cloud.id
  network_security_group_id = azurerm_network_security_group.nsg-aulatarefa-cloud.id
}

resource "null_resource" "install-nginx" {
  connection {
    type = "ssh"
    host = azurerm_public_ip.ip-aulatarefa-cloud.ip_address
    user = "adminuser"
    password = "Teste@1234!"
  } 

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update", 
      "sudo apt install -y nginx" 
      ] 
  }

  depends_on = [ 
    azurerm_linux_virtual_machine.vm-aulatarefa-cloud
   ]
}