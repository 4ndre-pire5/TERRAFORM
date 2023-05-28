resource "azurerm_virtual_network" "vnet-aulatarefa-cloud" {
  name                = "vnet-aulatarefa-cloud"
  location            = azurerm_resource_group.rg-aulatarefa-cloud.location
  resource_group_name = azurerm_resource_group.rg-aulatarefa-cloud.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Aula Tarefa Impacta"
  }
}

resource "azurerm_subnet" "sub-aulatarefa-cloud" {
  name                 = "sub-aulatarefa-cloud"
  resource_group_name  = azurerm_resource_group.rg-aulatarefa-cloud.name
  virtual_network_name = azurerm_virtual_network.vnet-aulatarefa-cloud.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-aulatarefa-cloud" {
  name                = "nsg-aulatarefa-cloud"
  location            = azurerm_resource_group.rg-aulatarefa-cloud.location
  resource_group_name = azurerm_resource_group.rg-aulatarefa-cloud.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Aula Tarefa Impacta"
  }
}